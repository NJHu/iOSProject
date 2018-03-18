//
//  WKWebViewJavascriptBridge.h
//
#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>


@interface WKWebViewJsBridge : NSObject<WKNavigationDelegate>

- (instancetype)initWith:(WKWebView *)webView delegate:(id<WKNavigationDelegate>)delegate;

@property (weak, nonatomic, readonly) WKWebView *webView;

- (void)registerHandler:(NSString *)handleName handle:(void(^)(id data, void(^)(id responseData)))handle;

@end

