//
//  WKWebViewJavascriptBridge.h
//
#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

typedef void (^WVJBResponseCallback)(id responseData);
typedef void (^WVJBHandler)(id data, WVJBResponseCallback responseCallback);

@interface WKWebViewJsBridge : NSObject<WKNavigationDelegate>

@property (assign, nonatomic) BOOL isInit;

+ (instancetype)bridgeForWebView:(WKWebView*)webView;
- (void)setWebViewDelegate:(id)webViewDelegate;

@property (weak, nonatomic, readonly) WKWebView *webView;

- (void)registerHandler:(NSString*)handlerName handler:(WVJBHandler)handler;
- (void)removeHandler:(NSString*)handlerName;
- (void)callHandler:(NSString*)handlerName;
- (void)callHandler:(NSString*)handlerName data:(id)data;
- (void)callHandler:(NSString*)handlerName data:(id)data responseCallback:(WVJBResponseCallback)responseCallback;
- (void)reset;

@end

