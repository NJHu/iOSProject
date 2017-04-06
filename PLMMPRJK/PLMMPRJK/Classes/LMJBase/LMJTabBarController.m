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
#import "LMJTabBar.h"


@interface LMJTabBarController ()

@end

@implementation LMJTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    /**
     *  添加了4个控制器
     */
    [self addChildViewControllers];
    
    
    // 把系统的tababr设置为自定义的tababr
    //    self.tabBar = [[LMJTabBar alloc] init];
    // 利用KVC
    [self setValue:[[LMJTabBar alloc] init] forKey:@"tabBar"];
}


/**
 *  添加了4个控制器
 */
- (void)addChildViewControllers
{
    [self addChildViewController:[[LMJHomeViewController alloc] init] title:@"关注" image:@"tabBar_friendTrends_icon" selectedImage:@"tabBar_friendTrends_click_icon"];
    
    
    [self addChildViewController:[[LMJMessageViewController alloc] init] title:@"精华" image:@"tabBar_essence_icon" selectedImage:@"tabBar_essence_click_icon"];
    
    [self addChildViewController:[[LMJNewViewController alloc] init] title:@"新帖" image:@"tabBar_new_icon" selectedImage:@"tabBar_new_click_icon"];
    
    [self addChildViewController:[[LMJMeViewController alloc] init] title:@"我" image:@"tabBar_me_icon" selectedImage:@"tabBar_me_click_icon"];
}

/**
 *  自定义方法添加自控制器
 */
- (void)addChildViewController:(UIViewController *)childController title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    childController.navigationItem.title = title;
    childController.tabBarItem.title = title;
    childController.tabBarItem.image = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childController.tabBarItem.selectedImage = [UIImage imageNamed:selectedImage];
    
    // 在这里会加载loadview, 并且设置里边的标题
    //    childController.view.backgroundColor = [self randomColor];
    
    // 如果在上一步之后再执行 childController.navigationItem.title = title;
    // 那么自定义的标题会被覆盖
    // 注意
    
    /**
     *  添加自控制器, 并且包装成导航控制器
     */
    [self addChildViewController:[[LMJNavigationController alloc] initWithRootViewController:childController]];
}

@end
