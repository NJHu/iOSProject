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

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat itemWidth = self.lmj_width / (self.items.count + 1);
    __block CGFloat itemHeight = 0;
    __block CGFloat itemY = 0;
    
    NSMutableArray<UIView *> *tabBarButtonMutableArray = [NSMutableArray array];
    
    [self.subviews enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            [tabBarButtonMutableArray addObject:obj];
            obj.lmj_width = itemWidth;
            itemHeight = obj.lmj_height;
            itemY = obj.lmj_y;
        }
    }];
    
    [tabBarButtonMutableArray enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.lmj_x = idx * itemWidth;
        if (idx > 1) {
            obj.lmj_x = (idx + 1) * itemWidth;
        }
        if (idx == 2) {
            self.publishBtn.lmj_size = CGSizeMake(itemWidth, itemHeight);
            self.publishBtn.lmj_centerX = self.lmj_width * 0.5;
            self.publishBtn.lmj_y = itemY;
        }
    }];
    
    [self bringSubviewToFront:self.publishBtn];
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
        
        btn.imageView.contentMode = UIViewContentModeCenter;
        LMJWeak(self);
        LMJWeak(btn);
        [btn addActionHandler:^(NSInteger tag) {
            !weakself.publishBtnClick ?: weakself.publishBtnClick(weakself, weakbtn);
        }];
        
    }
    return _publishBtn;
}

@end








