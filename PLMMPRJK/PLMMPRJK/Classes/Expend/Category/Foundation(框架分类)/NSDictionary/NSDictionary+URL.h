//
//  NSDictionary+URL.h
//  IOS-Categories
//
//  Created by Jakey on 15/8/7.
//  Copyright © 2015年 www.skyfox.org. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (URL)
/**
 *  @brief  将url参数转换成NSDictionary
 *
 *  @param query url参数
 *
 *  @return NSDictionary
 */
+ (NSDictionary *)dictionaryWithURLQuery:(NSString *)query;
/**
 *  @brief  将NSDictionary转换成url 参数字符串
 *
 *  @return url 参数字符串
 */
- (NSString *)URLQueryString;
@end
