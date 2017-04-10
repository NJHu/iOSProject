//
//  LMJWebViewController.h
//  PLMMPRJK
//
//  Created by NJHu on 2017/4/9.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJBaseViewController.h"
#import <WebKit/WebKit.h>


@protocol LMJWebViewControllerDelegate <NSObject>

//@optional
//// 左上边的返回按钮点击
//- (void)backBtnClick:(UIButton *)backBtn webView:(WKWebView *)webView ;
//
////左上边的关闭按钮的点击
//- (void)closeBtnClick:(UIButton *)closeBtn webView:(WKWebView *)webView;;
//
@end


@protocol LMJWebViewControllerDataSource <NSObject>

@optional
// 默认需要
- (BOOL)isNeedProgressIndicator;

// 默认需要
- (BOOL)isNeedAutoTitle;

@end

@interface LMJWebViewController : LMJBaseViewController<WKNavigationDelegate, WKUIDelegate, LMJWebViewControllerDelegate, LMJWebViewControllerDataSource>

/** webView */
@property (nonatomic, strong) WKWebView *webView;

/** <#digest#> */
@property (nonatomic, copy) NSString *gotoURL;


// 7页面加载完调用, 必须调用super
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation NS_REQUIRES_SUPER;


// 8页面加载失败时调用, 必须调用super
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error NS_REQUIRES_SUPER;

@end
