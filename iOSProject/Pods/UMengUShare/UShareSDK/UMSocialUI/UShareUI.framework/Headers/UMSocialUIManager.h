//
//  UMSocialUIManager.h
//  UMSocialSDK
//
//  Created by umeng on 16/8/10.
//  Copyright © 2016年 UMeng+. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UMSocialShareUIConfig.h"

@interface UMSocialUIManager : NSObject

#pragma mark - 6.1新增API

/**
 *  显示分享面板
 *
 *  @param sharePlatformSelectionBlock 回调block
 */
+ (void)showShareMenuViewInWindowWithPlatformSelectionBlock:(UMSocialSharePlatformSelectionBlock)sharePlatformSelectionBlock;

/**
 *  设置预定义平台
 *
 *  @param preDefinePlatforms 预定于平台数组@see UMSocialPlatformType.
 *  开发者需要自己预定义自己需要的平台。
 *  此函数需要在UMSocialSharePlatformSelectionBlock之前调用，
 *  传入的平台必须是合法并且是core模块已经检测到的已经存在的平台，不然会被过滤掉(此条款是上线appStore审核的条件，开发者必须注意)
 */
+(void)setPreDefinePlatforms:(NSArray*)preDefinePlatforms;


/**
 *  设置用户自定义的平台显示在分享面板的imageIcon和imageName
 *  设置了此平台后不会过分享面板过滤掉
 *  http://dev.umeng.com/social/ios/进阶文档#5
 *
 *  @param platformType 用户自定义的平台 范围在（UMSocialPlatformType_UserDefine_Begin，UMSocialPlatformType_UserDefine_End） @see UMSocialPlatformType
 *  @param platformIcon    平台的icon
 *  @param platformName    平台的名字
 *  @disuss 此函数也可以加入用户需要自定义非平台的功能的性item,比如copy,paste等系统功能
 */
+(void)addCustomPlatformWithoutFilted:(UMSocialPlatformType)platformType
           withPlatformIcon:(UIImage*)platformIcon
           withPlatformName:(NSString*)platformName;

/**
 *  删除用户自定义的平台显示在分享面板的imageIcon和imageName
 *  http://dev.umeng.com/social/ios/进阶文档#5
 *
 *  @param platformType 范围在（UMSocialPlatformType_UserDefine_Begin，UMSocialPlatformType_UserDefine_End） @see UMSocialPlatformType
 */
+(void)removeCustomPlatformWithoutFilted:(UMSocialPlatformType)platformType;

/**
 *  删除所有的用户自定义的平台
 * http://dev.umeng.com/social/ios/进阶文档#5
 */
+(void)removeAllCustomPlatformWithoutFilted;


/**
 *  设置分享面板的代理，从而监控其显示和隐藏的状态
 *
 *  @param shareMenuViewDelegate shareMenuViewDelegate @see UMSocialShareMenuViewDelegate
 *  @dicuss 用户根据自己的需求来判断是否需要监控分享面板的显示和隐藏的状态
 */
+(void)setShareMenuViewDelegate:(id<UMSocialShareMenuViewDelegate>)shareMenuViewDelegate;

@end

