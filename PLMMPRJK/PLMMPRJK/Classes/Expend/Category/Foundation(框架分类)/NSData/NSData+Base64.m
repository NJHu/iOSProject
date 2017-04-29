//
//  NSData+Base64.m
//  iOS-Categories (https://github.com/shaojiankui/iOS-Categories)
//
//  Created by Jakey on 15/1/26.
//  Copyright (c) 2015年 www.skyfox.org. All rights reserved.
//

#import "NSData+Base64.h"
#pragma GCC diagnostic ignored "-Wselector"
#import <Availability.h>

@implementation NSData (Base64)
/**
 *  @brief  字符串base64后转data
 *
 *  @param string 传入字符串
 *
 *  @return 传入字符串 base64后的data
 */
+ (NSData *)dataWithBase64EncodedString:(NSString *)string
{
    if (![string length]) return nil;
    NSData *decoded = nil;
#if __MAC_OS_X_VERSION_MIN_REQUIRED < __MAC_10_9 || __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
    if (![NSData instancesRespondToSelector:@selector(initWithBase64EncodedString:options:)])
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        decoded = [[self alloc] initWithBase64Encoding:[string stringByReplacingOccurrencesOfString:@"[^A-Za-z0-9+/=]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [string length])]];
#pragma clang diagnostic pop
    }
    else
#endif
    {
        decoded = [[self alloc] initWithBase64EncodedString:string options:NSDataBase64DecodingIgnoreUnknownCharacters];
    }
    return [decoded length]? decoded: nil;
}
/**
 *  @brief  NSData转string
 *
 *  @param wrapWidth 换行长度  76  64
 *
 *  @return base64后的字符串
 */
- (NSString *)base64EncodedStringWithWrapWidth:(NSUInteger)wrapWidth
{
    if (![self length]) return nil;
    NSString *encoded = nil;
#if __MAC_OS_X_VERSION_MIN_REQUIRED < __MAC_10_9 || __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
    if (![NSData instancesRespondToSelector:@selector(base64EncodedStringWithOptions:)])
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        encoded = [self base64Encoding];
#pragma clang diagnostic pop

    }
    else
#endif
    {
        switch (wrapWidth)
        {
            case 64:
            {
                return [self base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
            }
            case 76:
            {
                return [self base64EncodedStringWithOptions:NSDataBase64Encoding76CharacterLineLength];
            }
            default:
            {
                encoded = [self base64EncodedStringWithOptions:(NSDataBase64EncodingOptions)0];
            }
        }
    }
    if (!wrapWidth || wrapWidth >= [encoded length])
    {
        return encoded;
    }
    wrapWidth = (wrapWidth / 4) * 4;
    NSMutableString *result = [NSMutableString string];
    for (NSUInteger i = 0; i < [encoded length]; i+= wrapWidth)
    {
        if (i + wrapWidth >= [encoded length])
        {
            [result appendString:[encoded substringFromIndex:i]];
            break;
        }
        [result appendString:[encoded substringWithRange:NSMakeRange(i, wrapWidth)]];
        [result appendString:@"\r\n"];
    }
    return result;
}
/**
 *  @brief  NSData转string 换行长度默认64
 *
 *  @return base64后的字符串
 */
- (NSString *)base64EncodedString
{
    return [self base64EncodedStringWithWrapWidth:0];
}
@end