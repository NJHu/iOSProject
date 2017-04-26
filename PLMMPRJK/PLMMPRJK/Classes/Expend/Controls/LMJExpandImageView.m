//
//  LMJExpandImageView.m
//  GoMeYWLC
//
//  Created by NJHu on 2016/11/10.
//  Copyright © 2016年 NJHu. All rights reserved.
//

#import "LMJExpandImageView.h"

@implementation LMJExpandImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupOnce];
    }
    
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setupOnce];
}

- (void)setupOnce
{
    //关键步骤 设置可变化背景view属性
    self.autoresizingMask = UIViewAutoresizingFlexibleHeight| UIViewAutoresizingFlexibleWidth;
    self.clipsToBounds = YES;
    self.contentMode = UIViewContentModeScaleAspectFill;
    
    self.userInteractionEnabled = YES;
}

@end
