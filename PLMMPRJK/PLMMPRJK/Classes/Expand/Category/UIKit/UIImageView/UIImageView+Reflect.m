//
//  UIImageView+Reflect.m
//  UIImageView-Reflect
//
//  Created by Snowmanzzz on 3/19/14.
//  Copyright (c) 2014 zzz. All rights reserved.
//

#import "UIImageView+Reflect.h"

@implementation UIImageView (Reflect)
/**
 *  @brief  倒影
 */
- (void)reflect {
    CGRect frame = self.frame;
    frame.origin.y += (frame.size.height + 1);

    UIImageView *reflectionImageView = [[UIImageView alloc] initWithFrame:frame];
    self.clipsToBounds = TRUE;
    reflectionImageView.contentMode = self.contentMode;
    [reflectionImageView setImage:self.image];
    reflectionImageView.transform = CGAffineTransformMakeScale(1.0, -1.0);
    
    CALayer *reflectionLayer = [reflectionImageView layer];
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.bounds = reflectionLayer.bounds;
    gradientLayer.position = CGPointMake(reflectionLayer.bounds.size.width / 2, reflectionLayer.bounds.size.height * 0.5);
    gradientLayer.colors = [NSArray arrayWithObjects:
                            (id)[[UIColor clearColor] CGColor],
                            (id)[[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.3] CGColor], nil];
    
    gradientLayer.startPoint = CGPointMake(0.5,0.5);
    gradientLayer.endPoint = CGPointMake(0.5,1.0);
    reflectionLayer.mask = gradientLayer;
    
    [self.superview addSubview:reflectionImageView];

}

@end
