//
//  QQLrcLabel.m
//  QQMusic
//
//  Created by Apple on 16/5/18.
//  Copyright © 2016年 KeenLeung. All rights reserved.
//

#import "QQLrcLabel.h"

@implementation QQLrcLabel

/** 重写 set 方法, 重新绘制*/
- (void)setProgress:(CGFloat)progress{
    
    _progress = progress;
    
    if (_progress >= 0.99) {
        _progress = 0;
    }
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    // 1.设置填充色
    [[UIColor greenColor] set];
    
    // 2.设置绘制的范围
    CGRect fillRect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width * self.progress, rect.size.height);
    
    UIRectFillUsingBlendMode(fillRect, kCGBlendModeSourceIn);
}

@end
