//
//  LWApiSDK.h
//  LWApiSDK
//
//  Created by Leyteris on 9/22/13.
//  Copyright (c) 2013 Laiwang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LWApiUtils.h"
#import "LWApiConfig.h"
#import "LWApiRequest.h"
#import "LWApiResponse.h"
#import "LWApiMessage.h"
#import "LWApiMediaObject.h"
#import "LWApiImageObject.h"

/**
 *  sdk代理协议
 */
@protocol LWApiSDKDelegate <NSObject>

/**
 *  请求回调
 *
 *  @param request 请求回调
 */
- (void)didReceiveLaiwangRequest:(LWApiBaseRequest*)request;

/**
 *  响应回调
 *
 *  @param response 响应回调
 */
- (void)didReceiveLaiwangResponse:(LWApiBaseResponse*)response;

@end

@interface LWApiSDK : NSObject

/**
 *  在来往终端程序中注册第三方应用,需要在每次启动第三方应用程序时调用。
 *
 *  特别注意：务必将appId加入app的URL Schemes中，否则将无法会跳
 *
 *  @param appId  开发者id
 *  @param secret 开发者secret
 *  @param description 第三方应用的名称
 */
+ (void)registerApp:(NSString *)appId
             secret:(NSString *)secret
        description:(NSString *)description;

/**
 *  检查来往是否已被用户安装
 *
 *  @return 已安装返回YES，未安装返回NO。
 */
+ (BOOL)isLWAppInstalled;

/**
 *  获取当前来往SDK的版本号
 *
 *  @return 当前来往SDK的版本号
 */
+ (NSString *)getApiVersion;

/**
 *  开启debug模式
 *
 *  @param enabled 是否开启
 */
+ (void)enableDebugMode:(BOOL)enabled;

/**
 *  打开来往
 *
 *  @return 成功返回YES，失败返回NO。
 */
+ (BOOL)openLWApp;

/**
 *  处理来往通过URL启动App时传递的数据
 *
 *  @param url      启动App的URL
 *  @param delegate LWApiDelegate对象，用来接收来往触发的消息
 *
 *  @return 成功返回YES，失败返回NO。
 */
+ (BOOL)handleOpenURL:(NSURL *)url delegate:(id<LWApiSDKDelegate>)delegate;

/**
 *  发送请求到来往,等待来往返回onResp
 *
 *  @param request 具体的发送请求
 *
 *  @return 成功返回YES，失败返回NO
 */
+ (BOOL)sendRequest:(LWApiBaseRequest *)request;

/**
 *  收到来往onReq的请求，发送对应的应答给来往，并切换到来往界面
 *
 *  @param response 具体的应答内容
 *
 *  @return 成功返回YES，失败返回NO
 */
+ (BOOL)sendResponse:(LWApiBaseResponse *)response;

@end
