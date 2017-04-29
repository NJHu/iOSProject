//
//  NSString+Contains.m
//  iOS-Categories (https://github.com/shaojiankui/iOS-Categories)
//
//  Created by 符现超 on 15/5/9.
//  Copyright (c) 2015年 http://weibo.com/u/1655766025 All rights reserved.
//

#import "NSString+Contains.h"

@implementation NSString (Contains)

/**
 *  @brief  判断URL中是否包含中文
 *
 *  @return 是否包含中文
 */
- (BOOL)isContainChinese
{
    NSUInteger length = [self length];
    for (NSUInteger i = 0; i < length; i++) {
        NSRange range = NSMakeRange(i, 1);
        NSString *subString = [self substringWithRange:range];
        const char *cString = [subString UTF8String];
        if (strlen(cString) == 3) {
            return YES;
        }
    }
    return NO;
}

/**
 *  @brief  是否包含空格
 *
 *  @return 是否包含空格
 */
- (BOOL)isContainBlank
{
    NSRange range = [self rangeOfString:@" "];
    if (range.location != NSNotFound) {
        return YES;
    }
    return NO;
}

//Unicode编码的字符串转成NSString
- (NSString *)makeUnicodeToString
{
    NSString *tempStr1 = [self stringByReplacingOccurrencesOfString:@"\\u"withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\""withString:@"\\\""];
    NSString *tempStr3 = [[@"\""stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    //NSString* returnStr = [NSPropertyListSerialization propertyListFromData:tempData mutabilityOption:NSPropertyListImmutable format:NULL errorDescription:NULL];
    
    NSString *returnStr = [NSPropertyListSerialization propertyListWithData:tempData options:NSPropertyListMutableContainersAndLeaves format:NULL error:NULL];
    
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n"withString:@"\n"];
}

- (BOOL)containsCharacterSet:(NSCharacterSet *)set
{
    NSRange rang = [self rangeOfCharacterFromSet:set];
    if (rang.location == NSNotFound) {
        return NO;
    } else {
        return YES;
    }
}
/**
 *  @brief 是否包含字符串
 *
 *  @param string 字符串
 *
 *  @return YES, 包含; Otherwise
 */
- (BOOL)containsaString:(NSString *)string
{
    NSRange rang = [self rangeOfString:string];
    if (rang.location == NSNotFound) {
        return NO;
    } else {
        return YES;
    }
}

/**
 *  @brief 获取字符数量
 */
- (int)wordsCount
{
    NSInteger n = self.length;
    int i;
    int l = 0, a = 0, b = 0;
    unichar c;
    for (i = 0; i < n; i++)
    {
        c = [self characterAtIndex:i];
        if (isblank(c)) {
            b++;
        } else if (isascii(c)) {
            a++;
        } else {
            l++;
        }
    }
    if (a == 0 && l == 0) {
        return 0;
    }
    return l + (int)ceilf((float)(a + b) / 2.0);
}
@end
