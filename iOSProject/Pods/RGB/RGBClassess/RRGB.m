//
//  RRGB.m
//  RGB
//
//  Created by roycms on 2016/10/19.
//  Copyright © 2016年 roycms. All rights reserved.
//

#import "RRGB.h"
@implementation RRGB

+ (UIColor *)colorWithRGB16:(int)rgb {
    return [UIColor colorWithRed:((rgb & 0xFF0000) >> 16) / 255.0f
                           green:((rgb & 0xFF00) >> 8) / 255.0f
                            blue:((rgb & 0xFF)) / 255.0f
                           alpha:1.0f];
}
+ (UIColor *)colorWithRGBFromString:(NSString *)rgb {
    if ([rgb rangeOfString:@"#"].location != NSNotFound) {
        rgb = [rgb substringFromIndex:1];
    }
    rgb = [NSString stringWithFormat:@"0x%@",rgb];
    unsigned long rgb16 = strtoul([rgb UTF8String],0,16);
    
    return [self colorWithRGB16:(int)rgb16];
}
@end
