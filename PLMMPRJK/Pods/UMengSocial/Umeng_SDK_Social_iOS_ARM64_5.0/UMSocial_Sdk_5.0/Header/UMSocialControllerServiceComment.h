//
//  UMSocialControllerServiceComment.h
//  SocialSDK
//
//  Created by yeahugo on 12-12-7.
//  Copyright (c) 2012年 Umeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UMSocialControllerService.h"

/**
 用此类的方法可以得到分享的有关UI对象，例如分享列表、评论列表、分享编辑页、分享授权页、个人中心页面等。返回都是`UINavigationController`对象，建议把这个对象present到你要添加到的`UIViewController`上
 */
@interface UMSocialControllerServiceComment : UMSocialControllerService

/**
 返回一个以[UMSocialData defaultData]来做初始化参数的`UMSocialControllerServiceComment`对象
 
 @return `UMSocialControllerServiceComment`的默认初始化对象
 */
+(UMSocialControllerServiceComment *)defaultControllerService;

/**
 评论列表页面，评论列表页面包括各评论详情、评论编辑
 
 @return `UINavigationController`对象
 */
- (UINavigationController *)getSocialCommentListController;


/**
 得到个人中心页面，该页面包括用户各个微博授权信息和选择的登录账号
 
 @return `UINavigationController`对象
 */
- (UINavigationController *)getSocialAccountController;


/**
 sns账号设置页面，该页面包括个人的各个微博授权信息
 
 @return `UINavigationController`对象
 */
- (UINavigationController *)getSnsAccountController;


/**
 登录页面,出现你配置出现的所有sns平台，授权之后设置为sdk的登录账号。使用评论功能时会取此登录账号的昵称和头像。
 
 @return `UINavigationController`对象
 */
- (UINavigationController *)getSocialLoginController;

@end
