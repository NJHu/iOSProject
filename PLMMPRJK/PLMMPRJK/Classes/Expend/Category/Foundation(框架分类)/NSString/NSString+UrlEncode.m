//
//  NSString+UrlEncode.h
//  iOS-Categories (https://github.com/shaojiankui/iOS-Categories)
//
//  Created by Jakey on 14/12/15.
//  Copyright (c) 2014年 www.skyfox.org. All rights reserved.
//


#import "NSString+UrlEncode.h"

@implementation NSString (UrlEncode)
/**
 *  @brief  urlEncode
 *
 *  @return urlEncode 后的字符串
 */
- (NSString *)urlEncode {
    return [self urlEncodeUsingEncoding:NSUTF8StringEncoding];
}
/**
 *  @brief  urlEncode
 *
 *  @param encoding encoding模式
 *
 *  @return urlEncode 后的字符串
 */
- (NSString *)urlEncodeUsingEncoding:(NSStringEncoding)encoding {
    return (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,
                (__bridge CFStringRef)self,NULL,(CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
                 CFStringConvertNSStringEncodingToEncoding(encoding));
}
/**
 *  @brief  urlDecode
 *
 *  @return urlDecode 后的字符串
 */
- (NSString *)urlDecode {
    return [self urlDecodeUsingEncoding:NSUTF8StringEncoding];
}
/**
 *  @brief  urlDecode
 *
 *  @param encoding encoding模式
 *
 *  @return urlDecode 后的字符串
 */
- (NSString *)urlDecodeUsingEncoding:(NSStringEncoding)encoding {
	return (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,
             (__bridge CFStringRef)self,CFSTR(""),CFStringConvertNSStringEncodingToEncoding(encoding));
}
/**
 *  @brief  url query转成NSDictionary
 *
 *  @return NSDictionary
 */
- (NSDictionary *)dictionaryFromURLParameters
{
    NSArray *pairs = [self componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val = [[kv objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [params setObject:val forKey:[kv objectAtIndex:0]];
    }
    return params;
}

@end
