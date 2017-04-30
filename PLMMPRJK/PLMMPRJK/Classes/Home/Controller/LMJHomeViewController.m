//
//  LMJHomeViewController.m
//  PLMMPRJK
//
//  Created by NJHu on 2017/3/29.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJHomeViewController.h"
#import "LMJActivityViewController.h"
#import "LMJLiftCycleViewController.h"
#import "LMJRunTimeViewController.h"
#import "LMJMultithreadViewController.h"
#import "LMJProtocolViewController.h"
#import "LMJBlockLoopViewController.h"

@interface LMJHomeViewController ()

@end

@implementation LMJHomeViewController

#pragma mark viewController生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIEdgeInsets edgeInsets = self.tableView.contentInset;
    edgeInsets.bottom += self.tabBarController.tabBar.lmj_height;
    self.tableView.contentInset = edgeInsets;
    
    LMJWordArrowItem *item0 = [LMJWordArrowItem itemWithTitle:@"ViewController的生命周期" subTitle: nil];
    item0.destVc = [LMJLiftCycleViewController class];
    
    LMJWordArrowItem *item1 = [LMJWordArrowItem itemWithTitle:@"运行时RunTime 的知识运用" subTitle: nil];
    item1.destVc = [LMJRunTimeViewController class];
    
    LMJWordArrowItem *item2 = [LMJWordArrowItem itemWithTitle:@"多线程知识运用" subTitle: nil];
    item2.destVc = [LMJMultithreadViewController class];
    
    LMJWordArrowItem *item3 = [LMJWordArrowItem itemWithTitle:@"Protocol 的实现类" subTitle: nil];
    item3.destVc = [LMJProtocolViewController class];
    
    
    LMJWordArrowItem *item4 = [LMJWordArrowItem itemWithTitle:@"Block 内存释放" subTitle: nil];
    item4.destVc = [LMJBlockLoopViewController class];
    
    
    LMJItemSection *section0 = [LMJItemSection sectionWithItems:@[item0, item1, item2, item3, item4] andHeaderTitle:nil footerTitle:nil];
    
    [self.sections addObject:section0];
    
    
    
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
    LMJActivityViewController *ac = [LMJActivityViewController new];
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
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:curTitle];
    
    [title addAttribute:NSForegroundColorAttributeName value:HEXCOLOR(0x333333) range:NSMakeRange(0, title.length)];
    
    [title addAttribute:NSFontAttributeName value:CHINESE_SYSTEM(16) range:NSMakeRange(0, title.length)];
    
    return title;
}






@end




