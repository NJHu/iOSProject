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


#import "EaseBubbleView.h"

@interface EaseBubbleView (Voice)

/*!
 @method
 @brief 构建语音类型消息气泡视图
 @discussion
 @result
 */
- (void)setupVoiceBubbleView;

/*!
 @method
 @brief 变更语音类型消息气泡的边距，并更新改子视图约束
 @discussion
 @param margin 气泡边距
 @result
 */
- (void)updateVoiceMargin:(UIEdgeInsets)margin;

@end
