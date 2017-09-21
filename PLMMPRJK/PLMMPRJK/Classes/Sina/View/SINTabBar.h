//
//  SINTabBar.h
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/6/19.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import <CYLTabBarController/CYLTabBarController.h>
#import <CYLTabBar.h>

@interface SINTabBar : UITabBar

/** <#digest#> */
@property (nonatomic, copy) void(^publishBtnClick)(SINTabBar *tabBar, UIButton *publishBtn);

@end
