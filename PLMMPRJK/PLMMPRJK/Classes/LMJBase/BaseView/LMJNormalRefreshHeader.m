//
//  LMJNormalRefreshHeader.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/4/11.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJNormalRefreshHeader.h"

@implementation LMJNormalRefreshHeader


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
    
    self.automaticallyChangeAlpha = YES;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
}

@end
