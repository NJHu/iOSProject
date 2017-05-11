//
//  BSJTabBar.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/5/11.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "BSJTabBar.h"

@interface BSJTabBar ()
/** <#digest#> */
@property (weak, nonatomic) UIButton *publishBtn;
@end

@implementation BSJTabBar

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
    
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    NSMutableArray<UIView *> *tabBarButtonMutableArray = [NSMutableArray array];
    
    [self.subviews enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            [tabBarButtonMutableArray addObject:obj];
        }
    }];
    

    [tabBarButtonMutableArray enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        
        
        
    }];
    
    
}


- (UIButton *)publishBtn
{
    if(_publishBtn == nil)
    {
        UIButton *btn = [[UIButton alloc] init];
        [self addSubview:btn];
        
        _publishBtn = btn;
        
        [btn setImage:[UIImage imageNamed:@"tabBar_publish_icon"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"tabBar_publish_click_icon"] forState:UIControlStateHighlighted];
        
        LMJWeakSelf(self);
        LMJWeakSelf(btn);
        [btn addActionHandler:^(NSInteger tag) {
            
            !weakself.publishBtnClick ?: weakself.publishBtnClick(weakself, weakbtn);
        }];
        
    }
    return _publishBtn;
}


@end
