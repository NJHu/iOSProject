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

#import "MWPhotoBrowser.h"
#import "EaseMessageModel.h"

typedef void (^FinishBlock)(BOOL success);
typedef void (^PlayBlock)(BOOL playing, EaseMessageModel *messageModel);

@class EMChatFireBubbleView;
@interface EaseMessageReadManager : NSObject<MWPhotoBrowserDelegate>

@property (strong, nonatomic) MWPhotoBrowser *photoBrowser;
@property (strong, nonatomic) FinishBlock finishBlock;

@property (strong, nonatomic) EaseMessageModel *audioMessageModel;

+ (id)defaultManager;

/*!
 @method
 @brief 显示图片消息原图
 @discussion
 @param imageArray   原图数组，需要传入UIImage对象
 @return
 */
- (void)showBrowserWithImages:(NSArray *)imageArray;

/*!
 @method
 @brief 语音消息是否可以播放
 @discussion 若传入的语音消息正在播放，停止播放并重置isMediaPlaying，返回NO；否则当前语音消息isMediaPlaying设为yes，记录的上一条语音消息isMediaPlaying重置，更新消息ext，返回yes
 @param messageModel   选中的语音消息model
 @param updateCompletion  语音消息model更新后的回调
 @return
 */
- (BOOL)prepareMessageAudioModel:(EaseMessageModel *)messageModel
            updateViewCompletion:(void (^)(EaseMessageModel *prevAudioModel, EaseMessageModel *currentAudioModel))updateCompletion;

/*!
 @method
 @brief 重置正在播放状态为NO，返回对应的语音消息model
 @discussion 重置正在播放状态为NO，返回对应的语音消息model，若当前记录的消息不为语音消息，返回nil
 @return  返回修改后的语音消息model
 */
- (EaseMessageModel *)stopMessageAudioModel;

@end
