//
//  LMJCALayerViewController.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/10/23.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJCALayerViewController.h"

@interface LMJCALayerViewController ()

@end

@implementation LMJCALayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_interactivePopDisabled = YES;
    [self.view makeToast:@"点击屏幕" duration:3 position:CSToastPositionCenter];
}

- (UIView *)redView
{
    if(!_redView)
    {
        UIView *redView = [[UIView alloc] initWithFrame:CGRectMake(50, 100, 150, 200)];
        [self.view addSubview:redView];
        _redView = redView;
        redView.backgroundColor = [UIColor redColor];
    }
    return _redView;
}

- (CALayer *)blueLayer
{
    if(!_blueLayer)
    {
        CALayer *blueLayer = [CALayer layer];
        [self.view.layer addSublayer:blueLayer];
        blueLayer.backgroundColor = [UIColor blueColor].CGColor;
        _blueLayer = blueLayer;
        blueLayer.frame = CGRectMake(50, 350, 100, 70);
        
    }
    return _blueLayer;
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
