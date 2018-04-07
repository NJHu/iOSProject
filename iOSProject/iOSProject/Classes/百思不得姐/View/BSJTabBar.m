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
    
    
    NSMutableArray<UIView *> *tabBarButtonMutableArray = [NSMutableArray array];
    
    [self.subviews enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            [tabBarButtonMutableArray addObject:obj];
            obj.lmj_width = itemWidth;
        }
        
    }];
    

    [tabBarButtonMutableArray enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        obj.lmj_x = idx * itemWidth;
        
        if (idx > 1) {
            obj.lmj_x = (idx + 1) * itemWidth;
        }
        
        if (idx == 2) {
            [self.publishBtn sizeToFit];
            self.publishBtn.lmj_centerX = self.lmj_width * 0.5;
            self.publishBtn.lmj_y = 5;
//            self.publishBtn.lmj_size = CGSizeMake(itemWidth, itemWidth);
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
        
        LMJWeak(self);
        LMJWeak(btn);
        [btn addActionHandler:^(NSInteger tag) {
            
            !weakself.publishBtnClick ?: weakself.publishBtnClick(weakself, weakbtn);
        }];
        
    }
    return _publishBtn;
}

//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
//{
//    
//    if ([self pointInside:point withEvent:event] &&  CGRectContainsPoint(self.publishBtn.frame, point)) {
//        
//        return self.publishBtn;
//        
//    }
//    
//    return [super hitTest:point withEvent:event];
//        
//        
//}


@end








