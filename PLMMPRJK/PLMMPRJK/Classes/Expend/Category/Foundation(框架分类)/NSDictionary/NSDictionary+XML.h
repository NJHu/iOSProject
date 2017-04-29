//
//  NSDictionary+XML.h
//  IOS-Categories
//
//  Created by Jakey on 15/8/7.
//  Copyright © 2015年 www.skyfox.org. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (XML)
/**
 *  @brief  将NSDictionary转换成XML 字符串
 *
 *  @return XML 字符串
 */
- (NSString *)XMLString;
@end
