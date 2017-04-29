//
//  IFlySpeechPlusSDKInterface.h
//  IFlySpeechPlusSDK
//
//  Created by 张剑 on 14/12/1.
//  Copyright (c) 2014年 iflytek. All rights reserved.
//

#import <Foundation/Foundation.h>



#pragma mark -
/*! @brief 第三方应用程序使用的SDK接口。
 *
 *  该类封装了语音+的所有接口
 */
@interface IFlySpeechPlusSDKInterface : NSObject

/*! @brief 向语音+注册第三方应用。
 *
 * 需要在每次启动第三方应用程序时调用。第一次调用后，会在语音+的可用应用列表中出现。
 * iOS7及以上系统需要调起一次语音+才会出现在语音+的可用应用列表中。
 * @attention 请保证在主线程中调用此函数
 * @param appid 用户ID
 * @return 成功返回YES，失败返回NO。
 */
+(BOOL) registerApp:(NSString *)appid;

/*! @brief 向语音+注册第三方应用。
 *
 * 需要在每次启动第三方应用程序时调用。第一次调用后，会在语音+的可用应用列表中出现。
 * iOS7及以上系统需要调起一次语音+才会出现在语音+的可用应用列表中。
 * @attention 请保证在主线程中调用此函数
 * @param appid 用户ID
 * @param appdesc 应用附加信息，长度不超过1024字节
 * @return 成功返回YES，失败返回NO。
 */
+(BOOL) registerApp:(NSString *)appid withDescription:(NSString *)appdesc;

/*! @brief 检查语音+是否已被用户安装
 *
 * @return 语音+已安装返回YES，未安装返回NO。
 */
+(BOOL) isIFlySpeechPlusInstalled;

/*! @brief 获取语音+的itunes安装地址
 *
 * @return 语音+的安装地址字符串。
 */
+(NSString *) getIFlySpeechPlusItunesUrl;

/*!
 *  获取语音+在itunes上的appid用于程序内下载
 *
 *  @return 音+在itunes上的appid
 */
+(NSString *) getIFlySpeechPlusItunesAppID;

/*! @brief 获取当前语音+SDK的版本号
 *
 * @return 返回当前语音+SDK的版本号
 */
+(NSString *) getIFlySpeechPlusSDKVersion;

/*! @brief 打开语音+
 *
 * @return 成功返回YES，失败返回NO。
 */
+(BOOL) openIFlySpeechPlus;

/*! @brief 处理语音+使用URL启动第三方应用程序时传递的数据
 *
 * 需要在 application:openURL:sourceApplication:annotation:或者application:handleOpenURL中调用。
 * @param url 语音+启动第三方应用程序时传递过来的URL
 * @return 成功返回YES，失败返回NO。
 */
+(BOOL) handleOpenURL:(NSURL *) url;

/**
 *  @brief  处理协议2.0，语音+放置在剪贴板的消息，当第三方程序从后台进入前台时驱动协议处理。
 *  @return 成功返回YES，失败返回NO
 */
+(BOOL) handlePasteboardMessage;

@end
