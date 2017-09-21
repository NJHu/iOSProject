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

typedef NS_ENUM(NSUInteger, DXTextViewInputViewType) {
    DXTextViewNormalInputType = 0,
    DXTextViewTextInputType,
    DXTextViewFaceInputType,
    DXTextViewShareMenuInputType,
};

@interface EaseTextView : UITextView

/*
 *  提示用户输入的标语
 */
@property (nonatomic, copy) NSString *placeHolder;

/*
 *  标语文本的颜色
 */
@property (nonatomic, strong) UIColor *placeHolderTextColor;


/*
 @method
 @brief 获取自身文本占据有多少行
 @discussion
 @result        返回行数
 */
- (NSUInteger)numberOfLinesOfText;


/*
 @method
 @brief 获取每行的高度
 @discussion
 @result        根据iPhone或者iPad来获取每行字体的高度
 */
+ (NSUInteger)maxCharactersPerLine;

/*
 @method
 @brief 获取某个文本占据自身适应宽带的行数
 @discussion
 @param text    目标文本
 @result        返回占据行数
 */
+ (NSUInteger)numberOfLinesForMessage:(NSString *)text;

@end
