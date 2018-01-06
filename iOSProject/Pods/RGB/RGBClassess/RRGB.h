//
//  RRGB.h
//  RGB
//
//  Created by roycms on 2016/10/19.
//  Copyright © 2016年 roycms. All rights reserved.
//

#define RGB(rgbValue) [RRGB colorWithRGBFromString:(rgbValue)]
#define RGB16(rgbValue) [RRGB colorWithRGB16:(rgbValue)]

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface RRGB : NSObject
+ (UIColor *)colorWithRGB16:(int)rgb;
+ (UIColor *)colorWithRGBFromString:(NSString *)rgb;
@end
