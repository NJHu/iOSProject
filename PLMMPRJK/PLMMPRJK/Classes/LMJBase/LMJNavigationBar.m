//
//  LMJNavigationBar.m
//  PLMMPRJK
//
//  Created by NJHu on 2017/3/31.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJNavigationBar.h"

@implementation LMJNavigationBar

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupLMJNavigationBarUIOnce];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setupLMJNavigationBarUIOnce];
}

- (void)setupLMJNavigationBarUIOnce
{

    
}




- (void)layoutSubviews
{
    [super layoutSubviews];
    
}


//找查到Nav底部的黑线
- (UIImageView *)findHairlineImageViewUnder:(UIView *)view
{
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0)
    {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}


- (UIImageView *)bottomBlackLineView
{
    return [self findHairlineImageViewUnder:self];
}

@end











