//
//  WebView+Alert.h
//  AlertProject
//
//  Created by Peter.Kang on 14-1-23.
//  Copyright (c) 2014年 Peter.Kang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWebView (JavaScriptAlert)<UIAlertViewDelegate>
-(void)webView:(UIWebView *)sender runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(id)frame;

-(BOOL)webView:(UIWebView *)sender runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(id)frame;
@end
