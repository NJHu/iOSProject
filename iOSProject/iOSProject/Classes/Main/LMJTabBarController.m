//
//  LMJTabBarController.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/4/6.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJTabBarController.h"
#import "LMJNavigationController.h"
#import "LMJHomeViewController.h"
#import "LMJMessageViewController.h"
#import "LMJMeViewController.h"
#import "LMJNewViewController.h"
#import "LMJCasesViewController.h"


@interface LMJTabBarController ()<UITabBarControllerDelegate>

@end

@implementation LMJTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBar.tintColor = [UIColor redColor];
    [self setValue:[NSValue valueWithUIOffset:UIOffsetMake(0, -3)] forKeyPath:LMJKeyPath(self, titlePositionAdjustment)];
    [self addTabarItems];
    [self addChildViewControllers];
    self.delegate = self;
}


- (void)addChildViewControllers
{
    LMJNavigationController *one = [[LMJNavigationController alloc] initWithRootViewController:[[LMJHomeViewController alloc] init]];
    
    LMJNavigationController *two = [[LMJNavigationController alloc] initWithRootViewController:[[LMJNewViewController alloc] init]];
    
    LMJNavigationController *three = [[LMJNavigationController alloc] initWithRootViewController:[[LMJMessageViewController alloc] init]];
    
    LMJNavigationController *four = [[LMJNavigationController alloc] initWithRootViewController:[[LMJMeViewController alloc] init]];
    
    LMJNavigationController *five = [[LMJNavigationController alloc] initWithRootViewController:[[LMJCasesViewController alloc] init]];
    
    self.viewControllers = @[two, one, three, five, four];
    
}

- (void)addTabarItems
{
    
    NSDictionary *firstTabBarItemsAttributes = @{
                                                 CYLTabBarItemTitle : @"基础",
                                                 CYLTabBarItemImage : @"tabBar_essence_icon",
                                                 CYLTabBarItemSelectedImage : @"tabBar_essence_click_icon",
                                                 };
    
    NSDictionary *secondTabBarItemsAttributes = @{
                                                 CYLTabBarItemTitle : @"预演",
                                                 CYLTabBarItemImage : @"tabBar_friendTrends_icon",
                                                 CYLTabBarItemSelectedImage : @"tabBar_friendTrends_click_icon",
                                                 };
    NSDictionary *thirdTabBarItemsAttributes = @{
                                                 CYLTabBarItemTitle : @"实例",
                                                 CYLTabBarItemImage : @"tabBar_new_icon",
                                                 CYLTabBarItemSelectedImage : @"tabBar_new_click_icon",
                                                 };
    NSDictionary *fourthTabBarItemsAttributes = @{
                                                  CYLTabBarItemTitle : @"分享",
                                                  CYLTabBarItemImage : @"tabBar_me_icon",
                                                  CYLTabBarItemSelectedImage : @"tabBar_me_click_icon"
                                                  };
    NSDictionary *fifthTabBarItemsAttributes = @{
                                                  CYLTabBarItemTitle : @"更多",
                                                  CYLTabBarItemImage : @"tabbar_discover",
                                                  CYLTabBarItemSelectedImage : @"tabbar_discover_highlighted"
                                                  };
    self.tabBarItemsAttributes = @[    secondTabBarItemsAttributes,
                                       firstTabBarItemsAttributes,
                                       thirdTabBarItemsAttributes,
                                       fifthTabBarItemsAttributes,
                                       fourthTabBarItemsAttributes
                                       ];
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    return YES;
}

@end
