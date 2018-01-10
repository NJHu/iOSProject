//
//  LMJFingerCheckViewController.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/5/22.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJFingerCheckViewController.h"
#import <TDTouchID.h>

@interface LMJFingerCheckViewController ()

@end

@implementation LMJFingerCheckViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //使用TDButton更方便 https://github.com/greezi/TDButton
    UIButton *touchIDButton = [[UIButton alloc] init];
    [touchIDButton setBackgroundImage:[UIImage imageWithColor:[UIColor RandomColor]] forState:UIControlStateNormal];
    
    [touchIDButton setTitle:@"指纹解锁" forState:UIControlStateNormal];
    
    [touchIDButton addTarget:self action:@selector(touchVerification) forControlEvents:UIControlEventTouchDown];
    touchIDButton.frame = CGRectMake((self.view.frame.size.width - 200) * 0.5, 200, 200, 60);
    [self.view addSubview:touchIDButton];
}


/**
 验证 TouchID
 */
- (void)touchVerification {
    
    TDTouchID *touchID = [[TDTouchID alloc] init];
    
    [touchID td_showTouchIDWithDescribe:nil BlockState:^(TDTouchIDState state, NSError *error) {
        
        if (state == TDTouchIDStateNotSupport) {    //不支持TouchID
            
            [self.view makeToast:@"当前设备不支持TouchID, 请输入密码"];
            
        } else if (state == TDTouchIDStateSuccess) {    //TouchID验证成功
            
            NSLog(@"jump");
            [self.view makeToast:@"指纹验证成功"];
            
            
        } else if (state == TDTouchIDStateInputPassword) { //用户选择手动输入密码
            
            [self.view makeToast:@"当前设备不支持TouchID, 请输入密码"];
        }
        
        // ps:以上的状态处理并没有写完全!
        // 在使用中你需要根据回调的状态进行处理,需要处理什么就处理什么
    }];
    
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
