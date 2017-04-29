//
//  LMJVerticalLayoutViewController.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/4/20.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJVerticalLayoutViewController.h"

@interface LMJVerticalLayoutViewController ()

@end

@implementation LMJVerticalLayoutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}





#pragma mark - LMJNavUIBaseViewControllerDataSource
//- (BOOL)navUIBaseViewControllerIsNeedNavBar:(LMJNavUIBaseViewController *)navUIBaseViewController
//{
//    return YES;
//}

/**头部标题*/
- (NSMutableAttributedString*)lmjNavigationBarTitle:(LMJNavigationBar *)navigationBar
{
    return [self changeTitle:@"CollectionView默认是垂直流水"];
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
    
    [leftButton setTitle:@"< 返回" forState:UIControlStateNormal];
    
    leftButton.lmj_width = 60;
    
    [leftButton setTitleColor:[UIColor RandomColor] forState:UIControlStateNormal];
    
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
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:curTitle];
    
    [title addAttribute:NSForegroundColorAttributeName value:HEXCOLOR(0x333333) range:NSMakeRange(0, title.length)];
    
    [title addAttribute:NSFontAttributeName value:CHINESE_SYSTEM(16) range:NSMakeRange(0, title.length)];
    
    return title;
}


@end
