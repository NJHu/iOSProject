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

/**头部标题*/
- (NSMutableAttributedString*)lmjNavigationBarTitle:(LMJNavigationBar *)navigationBar
{
    return [self changeTitle:@"CollectionView默认是垂直流水"];
}


/** 导航条左边的按钮 */
- (UIImage *)lmjNavigationBarLeftButtonImage:(UIButton *)leftButton navigationBar:(LMJNavigationBar *)navigationBar
{
    
    [leftButton setTitle:@"< 返回" forState:UIControlStateNormal];
    
    leftButton.lmj_width = 60;
    
    [leftButton setTitleColor:[UIColor RandomColor] forState:UIControlStateNormal];
    
    return nil;
}



#pragma mark - LMJNavUIBaseViewControllerDelegate
/** 左边的按钮的点击 */
-(void)leftButtonEvent:(UIButton *)sender navigationBar:(LMJNavigationBar *)navigationBar
{
    [self.navigationController popViewControllerAnimated:YES];
}



@end
