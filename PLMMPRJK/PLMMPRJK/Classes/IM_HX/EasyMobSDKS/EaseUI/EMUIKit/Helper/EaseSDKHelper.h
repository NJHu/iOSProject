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

/** @brief 登录状态变更的通知 */
#define KNOTIFICATION_LOGINCHANGE @"loginStateChange"
/** @brief 实时音视频呼叫 */
#define KNOTIFICATION_CALL @"callOutWithChatter"
/** @brief 关闭实时音视频 */
#define KNOTIFICATION_CALL_CLOSE @"callControllerClose"
/** @brief 群组消息ext的字段，用于存放被@的环信id数组 */
#define kGroupMessageAtList      @"em_at_list"
/** @brief 群组消息ext字典中，kGroupMessageAtList字段的值，用于@所有人 */
#define kGroupMessageAtAll       @"all"
/** @brief 注册SDK时，是否允许控制台输出log */
#define kSDKConfigEnableConsoleLogger @"SDKConfigEnableConsoleLogger"
/** @brief 使用的SDK是否为Lite版本(即不包含实时音视频功能) */
#define kEaseUISDKConfigIsUseLite @"isUselibHyphenateClientSDKLite"

@interface EaseSDKHelper : NSObject<EMClientDelegate>

/** @brief 当前是否有imagePickerViewController弹出 */
@property (nonatomic) BOOL isShowingimagePicker;

/** @brief 使用的SDK是否为Lite版本(即不包含实时音视频功能) */
@property (nonatomic) BOOL isLite;

+ (instancetype)shareHelper;

#pragma mark - init Hyphenate

/*!
 @method
 @brief 注册3.xSDK，注册远程通知
 @param application     UIApplication对象
 @param launchOptions   启动配置(传入AppDelegate中启动回调的参数，可选)
 @param appkey          已注册的appkey
 @param apnsCertName    上传的推送证书名
 @param otherConfig     注册SDK的额外配置(此方法目前只解析了kSDKConfigEnableConsoleLogger字段)
 */
- (void)hyphenateApplication:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
                    appkey:(NSString *)appkey
              apnsCertName:(NSString *)apnsCertName
               otherConfig:(NSDictionary *)otherConfig;

#pragma mark - receive remote notification

/*!
 @method
 @brief 程序在前台收到APNs时，需要调用此方法
 @param application  UIApplication
 @param userInfo     推送内容
 */
- (void)hyphenateApplication:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo;

#pragma mark - send message

/*!
 @method
 @brief 构建待发送的文本消息
 @discussion        向环信id为to的用户发送文本消息
 @param text        待发送的文本信息
 @param to          消息的接收方环信id
 @param messageType 消息的聊天类型
 @param messageExt  消息的扩展属性
 @result 返回构建完成的消息
 */
+ (EMMessage *)sendTextMessage:(NSString *)text
                            to:(NSString *)to
                   messageType:(EMChatType)messageType
                    messageExt:(NSDictionary *)messageExt;

/*!
 @method
 @brief 构建待发送的透传消息
 @discussion        向环信id为to的用户发送透传消息
 @param action      透传消息的命令内容
 @param to          消息的接收方环信id
 @param messageType 消息的聊天类型
 @param messageExt  消息的扩展属性
 @param cmdParams   透传消息命令参数，只是为了兼容老版本，应该使用EMMessage的扩展属性来代替
 @result 返回构建完成的消息
 */
+ (EMMessage *)sendCmdMessage:(NSString *)action
                            to:(NSString *)to
                   messageType:(EMChatType)messageType
                    messageExt:(NSDictionary *)messageExt
                     cmdParams:(NSArray *)params;

/*!
 @method
 @brief 构建待发送的位置消息
 @discussion        向环信id为to的用户发送位置消息
 @param latitude    纬度
 @param longitude   经度
 @param address     地址信息
 @param to          消息的接收方环信id
 @param messageType 消息的聊天类型
 @param messageExt  消息的扩展属性
 @result 返回构建完成的消息
 */
+ (EMMessage *)sendLocationMessageWithLatitude:(double)latitude
                                     longitude:(double)longitude
                                       address:(NSString *)address
                                            to:(NSString *)to
                                   messageType:(EMChatType)messageType
                                    messageExt:(NSDictionary *)messageExt;

/*!
 @method
 @brief 构建待发送的图片消息
 @discussion        向环信id为to的用户发送图片消息
 @param imageData   图片数据(NSData对象)
 @param to          消息的接收方环信id
 @param messageType 消息的聊天类型
 @param messageExt  消息的扩展属性
 @result 返回构建完成的消息
 */
+ (EMMessage *)sendImageMessageWithImageData:(NSData *)imageData
                                          to:(NSString *)to
                                 messageType:(EMChatType)messageType
                                  messageExt:(NSDictionary *)messageExt;

/*!
 @method
 @brief 构建待发送的图片消息
 @discussion        向环信id为to的用户发送图片消息
 @param image       图片(UIImage对象)
 @param to          消息的接收方环信id
 @param messageType 消息的聊天类型
 @param messageExt  消息的扩展属性
 @result 返回构建完成的消息
 */
+ (EMMessage *)sendImageMessageWithImage:(UIImage *)image
                                      to:(NSString *)to
                             messageType:(EMChatType)messageType
                              messageExt:(NSDictionary *)messageExt;

/*!
 @method
 @brief 构建待发送的语音消息
 @discussion        向环信id为to的用户发送语音消息
 @param localPath   录制的语音文件本地路径
 @param duration    语音时长
 @param to          消息的接收方环信id
 @param messageType 消息的聊天类型
 @param messageExt  消息的扩展属性
 @result 返回构建完成的消息
 */
+ (EMMessage *)sendVoiceMessageWithLocalPath:(NSString *)localPath
                                    duration:(NSInteger)duration
                                          to:(NSString *)to
                                messageType:(EMChatType)messageType
                                  messageExt:(NSDictionary *)messageExt;

/*!
 @method
 @brief 构建待发送的视频消息
 @discussion        向环信id为to的用户发送视频消息
 @param url         视频文件本地路径url
 @param to          消息的接收方环信id
 @param messageType 消息的聊天类型
 @param messageExt  消息的扩展属性
 @result 返回构建完成的消息
 */
+ (EMMessage *)sendVideoMessageWithURL:(NSURL *)url
                                    to:(NSString *)to
                           messageType:(EMChatType)messageType
                            messageExt:(NSDictionary *)messageExt;

#pragma mark - call

@end
