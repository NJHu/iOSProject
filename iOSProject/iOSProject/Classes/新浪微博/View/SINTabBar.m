//
//  SINTabBar.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/6/19.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "SINTabBar.h"

@interface SINTabBar ()
/** <#digest#> */
@property (weak, nonatomic) UIButton *publishBtn;

@end

@implementation SINTabBar

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat itemWidth = self.lmj_width / (self.items.count + 1);
    NSMutableArray<UIView *> *tabBarButtonMutableArray = [NSMutableArray array];
    __block CGFloat itemY = 0;
    __block CGFloat itemheight = 0;
    
    [self.subviews enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            [tabBarButtonMutableArray addObject:obj];
            obj.lmj_width = itemWidth;
            itemY = obj.lmj_y;
            itemheight = obj.lmj_height;
        }
        
    }];
    
    [tabBarButtonMutableArray enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.lmj_x = idx * itemWidth;
        
        if (idx > 1) {
            obj.lmj_x = (idx + 1) * itemWidth;
        }
        
        if (idx == 2) {
            [self.publishBtn sizeToFit];
            self.publishBtn.lmj_size = CGSizeMake(itemWidth, itemheight);
            self.publishBtn.lmj_centerX = self.lmj_width * 0.5;
            self.publishBtn.lmj_y = itemY;
        }
    }];
    [self bringSubviewToFront:self.publishBtn];
}


- (UIButton *)publishBtn {
    if(_publishBtn == nil) {
        UIButton *btn = [[UIButton alloc] init];
        [self addSubview:btn];
        
        _publishBtn = btn;
        
        [btn setImage:[UIImage imageNamed:@"tabbar_compose_icon_add"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"tabbar_compose_icon_add_highlighted"] forState:UIControlStateHighlighted];
        
        [btn setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_button"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_button_highlighted"] forState:UIControlStateHighlighted];
        LMJWeak(self);
        LMJWeak(btn);
        [btn addActionHandler:^(NSInteger tag) {
            !weakself.publishBtnClick ?: weakself.publishBtnClick(weakself, weakbtn);
        }];
    }
    return _publishBtn;
}


@end
