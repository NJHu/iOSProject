//
//  CALayer+UIColor.m
//  test
//
//  Created by LiuLogan on 15/6/17.
//  Copyright (c) 2015年 Xidibuy. All rights reserved.
//

#import "CALayer+UIColor.h"

@implementation CALayer (UIColor)

- (void)setBorderUIColor:(UIColor*)color {
    self.borderColor = color.CGColor;
}

- (UIColor*)borderUIColor {
    return [UIColor colorWithCGColor:self.borderColor];
}

-(void)setContentsUIImage:(UIImage*)bgImage{
    self.contents=(__bridge id)(bgImage.CGImage);
}
-(UIImage*)contentsUIImage{
    return self.contents;
}
@end
