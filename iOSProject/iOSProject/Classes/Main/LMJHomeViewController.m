//
//  LMJHomeViewController.m
//  PLMMPRJK
//
//  Created by NJHu on 2017/3/29.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJHomeViewController.h"
#import "LMJWebViewController.h"
#import "LMJLiftCycleViewController.h"
#import "LMJRunTimeViewController.h"
#import "LMJNSThreadViewController.h"
#import "LMJGCDViewController.h"
#import "LMJNSOperationViewController.h"
#import "LMJLockViewController.h"
#import "LMJProtocolViewController.h"
#import "LMJBlockLoopViewController.h"

#import "LMJDynamicViewController.h"
#import "LMJCoreAnimationViewController.h"
#import "LMJDrawRectViewController.h"

@interface LMJHomeViewController ()

@end

@implementation LMJHomeViewController

#pragma mark viewController生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIEdgeInsets edgeInsets = self.tableView.contentInset;
    edgeInsets.bottom += self.tabBarController.tabBar.lmj_height;
    self.tableView.contentInset = edgeInsets;
    
    LMJWordArrowItem *item00 = [LMJWordArrowItem itemWithTitle:@"ViewController的生命周期" subTitle: nil];
    item00.destVc = [LMJLiftCycleViewController class];
    
    LMJWordArrowItem *item01 = [LMJWordArrowItem itemWithTitle:@"运行时RunTime 的知识运用" subTitle: nil];
    item01.destVc = [LMJRunTimeViewController class];
    
    LMJWordArrowItem *item03 = [LMJWordArrowItem itemWithTitle:@"Protocol 的实现类" subTitle: nil];
    item03.destVc = [LMJProtocolViewController class];
    
    
    LMJWordArrowItem *item04 = [LMJWordArrowItem itemWithTitle:@"Block 内存释放" subTitle: nil];
    item04.destVc = [LMJBlockLoopViewController class];
    
    
    LMJItemSection *section0 = [LMJItemSection sectionWithItems:@[item00, item01, item03, item04] andHeaderTitle:@"生命周期, RunTime" footerTitle:nil];
    
    [self.sections addObject:section0];
    
    
    
    LMJWordArrowItem *item10 = [LMJWordArrowItem itemWithTitle:@"NSThread 多线程" subTitle: nil];
    item10.destVc = [LMJNSThreadViewController class];
    
    LMJWordArrowItem *item11 = [LMJWordArrowItem itemWithTitle:@"GCD 多线程" subTitle: nil];
    item11.destVc = [LMJGCDViewController class];
    
    LMJWordArrowItem *item12 = [LMJWordArrowItem itemWithTitle:@" NSOperation 多线程" subTitle: nil];
    item12.destVc = [LMJNSOperationViewController class];
    
    LMJWordArrowItem *item13 = [LMJWordArrowItem itemWithTitle:@"同步锁知识" subTitle: nil];
    item13.destVc = [LMJLockViewController class];
    
    
    
    LMJItemSection *section1 = [LMJItemSection sectionWithItems:@[item10, item11, item12, item13] andHeaderTitle:@"NSThread, GCD, NSOperation, Lock" footerTitle:nil];
    
    [section1.items makeObjectsPerformSelector:@selector(setTitleColor:) withObject:[UIColor RandomColor]];
    
    [self.sections addObject:section1];
    
    
    LMJWordArrowItem *item20 = [LMJWordArrowItem itemWithTitle:@"物理仿真" subTitle: @""];
    
    item20.destVc = [LMJDynamicViewController class];
    
    LMJWordArrowItem *item21 = [LMJWordArrowItem itemWithTitle:@"核心动画" subTitle: @""];
    
    item21.destVc = [LMJCoreAnimationViewController class];
    
    LMJWordArrowItem *item22 = [LMJWordArrowItem itemWithTitle:@"绘图 Quartz2D" subTitle: @"Draw Rect"];
    
    item22.destVc = [LMJDrawRectViewController class];
    
    LMJItemSection *section2 = [LMJItemSection sectionWithItems:@[item20, item21, item22] andHeaderTitle:@"物理仿真, 核心动画, 绘图 Quartz2D" footerTitle:nil];
    
    [self.sections addObject:section2];
    
    
    UITabBarItem *homeItem = self.navigationController.tabBarItem;
    
    [homeItem setBadgeValue:@"3"];
    
}



#pragma mark - LMJNavUIBaseViewControllerDataSource
//- (BOOL)navUIBaseViewControllerIsNeedNavBar:(LMJNavUIBaseViewController *)navUIBaseViewController
//{
//    return YES;
//}



#pragma mark - DataSource
/**头部标题*/
- (NSMutableAttributedString*)lmjNavigationBarTitle:(LMJNavigationBar *)navigationBar
{
    return [self changeTitle:@"预演 功能列表"];
}

/** 背景图片 */
//- (UIImage *)lmjNavigationBarBackgroundImage:(LMJNavigationBar *)navigationBar
//{
//
//}

/** 背景色 */
//- (UIColor *)lmjNavigationBackgroundColor:(LMJNavigationBar *)navigationBar
//{
//
//}

/** 是否隐藏底部黑线 */
//- (BOOL)lmjNavigationIsHideBottomLine:(LMJNavigationBar *)navigationBar
//{
//    return NO;
//}

/** 导航条的高度 */
//- (CGFloat)lmjNavigationHeight:(LMJNavigationBar *)navigationBar
//{
//
//}


/** 导航条的左边的 view */
//- (UIView *)lmjNavigationBarLeftView:(LMJNavigationBar *)navigationBar
//{
//
//}
/** 导航条右边的 view */
//- (UIView *)lmjNavigationBarRightView:(LMJNavigationBar *)navigationBar
//{
//
//}
/** 导航条中间的 View */
//- (UIView *)lmjNavigationBarTitleView:(LMJNavigationBar *)navigationBar
//{
//
//}
/** 导航条左边的按钮 */
- (UIImage *)lmjNavigationBarLeftButtonImage:(UIButton *)leftButton navigationBar:(LMJNavigationBar *)navigationBar
{
    [leftButton setTitle:@"😁" forState:UIControlStateNormal];
    return nil;
}
/** 导航条右边的按钮 */
- (UIImage *)lmjNavigationBarRightButtonImage:(UIButton *)rightButton navigationBar:(LMJNavigationBar *)navigationBar
{
    [rightButton setTitle:@"百度" forState:UIControlStateNormal];
    
    [rightButton setTitleColor:[UIColor RandomColor] forState:UIControlStateNormal];
    return nil;
}



#pragma mark - Delegate
/** 左边的按钮的点击 */
-(void)leftButtonEvent:(UIButton *)sender navigationBar:(LMJNavigationBar *)navigationBar
{
    
}
/** 右边的按钮的点击 */
-(void)rightButtonEvent:(UIButton *)sender navigationBar:(LMJNavigationBar *)navigationBar
{
    LMJWebViewController *ac = [LMJWebViewController new];
    ac.gotoURL = @"http://www.baidu.com";
    
    [self.navigationController pushViewController:ac animated:YES];
    NSLog(@"%s", __func__);
}
/** 中间如果是 label 就会有点击 */
-(void)titleClickEvent:(UILabel *)sender navigationBar:(LMJNavigationBar *)navigationBar
{
    NSLog(@"%s", __func__);
}


#pragma mark 自定义代码

-(NSMutableAttributedString *)changeTitle:(NSString *)curTitle
{
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:curTitle ?: @""];
    
    [title addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, title.length)];
    
    [title addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, title.length)];
    
    return title;
}






@end




