//
//  LMJFaceDetectorViewController.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/5/7.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJFaceDetectorViewController.h"

@interface LMJFaceDetectorViewController ()

@end

@implementation LMJFaceDetectorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    switch (self.faceDetectorType) {
        case LMJFaceDetectorViewControllerTypeRegist:
            self.navigationItem.title = @"脸部\"注册\"";
            break;
        case LMJFaceDetectorViewControllerTypeYanZheng:
            self.navigationItem.title = @"脸部\"验证\"";
            break;
    }

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
