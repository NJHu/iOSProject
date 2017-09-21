//
//  IMHLoginViewController.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/9/20.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "IMHLoginViewController.h"

@interface IMHLoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;

@end

@implementation IMHLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"登录或者注册";
}



#pragma mark - actions
- (IBAction)registerEM:(UIButton *)sender {
    
    [MBProgressHUD showMessage:@"正在注册中" ToView: self.view];
    EMError *error = [[EMClient sharedClient] registerWithUsername:self.userNameTextField.text password:self.pwdTextField.text];
    [MBProgressHUD hideHUDForView:self.view];
    
    if (error==nil) {
        [MBProgressHUD showInfo:@"注册成功, 请登录" ToView:self.view];
    }else
    {
        [MBProgressHUD showInfo:@"注册失败" ToView:self.view];
    }
    
    
    
}
- (IBAction)loginClickEM:(UIButton *)sender {
    
    /*
     
     自动登录在以下几种情况下会被取消：
     
     用户调用了 SDK 的登出动作；
     用户在别的设备上更改了密码，导致此设备上自动登录失败；
     用户的账号被从服务器端删除；
     用户从另一个设备登录，把当前设备上登录的用户踢出。
     所以，在您调用登录方法前，应该先判断是否设置了自动登录，如果设置了，则不需要您再调用。
     */
    BOOL isAutoLogin = [EMClient sharedClient].options.isAutoLogin;
    if (isAutoLogin) {
        return;
    }
    
    [MBProgressHUD showMessage:@"正在登录中" ToView: self.view];
    EMError *error = [[EMClient sharedClient] loginWithUsername:self.userNameTextField.text password:self.pwdTextField.text];
    [MBProgressHUD hideHUDForView:self.view];
    
    if (error==nil) {
        
        [[EMClient sharedClient].options setIsAutoLogin:YES];
        
        [MBProgressHUD showInfo:@"登录成功" ToView:self.view];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self dismissViewControllerAnimated:YES completion:nil];
        });
    }else
    {
        [MBProgressHUD showInfo:@"登录失败" ToView:self.view];
    }
    
    
    
    
}

#pragma mark - LMJNavUIBaseViewControllerDataSource

- (UIImage *)lmjNavigationBarBackgroundImage:(LMJNavigationBar *)navigationBar
{
    return [UIImage imageWithColor:UIColor.whiteColor];
}
/** 导航条左边的按钮 */
- (UIImage *)lmjNavigationBarLeftButtonImage:(UIButton *)leftButton navigationBar:(LMJNavigationBar *)navigationBar
{
    return nil;
}

#pragma mark - LMJNavUIBaseViewControllerDelegate
/** 左边的按钮的点击 */
-(void)leftButtonEvent:(UIButton *)sender navigationBar:(LMJNavigationBar *)navigationBar
{
    [self dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark - LMJTextViewControllerDataSource
- (NSArray <UIButton *> *)textViewControllerRelationButtons:(LMJTextViewController *)textViewController;
{
    NSMutableArray *array = [NSMutableArray array];
    
    [self.view.subviews enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([obj isKindOfClass:[UIButton class]]) {
            [array addObject:obj];
        }
        
    }];
    
    return array;
}

@end
