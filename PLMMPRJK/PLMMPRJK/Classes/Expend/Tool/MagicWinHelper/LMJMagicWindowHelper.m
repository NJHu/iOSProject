//
//  LMJMagicWindowHelper.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/4/12.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJMagicWindowHelper.h"
#import "LMJActivityViewController.h"

@implementation LMJMagicWindowHelper

+ (void)MagicStart
{
    // 魔窗
    [MWApi registerApp:LMJThirdSDKMagicWindow];
    
    [MWApi registerMLinkHandlerWithKey:@"test1Key" handler:^(NSURL *url, NSDictionary *params) {
        
        if ([params[@"url"] length] == 0) {
            return ;
        }
        
        
        Log(@"%@\n\n%@", url.absoluteString, params);
        
        
        [SVProgressHUD showSuccessWithStatus:params.description];
        
        //跳转到app展示页，示例如下：
        LMJActivityViewController *activityWebVc = [[LMJActivityViewController alloc] init];
        
        
        activityWebVc.gotoURL = params[@"url"];
        
        
        
        [kKeyWindow.rootViewController.childViewControllers.firstObject.childViewControllers.firstObject.navigationController pushViewController:activityWebVc animated:NO];
    }];
}

@end
