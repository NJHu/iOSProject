//
//  UIView+LMJNjHuFrame.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/4/29.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "UIView+LMJNjHuFrame.h"

@implementation UIView (LMJNjHuFrame)

- (CGFloat)lmj_x {
    return self.frame.origin.x;
}

- (void)setLmj_x:(CGFloat)lmj_x {
    CGRect frame = self.frame;
    frame.origin.x = lmj_x;
    self.frame = frame;
}

- (CGFloat)lmj_y {
    return self.frame.origin.y;
}

- (void)setLmj_y:(CGFloat)lmj_y {
    CGRect frame = self.frame;
    frame.origin.y = lmj_y;
    self.frame = frame;
}

- (CGFloat)lmj_right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setLmj_right:(CGFloat)lmj_right {
    CGRect frame = self.frame;
    frame.origin.x = lmj_right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)lmj_bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setLmj_bottom:(CGFloat)lmj_bottom {
    
    CGRect frame = self.frame;
    
    frame.origin.y = lmj_bottom - frame.size.height;
    
    self.frame = frame;
}

- (CGFloat)lmj_width {
    return self.frame.size.width;
}

- (void)setLmj_width:(CGFloat)lmj_width {
    CGRect frame = self.frame;
    frame.size.width = lmj_width;
    self.frame = frame;
}

- (CGFloat)lmj_height {
    return self.frame.size.height;
}

- (void)setLmj_height:(CGFloat)lmj_height {
    CGRect frame = self.frame;
    frame.size.height = lmj_height;
    self.frame = frame;
}

- (CGFloat)lmj_centerX {
    return self.center.x;
}

- (void)setLmj_centerX:(CGFloat)lmj_centerX {
    self.center = CGPointMake(lmj_centerX, self.center.y);
}

- (CGFloat)lmj_centerY {
    return self.center.y;
}

- (void)setLmj_centerY:(CGFloat)lmj_centerY {
    self.center = CGPointMake(self.center.x, lmj_centerY);
}

- (CGPoint)lmj_origin {
    return self.frame.origin;
}

- (void)setLmj_origin:(CGPoint)lmj_origin {
    CGRect frame = self.frame;
    frame.origin = lmj_origin;
    self.frame = frame;
}

- (CGSize)lmj_size {
    return self.frame.size;
}

- (void)setLmj_size:(CGSize)lmj_size {
    CGRect frame = self.frame;
    frame.size = lmj_size;
    self.frame = frame;
}

@end
