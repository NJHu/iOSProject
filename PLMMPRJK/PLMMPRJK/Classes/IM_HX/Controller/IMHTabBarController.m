//
//  IMHTabBarController.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/5/11.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "IMHTabBarController.h"
#import "IMHAppDelegate.h"
#import "IMHChatsViewController.h"
#import "IMHContractsViewController.h"
#import "IMHDiscoveryViewController.h"
#import "IMHProfileViewController.h"
#import "IMHLoginViewController.h"


@interface IMHTabBarController ()

@end

@implementation IMHTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tabBar.tintColor = RGB(25, 179, 10);
    self.tabBar.unselectedItemTintColor = RGB(103, 107, 112);
    self.titlePositionAdjustment = UIOffsetMake(0, -3);
    
    [self addTabarItems];
    [self addChildViewControllers];
    
    [IMHAppDelegate sharedDelegate];
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(![EMClient sharedClient].options.isAutoLogin)
    {
        [self presentViewController:[[LMJNavigationController alloc] initWithRootViewController:[[IMHLoginViewController alloc] init]] animated:YES completion:nil];
    }
}



- (void)addChildViewControllers
{
    LMJNavigationController *one = [[LMJNavigationController alloc] initWithRootViewController:[[IMHChatsViewController alloc] init]];
    
    LMJNavigationController *two = [[LMJNavigationController alloc] initWithRootViewController:[[IMHContractsViewController alloc] init]];
    
    LMJNavigationController *four = [[LMJNavigationController alloc] initWithRootViewController:[[IMHDiscoveryViewController alloc] init]];
    
    LMJNavigationController *five = [[LMJNavigationController alloc] initWithRootViewController:[[IMHProfileViewController alloc] init]];
    
    self.viewControllers = @[one, two, four, five];
    
}

/*
 
 tabbar_home
 */

- (void)addTabarItems
{
    
    
    NSDictionary *firstTabBarItemsAttributes = @{
                                                 CYLTabBarItemTitle : @"聊天",
                                                 CYLTabBarItemImage : @"tabbar_mainframe",
                                                 CYLTabBarItemSelectedImage : @"tabbar_mainframeHL",
                                                 };
    
    NSDictionary *secondTabBarItemsAttributes = @{
                                                  CYLTabBarItemTitle : @"通讯录",
                                                  CYLTabBarItemImage : @"tabbar_contacts",
                                                  CYLTabBarItemSelectedImage : @"tabbar_contactsHL",
                                                  };
    NSDictionary *thirdTabBarItemsAttributes = @{
                                                 CYLTabBarItemTitle : @"发现",
                                                 CYLTabBarItemImage : @"tabbar_discoverWX",
                                                 CYLTabBarItemSelectedImage : @"tabbar_discoverWXHL",
                                                 };
    
    NSDictionary *fourthTabBarItemsAttributes = @{
                                                  CYLTabBarItemTitle : @"我的",
                                                  CYLTabBarItemImage : @"tabbar_me",
                                                  CYLTabBarItemSelectedImage : @"tabbar_meHL"
                                                  };
    
    self.tabBarItemsAttributes = @[
                                   firstTabBarItemsAttributes,
                                   secondTabBarItemsAttributes,
                                   thirdTabBarItemsAttributes,
                                   fourthTabBarItemsAttributes
                                   ];
    
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    return YES;
}




@end
