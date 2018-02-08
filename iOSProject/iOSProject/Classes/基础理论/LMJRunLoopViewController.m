//
//  LMJRunLoopViewController.m
//  iOSProject
//
//  Created by HuXuPeng on 2018/2/8.
//  Copyright © 2018年 github.com/njhu. All rights reserved.
//

#import "LMJRunLoopViewController.h"
#import "LMJWebViewController.h"
@interface LMJRunLoopViewController ()

@end

@implementation LMJRunLoopViewController

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

- (UIImage *)lmjNavigationBarRightButtonImage:(UIButton *)rightButton navigationBar:(LMJNavigationBar *)navigationBar {
    
    [rightButton setTitle:@"参考网页" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    rightButton.lmj_width = 100;
    
    return nil;
}

- (void)rightButtonEvent:(UIButton *)sender navigationBar:(LMJNavigationBar *)navigationBar {
    LMJWebViewController *web = [[LMJWebViewController alloc] init];
    web.gotoURL = @"https://github.com/NJHu/NJNet/blob/master/0912runloop/README.md";
    [self.navigationController pushViewController:web animated:YES];
    
}

@end
