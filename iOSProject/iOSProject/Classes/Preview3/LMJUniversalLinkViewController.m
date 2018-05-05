//
//  LMJUniversalLinkViewController.m
//  iOSProject
//
//  Created by HuXuPeng on 2018/5/5.
//  Copyright © 2018年 github.com/njhu. All rights reserved.
//

#import "LMJUniversalLinkViewController.h"

@interface LMJUniversalLinkViewController ()

@end

@implementation LMJUniversalLinkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[[NSBundle mainBundle] URLForResource:@"LMJUniversalLink" withExtension:@"html"]]];
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler
{
    NSLog(@"%@", frame);
    
    [UIAlertController mj_showAlertWithTitle:@"打开浏览器, 点击里边的链接打开 App " message:message appearanceProcess:^(JXTAlertController * _Nonnull alertMaker) {
        
        alertMaker.addActionDestructiveTitle(@"cancel").addActionDefaultTitle(@"confirm");
        
    } actionsBlock:^(NSInteger buttonIndex, UIAlertAction * _Nonnull action, JXTAlertController * _Nonnull alertSelf) {
        
        if (buttonIndex == 0) {
            completionHandler(NO);
        }else {
            completionHandler(YES);
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/NJHu/njhu.github.io/blob/master/iOSProjectAppIntroduction/readme.md"] options:@{@"from": @"iOSProject"} completionHandler:^(BOOL success) {
                NSLog(@"打开了浏览器");
            }];
        }
    }];
}
@end
