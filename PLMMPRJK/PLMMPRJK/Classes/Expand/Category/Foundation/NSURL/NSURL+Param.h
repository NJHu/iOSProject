//
//  NSURL+Param.h
//  iOS-Categories (https://github.com/shaojiankui/iOS-Categories)
//
//  Created by Jakey on 14/12/30.
//  Copyright (c) 2014年 www.skyfox.org. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (Param)
/**
 *  @brief  url参数转字典
 *
 *  @return 参数转字典结果
 */
- (NSDictionary *)parameters;
/**
 *  @brief  根据参数名 取参数值
 *
 *  @param parameterKey 参数名的key
 *
 *  @return 参数值
 */
- (NSString *)valueForParameter:(NSString *)parameterKey;
@end
