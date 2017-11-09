//
//  IMHProfileViewController.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/9/20.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "IMHProfileViewController.h"
#import "IMHLoginViewController.h"

@interface IMHProfileViewController ()

@end

@implementation IMHProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的";
    
    
    LMJWordArrowItem *item = [LMJWordArrowItem itemWithTitle:[EMClient sharedClient].currentUsername subTitle: [EMClient sharedClient].version];
    
    item.image = [UIImage imageNamed:@"xhr"];
    item.cellHeight = 100;
    
    LMJWordItem *item1 = [LMJWordItem itemWithTitle:@"退出登录" subTitle: nil];
    
    LMJWeakSelf(self);
    item1.itemOperation = ^(NSIndexPath *indexPath) {
        
        [MBProgressHUD showMessage:@"正在登录out..." ToView: self.view];
        EMError *error = [[EMClient sharedClient] logout:YES];
        [MBProgressHUD hideHUDForView:self.view];
        
        if (!error) {
            NSLog(@"退出成功");
            [MBProgressHUD showInfo:@"登录出成功" ToView:self.view];
            
            [weakself.parentViewController presentViewController:[[LMJNavigationController alloc] initWithRootViewController:[[IMHLoginViewController alloc] init]] animated:YES completion:nil];
        }
        
        

        
    };
    
    
    LMJItemSection *section0 = [LMJItemSection sectionWithItems:@[item] andHeaderTitle:nil footerTitle:nil];
    
    LMJItemSection *section1 = [LMJItemSection sectionWithItems:@[item1] andHeaderTitle:nil footerTitle:nil];
    
    [self.sections addObject:section0];
    [self.sections addObject:section1];
}


#pragma mark - LMJNavUIBaseViewControllerDataSource
- (BOOL)navUIBaseViewControllerIsNeedNavBar:(LMJNavUIBaseViewController *)navUIBaseViewController
{
    return YES;
}

- (UIStatusBarStyle)navUIBaseViewControllerPreferStatusBarStyle:(LMJNavUIBaseViewController *)navUIBaseViewController
{
    return UIStatusBarStyleLightContent;
}

/**头部标题*/
- (NSMutableAttributedString*)lmjNavigationBarTitle:(LMJNavigationBar *)navigationBar
{
    return [self changeTitle:self.navigationItem.title ?: self.title];
}

/** 背景图片 */
//- (UIImage *)lmjNavigationBarBackgroundImage:(LMJNavigationBar *)navigationBar
//{
//
//}

/** 背景色 */
- (UIColor *)lmjNavigationBackgroundColor:(LMJNavigationBar *)navigationBar
{
    return RGB(30, 30, 30);
}

/** 是否隐藏底部黑线 */
- (BOOL)lmjNavigationIsHideBottomLine:(LMJNavigationBar *)navigationBar
{
    return YES;
}

/** 导航条的高度 */
//- (CGFloat)lmjNavigationHeight:(LMJNavigationBar *)navigationBar
//{
//    return 64;
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
    //    [leftButton setImage:[UIImage imageNamed:@"NavgationBar_white_back"] forState:UIControlStateHighlighted];
    
    //    return [UIImage imageNamed:@"NavgationBar_blue_back"];
    return nil;
}
/** 导航条右边的按钮 */
//- (UIImage *)lmjNavigationBarRightButtonImage:(UIButton *)rightButton navigationBar:(LMJNavigationBar *)navigationBar
//{
//
//}



#pragma mark - LMJNavUIBaseViewControllerDelegate
/** 左边的按钮的点击 */
-(void)leftButtonEvent:(UIButton *)sender navigationBar:(LMJNavigationBar *)navigationBar
{
    [self.navigationController popViewControllerAnimated:YES];
}
/** 右边的按钮的点击 */
-(void)rightButtonEvent:(UIButton *)sender navigationBar:(LMJNavigationBar *)navigationBar
{
    
}
/** 中间如果是 label 就会有点击 */
-(void)titleClickEvent:(UILabel *)sender navigationBar:(LMJNavigationBar *)navigationBar
{
    
}


#pragma mark 自定义代码

-(NSMutableAttributedString *)changeTitle:(NSString *)curTitle
{
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:curTitle ?: @""];
    
    [title addAttribute:NSForegroundColorAttributeName value:UIColor.whiteColor range:NSMakeRange(0, title.length)];
    
    [title addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:AdaptedWidth(18)] range:NSMakeRange(0, title.length)];
    
    return title;
}
@end
