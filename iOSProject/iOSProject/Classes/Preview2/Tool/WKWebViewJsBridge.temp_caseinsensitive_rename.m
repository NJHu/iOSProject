
#import "WKWebViewJsBridge.h"

#define kProtocolScheme    @"eagle"
#define kQueueHasMessage   @"__queue_message__"
#define kReturnMessage     @"__return_message__"
#define kInitAppMessage    @"__init_app__"

#define kStartPageMessage   @"startPage"
#define kStartActionMessage @"startAction"
#define kGetMessage         @"get"
#define kSetMessage         @"set"
#define kCloseMessage       @"close"
#define split               @"_:_"


@interface WKWebViewJsBridge ()

@property (strong, nonatomic) NSMutableArray* startupMessageQueue;
@property (strong, nonatomic) NSMutableDictionary* responseCallbacks;
@property (strong, nonatomic) NSMutableDictionary* messageHandlers;
@property (strong, nonatomic) WVJBHandler messageHandler;

@end

@implementation WKWebViewJsBridge {
    __weak WKWebView* _webView;
    __weak id<WKNavigationDelegate> _webViewDelegate;
    long _uniqueId;
}

+ (instancetype)bridgeForWebView:(WKWebView*)webView {
    WKWebViewJsBridge* bridge = [[self alloc] init];
    [bridge _setupInstance:webView];
    [bridge reset];
    
    [bridge registerDefault];
    return bridge;
}

+ (BOOL)handlerUrl:(NSString *)urlString {
    @try {
        NSURL *url = [NSURL URLWithString:urlString];
        NSString *scheme = url.scheme.lowercaseString;
        NSString *host = url.host.lowercaseString;
        if ([kProtocolScheme isEqualToString:scheme]
            && ([kStartPageMessage.lowercaseString isEqualToString:host]
                ||[kStartActionMessage.lowercaseString isEqualToString:host])) {
                NSString *dataString = url.path;
                if (e_isEmpty(dataString)) {
                    return NO;
                }
                dataString = [dataString substringFromIndex:1];
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[dataString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
                if ([kStartPageMessage.lowercaseString isEqualToString:host]) {
                    [WKWebViewJsBridge handlerPage:dict callback:nil];
                } else if ([kStartActionMessage.lowercaseString isEqualToString:host]) {
                    [WKWebViewJsBridge handlerAction:dict callback:nil];
                }
                return YES;
            }
    } @catch (NSException *exception) {
        e_log(@"%@: %@", exception.name, exception.reason);
    }
    return NO;
}


+ (void)loadUrl:(WKWebView*)webView url:(NSString *)urlString {
    if (e_isEmpty(urlString)) {
        return;
    }
    @try {
        NSString *url = urlString;
        if([[NSPredicate predicateWithFormat:@"SELF MATCHES %@",@".+\\?.+\\{.*\\}.*"] evaluateWithObject:urlString]) {
            NSString *query = [urlString substringFromIndex:[urlString rangeOfString:@"?"].location];
            NSString *regularExpStr = @"\\{[^\\}]*\\}";
            NSRegularExpression *regularExp = [[NSRegularExpression alloc] initWithPattern:regularExpStr options:NSRegularExpressionCaseInsensitive error:nil];
            NSArray <NSTextCheckingResult *> *resultArr = [regularExp matchesInString:query options:NSMatchingReportProgress range:NSMakeRange(0, query.length)];
            for (NSTextCheckingResult *result in resultArr) {
                NSString *subStr = [query substringWithRange:result.range];
                NSString *replace = [subStr substringWithRange:NSMakeRange(1, subStr.length-2)];
                if ([replace containsString:@"|"]) {
                    NSArray *arr = [replace componentsSeparatedByString:@"|"];
                    if (arr.count == 2) {
                        replace = arr[1];
                    } else {
                        replace = arr[0];
                    }
                }
                NSString *value = e_preference_get(replace);
                if (!value) {
                    value = @"";
                }
                url = [url stringByReplacingOccurrencesOfString:subStr withString:value];
            }
        }
        url = [url stringByReplacingOccurrencesOfString:@"eagle://file" withString:[@"file://" stringByAppendingString:e_path_cache]];
        if ([url hasPrefix:@"file://"]) {
            if (UIDevice.currentDevice.systemVersion.floatValue >= 9.0) {
                [webView loadFileURL:[NSURL URLWithString:url] allowingReadAccessToURL:[NSURL fileURLWithPath:e_path_cache]];
            } else {
                e_log(@"%@", @"系统版本过低，无法使用本地h5");
            }
        } else {
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
            [webView loadRequest:request];
        }
    } @catch (NSException *exception) {
        e_log(@"%@: %@", exception.name, exception.reason);
    }
}


- (void)registerDefault {
    //启动页面
    [self registerHandler:kStartPageMessage handler:^(id data, WVJBResponseCallback responseCallback) {
        [WKWebViewJsBridge handlerPage:data callback:responseCallback];
    }];
    
    //调用方法
    [self registerHandler:kStartActionMessage handler:^(id data, WVJBResponseCallback responseCallback) {
        [WKWebViewJsBridge handlerAction:data callback:responseCallback];
    }];
    //获取数据
    [self registerHandler:kGetMessage handler:^(id data, WVJBResponseCallback responseCallback) {
        if (![data isKindOfClass:NSArray.class]) {
            return;
        }
        NSArray *arr = data;
        if (e_isEmpty(arr)) {
            responseCallback(@{});
            return;
        }
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        for (NSString *key in arr) {
            id value = e_preference_get(key);
            if (value) {
                dict[key] = value;
            }
        }
        responseCallback(dict);
    }];
    //保存数据
    [self registerHandler:kSetMessage handler:^(id data, WVJBResponseCallback responseCallback) {
        if (![data isKindOfClass:NSDictionary.class]) {
            return;
        }
        NSDictionary *dict = data;
        [dict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            e_preference_set(key, obj);
        }];
    }];
    //关闭当前h5
    [self registerHandler:kCloseMessage handler:^(id data, WVJBResponseCallback responseCallback) {
        UIViewController *con = [_webView viewController];
        if (con.navigationController) {
            if (con == con.navigationController.viewControllers[0]) {
                [con.navigationController dismissViewControllerAnimated:YES completion:nil];
            } else {
                [con.navigationController popViewControllerAnimated:YES];
            }
        } else {
            [con dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}

+ (void) handlerPage:(id)data callback:(WVJBResponseCallback)callback {
    if (![data isKindOfClass:NSDictionary.class]) {
        return;
    }
    NSString *pageName = data[@"pageName"][@"ios"];
    if (e_isEmpty(pageName)) {
        return;
    }
    @try {
        UIViewController *desCon = nil;
        if ([pageName containsString:split]) {
            NSArray *arr = [pageName componentsSeparatedByString:split];
            NSString *storyboardName = arr[0];
            NSString *storyboardId = arr[1];
            if ([@"init" isEqualToString:storyboardId]) {
                desCon = e_storyboard_rootController(storyboardName);
            } else {
                desCon = e_storyboard_controllerWithId(storyboardName, storyboardId);
            }
        } else {
            Class clazz = NSClassFromString(pageName);
            desCon = [[clazz alloc] init];
        }
        if (!desCon) {
            return;
        }
        NSString *startType = data[@"startType"];
        BOOL isBack = NO;
        if ([@"back" isEqualToString:startType]) {
            UIViewController *backCon = e_backToController(desCon.class);
            if (backCon) {
                isBack = YES;
                desCon = backCon;
            }
        }
        NSDictionary *pageData = data[@"data"];
        NSString *dataClassName = data[@"dataClass"][@"ios"];
        if (e_isEmpty(dataClassName) && e_isNotEmpty(pageData)) {
            if ([desCon isKindOfClass:UINavigationController.class]) {
                [((UINavigationController *)desCon).viewControllers.firstObject setValuesForKeysWithDictionary:pageData];
            } else {
                [desCon setValuesForKeysWithDictionary:pageData];
            }
        } else if (e_isNotEmpty(pageData)){
            NSArray *arr = [dataClassName componentsSeparatedByString:split];
            if (arr.count == 2) {
                NSString *objectKey = arr[0];
                id dataObject = [[NSClassFromString(arr[1]) alloc] init];
                [dataObject setValuesForKeysWithDictionary:pageData];
                if ([desCon isKindOfClass:UINavigationController.class]) {
                    [((UINavigationController *)desCon).viewControllers.firstObject setValue:dataObject forKey:objectKey];
                } else {
                    [desCon setValue:dataObject forKey:objectKey];
                }
            }
        }
        if (!isBack) {
            //启动页面 desCon
            UIViewController *topController = e_topController;
            if ([topController isKindOfClass:UINavigationController.class] && ![desCon isKindOfClass:UINavigationController.class]) {
                [(UINavigationController *)topController pushViewController:desCon animated:YES];
            } else {
                [topController presentViewController:desCon animated:YES completion:nil];
            }
        }
        if (callback) {
            callback(nil);
        }
    } @catch (NSException *exception) {
        e_log(@"%@: %@", exception.name, exception.reason);
    }
}

+ (void)handlerAction:(id)data callback:(WVJBResponseCallback)callback {
    if (![data isKindOfClass:NSDictionary.class]) {
        return;
    }
    @try {
        NSString *action = data[@"action"][@"ios"];
        if (e_isEmpty(action)) {
            return;
        }
        NSArray *arr = [action componentsSeparatedByString:split];
        NSString *className = arr[0];
        NSString *methodName = arr[arr.count -1];
        NSString *instanceName = nil;
        if (arr.count == 3) {
            instanceName = arr[1];
        }
        Class class = NSClassFromString(className);
        if (!class) {
            return;
        }
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        id obj = class;
        if (e_isNotEmpty(instanceName)) {
            if ([@"()" isEqualToString:instanceName]) {
                obj = [[class alloc] init];
            } else if ([class respondsToSelector:NSSelectorFromString(instanceName)]){
                obj = [class performSelector:NSSelectorFromString(instanceName)];
            } else {
                return;
            }
        }
        SEL method = NSSelectorFromString(methodName);
        if (![obj respondsToSelector:method]) {
            return;
        }
        
        id methodData = data[@"data"];
        NSArray *dataArr = nil;
        if (e_isEmpty(methodData)) {
            dataArr = @[];
        } else {
            if ([methodData isKindOfClass:NSDictionary.class]) {
                id iosData = methodData[@"ios"];
                if ([iosData isKindOfClass:NSArray.class]) {
                    dataArr = iosData;
                } else {
                    dataArr = @[iosData];
                }
            } else if ([methodData isKindOfClass:NSArray.class]){
                dataArr = methodData;
            }
        }
        // 方法签名(方法的描述)
        NSMethodSignature *signature = [class methodSignatureForSelector:method];
        if (!signature) {
            signature = [class instanceMethodSignatureForSelector:method];
        }
        if (!signature) {
            return;
        }
        // NSInvocation : 利用一个NSInvocation对象包装一次方法调用（方法调用者、方法名、方法参数、方法返回值）
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        invocation.target = obj;
        invocation.selector = method;
        // 设置参数
        NSInteger paramsCount = signature.numberOfArguments - 2;
        paramsCount = MIN(paramsCount, dataArr.count);
        for (NSInteger i = 0; i < paramsCount; i++) {
            id object = dataArr[i];
            if ([object isKindOfClass:[NSNull class]]) continue;
            [invocation setArgument:&object atIndex:i + 2];
        }
        
        // 调用方法
        [invocation invoke];
        id result = nil;
        void *tempResultSet;
        if (signature.methodReturnLength) {
            [invocation getReturnValue:&tempResultSet];
            result = (__bridge id)(tempResultSet);
        }
        if (result && callback) {
            callback(result);
        }
    } @catch (NSException *exception) {
        e_log(@"%@: %@", exception.name, exception.reason);
    }
#pragma clang diagnostic pop
    
}

- (void)send:(id)data {
    [self send:data responseCallback:nil];
}

- (void)send:(id)data responseCallback:(WVJBResponseCallback)responseCallback {
    [self sendData:data responseCallback:responseCallback handlerName:nil];
}

- (void)callHandler:(NSString *)handlerName {
    [self callHandler:handlerName data:nil responseCallback:nil];
}

- (void)callHandler:(NSString *)handlerName data:(id)data {
    [self callHandler:handlerName data:data responseCallback:nil];
}

- (void)callHandler:(NSString *)handlerName data:(id)data responseCallback:(WVJBResponseCallback)responseCallback {
    [self sendData:data responseCallback:responseCallback handlerName:handlerName];
}

- (void)registerHandler:(NSString *)handlerName handler:(WVJBHandler)handler {
    self.messageHandlers[handlerName] = [handler copy];
}

- (void)removeHandler:(NSString *)handlerName {
    [self.messageHandlers removeObjectForKey:handlerName];
}

- (void)reset {
    self.startupMessageQueue = [NSMutableArray array];
    self.responseCallbacks = [NSMutableDictionary dictionary];
    _uniqueId = 0;
}

- (void)setWebViewDelegate:(id<WKNavigationDelegate>)webViewDelegate {
    _webViewDelegate = webViewDelegate;
}

/* Internals
 ***********/
- (void)dealloc {
    self.startupMessageQueue = nil;
    self.responseCallbacks = nil;
    self.messageHandlers = nil;
    
    _webView = nil;
    _webViewDelegate = nil;
    _webView.navigationDelegate = nil;
}


/* WKWebView Specific Internals
 ******************************/

- (void) _setupInstance:(WKWebView*)webView {
    _webView = webView;
    _webView.navigationDelegate = self;
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    if (webView != _webView) { return; }
    
    __strong typeof(_webViewDelegate) strongDelegate = _webViewDelegate;
    if (strongDelegate && [strongDelegate respondsToSelector:@selector(webView:didFinishNavigation:)]) {
        [strongDelegate webView:webView didFinishNavigation:navigation];
    }
}


- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    if (webView != _webView) { return; }
    
    __strong typeof(_webViewDelegate) strongDelegate = _webViewDelegate;
    if (strongDelegate && [strongDelegate respondsToSelector:@selector(webView:decidePolicyForNavigationResponse:decisionHandler:)]) {
        [strongDelegate webView:webView decidePolicyForNavigationResponse:navigationResponse decisionHandler:decisionHandler];
    }
    else {
        decisionHandler(WKNavigationResponsePolicyAllow);
    }
}

- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential *))completionHandler {
    if (webView != _webView) { return; }
    
    __strong typeof(_webViewDelegate) strongDelegate = _webViewDelegate;
    if (strongDelegate && [strongDelegate respondsToSelector:@selector(webView:didReceiveAuthenticationChallenge:completionHandler:)]) {
        [strongDelegate webView:webView didReceiveAuthenticationChallenge:challenge completionHandler:completionHandler];
    } else {
        completionHandler(NSURLSessionAuthChallengePerformDefaultHandling, nil);
    }
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    if (webView != _webView) { return; }
    NSURL *url = navigationAction.request.URL;
    __strong typeof(_webViewDelegate) strongDelegate = _webViewDelegate;
    WKNavigationActionPolicy policy = WKNavigationActionPolicyAllow;
    if ([self isWebViewJavascriptBridgeURL:url]) {
        policy = WKNavigationActionPolicyCancel;
        if ([self isInitAppMessageURL:url]) {
            self.isInit = YES;
            [self jsInit];
        } else if([self isReturnMessageURL:url]){
            [self flushMessageQueue:[url.path substringFromIndex:1]];
        } else if([kStartPageMessage.lowercaseString isEqualToString:url.host.lowercaseString]
                  ||[kStartActionMessage.lowercaseString isEqualToString:url.host.lowercaseString]) {
            [WKWebViewJsBridge handlerUrl:url.absoluteString];
        } else if ([@"file" isEqualToString:url.host.lowercaseString]) {
            [WKWebViewJsBridge loadUrl:webView url:url.absoluteString];
        } else {
            policy = WKNavigationActionPolicyAllow;
        }
    }
    
    if (policy == WKNavigationActionPolicyAllow && strongDelegate && [strongDelegate respondsToSelector:@selector(webView:decidePolicyForNavigationAction:decisionHandler:)]) {
        [_webViewDelegate webView:webView decidePolicyForNavigationAction:navigationAction decisionHandler:decisionHandler];
    } else {
        decisionHandler(policy);
    }
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    if (webView != _webView) { return; }
    
    __strong typeof(_webViewDelegate) strongDelegate = _webViewDelegate;
    if (strongDelegate && [strongDelegate respondsToSelector:@selector(webView:didStartProvisionalNavigation:)]) {
        [strongDelegate webView:webView didStartProvisionalNavigation:navigation];
    }
}


- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    if (webView != _webView) { return; }
    
    __strong typeof(_webViewDelegate) strongDelegate = _webViewDelegate;
    if (strongDelegate && [strongDelegate respondsToSelector:@selector(webView:didFailNavigation:withError:)]) {
        [strongDelegate webView:webView didFailNavigation:navigation withError:error];
    }
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    if (webView != _webView) { return; }
    
    __strong typeof(_webViewDelegate) strongDelegate = _webViewDelegate;
    if (strongDelegate && [strongDelegate respondsToSelector:@selector(webView:didFailProvisionalNavigation:withError:)]) {
        [strongDelegate webView:webView didFailProvisionalNavigation:navigation withError:error];
    }
}

- (NSString*) _evaluateJavascript:(NSString*)javascriptCommand {
    [_webView evaluateJavaScript:javascriptCommand completionHandler:nil];
    return NULL;
}

static int logMaxLength = 1000;

+ (void)setLogMaxLength:(int)length { logMaxLength = length;}

- (id)init {
    if (self = [super init]) {
        self.messageHandlers = [NSMutableDictionary dictionary];
        self.startupMessageQueue = [NSMutableArray array];
        self.responseCallbacks = [NSMutableDictionary dictionary];
        _uniqueId = 0;
    }
    return self;
}

- (void)sendData:(id)data responseCallback:(WVJBResponseCallback)responseCallback handlerName:(NSString*)handlerName {
    NSMutableDictionary* message = [NSMutableDictionary dictionary];
    
    if (data) {
        message[@"data"] = data;
    }
    
    if (responseCallback) {
        NSString* callbackId = [NSString stringWithFormat:@"app_cb_%ld", ++_uniqueId];
        self.responseCallbacks[callbackId] = [responseCallback copy];
        message[@"callbackId"] = callbackId;
    }
    
    if (handlerName) {
        message[@"handlerName"] = handlerName;
    }
    [self _queueMessage:message];
}

- (void)flushMessageQueue:(NSString *)messageQueueString{
    if (messageQueueString == nil || messageQueueString.length == 0) {
        return;
    }
    id message = [self _deserializeMessageJSON:messageQueueString];
    if (![message isKindOfClass:[NSDictionary class]]) {
        return;
    }
    [self _log:@"接收到js的消息" json:message];
    
    NSString* responseId = message[@"responseId"];
    if (responseId) {
        WVJBResponseCallback responseCallback = _responseCallbacks[responseId];
        responseCallback(message[@"responseData"]);
        [self.responseCallbacks removeObjectForKey:responseId];
    } else {
        WVJBResponseCallback responseCallback = NULL;
        NSString* callbackId = message[@"callbackId"];
        if (callbackId) {
            responseCallback = ^(id responseData) {
                if (responseData == nil) {
                    responseData = [NSNull null];
                }
                
                NSDictionary* msg = @{ @"responseId":callbackId, @"responseData":responseData };
                [self _queueMessage:msg];
            };
        } else {
            responseCallback = ^(id ignoreResponseData) {
                // Do nothing
            };
        }
        
        WVJBHandler handler = self.messageHandlers[message[@"handlerName"]];
        
        if (!handler) {
            return;
        }
        
        handler(message[@"data"], responseCallback);
    }
}

- (void)jsInit {
    if (self.startupMessageQueue) {
        NSArray* queue = self.startupMessageQueue;
        self.startupMessageQueue = nil;
        for (id queuedMessage in queue) {
            [self _dispatchMessage:queuedMessage];
        }
    }
}

- (BOOL)isWebViewJavascriptBridgeURL:(NSURL*)url {
    if (![self isSchemeMatch:url]) {
        return NO;
    }
    return YES;
}

- (BOOL)isSchemeMatch:(NSURL*)url {
    NSString* scheme = url.scheme.lowercaseString;
    return [scheme isEqualToString:kProtocolScheme];
}

- (BOOL)isQueueMessageURL:(NSURL*)url {
    NSString* host = url.host.lowercaseString;
    return [self isSchemeMatch:url] && [host isEqualToString:kQueueHasMessage];
}

- (BOOL)isReturnMessageURL:(NSURL*)url {
    NSString* host = url.host.lowercaseString;
    return [self isSchemeMatch:url] && [host isEqualToString:kReturnMessage];
}

- (BOOL)isInitAppMessageURL:(NSURL*)url {
    NSString* host = url.host.lowercaseString;
    return [self isSchemeMatch:url] && [host isEqualToString:kInitAppMessage];
}

- (void)_queueMessage:(NSDictionary*)message {
    if (self.startupMessageQueue) {
        [self.startupMessageQueue addObject:message];
    } else {
        [self _dispatchMessage:message];
    }
}

- (void)_dispatchMessage:(NSDictionary*)message {
    NSString *messageJSON = [self _serializeMessage:message pretty:NO];
    [self _log:@"给js发送消息" json:messageJSON];
    messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\\" withString:@"\\\\"];
    messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\'" withString:@"\\\'"];
    messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"];
    messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\r" withString:@"\\r"];
    messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\f" withString:@"\\f"];
    messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\u2028" withString:@"\\u2028"];
    messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\u2029" withString:@"\\u2029"];
    
    NSString* javascriptCommand = [NSString stringWithFormat:@"app._handleMessageFromApp('%@');", messageJSON];
    if ([[NSThread currentThread] isMainThread]) {
        [self _evaluateJavascript:javascriptCommand];
    } else {
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self _evaluateJavascript:javascriptCommand];
        });
    }
}

- (NSString *)_serializeMessage:(id)message pretty:(BOOL)pretty{
    return [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:message options:(NSJSONWritingOptions)(pretty ? NSJSONWritingPrettyPrinted : 0) error:nil] encoding:NSUTF8StringEncoding];
}

- (id)_deserializeMessageJSON:(NSString *)messageJSON {
    return [NSJSONSerialization JSONObjectWithData:[messageJSON dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
}

- (void)_log:(NSString *)action json:(id)json {
    if (![json isKindOfClass:[NSString class]]) {
        json = [self _serializeMessage:json pretty:YES];
    }
    if ([json length] > logMaxLength) {
        e_log(@"js交互 %@: %@ [...]", action, [json substringToIndex:logMaxLength]);
    } else {
        e_log(@"js交互 %@: %@", action, json);
    }
}

@end

