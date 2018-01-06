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
#import <Foundation/Foundation.h>

#if ENABLE_LITE == 1
#import <HyphenateLite/HyphenateLite.h>
#else
#import <Hyphenate/Hyphenate.h>
#endif

@class EMMessage;

/** @brief 消息模型协议 */
@protocol IMessageModel <NSObject>

/** @brief 消息cell的高度 */
@property (nonatomic) CGFloat cellHeight;
/** @brief 消息对象 */
@property (strong, nonatomic, readonly) EMMessage *message;
/** @brief 消息id */
@property (strong, nonatomic, readonly) NSString *messageId;
/** @brief 消息发送状态 */
@property (nonatomic, readonly) EMMessageStatus messageStatus;
/** @brief 消息体类型 */
@property (nonatomic, readonly) EMMessageBodyType bodyType;
/** @brief 消息是否已读 */
@property (nonatomic) BOOL isMessageRead;
/** @brief 当前登录用户是否为消息的发送方 */
@property (nonatomic) BOOL isSender;
/** @brief 消息发送方的昵称 */
@property (strong, nonatomic) NSString *nickname;
/** @brief 消息发送方的头像url */
@property (strong, nonatomic) NSString *avatarURLPath;
/** @brief 消息发送方的头像 */
@property (strong, nonatomic) UIImage *avatarImage;
/** @brief 文本消息的文字 */
@property (strong, nonatomic) NSString *text;
/** @brief 文本消息的富文本属性 */
@property (strong, nonatomic) NSAttributedString *attrBody;
/** @brief 缩略图默认显示的图片名(防止缩略图下载失败后，无显示内容) */
@property (strong, nonatomic) NSString *failImageName;
/** @brief 图片消息原图的大小 */
@property (nonatomic) CGSize imageSize;
/** @brief 图片消息缩略图的大小 */
@property (nonatomic) CGSize thumbnailImageSize;
/** @brief 图片消息的原图 */
@property (strong, nonatomic) UIImage *image;
/** @brief 图片消息的缩略图 */
@property (strong, nonatomic) UIImage *thumbnailImage;
/** @brief 位置消息的地址信息 */
@property (strong, nonatomic) NSString *address;
/** @brief 地址消息的纬度 */
@property (nonatomic) double latitude;
/** @brief 地址消息的经度 */
@property (nonatomic) double longitude;
/** @brief 语音消息是否正在播放 */
@property (nonatomic) BOOL isMediaPlaying;
/** @brief 语音消息是否已经播放过 */
@property (nonatomic) BOOL isMediaPlayed;
/** @brief 语音消息(或视频消息)时长 */
@property (nonatomic) CGFloat mediaDuration;
/** @brief 附件显示的图标图片名 */
@property (strong, nonatomic) NSString *fileIconName;
/** @brief 文件消息的附件显示名 */
@property (strong, nonatomic) NSString *fileName;
/** @brief 文件消息的附件大小 */
@property (strong, nonatomic) NSString *fileSizeDes;
/** @brief 消息的附件下载进度 */
@property (nonatomic) float progress;
/** @brief 消息的附件本地存储路径 */
@property (strong, nonatomic, readonly) NSString *fileLocalPath;
/** @brief 图片消息(或视频消息)的缩略图本地存储路径 */
@property (strong, nonatomic) NSString *thumbnailFileLocalPath;
/** @brief 消息的附件远程地址 */
@property (strong, nonatomic) NSString *fileURLPath;
/** @brief 图片消息(或视频消息)的缩略图远程地址 */
@property (strong, nonatomic) NSString *thumbnailFileURLPath;

/*!
 @method
 @brief 初始化消息对象模型
 @param message    消息对象
 @return 消息对象模型
 */
- (instancetype)initWithMessage:(EMMessage *)message;

@end
