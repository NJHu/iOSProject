//
//  LMJMeViewController.m
//  PLMMPRJK
//
//  Created by NJHu on 2017/3/30.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJMeViewController.h"
#import "LMJUMengHelper.h"

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
    
    NSArray<UIButton *> *btns = @[self.shareBtn, self.SinaLoginBtn, self.QQLoginBtn, self.WXLoginBtn];
    
    [btns mas_distributeViewsAlongAxis:MASAxisTypeVertical withFixedItemLength:44 leadSpacing:150 tailSpacing:200];
    
    [btns mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(50);
        make.right.offset(-50);
    }];
}
/**
 *  多个控件固定间隔的等间隔排列，变化的是控件的长度或者宽度值
 *
 *  @param axisType        轴线方向
 *  @param fixedSpacing    间隔大小
 *  @param leadSpacing     头部间隔
 *  @param tailSpacing     尾部间隔
 */
//- (void)mas_distributeViewsAlongAxis:(MASAxisType)axisType
//                    withFixedSpacing:(CGFloat)fixedSpacing l
//eadSpacing:(CGFloat)leadSpacing
//tailSpacing:(CGFloat)tailSpacing;

/**
 *  多个固定大小的控件的等间隔排列,变化的是间隔的空隙
 *
 *  @param axisType        轴线方向
 *  @param fixedItemLength 每个控件的固定长度或者宽度值
 *  @param leadSpacing     头部间隔
 *  @param tailSpacing     尾部间隔
 */
//- (void)mas_distributeViewsAlongAxis:(MASAxisType)axisType
//                 withFixedItemLength:(CGFloat)fixedItemLength
//                         leadSpacing:(CGFloat)leadSpacing
//                         tailSpacing:(CGFloat)tailSpacing;



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
    
    
    [LMJUMengHelper getUserInfoForPlatform:type completion:^(UMSocialUserInfoResponse *result, NSError *error) {

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
    NSLog(@"%s", __func__);
}

- (void)rightButtonEvent:(UIButton *)sender navigationBar:(LMJNavigationBar *)navigationBar
{
    [LMJUMengHelper shareTitle:@"NJHu-GitHub" subTitle:@"谢谢使用!欢迎交流!" thumbImage:@"https://avatars2.githubusercontent.com/u/18454795?s=400&u=c8a7cc691e5c3611e9fb49dcf9c83843dd9141a2&v=4" shareURL:@"https://www.github.com/njhu"];
    
}

- (void)titleClickEvent:(UILabel *)sender navigationBar:(LMJNavigationBar *)navigationBar
{
    NSLog(@"%@", sender);
}

- (NSMutableAttributedString*)lmjNavigationBarTitle:(LMJNavigationBar *)navigationBar
{
    return [self changeTitle:@"友盟分享和第三方登录"];
}

#pragma mark 自定义代码

-(NSMutableAttributedString *)changeTitle:(NSString *)curTitle
{
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:curTitle ?: @""];
    
    [title addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, title.length)];
    
    [title addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:NSMakeRange(0, title.length)];
    
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
