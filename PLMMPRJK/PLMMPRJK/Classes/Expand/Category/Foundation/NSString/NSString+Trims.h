//
//  NSString+Trims.h
//  iOS-Categories (https://github.com/shaojiankui/iOS-Categories)
//
//  Created by Jakey on 15/3/29.
//  Copyright (c) 2015年 www.skyfox.org. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Trims)
/**
 *  @brief  清除html标签
 *
 *  @return 清除后的结果
 */
- (NSString *)stringByStrippingHTML;
/**
 *  @brief  清除js脚本
 *
 *  @return 清楚js后的结果
 */
- (NSString *)stringByRemovingScriptsAndStrippingHTML;
/**
 *  @brief  去除空格
 *
 *  @return 去除空格后的字符串
 */
- (NSString *)trimmingWhitespace;
/**
 *  @brief  去除字符串与空行
 *
 *  @return 去除字符串与空行的字符串
 */
- (NSString *)trimmingWhitespaceAndNewlines;
@end
