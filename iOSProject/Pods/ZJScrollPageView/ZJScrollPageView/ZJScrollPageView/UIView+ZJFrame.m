//
//  UIView+Frame.m
//  BuDeJie
//
//  Created by yz on 15/10/29.
//  Copyright © 2015年 yz. All rights reserved.
//

#import "UIView+ZJFrame.h"

@implementation UIView (ZJFrame)

- (CGFloat)zj_height
{
    return self.frame.size.height;
}

- (CGFloat)zj_width
{
    return self.frame.size.width;
}

- (void)setZj_height:(CGFloat)zj_height {
    CGRect frame = self.frame;
    frame.size.height = zj_height;
    self.frame = frame;
}
- (void)setZj_width:(CGFloat)zj_width {
    CGRect frame = self.frame;
    frame.size.width = zj_width;
    self.frame = frame;
}

- (CGFloat)zj_x
{
    return self.frame.origin.x;
}

- (void)setZj_x:(CGFloat)zj_x {
    CGRect frame = self.frame;
    frame.origin.x = zj_x;
    self.frame = frame;
}


- (CGFloat)zj_y
{
    return self.frame.origin.y;
}


- (void)setZj_y:(CGFloat)zj_y {
    CGRect frame = self.frame;
    frame.origin.y = zj_y;
    self.frame = frame;
}


- (void)setZj_centerX:(CGFloat)zj_centerX {
    CGPoint center = self.center;
    center.x = zj_centerX;
    self.center = center;
}

- (CGFloat)zj_centerX
{
    return self.center.x;
}


- (void)setZj_centerY:(CGFloat)zj_centerY {
    CGPoint center = self.center;
    center.y = zj_centerY;
    self.center = center;
}

- (CGFloat)zj_centerY
{
    return self.center.y;
}

@end
