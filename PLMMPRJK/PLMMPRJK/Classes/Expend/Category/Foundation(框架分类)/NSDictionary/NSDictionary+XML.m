//
//  NSDictionary+XML.m
//  IOS-Categories
//
//  Created by Jakey on 15/8/7.
//  Copyright © 2015年 www.skyfox.org. All rights reserved.
//

#import "NSDictionary+XML.h"

@implementation NSDictionary (XML)
/**
 *  @brief  将NSDictionary转换成XML 字符串
 *
 *  @return XML 字符串
 */
- (NSString *)XMLString {
    
    NSString *xmlStr = @"<xml>";
    
    for (NSString *key in self.allKeys) {
        
        NSString *value = [self objectForKey:key];
        
        xmlStr = [xmlStr stringByAppendingString:[NSString stringWithFormat:@"<%@>%@</%@>", key, value, key]];
    }
    
    xmlStr = [xmlStr stringByAppendingString:@"</xml>"];
    
    return xmlStr;
}

@end
