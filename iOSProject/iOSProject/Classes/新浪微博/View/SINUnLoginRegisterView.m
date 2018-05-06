//
//  SINUnLoginRegisterView.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/6/20.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "SINUnLoginRegisterView.h"

@interface SINUnLoginRegisterView ()

/** <#digest#> */
@property (nonatomic, copy) void(^registClick)(void);

/** <#digest#> */
@property (nonatomic, copy) void(^loginClick)(void);

/** <#digest#> */
@property (assign, nonatomic) SINUnLoginRegisterViewType type;

/** <#digest#> */
@property (weak, nonatomic) UIImageView *caCycleImageView;
/** <#digest#> */
@property (weak, nonatomic) UIImageView *slognImageView;
/** <#digest#> */
@property (weak, nonatomic) UIImageView *coverImageView;
/** <#digest#> */
@property (weak, nonatomic) UILabel *encourageLabel;

/** <#digest#> */
@property (weak, nonatomic) UIButton *registerButton;
/** <#digest#> */
@property (weak, nonatomic) UIButton *loginButton;

@end

@implementation SINUnLoginRegisterView

+ (instancetype)unLoginRegisterViewWithType:(SINUnLoginRegisterViewType)type registClick:(void (^)(void))registClick loginClick:(void (^)(void))loginClick
{
    SINUnLoginRegisterView *unLoginRegisterView = [[SINUnLoginRegisterView alloc] init];
    unLoginRegisterView.registClick = registClick;
    unLoginRegisterView.loginClick = loginClick;
    unLoginRegisterView.type = type;
    return unLoginRegisterView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupUIOnce];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setupUIOnce];
}

- (void)setupUIOnce
{
    [self.caCycleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.centerY.offset(-100);
        make.size.mas_equalTo(CGSizeMake(200, 200));
    }];
    
    [self.coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.caCycleImageView);
        make.top.mas_equalTo(self.caCycleImageView).offset(-30);
        make.bottom.mas_equalTo(self.caCycleImageView).offset(0);
    }];
    
    [self.slognImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.caCycleImageView);
    }];
    
    [self.encourageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.coverImageView.mas_bottom).offset(20);
        make.left.mas_equalTo(self.coverImageView).offset(-30);
        make.right.mas_equalTo(self.coverImageView).offset(30);
    }];
    
    NSArray *btns = @[self.registerButton, self.loginButton];
    
    [btns mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:30 leadSpacing:30 tailSpacing:30];
    [btns mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.encourageLabel.mas_bottom).offset(20);
        make.height.mas_equalTo(44);
    }];
}


- (void)login:(UIButton *)btn
{
    if (btn.tag == 0) {
        !self.registClick ?: self.registClick();
    }else if (btn.tag == 1)
    {
        !self.loginClick ?: self.loginClick();
    }
}

- (void)setType:(SINUnLoginRegisterViewType)type
{
    _type = type;
    
    switch (type) {
        case SINUnLoginRegisterViewTypeHomePage:
        {
        }
            break;
        case SINUnLoginRegisterViewTypeMsgPage:
        {
            self.caCycleImageView.hidden = YES;
            self.coverImageView.hidden = YES;
            self.slognImageView.image = [UIImage imageNamed:@"visitordiscover_image_message"];
        }
            break;
        case SINUnLoginRegisterViewTypeProfilePage:
        {
            self.coverImageView.hidden = YES;
            self.caCycleImageView.hidden = YES;
            self.slognImageView.image = [UIImage imageNamed:@"visitordiscover_image_profile"];
        }
            break;
    }
}


#pragma mark - getter

- (UIImageView *)caCycleImageView
{
    if(_caCycleImageView == nil)
    {
        UIImageView *caCycleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"visitordiscover_feed_image_smallicon"]];
        [self addSubview:caCycleImageView];
        _caCycleImageView = caCycleImageView;
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        animation.duration = 5;
        animation.removedOnCompletion = NO;
        animation.repeatCount = INFINITY;
        animation.fromValue = @0;
        animation.toValue = @(M_PI * 2);
        [caCycleImageView.layer addAnimation:animation forKey:nil];
    }
    return _caCycleImageView;
}

- (UIImageView *)coverImageView
{
    if(_coverImageView == nil)
    {
        UIImageView *coverImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"visitordiscover_feed_mask_smallicon"]];
        [self addSubview:coverImageView];
        _coverImageView = coverImageView;
    }
    return _coverImageView;
}


- (UIImageView *)slognImageView
{
    if(_slognImageView == nil)
    {
        UIImageView *slognImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"visitordiscover_feed_image_house"]];
        [self addSubview:slognImageView];
        _slognImageView = slognImageView;
    }
    return _slognImageView;
}


- (UILabel *)encourageLabel
{
    if(_encourageLabel == nil)
    {
        
        UILabel *label = [[UILabel alloc] init];
        [self addSubview:label];
        _encourageLabel = label;
        
        label.text = @"systemFontOfSizesystemFontOfSizesystemFontOfSizesystemFontOfSizesystemFontOfSizesystemFontOfSize";
        label.numberOfLines = 0;
        label.textColor = [UIColor lightGrayColor];
        label.font = [UIFont systemFontOfSize:13];
        
    }
    return _encourageLabel;
}

- (UIButton *)registerButton
{
    if(_registerButton == nil)
    {
        UIButton *registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:registerButton];
        _registerButton = registerButton;
        
        [registerButton setTitle:@"注册" forState: UIControlStateNormal];
        [registerButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [registerButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        
        [registerButton setBackgroundImage:[[UIImage imageNamed:@"common_button_white_disable"] stretchableImageWithLeftCapWidth:5.5 topCapHeight:17.5] forState:UIControlStateNormal];
        [registerButton setBackgroundImage:[[UIImage imageNamed:@"common_button_white_disable"] stretchableImageWithLeftCapWidth:5.5 topCapHeight:17.5] forState:UIControlStateHighlighted];
        
        [registerButton addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
        
        registerButton.tag = 0;
        
    }
    return _registerButton;
}

- (UIButton *)loginButton
{
    if(_loginButton == nil)
    {
        UIButton *registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:registerButton];
        _loginButton = registerButton;
        
        [registerButton setTitle:@"登录" forState: UIControlStateNormal];
        [registerButton setTitleColor:[UIColor  darkTextColor] forState:UIControlStateNormal];
        [registerButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        
        [registerButton setBackgroundImage:[[UIImage imageNamed:@"common_button_white_disable"] stretchableImageWithLeftCapWidth:5.5 topCapHeight:17.5] forState:UIControlStateNormal];
        [registerButton setBackgroundImage:[[UIImage imageNamed:@"common_button_white_disable"] stretchableImageWithLeftCapWidth:5.5 topCapHeight:17.5] forState:UIControlStateHighlighted];
        
        [registerButton addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
        
        registerButton.tag = 1;
        
    }
    return _loginButton;
}


@end
