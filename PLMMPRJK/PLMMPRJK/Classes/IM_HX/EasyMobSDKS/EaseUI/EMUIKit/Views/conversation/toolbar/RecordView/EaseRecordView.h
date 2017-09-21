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

typedef enum{
    EaseRecordViewTypeTouchDown,
    EaseRecordViewTypeTouchUpInside,
    EaseRecordViewTypeTouchUpOutside,
    EaseRecordViewTypeDragInside,
    EaseRecordViewTypeDragOutside,
}EaseRecordViewType;

@interface EaseRecordView : UIView

@property (nonatomic) NSArray *voiceMessageAnimationImages UI_APPEARANCE_SELECTOR;

@property (nonatomic) NSString *upCancelText UI_APPEARANCE_SELECTOR;

@property (nonatomic) NSString *loosenCancelText UI_APPEARANCE_SELECTOR;

/*
 @method
 @brief 录音按钮按下
 @discussion
 @param
 @result
 */
-(void)recordButtonTouchDown;

/*
 @method
 @brief 手指在录音按钮内部时离开
 @discussion
 @param
 @result
 */
-(void)recordButtonTouchUpInside;

/*
 @method
 @brief 手指在录音按钮外部时离开
 @discussion
 @param
 @result
 */
-(void)recordButtonTouchUpOutside;

/*
 @method
 @brief 手指移动到录音按钮内部
 @discussion
 @param
 @result
 */
-(void)recordButtonDragInside;

/*
 @method
 @brief 手指移动到录音按钮外部
 @discussion
 @param
 @result
 */
-(void)recordButtonDragOutside;

@end
