//
//  LMJOCJSHelper.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/5/6.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJOCJSHelper.h"

NSString *const LMJOCJSHelperScriptMessageHandlerName1_ = @"OCJSHelper1";

@implementation LMJOCJSHelper

- (void)dealloc {
    NSLog(@"%@, %s", self.class, __func__);
}


- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    if (userContentController == self.webView.configuration.userContentController) {
        
        if ([message.name isEqualToString:LMJOCJSHelperScriptMessageHandlerName1_]) {
            
            NSDictionary *dict = message.body;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if ([dict isKindOfClass:[NSDictionary class]]) {
                    
                    NSString *code = dict[@"code"];
                    
                    if ([code isEqualToString:@"getDeviceId"]) {
                        
                        NSString *functionName = dict[@"functionName"];
                        
                        NSString *js = [functionName stringByAppendingFormat:@"('%@')", @"OC里边得到 DeviceID: 9213876827468372"];
                        
                        [self.webView evaluateJavaScript:js completionHandler:^(id _Nullable obj, NSError * _Nullable error) {
                            
                            NSLog(@"%@, %@",obj, error);
                            
                        }];
                    }
                }
            });
        }
    }
}

@end
