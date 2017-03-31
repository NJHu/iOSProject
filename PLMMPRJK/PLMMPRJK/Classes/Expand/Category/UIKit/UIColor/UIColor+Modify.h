//
//  UIColor+Modify.h
//  iOS-Categories (https://github.com/shaojiankui/iOS-Categories)
//
//  Created by Jakey on 15/1/2.
//  Copyright (c) 2015年 www.skyfox.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Modify)
- (UIColor *)invertedColor;
- (UIColor *)colorForTranslucency;
- (UIColor *)lightenColor:(CGFloat)lighten;
- (UIColor *)darkenColor:(CGFloat)darken;
@end
