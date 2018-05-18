//
//  BSJTabBarController.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/5/11.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "BSJTabBarController.h"
#import "BSJEssenceViewController.h"
#import "BSJNewViewController.h"
#import "BSJPublishViewController.h"
#import "BSJTrendViewController.h"
#import "BSJMeViewController.h"
#import "BSJTabBar.h"
#import "BSJGuidePushView.h"
#import "PresentAnimator.h"

@interface BSJTabBarController ()<UITabBarControllerDelegate>

@end

@implementation BSJTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpTabBar];
    [self addChildViewControllers];
    [self addTabarItems];
    self.delegate = self;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [[UIApplication sharedApplication].keyWindow addSubview:[BSJGuidePushView guidePushView]];
    });
}


/**
 *  利用 KVC 把系统的 tabBar 类型改为自定义类型。覆盖父类方法
 */
- (void)setUpTabBar {
    BSJTabBar *tabBar = [[BSJTabBar alloc] init];
    LMJWeak(self);
    [tabBar setPublishBtnClick:^(BSJTabBar *tabBar, UIButton *publishBtn){
        [weakself showPublishVc];
    }];
    [self setValue:tabBar forKeyPath:LMJKeyPath(self, tabBar)];
}

- (void)addChildViewControllers
{
    LMJNavigationController *one = [[LMJNavigationController alloc] initWithRootViewController:[[BSJEssenceViewController alloc] init]];
    
    LMJNavigationController *two = [[LMJNavigationController alloc] initWithRootViewController:[[BSJNewViewController alloc] init]];
    
    LMJNavigationController *four = [[LMJNavigationController alloc] initWithRootViewController:[[BSJTrendViewController alloc] init]];
    
    LMJNavigationController *five = [[LMJNavigationController alloc] initWithRootViewController:[[BSJMeViewController alloc] init]];
    
    self.viewControllers = @[one, two, four, five];
    
}

- (void)addTabarItems
{
    
    NSDictionary *firstTabBarItemsAttributes = @{
                                                 @"TabBarItemTitle" : @"精华",
                                                 @"TabBarItemImage" : @"tabBar_essence_icon",
                                                 @"TabBarItemSelectedImage" : @"tabBar_essence_click_icon",
                                                 };
    
    NSDictionary *secondTabBarItemsAttributes = @{
                                                  @"TabBarItemTitle" : @"关注",
                                                  @"TabBarItemImage" : @"tabBar_friendTrends_icon",
                                                  @"TabBarItemSelectedImage" : @"tabBar_friendTrends_click_icon",
                                                  };
    NSDictionary *thirdTabBarItemsAttributes = @{
                                                 @"TabBarItemTitle" : @"新帖",
                                                 @"TabBarItemImage" : @"tabBar_new_icon",
                                                 @"TabBarItemSelectedImage" : @"tabBar_new_click_icon",
                                                 };
    
    NSDictionary *fourthTabBarItemsAttributes = @{
                                                  @"TabBarItemTitle" : @"我",
                                                  @"TabBarItemImage" : @"tabBar_me_icon",
                                                  @"TabBarItemSelectedImage" : @"tabBar_me_click_icon"
                                                  };
    
    NSArray<NSDictionary *>  *tabBarItemsAttributes = @[
                                   firstTabBarItemsAttributes,
                                   thirdTabBarItemsAttributes,
                                   secondTabBarItemsAttributes,
                                   fourthTabBarItemsAttributes
                                   ];
    
    [self.childViewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        obj.tabBarItem.title = tabBarItemsAttributes[idx][@"TabBarItemTitle"];
        obj.tabBarItem.image = [UIImage imageNamed:tabBarItemsAttributes[idx][@"TabBarItemImage"]];
        obj.tabBarItem.selectedImage = [UIImage imageNamed:tabBarItemsAttributes[idx][@"TabBarItemSelectedImage"]];
        obj.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -3);
    }];
    
    self.tabBar.tintColor = [UIColor redColor];
}

#pragma mark - UITabBarControllerDelegate
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    return YES;
}

- (void)showPublishVc
{
    LMJWeak(self);
    BSJPublishViewController *publishVc = [[BSJPublishViewController alloc] init];
    
    [PresentAnimator viewController:weakself presentViewController:publishVc presentViewFrame:[UIScreen mainScreen].bounds animated:YES completion:nil animatedDuration:0.5 presentAnimation:^(UIView *presentedView, UIView *containerView, void (^completion)(BOOL finished)) {
        
        // 自己做动画
        presentedView.transform = CGAffineTransformMakeTranslation(0, -kScreenHeight);
        [UIView animateWithDuration:0.5 animations:^{
            presentedView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            completion(finished);
        }];
        
    } dismissAnimation:^(UIView *dismissView, void (^completion)(BOOL finished)) {
        // 自己做动画
        [UIView animateWithDuration:0.5 animations:^{
            dismissView.transform = CGAffineTransformMakeTranslation(-kScreenWidth, 0);
        } completion:^(BOOL finished) {
            completion(finished);
        }];
        
    }];
    
}

@end
