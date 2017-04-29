//
//  NSURL+Param.m
//  iOS-Categories (https://github.com/shaojiankui/iOS-Categories)
//
//  Created by Jakey on 14/12/30.
//  Copyright (c) 2014年 www.skyfox.org. All rights reserved.
//

#import "NSURL+Param.h"

@implementation NSURL (Param)
/**
 *  @brief  url参数转字典
 *
 *  @return 参数转字典结果
 */
- (NSDictionary *)parameters
{
    NSMutableDictionary * parametersDictionary = [NSMutableDictionary dictionary];
    NSArray * queryComponents = [self.query componentsSeparatedByString:@"&"];
    for (NSString * queryComponent in queryComponents) {
        NSString * key = [queryComponent componentsSeparatedByString:@"="].firstObject;
        NSString * value = [queryComponent substringFromIndex:(key.length + 1)];
        [parametersDictionary setObject:value forKey:key];
    }
    return parametersDictionary;
}
/**
 *  @brief  根据参数名 取参数值
 *
 *  @param parameterKey 参数名的key
 *
 *  @return 参数值
 */
- (NSString *)valueForParameter:(NSString *)parameterKey
{
    return [[self parameters] objectForKey:parameterKey];
}
@end
