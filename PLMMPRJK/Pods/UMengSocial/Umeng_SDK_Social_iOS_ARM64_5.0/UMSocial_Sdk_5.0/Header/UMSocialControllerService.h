//
//  UMSocialUIController.h
//  SocialSDK
//
//  Created by Jiahuan Ye on 12-9-12.
//  Copyright (c) umeng.com All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UMSocialDataService.h"

#define kTagSocialIconActionSheet 1013
#define kTagSocialShakeView 1014

@class UMSocialControllerService;

/**
 `UMSocialControllerService`对象用到的一些回调方法，包括分享完成、授权完成、评论完成等事件，和关闭授权页面、分享页面、评论页面等事件。
 */
@protocol UMSocialUIDelegate <NSObject>

@optional

/**
 自定义关闭授权页面事件
 
 @param navigationCtroller 关闭当前页面的navigationCtroller对象
 
 */
-(BOOL)closeOauthWebViewController:(UINavigationController *)navigationCtroller socialControllerService:(UMSocialControllerService *)socialControllerService;

/**
 关闭当前页面之后
 
 @param fromViewControllerType 关闭的页面类型
 
 */
-(void)didCloseUIViewController:(UMSViewControllerType)fromViewControllerType;

/**
 各个页面执行授权完成、分享完成、或者评论完成时的回调函数
 
 @param response 返回`UMSocialResponseEntity`对象，`UMSocialResponseEntity`里面的viewControllerType属性可以获得页面类型
 */
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response;

/**
 点击分享列表页面，之后的回调方法，你可以通过判断不同的分享平台，来设置分享内容。
 例如：
 
 -(void)didSelectSocialPlatform:(NSString *)platformName withSocialData:(UMSocialData *)socialData
 {
    if (platformName == UMShareToSina) {
        socialData.shareText = @"分享到新浪微博的文字内容";
    }
    else{
        socialData.shareText = @"分享到其他平台的文字内容";
    }
 }
 
 @param platformName 点击分享平台
 
 @prarm socialData   分享内容
 */
-(void)didSelectSocialPlatform:(NSString *)platformName withSocialData:(UMSocialData *)socialData;


/**
 配置点击分享列表后是否弹出分享内容编辑页面，再弹出分享，默认需要弹出分享编辑页面
 
 @result 设置是否需要弹出分享内容编辑页面，默认需要
 
 */
-(BOOL)isDirectShareInIconActionSheet;
@end


/**
 用此类的方法可以得到分享的有关UI对象，例如分享列表、评论列表、分享编辑页、分享授权页、个人中心页面等。返回都是`UINavigationController`对象，建议把这个对象present到你要添加到的`UIViewController`上
 */
@interface UMSocialControllerService : NSObject

/**
 与`UMSocialControllerService`对象对应的`UMSocialData`对象，可以通过该对象设置分享内嵌文字、图片，获取分享数等属性
 */
@property (nonatomic, retain) UMSocialData *socialData;

/**
 用`UMSocialDataService`对象，可以调用发送微博、评论等数据级的方法
 */
@property (nonatomic, readonly) UMSocialDataService *socialDataService;

/**
 当前返回的`UINavigationController`对象
 */
@property (nonatomic, assign) UIViewController *currentViewController;

/**
 当前返回的`UIViewController`对象
 */
@property (nonatomic, assign) UINavigationController *currentNavigationController;


/**
 当前`<UMSocialUIDelegate>`对象,此对象可以获取到授权完成，关闭页面等状态，详情看`UMSocialUIDelegate`的定义
 */
@property (nonatomic, assign) id <UMSocialUIDelegate> socialUIDelegate;

/**
 当前sns平台名
 */
@property (nonatomic, retain) NSString *currentSnsPlatformName;

/**
 下一个页面类型
 */
@property (nonatomic, assign) UMSViewControllerType nextViewController;

/**
 返回一个以[UMSocialData defaultData]来做初始化参数的`UMSocialControllerService`对象
 
 @return `UMSocialControllerService`的默认初始化对象
 */
+(UMSocialControllerService *)defaultControllerService;

///---------------------------------------
/// @name 初始化方法和设置
///---------------------------------------

/**
 初始化一个`UMSocialControllerService`对象
 
 @param socialData `UMSocialData`对象
 
 @return 初始化对象
 */
- (id)initWithUMSocialData:(UMSocialData *)socialData;

/**
 设置分享内容和回调对象
 
 @param shareText 分享内嵌文字
 
 @param shareImage 分享内嵌图片,可以传入UIImage或者NSData类型
 
 @param socialUIDelegate 分享回调对象
 */
- (void)setShareText:(NSString *)shareText shareImage:(id)shareImage
    socialUIDelegate:(id<UMSocialUIDelegate>)socialUIDelegate;

///---------------------------------------
/// @name 获得评论列表、分享列表等UINavigationController
///---------------------------------------

/**
 得到一个分享列表页面，该列表出现的分享列表可以通过实现`UMSocialConfig`的类方法来自定义
 
 @return `UINavigationController`对象
 */
- (UINavigationController *)getSocialShareListController;


/**
 分享编辑页面
 
 @param platformType 要编辑的微博平台,并支持UMSocialSnsTypeEmail和UMSocialSnsTypeSms返回编辑Email页面和短信页面，不支持邮箱或者短信的设备分别返回nil
 
 @return `UINavigationController`对象
 */
- (UINavigationController *)getSocialShareEditController:(NSString *)platformType;

/**
 授权页面，如果你要想得到授权完成之后的事件，你可以实现`UMSocialUIDelegate`里面的`-(void)didCloseUIViewController:(UMSViewControllerType)fromViewControllerType;`方法，当授权关闭页面会调用此方法。另外授权完成之后sdk会自动去取个人账户信息，你可以在回调函数里面去到刚刚授权的微博平台的账户信息。
 
 @param shareToType 要授权的微博平台
 
 @return `UINavigationController`对象
 */
- (UINavigationController *)getSocialOauthController:(NSString *)platformType;

/**
 获取用以sns各平台icon平铺来展示的分享列表页面对象
 
 @param controller 弹出的分享列表页面，点击sns平台icon之后，出现的分享页面或者授权页面所在的UIViewController
 
 @return 分享列表页面
 */
- (id)getSocialIconActionSheetInController:(UIViewController *)controller;

/**
获取各种页面的`UIViewController`对象

@param viewControllerType 页面类型

@param snsName 编辑页面、授权页面等需要的平台名

@return 页面的`UIViewController`对象
*/
- (UIViewController *)getSocialViewController:(UMSViewControllerType)viewControllerType withSnsType:(NSString *)snsName;

-(void)setCurrentViewControllerType:(UMSViewControllerType)viewControllerType;

@end