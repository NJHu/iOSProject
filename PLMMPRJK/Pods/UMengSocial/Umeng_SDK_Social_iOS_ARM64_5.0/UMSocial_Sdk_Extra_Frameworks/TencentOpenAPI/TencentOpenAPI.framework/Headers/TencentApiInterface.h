//
//  TencentMessage.h
//  TencentOpenApi_IOS
//
//  Created by qqconnect on 13-5-29.
//  Copyright (c) 2013年 Tencent. All rights reserved.
//

#ifndef QQ_OPEN_SDK_LITE

#import <Foundation/Foundation.h>
#import "TencentMessageObject.h"

typedef enum
{
    kIphoneQQ,
    kIphoneQZONE,
    kThirdApp,
}
TecnentPlatformType;

typedef enum
{
    kTencentApiSuccess,
    kTencentApiPlatformUninstall,
    kTencentApiPlatformNotSupport,
    kTencentApiParamsError,
    kTencentApiFail,
}
TencentApiRetCode;

@class TencentApiReq;
@class TencentApiResp;

/**
 * \brief TencentApiInterface的回调
 *
 * TencentApiInterface的回调接口 
 * \note v1.0版本只支持腾讯业务拉起第三方请求内容
 */
@protocol TencentApiInterfaceDelegate <NSObject>

@optional
/**
 * 请求获得内容 当前版本只支持第三方相应腾讯业务请求
 */
- (BOOL)onTencentReq:(TencentApiReq *)req;

/**
 * 响应请求答复 当前版本只支持腾讯业务相应第三方的请求答复
 */
- (BOOL)onTencentResp:(TencentApiResp *)resp;

@end

/**
 * \brief TencentApiInterface的回调
 *
 * TencentApiInterface的调用接口 
 * \note v1.0版本只支持第三方答复内容
 */
@interface TencentApiInterface : NSObject

/**
 * 发送答复返回腾讯业务
 * \param resp 答复内容
 * \return 返回码
 */
+ (TencentApiRetCode)sendRespMessageToTencentApp:(TencentApiResp *)resp;

/**
 * 是否可以处理拉起协议
 * \param url
 * \param delegate 指定的回调
 * \return 是否是腾讯API认识的消息类型
 */
+ (BOOL)canOpenURL:(NSURL *)url delegate:(id<TencentApiInterfaceDelegate>)delegate;

/**
 * 处理应用拉起协议
 * \param url
 * \param delegate 指定的回调
 * \return 是否是腾讯API认识的消息类型
 */
+ (BOOL)handleOpenURL:(NSURL *)url delegate:(id<TencentApiInterfaceDelegate>)delegate;

/**
 * 用户设备是否安装腾讯APP
 * \param platform 指定的腾讯业务
 * \return YES:安装 NO:未安装
 */
+ (BOOL)isTencentAppInstall:(TecnentPlatformType)platform;

/**
 * 用户设备是否支持调用SDK
 * \param platform 指定的腾讯业务
 * \return YES:支持 NO:不支持
 */
+ (BOOL)isTencentAppSupportTencentApi:(TecnentPlatformType)platform;

@end

#endif
