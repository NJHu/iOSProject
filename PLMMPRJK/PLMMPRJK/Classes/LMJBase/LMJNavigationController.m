//
//  LMJNavigationController.m
//  PLMMPRJK
//
//  Created by NJHu on 2017/3/31.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJNavigationController.h"

@interface LMJNavigationController () <UIGestureRecognizerDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>

/** 系统的右划返回功能的代理记录 */
@property (nonatomic, strong) id popGesDelegate;

@end

@implementation LMJNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // 全局侧滑
    //    [self setupNavVCView];
    
    // 边缘侧滑
    // 记录代理属性和设置自己代理
    // 记录系统的pop代理
    self.popGesDelegate = self.interactivePopGestureRecognizer.delegate;
    
    self.delegate = self;
    
    self.navigationBar.hidden = YES;
}







#pragma mark - 边缘侧滑代码
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    // 返回跟控制器的时候就恢复系统的代理
    if(viewController == navigationController.childViewControllers.firstObject)
    {
        self.interactivePopGestureRecognizer.delegate = self.popGesDelegate;
    }
}



@end






//
//#pragma mark - 全局侧滑代码
//- (void)setupNavVCView
//{
//    // 记录代理属性和设置自己代理
//    // 记录系统的pop代理
//    //    CFPLog(@"%zd", screenPopGestureRecognizer.edges);
//    
//    UIPanGestureRecognizer *panGes = [[UIPanGestureRecognizer alloc] initWithTarget:self.interactivePopGestureRecognizer.delegate action:NSSelectorFromString(@"handleNavigationTransition:")];
//    
//    [self.view addGestureRecognizer:panGes];
//    
//    panGes.delegate = self;
//    
//    // 禁止之前的手势
//    self.interactivePopGestureRecognizer.enabled = NO;
//}
//
//
///**
// <UIScreenEdgePanGestureRecognizer: 0x7fa465606120; state = Possible; delaysTouchesBegan = YES; view = <UILayoutContainerView 0x7fa465409460>; target= <(action=handleNavigationTransition:, target=<_UINavigationInteractiveTransition 0x7fa465605fc0>)>>
// */
//
//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
//{
//    // 非根控制器才能触发
//    return self.childViewControllers.count > 1;
//}
