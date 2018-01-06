//
//  LMJUMengHelper.h
//  iOSProject
//
//  Created by HuXuPeng on 2017/12/29.
//  Copyright © 2017年 HuXuPeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UMessage.h"
#import <UMSocialCore/UMSocialCore.h>
#import <UShareUI/UShareUI.h>
#import <UMMobClick/MobClick.h>

@interface LMJUMengHelper : NSObject
/*!
 * 启动友盟统计功能
 */
+ (void)UMAnalyticStart;


/**
 初始化第三方登录和分享
 */
+ (void)UMSocialStart;


/**
 初始化推送
 
 */
+ (void)UMPushStart:(NSDictionary *)launchOptions;


/**
 自定义分享
 
 @param title 分享的标题
 @param subTitle 内容
 @param thumbImage 缩略图
 @param shareURL 分享的url
 */
+ (void)shareTitle:(NSString *)title subTitle:(NSString *)subTitle thumbImage:(NSString *)thumbImage shareURL:(NSString *)shareURL;


#pragma mark - UM第三方登录
+ (void)getUserInfoForPlatform:(UMSocialPlatformType)platformType completion:(void(^)(UMSocialUserInfoResponse *result, NSError *error))completion;



#pragma mark - UM统计

/// 在viewWillAppear调用,才能够获取正确的页面访问路径、访问深度（PV）的数据
+ (void)beginLogPageView:(__unsafe_unretained Class)pageView;

/// 在viewDidDisappeary调用，才能够获取正确的页面访问路径、访问深度（PV）的数据
+ (void)endLogPageView:(__unsafe_unretained Class)pageView;


/*!
 * 自定义名称
 */
/// 在viewWillAppear调用,才能够获取正确的页面访问路径、访问深度（PV）的数据
+(void)beginLogPageViewName:(NSString *)pageViewName;

/// 在viewDidDisappeary调用，才能够获取正确的页面访问路径、访问深度（PV）的数据
+(void)endLogPageViewName:(NSString *)pageViewName;
@end
