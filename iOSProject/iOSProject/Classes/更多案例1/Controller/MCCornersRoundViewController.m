//
//  MCCornersRoundViewController.m
//  iOSProject
//
//  Created by HuXuPeng on 2018/1/24.
//  Copyright © 2018年 github.com/njhu. All rights reserved.
//

#import "MCCornersRoundViewController.h"

@interface MCCornersRoundViewController ()

@end

@implementation MCCornersRoundViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}



#pragma mark - LMJNavUIBaseViewControllerDataSource

/** 导航条左边的按钮 */
- (UIImage *)lmjNavigationBarLeftButtonImage:(UIButton *)leftButton navigationBar:(LMJNavigationBar *)navigationBar
{
    [leftButton setImage:[UIImage imageNamed:@"NavgationBar_white_back"] forState:UIControlStateHighlighted];
    
    return [UIImage imageNamed:@"NavgationBar_blue_back"];
}

#pragma mark - LMJNavUIBaseViewControllerDelegate
/** 左边的按钮的点击 */
-(void)leftButtonEvent:(UIButton *)sender navigationBar:(LMJNavigationBar *)navigationBar
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
