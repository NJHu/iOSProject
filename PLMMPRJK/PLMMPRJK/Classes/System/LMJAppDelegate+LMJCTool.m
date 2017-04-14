//
//  LMJAppDelegate+LMJCTool.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/4/14.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJAppDelegate+LMJCTool.h"

@implementation LMJAppDelegate (LMJCTool)


- (void)setLaunchOptions:(NSDictionary *)launchOptions
{
    
    //配置DDLog
    [DDLog addLogger:[DDTTYLogger sharedInstance]]; // TTY = Xcode console
    [DDLog addLogger:[DDASLLogger sharedInstance]]; // ASL = Apple System Logs

    
    
    // 友盟
    [MPUmengHelper UMAnalyticStart];
    [MPUmengHelper UMSocialStart];
    [MPUmengHelper UMPushStart:launchOptions];
    
    
    
    // 魔窗
//    [LMJMagicWindowHelper MagicStart];
    
    // 键盘
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = YES;
    manager.shouldPlayInputClicks = YES;
    manager.shouldShowTextFieldPlaceholder = YES;
    
    
}

@end
