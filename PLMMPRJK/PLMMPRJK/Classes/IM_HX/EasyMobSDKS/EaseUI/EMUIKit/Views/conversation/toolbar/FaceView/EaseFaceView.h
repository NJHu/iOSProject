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


#import <UIKit/UIKit.h>

#import "EaseFacialView.h"

@protocol EMFaceDelegate

@required
/*!
 @method
 @brief 输入表情键盘的默认表情，或者点击删除按钮
 @discussion
 @param str       被选择的表情编码
 @param isDelete  是否为删除操作
 @result
 */
- (void)selectedFacialView:(NSString *)str isDelete:(BOOL)isDelete;

/*!
 @method
 @brief 点击表情键盘的发送回调
 @discussion
 @result
 */
- (void)sendFace;

/*!
 @method
 @brief 点击表情键盘的自定义表情，直接发送
 @discussion
 @param emotion 自定义表情对象
 @result
 */
- (void)sendFaceWithEmotion:(EaseEmotion *)emotion;

@end

@interface EaseFaceView : UIView <EaseFacialViewDelegate>

@property (nonatomic, assign) id<EMFaceDelegate> delegate;

- (BOOL)stringIsFace:(NSString *)string;

/*!
 @method
 @brief 通过数据源获取表情分组数,
 @discussion
 @param number 分组数
 @param emotionManagers 表情分组列表
 @result
 */
- (void)setEmotionManagers:(NSArray*)emotionManagers;

@end
