//
//  UIColor+Web.h
//  iOS-Categories (https://github.com/shaojiankui/iOS-Categories)
//
//  Created by Jakey on 14/12/22.
//  Copyright (c) 2014年 www.skyfox.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Web)
/**
 *  @brief  获取canvas用的颜色字符串
 *
 *  @return canvas颜色
 */
- (NSString *)canvasColorString;
/**
 *  @brief  获取网页颜色字串
 *
 *  @return 网页颜色
 */
- (NSString *)webColorString;
@end
