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

/** <#digest#> */
@property (weak, nonatomic) UIButton *shareBtn;

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
    
    
    [self.shareBtn makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.offset(-20);
        make.top.offset(100);
        
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
        
        LMJLog(@"%@", result);
        
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


- (UIButton *)shareBtn
{
    if(_shareBtn == nil)
    {
        UIButton *loginBtn = [[UIButton alloc] init];
        
        [loginBtn setTitle:@"分享面板" forState:UIControlStateNormal];
        
        [loginBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [loginBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        
        loginBtn.tag = 4;
        [loginBtn addTarget:self action:@selector(rightButtonEvent:navigationBar:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:loginBtn];
        
        loginBtn.titleLabel.font = AdaptedFontSize(20);
        
        [loginBtn setBackgroundColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [loginBtn setBackgroundColor:[UIColor redColor] forState:UIControlStateHighlighted];
        
        _shareBtn = loginBtn;
    }
    return _shareBtn;
}


#pragma mark 重写BaseViewController设置内容


- (void)leftButtonEvent:(UIButton *)sender navigationBar:(LMJNavigationBar *)navigationBar
{
    [self.navigationController popViewControllerAnimated:YES];
    LMJLog(@"%s", __func__);
}

- (void)rightButtonEvent:(UIButton *)sender navigationBar:(LMJNavigationBar *)navigationBar
{
    [MPUmengHelper shareTitle:@"NJHu-GitHub" subTitle:@"查看内容" thumbImage:@"https://wx.qlogo.cn/mmopen/VXT2numxe2Ru4jyibuTnxGqiabZbY3Vgic2byS4jibMDQkuCSGLdbFcrJvJgnpOKc5fehkWS11AFMapbfn8QgNdl9g/0" shareURL:@"https://www.github.com/njhu"];
    
}

- (void)titleClickEvent:(UILabel *)sender navigationBar:(LMJNavigationBar *)navigationBar
{
    LMJLog(@"%@", sender);
}

- (NSMutableAttributedString*)lmjNavigationBarTitle:(LMJNavigationBar *)navigationBar
{
    return [self changeTitle:@"友盟分享和第三方登录"];
}

#pragma mark 自定义代码

-(NSMutableAttributedString *)changeTitle:(NSString *)curTitle
{
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:curTitle];
    
    [title addAttribute:NSForegroundColorAttributeName value:HEXCOLOR(0x333333) range:NSMakeRange(0, title.length)];
    
    [title addAttribute:NSFontAttributeName value:SYSTEMFONT(13) range:NSMakeRange(0, title.length)];
    
    return title;
}


- (UIImage *)lmjNavigationBarLeftButtonImage:(UIButton *)leftButton navigationBar:(LMJNavigationBar *)navigationBar
{
    [leftButton setImage:[UIImage imageNamed:@"navigationButtonReturnClick"] forState:UIControlStateHighlighted];
    
    return [UIImage imageNamed:@"navigationButtonReturn"];
}



- (UIImage *)lmjNavigationBarRightButtonImage:(UIButton *)rightButton navigationBar:(LMJNavigationBar *)navigationBar
{
    UIButton *btn = rightButton;
    
    btn.backgroundColor = [UIColor yellowColor];

    [btn setTitle:@"分享" forState:UIControlStateNormal];
    
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    
    
    return nil;
}


@end
