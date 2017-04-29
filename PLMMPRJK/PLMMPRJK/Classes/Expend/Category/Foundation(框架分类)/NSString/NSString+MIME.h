//
//  NSString+MIME.h
//  iOS-Categories (https://github.com/shaojiankui/iOS-Categories)
//
//  Created by Jakey on 15/5/22.
//  Copyright (c) 2015年 www.skyfox.org. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (MIME)
/**
 *  @brief  根据文件url 返回对应的MIMEType
 *
 *  @return MIMEType
 */
- (NSString *)MIMEType;
/**
 *  @brief  根据文件url后缀 返回对应的MIMEType
 *
 *  @return MIMEType
 */
+ (NSString *)MIMETypeForExtension:(NSString *)extension;
/**
 *  @brief  常见MIME集合
 *
 *  @return 常见MIME集合
 */
+ (NSDictionary *)MIMEDict;
@end
