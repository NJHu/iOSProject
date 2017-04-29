//
//  UMSocialPlatformProvider.h
//  UMSocialSDK
//
//  Created by 张军华 on 16/8/4.
//  Copyright © 2016年 dongjianxiong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UMSocialPlatformConfig.h"

@class UMSocialMessageObject;

/**
 *  每个平台的必须实现的协议
 */
@protocol UMSocialPlatformProvider <NSObject>

@optional
/**
 *  当前UMSocialPlatformProvider对应操作的UMSocialPlatformType
 *  @discuss 当前很多平台对应多个平台类型，出现一对多的关系
 *  例如：QQ提供UMSocialPlatformType_Qzone 和 UMSocialPlatformType_QQ,用户点击分享或者认证的时候，需要区分用户分享或者认证的对应的哪个平台
 */
@property(nonatomic,assign)UMSocialPlatformType socialPlatformType;

/**
 *  初始化平台
 *
 *  @param appKey      对应的appkey
 *  @param appSecret   对应的appSecret
 *  @param redirectURL 对应的重定向url
 *  @discuss appSecret和redirectURL如果平台必须要的话就传入，不需要就传入nil
 */
-(void)umSocial_setAppKey:(NSString *)appKey
            withAppSecret:(NSString *)appSecret
          withRedirectURL:(NSString *)redirectURL;

/**
 *  授权
 *
 *  @param userInfo          用户的授权的自定义数据
 *  @param completionHandler 授权后的回调
 *  @discuss userInfo在有些平台可以带入，如果没有就传入nil.
 */
-(void)umSocial_AuthorizeWithUserInfo:(NSDictionary *)userInfo
                withCompletionHandler:(UMSocialRequestCompletionHandler)completionHandler;

/**
 *  授权
 *
 *  @param userInfo          用户的授权的自定义数据
 *  @param completionHandler 授权后的回调
 *  @parm  viewController   分享需要的viewController
 *  @discuss userInfo在有些平台可以带入，如果没有就传入nil.
 *           这个函数用于sms,email等需要传入viewController的平台
 */
-(void)umSocial_AuthorizeWithUserInfo:(NSDictionary *)userInfo
                   withViewController:(UIViewController*)viewController
                withCompletionHandler:(UMSocialRequestCompletionHandler)completionHandler;

/**
 *  分享
 *
 *  @param object            分享的对象数据模型
 *  @param completionHandler 分享后的回调
 */
-(void)umSocial_ShareWithObject:(UMSocialMessageObject *)object
          withCompletionHandler:(UMSocialRequestCompletionHandler)completionHandler;

/**
 *  分享
 *
 *  @param object            分享的对象数据模型
 *  @param completionHandler 分享后的回调
 *  @parm  viewController   分享需要的viewController
 *  @dicuss 这个函数用于sms,email等需要传入viewController的平台
 */
-(void)umSocial_ShareWithObject:(UMSocialMessageObject *)object
             withViewController:(UIViewController*)viewController
          withCompletionHandler:(UMSocialRequestCompletionHandler)completionHandler;

/**
 *  取消授权
 *
 *  @param completionHandler 授权后的回调
 *  @discuss userInfo在有些平台可以带入，如果没有就传入nil.
 */
-(void)umSocial_cancelAuthWithCompletionHandler:(UMSocialRequestCompletionHandler)completionHandler;

/**
 *  授权成功后获得用户的信息
 *
 *  @param completionHandler 请求的回调
 */
-(void)umSocial_RequestForUserProfileWithCompletionHandler:(UMSocialRequestCompletionHandler)completionHandler;


/**
 *  获取用户信息
 *  @param currentViewController 用于弹出类似邮件分享、短信分享等这样的系统页面
 *  @param completion   回调
 */
- (void)umSocial_RequestForUserProfileWithViewController:(id)currentViewController
                                              completion:(UMSocialRequestCompletionHandler)completion;


/**
 *  清除平台的数据F
 */
-(void)umSocial_clearCacheData;

/**
 *  获得从sso或者web端回调到本app的回调
 *
 *  @param url 第三方sdk的打开本app的回调的url
 *
 *  @return 是否处理  YES代表处理成功，NO代表不处理
 */
-(BOOL)umSocial_handleOpenURL:(NSURL *)url;
-(BOOL)umSocial_handleOpenURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;
-(BOOL)umSocial_handleOpenURL:(NSURL *)url options:(NSDictionary*)options;


#pragma mark - 平台的特性
/**
 *  平台的特性
 *
 *  @return 返回平台特性
 *
 */
-(UMSocialPlatformFeature)umSocial_SupportedFeatures;

/**
 *  平台的版本
 *
 *  @return 当前平台sdk的version
 */
-(NSString *)umSocial_PlatformSDKVersion;

/**
 *  检查urlschema
 *
 */
-(BOOL)checkUrlSchema;


-(BOOL)umSocial_isInstall;

-(BOOL)umSocial_isSupport;


@end


