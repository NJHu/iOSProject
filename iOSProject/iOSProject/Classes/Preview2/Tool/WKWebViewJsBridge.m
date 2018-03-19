
#import "WKWebViewJsBridge.h"
#import "WKBridgeTool.h"


@interface WKWebViewJsBridge ()
{
   __weak WKWebView *_webView;
    __weak id<WKNavigationDelegate> _delegate;
}
/** js 调用 oc */
@property (nonatomic, strong) NSMutableDictionary *messageHandles;

@end

@implementation WKWebViewJsBridge


/*
 NSURL *url = [NSURL URLWithString:@"https://www.baidu.com/news/toady?abc=1&bcd=3"];
 (lldb) po url.path
 /news/toady
 
 (lldb) po url.host
 www.baidu.com
 
 (lldb) po url.scheme
 https
 
 (lldb) po url.query
 abc=1&bcd=3
 */

#define khandlerName @"handlerName"
#define kData @"data"
#define kCallbackId @"callbackId"
#define kResponseId @"responseId"
#define kResponseData @"responseData"

#pragma mark - action
- (void)continueAction:(NSURL *)url
{
    if (url.path.length < 1) {
        return;
    }
    NSString *messageJsonString = [url.path substringFromIndex:1];
    
    NSDictionary *messageJsonDict = [NSJSONSerialization JSONObjectWithData:[messageJsonString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
    
    // 不是字典返回
    if (![messageJsonDict isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    NSString *handleName = messageJsonDict[khandlerName];
    // 转换成小写啦啦啦啦啦
    void(^handlerBlock)(id data, void(^)(id responseData)) = self.messageHandles[handleName.lowercaseString];
    if (!handlerBlock) {
        return;
    }
    
    // 回调给 H5!!!!关键步骤!!!!!================================
    void(^responseCallback)(id responseData) = nil;
    NSString *callbackId = messageJsonDict[kCallbackId];
    
    if (!LMJIsEmpty(callbackId)) {
        responseCallback = ^(id responseData) {
            if (LMJIsEmpty(responseData)) {
                return ;
            }
            
            NSDictionary *responseMsg = @{kResponseId: callbackId, kResponseData: responseData};
            
            // 回调 H5
            [WKBridgeTool dispatchMsgToh5:responseMsg webView:_webView];
        };
    }else {
        
        responseCallback = ^(id responseData) {
            
        };
    }
    // =============================================================
    // 传递的数据
    id data = messageJsonDict[kData];
    
    
    handlerBlock(data, responseCallback);
}

#pragma mark - handel
- (void)registerHandler:(NSString *)handleName handle:(void(^)(id data, void(^)(id responseData)))handle {
    self.messageHandles[handleName.lowercaseString] = [handle copy];
}

- (void)callHandler:(NSString*)handlerName data:(id)data responseCallback:(void(^)(id responseData))responseCallback {
    
}

#pragma mark - init
- (instancetype)initWithWebView:(WKWebView *)webView delegate:(id<WKNavigationDelegate>)delegate {
    if (self = [self init]) {
        
        LMJWeakSelf(self);
        LMJWeakSelf(webView);
        LMJWeakSelf(delegate);
        
        _webView = weakwebView;
        _webView.navigationDelegate = weakself;
        _delegate = weakdelegate;
        
        [WKBridgeTool bridgeRegisterDefault:weakself];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _messageHandles = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)dealloc {
    _messageHandles = nil;
    _delegate = nil;
    _webView = nil;
}


#pragma mark - getter
- (WKWebView *)webView {
    return _webView;
}


#pragma mark WKNavigationDelegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    if (webView != _webView) { return; }
    
    NSURL *url = navigationAction.request.URL;
    WKNavigationActionPolicy policy = WKNavigationActionPolicyAllow;
    
    if ([WKBridgeTool isWebViewJavascriptBridgeURL:url]) {
        policy = WKNavigationActionPolicyCancel;
        // 执行拦截
        [self continueAction:url];
    }
    
    if (policy == WKNavigationActionPolicyAllow && _delegate && [_delegate respondsToSelector:@selector(webView:decidePolicyForNavigationAction:decisionHandler:)]) {
        [_delegate webView:webView decidePolicyForNavigationAction:navigationAction decisionHandler:decisionHandler];
    } else {
        decisionHandler(policy);
    }
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    if (webView != _webView) { return; }
    
    if (_delegate && [_delegate respondsToSelector:@selector(webView:didFinishNavigation:)]) {
        [_delegate webView:webView didFinishNavigation:navigation];
    }
}


- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    if (webView != _webView) { return; }
    
    if (_delegate && [_delegate respondsToSelector:@selector(webView:decidePolicyForNavigationResponse:decisionHandler:)]) {
        [_delegate webView:webView decidePolicyForNavigationResponse:navigationResponse decisionHandler:decisionHandler];
    }
    else {
        decisionHandler(WKNavigationResponsePolicyAllow);
    }
}

- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential *))completionHandler {
    if (webView != _webView) { return; }
    
    if (_delegate && [_delegate respondsToSelector:@selector(webView:didReceiveAuthenticationChallenge:completionHandler:)]) {
        [_delegate webView:webView didReceiveAuthenticationChallenge:challenge completionHandler:completionHandler];
    } else {
        completionHandler(NSURLSessionAuthChallengePerformDefaultHandling, nil);
    }
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    if (webView != _webView) { return; }
    
    if (_delegate && [_delegate respondsToSelector:@selector(webView:didStartProvisionalNavigation:)]) {
        [_delegate webView:webView didStartProvisionalNavigation:navigation];
    }
}


- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    if (webView != _webView) { return; }
    
    if (_delegate && [_delegate respondsToSelector:@selector(webView:didFailNavigation:withError:)]) {
        [_delegate webView:webView didFailNavigation:navigation withError:error];
    }
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    if (webView != _webView) { return; }
    
    if (_delegate && [_delegate respondsToSelector:@selector(webView:didFailProvisionalNavigation:withError:)]) {
        [_delegate webView:webView didFailProvisionalNavigation:navigation withError:error];
    }
}



@end

