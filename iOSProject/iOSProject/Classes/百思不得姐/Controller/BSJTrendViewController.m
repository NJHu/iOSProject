//
//  BSJTrendViewController.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/5/11.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "BSJTrendViewController.h"
#import "BSJRecommendViewController.h"
#import "BSJLoginRegisterViewController.h"


@interface BSJTrendViewController ()

@end

@implementation BSJTrendViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}


#pragma mark - action

- (IBAction)goToLoginRegister:(UIButton *)sender {
    
    [self presentViewController:[[LMJNavigationController alloc] initWithRootViewController:[[BSJLoginRegisterViewController alloc] init]] animated:YES completion:nil];
}


#pragma mark - LMJNavUIBaseViewControllerDataSource


- (NSMutableAttributedString *)lmjNavigationBarTitle:(LMJNavigationBar *)navigationBar
{
    return [self changeTitle:@"我的关注"];
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
    [self.navigationController pushViewController:[[BSJRecommendViewController alloc] init] animated:YES];
}
/** 右边的按钮的点击 */
-(void)rightButtonEvent:(UIButton *)sender navigationBar:(LMJNavigationBar *)navigationBar
{
        [self.navigationController pushViewController:[[BSJRecommendViewController alloc] init] animated:YES];
}
/** 中间如果是 label 就会有点击 */
-(void)titleClickEvent:(UILabel *)sender navigationBar:(LMJNavigationBar *)navigationBar
{
        [self.navigationController pushViewController:[[BSJRecommendViewController alloc] init] animated:YES];
}


#pragma mark 自定义代码

-(NSMutableAttributedString *)changeTitle:(NSString *)curTitle
{
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:curTitle ?: @""];

    [title addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, title.length)];

    [title addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:18] range:NSMakeRange(0, title.length)];

    return title;
}





@end
