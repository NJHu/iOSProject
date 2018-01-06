/************************************************************
 *  * Hyphenate CONFIDENTIAL
 * __________________
 * Copyright (C) 2016 Hyphenate Inc. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of Hyphenate Inc.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Hyphenate Inc.
 */

#import <Foundation/Foundation.h>

@interface EaseConvertToCommonEmoticonsHelper : NSObject

/*!
 @method
 @brief 系统emoji表情转换为表情编码
 @discussion
 @param text   待转换的文字
 @return  转换后的文字
 */
+ (NSString *)convertToCommonEmoticons:(NSString *)text;

/*!
 @method
 @brief 表情编码转换为系统emoji表情
 @discussion
 @param text   待转换的文字
 @return  转换后的文字
 */
+ (NSString *)convertToSystemEmoticons:(NSString *)text;

@end
