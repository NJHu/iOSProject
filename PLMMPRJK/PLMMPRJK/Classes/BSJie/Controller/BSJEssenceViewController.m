//
//  BSJEssenceViewController.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/5/11.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "BSJEssenceViewController.h"

@interface BSJEssenceViewController ()

/** <#digest#> */
@property (weak, nonatomic) UIScrollView *titlesScrollView;

@end

@implementation BSJEssenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}


- (UIScrollView *)titlesScrollView
{
    if(_titlesScrollView == nil)
    {
        
    }
    return _titlesScrollView;
}




#pragma mark - LMJNavUIBaseViewControllerDataSource


- (UIStatusBarStyle)navUIBaseViewControllerPreferStatusBarStyle:(LMJNavUIBaseViewController *)navUIBaseViewController
{
    return UIStatusBarStyleLightContent;
}

/** 背景色 */
- (UIColor *)lmjNavigationBackgroundColor:(LMJNavigationBar *)navigationBar
{
    return RGB(208, 50, 40);
}

/** 是否隐藏底部黑线 */
- (BOOL)lmjNavigationIsHideBottomLine:(LMJNavigationBar *)navigationBar
{
    return YES;
}

/** 导航条中间的 View */
- (UIView *)lmjNavigationBarTitleView:(LMJNavigationBar *)navigationBar
{
    return ({
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainTitle"]];
        imageView.backgroundColor = [UIColor whiteColor];
        
        
        imageView;
    });
}
/** 导航条左边的按钮 */
- (UIImage *)lmjNavigationBarLeftButtonImage:(UIButton *)leftButton navigationBar:(LMJNavigationBar *)navigationBar
{
    [leftButton setImage:[UIImage imageNamed:@"MainTagSubIconClick"] forState:UIControlStateHighlighted];
    return [UIImage imageNamed:@"MainTagSubIcon"];
}
/** 导航条右边的按钮 */
- (UIImage *)lmjNavigationBarRightButtonImage:(UIButton *)rightButton navigationBar:(LMJNavigationBar *)navigationBar
{
    [rightButton setImage:[UIImage imageNamed:@"nav_coin_icon_click"] forState:UIControlStateHighlighted];
    return [UIImage imageNamed:@"nav_coin_icon"];
}



#pragma mark - LMJNavUIBaseViewControllerDelegate
/** 左边的按钮的点击 */
-(void)leftButtonEvent:(UIButton *)sender navigationBar:(LMJNavigationBar *)navigationBar
{
    
}
/** 右边的按钮的点击 */
-(void)rightButtonEvent:(UIButton *)sender navigationBar:(LMJNavigationBar *)navigationBar
{
    
}
/** 中间如果是 label 就会有点击 */
-(void)titleClickEvent:(UILabel *)sender navigationBar:(LMJNavigationBar *)navigationBar
{
    
}







@end
