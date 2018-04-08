//
//  LMJDrawBaseViewController.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/10/24.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJDrawBaseViewController.h"

@interface LMJDrawBaseViewController ()

@end

@implementation LMJDrawBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_interactivePopDisabled = YES;
}

- (UIView *)redView
{
    if(!_redView)
    {
        UIView *redView = [[self.drawViewClass alloc] initWithFrame:CGRectMake(10, 100, kScreenWidth - 20, kScreenHeight - 140)];
        [self.view addSubview:redView];
        _redView = redView;
        redView.backgroundColor = [UIColor whiteColor];
    }
    return _redView;
}

- (Class)drawViewClass
{
    return [UIView class];
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
