//
//  NSString+UUID.h
//  iOS-Categories (https://github.com/shaojiankui/iOS-Categories)
//
//  Created by Jakey on 14/12/30.
//  Copyright (c) 2014年 www.skyfox.org. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (UUID)
/**
 *  @brief  获取随机 UUID 例如 E621E1F8-C36C-495A-93FC-0C247A3E6E5F
 *
 *  @return 随机 UUID
 */
+ (NSString *)UUID;
/**
 *
 *  @brief  毫秒时间戳 例如 1443066826371
 *
 *  @return 毫秒时间戳
 */
+ (NSString *)UUIDTimestamp;
@end
