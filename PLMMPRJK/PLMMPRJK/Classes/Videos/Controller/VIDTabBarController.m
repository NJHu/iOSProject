//
//  VIDTabBarController.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/5/11.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "VIDTabBarController.h"
#import "VIDLocalViewController.h"
#import "VIDNetListViewController.h"
#import "VIDTableViewController.h"
#import "VIDCollectionViewController.h"

@interface VIDTabBarController ()

@end

@implementation VIDTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tabBar.tintColor = RGB(25, 179, 10);
    self.tabBar.unselectedItemTintColor = RGB(103, 107, 112);
    self.titlePositionAdjustment = UIOffsetMake(0, -10);
    [self addTabarItems];
    [self addChildViewControllers];
    
}



- (void)addChildViewControllers
{
    LMJNavigationController *one = [[LMJNavigationController alloc] initWithRootViewController:[[VIDNetListViewController alloc] init]];
    
    LMJNavigationController *two = [[LMJNavigationController alloc] initWithRootViewController:[[VIDTableViewController alloc] init]];
    
    LMJNavigationController *four = [[LMJNavigationController alloc] initWithRootViewController:[[VIDCollectionViewController alloc] init]];
    
    LMJNavigationController *five = [[LMJNavigationController alloc] initWithRootViewController:[[VIDLocalViewController alloc] init]];
    
    self.viewControllers = @[one, two, four, five];
    
}

/*
 
 tabbar_home
 */

- (void)addTabarItems
{
    
    
    NSDictionary *firstTabBarItemsAttributes = @{
                                                 CYLTabBarItemTitle : @"列表视频",
                                                
                                                 };
    
    NSDictionary *secondTabBarItemsAttributes = @{
                                                  CYLTabBarItemTitle : @"Table视频",
                                                  };
    NSDictionary *thirdTabBarItemsAttributes = @{
                                                 CYLTabBarItemTitle : @"Collection视频",
                                                 };
    
    NSDictionary *fourthTabBarItemsAttributes = @{
                                                  CYLTabBarItemTitle : @"Local下载",
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
