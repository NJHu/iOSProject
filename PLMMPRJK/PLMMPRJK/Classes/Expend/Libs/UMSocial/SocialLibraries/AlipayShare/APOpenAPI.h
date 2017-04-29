//
//  APOpenAPI.h
//  所有API接口
//
//  Created by Alipay on 15-4-15.
//  Copyright (c) 2015年 Alipay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APOpenAPIObject.h"

#pragma mark - APOpenAPIDelegate

/*! @brief 接收并处理来自支付宝终端程序的事件消息
 *
 * 接收并处理来自支付宝终端程序的事件消息，期间支付宝界面会切换到第三方应用程序。
 * APOpenAPIDelegate 会在handleOpenURL:delegate:中使用并触发。
 */
@protocol APOpenAPIDelegate <NSObject>
@optional

/*! @brief 收到一个来自支付宝的请求，第三方应用程序处理完后调用sendResp向支付宝发送结果
 *
 * 收到一个来自支付宝的请求，异步处理完成后必须调用sendResp发送处理结果给支付宝。
 * @param req 具体请求内容
 */
-(void) onReq:(APBaseReq*)req;



/*! @brief 发送一个sendReq后，收到支付宝的回应
 *
 * 收到一个来自支付宝的处理结果。调用一次sendReq后会收到onResp。
 * @param resp具体的回应内容
 */
-(void) onResp:(APBaseResp*)resp;

@end

#pragma mark - APOpenAPI

/*! @brief 支付宝API接口函数类
 *
 * 该类封装了支付宝终端SDK的所有接口
 */
@interface APOpenAPI : NSObject


/*! @brief APOpenAPI的成员函数，向支付宝终端程序注册第三方应用。
 *
 * 需要在每次启动第三方应用程序时调用。第一次调用后，会在支付宝的可用应用列表中出现。
 * iOS7及以上系统需要调起一次支付宝才会出现在支付宝的可用应用列表中。
 * @attention 请保证在主线程中调用此函数
 * @param appid 支付宝开发者ID
 * @return 成功返回YES，失败返回NO。
 */
+(BOOL) registerApp:(NSString *)appid;



/*! @brief APOpenAPI的成员函数，向支付宝终端程序注册第三方应用。
 *
 * 需要在每次启动第三方应用程序时调用。第一次调用后，会在支付宝的可用应用列表中出现。
 * @see registerApp
 * @param appid 支付宝开发者ID
 * @param appdesc 应用附加信息，长度不超过1024字节
 * @return 成功返回YES，失败返回NO。
 */
+(BOOL) registerApp:(NSString *)appid withDescription:(NSString *)appdesc;



/*! @brief 处理支付宝通过URL启动App时传递的数据
 *
 * 需要在 application:openURL:sourceApplication:annotation:或者application:handleOpenURL中调用。
 * @param url 支付宝启动第三方应用时传递过来的URL
 * @param delegate  APOpenAPIDelegate对象，用来接收支付宝触发的消息。
 * @return 成功返回YES，失败返回NO。
 */
+(BOOL) handleOpenURL:(NSURL *) url delegate:(id<APOpenAPIDelegate>) delegate;



/*! @brief 检查支付宝是否已被用户安装
 *
 * @return 支付宝已安装返回YES，未安装返回NO。
 */
+(BOOL) isAPAppInstalled;



/*! @brief 判断当前支付宝的版本是否支持OpenApi
 *
 * @return 支持返回YES，不支持返回NO。
 */
+(BOOL) isAPAppSupportOpenApi;



/*! @brief 获取支付宝的itunes安装地址
 *
 * @return 支付宝的安装地址字符串。
 */
+(NSString *) getAPAppInstallUrl;



/*! @brief 获取当前支付宝SDK的版本号
 *
 * @return 返回当前支付宝SDK的版本号
 */
+(NSString *) getApiVersion;



/*! @brief 打开支付宝
 *
 * @return 成功返回YES，失败返回NO。
 */
+(BOOL) openAPApp;


/*! @brief 发送请求到支付宝，等待支付宝返回onResp
 *
 * 函数调用后，会切换到支付宝的界面。第三方应用程序等待支付宝返回onResp。支付宝在异步处理完成后一定会调用onResp。支持以下类型
 * @param req 具体的发送请求，在调用函数后，请自己释放。
 * @return 成功返回YES，失败返回NO。
 */
+(BOOL) sendReq:(APBaseReq*)req;


/*! @brief 收到支付宝onReq的请求，发送对应的应答给支付宝，并切换到支付宝界面
 *
 * 函数调用后，会切换到支付宝的界面。第三方应用程序收到支付宝onReq的请求，异步处理该请求，完成后必须调用该函数。可能发送的相应有
 * @param resp 具体的应答内容，调用函数后，请自己释放
 * @return 成功返回YES，失败返回NO。
 */
+(BOOL) sendResp:(APBaseResp*)resp;

@end
