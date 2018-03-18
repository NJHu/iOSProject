
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


#pragma mark - action

- (void)continueAction:(NSURL *)url
{
    
    
}

- (instancetype)initWith:(WKWebView *)webView delegate:(id<WKNavigationDelegate>)delegate {
    if (self = [self init]) {
        _webView = webView;
        _delegate = delegate;
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
}

- (WKWebView *)webView {
    return _webView;
}

#pragma mark - handel
- (void)registerHandler:(NSString *)handleName handle:(void(^)(id data, void(^)(id responseData)))handle {
    self.messageHandles[handleName] = [handle copy];
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

