//
//  LMJOCJSHelper.h
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/5/6.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

UIKIT_EXTERN NSString *const LMJOCJSHelperScriptMessageHandlerName1_;


@protocol LMJOCJSHelperDelegate <NSObject>

@optional

@end



@interface LMJOCJSHelper : NSObject<WKScriptMessageHandler>

/** <#digest#> */
@property (weak, nonatomic) WKWebView *webView;

/** <#digest#> */
@property (weak, nonatomic) id<LMJOCJSHelperDelegate> delegate;


- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message;

@end
