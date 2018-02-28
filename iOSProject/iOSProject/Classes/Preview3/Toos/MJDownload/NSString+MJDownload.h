//
//  NSString+MJDownload.h
//  MJDownloadExample
//
//  Created by MJ Lee on 15/7/18.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (MJDownload)
/**
 *  在前面拼接caches文件夹
 */
- (NSString *)prependCaches;

/**
 *  生成MD5摘要
 */
- (NSString *)MD5;

/**
 *  文件大小
 */
- (NSInteger)fileSize;

/**
 *  生成编码后的URL
 */
//- (NSString *)encodedURL;
@end
