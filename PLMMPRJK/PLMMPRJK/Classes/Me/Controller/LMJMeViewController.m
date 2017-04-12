//
//  LMJMeViewController.m
//  PLMMPRJK
//
//  Created by NJHu on 2017/3/30.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJMeViewController.h"

@interface LMJMeViewController ()

/** <#digest#> */
@property (weak, nonatomic) UIButton *QQLoginBtn;
/** <#digest#> */
@property (weak, nonatomic) UIButton *WXLoginBtn;
/** <#digest#> */
@property (weak, nonatomic) UIButton *SinaLoginBtn;

@end

@implementation LMJMeViewController

#pragma mark viewController生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.QQLoginBtn makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY).offset(-150);
        
        
    }];
    
    
    [self.WXLoginBtn makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.QQLoginBtn);
        make.top.equalTo(self.QQLoginBtn.mas_bottom).offset(30);
        
    }];
    
    
    [self.SinaLoginBtn makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.WXLoginBtn);
        make.top.equalTo(self.WXLoginBtn.mas_bottom).offset(60);
        
    }];
    
}



#pragma mark - 登录
- (void)thirdLoginClick:(UIButton *)loginBtn
{
    
    NSInteger tag = loginBtn.tag;
    
    UMSocialPlatformType type = UMSocialPlatformType_UnKnown;
    
    switch (tag) {
        case 1:

            type = UMSocialPlatformType_QQ;
            
            break;
            
        case 2:
            
            type = UMSocialPlatformType_WechatSession;
            
            break;

            
        case 3:
            
            type = UMSocialPlatformType_Sina;
            
            break;
            
            
        default:
            
            return;
            
            break;
    }
    
    
    [MPUmengHelper getUserInfoForPlatform:type completion:^(UMSocialUserInfoResponse *result, NSError *error) {
        
        NSLog(@"%@", result);
        
    }];
    
}



#pragma mark - 懒加载
- (UIButton *)QQLoginBtn
{
    if(_QQLoginBtn == nil)
    {
        UIButton *loginBtn = [[UIButton alloc] init];
        [loginBtn setTitle:@"QQLogin" forState:UIControlStateNormal];
        
        [loginBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [loginBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        
        loginBtn.tag = 1;
        [loginBtn addTarget:self action:@selector(thirdLoginClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:loginBtn];
        
        
        loginBtn.titleLabel.font = AdaptedFontSize(20);
        
        [loginBtn setBackgroundColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [loginBtn setBackgroundColor:[UIColor redColor] forState:UIControlStateHighlighted];
        
        _QQLoginBtn = loginBtn;
        
    }
    return _QQLoginBtn;
}

- (UIButton *)WXLoginBtn
{
    if(_WXLoginBtn == nil)
    {
        UIButton *loginBtn = [[UIButton alloc] init];
        [loginBtn setTitle:@"WXLogin" forState:UIControlStateNormal];
        
        [loginBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [loginBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        
        loginBtn.tag = 2;
        [loginBtn addTarget:self action:@selector(thirdLoginClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:loginBtn];
        
        loginBtn.titleLabel.font = AdaptedFontSize(20);
        
        [loginBtn setBackgroundColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [loginBtn setBackgroundColor:[UIColor redColor] forState:UIControlStateHighlighted];
        
        _WXLoginBtn = loginBtn;
    }
    return _WXLoginBtn;
}


- (UIButton *)SinaLoginBtn
{
    if(_SinaLoginBtn == nil)
    {
        UIButton *loginBtn = [[UIButton alloc] init];
        
        [loginBtn setTitle:@"SinaLogin" forState:UIControlStateNormal];
        
        [loginBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [loginBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        
        loginBtn.tag = 3;
        [loginBtn addTarget:self action:@selector(thirdLoginClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:loginBtn];
        
        loginBtn.titleLabel.font = AdaptedFontSize(20);
        
        [loginBtn setBackgroundColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [loginBtn setBackgroundColor:[UIColor redColor] forState:UIControlStateHighlighted];
        
        _SinaLoginBtn = loginBtn;
    }
    return _SinaLoginBtn;
}



#pragma mark 重写BaseViewController设置内容


- (void)left_button_event:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    NSLog(@"%s", __func__);
}

- (void)right_button_event:(UIButton *)sender
{
    NSLog(@"%s", __func__);
}

- (void)title_click_event:(UILabel *)sender
{
    NSLog(@"%@", sender);
}

- (NSMutableAttributedString *)setTitle
{
    return [[NSMutableAttributedString alloc] initWithString:@"我的" attributes:nil];
}

- (UIButton *)set_leftButton
{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [btn setImage:[UIImage imageNamed:@"navigationButtonReturn"] forState:UIControlStateNormal];
//    navigationButtonReturn
    //navigationButtonReturnClick
    [btn setImage:[UIImage imageNamed:@"navigationButtonReturnClick"] forState:UIControlStateHighlighted];
    
    return btn;
}


- (UIButton *)set_rightButton
{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    btn.backgroundColor = [UIColor yellowColor];
    
    return btn;
}


@end
