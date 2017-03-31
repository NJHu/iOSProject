//
//  UIResponder+UIAdapt.m
//  iOS-Categories (https://github.com/shaojiankui/iOS-Categories)
//
//  Created by Jakey on 15/1/28.
//  Copyright (c) 2015年 www.skyfox.org. All rights reserved.
//

#import "UIResponder+UIAdapt.h"
#define XIB_WIDTH 320

@implementation UIResponder (UIAdapt)
CGRect CGAdaptRectMake(CGFloat x, CGFloat y, CGFloat width, CGFloat height)
{
    //UIScreenMode *currentMode = [[UIScreen mainScreen]currentMode];
    CGRect sreenBounds = [UIScreen mainScreen].bounds;
    CGFloat scale  = sreenBounds.size.width/XIB_WIDTH;
    return CGRectMake(x*scale, y*scale, width *scale, height*scale);
}

CGPoint CGAdaptPointMake(CGFloat x, CGFloat y){
    //UIScreenMode *currentMode = [[UIScreen mainScreen]currentMode];
    CGRect sreenBounds = [UIScreen mainScreen].bounds;
    CGFloat scale  = sreenBounds.size.width/XIB_WIDTH;
    return CGPointMake(x*scale, y*scale);
}

-(CGFloat)factorAdapt{
    //IScreenMode *currentMode = [[UIScreen mainScreen]currentMode];
    CGRect sreenBounds = [UIScreen mainScreen].bounds;
    CGFloat scale  = sreenBounds.size.width/XIB_WIDTH;
    return scale;
}
@end
