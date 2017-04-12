//
//  UMessage.h
//  UMessage
//
//  Created by luyiyuan on 10/8/13.
//  Copyright (c) 2013 umeng.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>


/** String type for alias
 */
//新浪微博
UIKIT_EXTERN NSString * __nonnull const kUMessageAliasTypeSina;
//腾讯微博
UIKIT_EXTERN NSString * __nonnull const kUMessageAliasTypeTencent;
//QQ
UIKIT_EXTERN NSString * __nonnull const kUMessageAliasTypeQQ;
//微信
UIKIT_EXTERN NSString * __nonnull const kUMessageAliasTypeWeiXin;
//百度
UIKIT_EXTERN NSString * __nonnull const kUMessageAliasTypeBaidu;
//人人网
UIKIT_EXTERN NSString * __nonnull const kUMessageAliasTypeRenRen;
//开心网
UIKIT_EXTERN NSString * __nonnull const kUMessageAliasTypeKaixin;
//豆瓣
UIKIT_EXTERN NSString * __nonnull const kUMessageAliasTypeDouban;
//facebook
UIKIT_EXTERN NSString * __nonnull const kUMessageAliasTypeFacebook;
//twitter
UIKIT_EXTERN NSString * __nonnull const kUMessageAliasTypeTwitter;


//error for handle
extern NSString * __nonnull const kUMessageErrorDomain;

typedef NS_ENUM(NSInteger, kUMessageError) {
    /**未知错误*/
    kUMessageErrorUnknown = 0,
    /**响应出错*/
    kUMessageErrorResponseErr = 1,
    /**操作失败*/
    kUMessageErrorOperateErr = 2,
    /**参数非法*/
    kUMessageErrorParamErr = 3,
    /**条件不足(如:还未获取device_token，添加tag是不成功的)*/
    kUMessageErrorDependsErr = 4,
    /**服务器限定操作*/
    kUMessageErrorServerSetErr = 5,
};


@class CLLocation;

/** UMessage：开发者使用主类（API）
 */
@interface UMessage : NSObject


///---------------------------------------------------------------------------------------
/// @name settings（most required）
///---------------------------------------------------------------------------------------

//--required

/** 绑定App的appKey和启动参数，启动消息参数用于处理用户通过消息打开应用相关信息
 @param appKey      主站生成appKey
 @param launchOptions 启动参数
 */
+ (void)startWithAppkey:(NSString * __nonnull)appKey launchOptions:(NSDictionary * __nullable)launchOptions;

/** 绑定App的appKey和启动参数，启动消息参数用于处理用户通过消息打开应用相关信息
 @param appKey      主站生成appKey
 @param launchOptions 启动参数
 @param value     开启友盟内部协议使用https的开关,默认是关闭
 */
+ (void)startWithAppkey:(NSString * __nonnull)appKey launchOptions:(NSDictionary * __nullable)launchOptions httpsenable:(BOOL)value;

/** 注册RemoteNotification的类型
 @brief 分别针对iOS8以前版本及iOS8及以后开启推送消息推送。
 默认的时候是sound，badge ,alert三个功能全部打开, 没有开启交互式推送行为分类。
 */
+ (void)registerForRemoteNotifications;

/** 注册RemoteNotification的类型
 @brief 分别针对iOS8以下版本及iOS8及以上开启推送消息推送。
 默认的时候是sound，badge ,alert三个功能全部打开。
 @param categories 交互式推送行为分类。可以具体查看demo。
 */
+ (void)registerForRemoteNotifications:(nullable NSSet<UIUserNotificationCategory *> *)categories8;

/** 注册RemoteNotification的类型
 @brief 分别针对iOS8以前版本及iOS8及以后开启推送消息推送。
 默认的时候是sound，badge ,alert三个功能全部打开。
 @param categories8 交互式推送行为分类。可以具体查看demo。
 @param types7 iOS7及以下版本的推送类型。默认types7 = UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound;
 @param types8 iOS8及以上，iOS10以下版本的推送类型。默认types8 = UIUserNotificationTypeAlert|UIUserNotificationTypeSound|UIUserNotificationTypeBadge;
  */
+ (void)registerForRemoteNotifications:(nullable NSSet<UIUserNotificationCategory *> *)categories8
                      withTypesForIos7:(UIRemoteNotificationType)types7
                      withTypesForIos8:(UIUserNotificationType)types8;



/** 解除RemoteNotification的注册（关闭消息推送，实际调用：[[UIApplication sharedApplication] unregisterForRemoteNotifications]）
 @param types 消息类型，参见`UIRemoteNotificationType`
 */
+ (void)unregisterForRemoteNotifications;

/** 向友盟注册该设备的deviceToken，便于发送Push消息
 @param deviceToken APNs返回的deviceToken
 */
+ (void)registerDeviceToken:(nullable NSData *)deviceToken;

/** 应用处于运行时（前台、后台）的消息处理
 @param userInfo 消息参数
 */
+ (void)didReceiveRemoteNotification:(nullable NSDictionary *)userInfo;

//--optional

/** 开发者自行传入location
 @param location 当前location信息
 */
+ (void)setLocation:(nullable CLLocation *)location;

/** 设置应用的日志输出的开关（默认关闭）
 @param value 是否开启标志，注意App发布时请关闭日志输出
 */
+ (void)setLogEnabled:(BOOL)value;

/** 设置是否允许SDK自动清空角标（默认开启）
 @param value 是否开启角标清空
 */
+ (void)setBadgeClear:(BOOL)value;

/** 设置是否允许SDK当应用在前台运行收到Push时弹出Alert框（默认开启）
 @warning 建议不要关闭，否则会丢失程序在前台收到的Push的点击统计,如果定制了 Alert，可以使用`sendClickReportForRemoteNotification`补发 log
 @param value 是否开启弹出框
 */
+ (void)setAutoAlert:(BOOL)value;

/** 设置App的发布渠道（默认为:"App Store"）
 @param channel 渠道名称
 */
+ (void)setChannel:(nullable NSString *)channel;

/** 设置设备的唯一ID，目前友盟这边设备的唯一ID是OpenUdid，如果你们可以采集到更合适的唯一ID，可以采用这个ID来替换OpenUdid
 @warning 用户可以设置uniqueId方便以后扩展，我们短时间内在服务区端任然会采取OpenUdid作为唯一标记。
 @param uniqueId 唯一ID名称
 */
+ (void)setUniqueID:(nullable NSString *)uniqueId;

/** 为某个消息发送点击事件
 @warning 请注意不要对同一个消息重复调用此方法，可能导致你的消息打开率飚升，此方法只在需要定制 Alert 框时调用
 @param userInfo 消息体的NSDictionary，此Dictionary是
        (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo中的userInfo
 */
+ (void)sendClickReportForRemoteNotification:(nullable NSDictionary *)userInfo;


///---------------------------------------------------------------------------------------
/// @name tag (optional)
///---------------------------------------------------------------------------------------


/** 获取当前绑定设备上的所有tag(每台设备最多绑定64个tag)
 @warning 获取列表的先决条件是已经成功获取到device_token，否则失败(kUMessageErrorDependsErr)
 @param handle responseTags为绑定的tag
 集合,remain剩余可用的tag数,为-1时表示异常,error为获取失败时的信息(ErrCode:kUMessageError)
 */
+ (void)getTags:(nullable void (^)(NSSet *__nonnull responseTags,NSInteger remain,NSError *__nonnull error))handle;

/** 绑定一个或多个tag至设备，每台设备最多绑定64个tag，超过64个，绑定tag不再成功，可`removeTag`或者`removeAllTags`来精简空间
 @warning 添加tag的先决条件是已经成功获取到device_token，否则直接添加失败(kUMessageErrorDependsErr)
 @param tag tag标记,可以为单个tag（NSString）也可以为tag集合（NSArray、NSSet），单个tag最大允许长度50字节，编码UTF-8，超过长度自动截取
 @param handle responseTags为绑定的tag集合,remain剩余可用的tag数,为-1时表示异常,error为获取失败时的信息(ErrCode:kUMessageError)
 */
+ (void)addTag:(nullable id)tag response:(nullable void (^)(id __nonnull responseObject ,NSInteger remain,NSError *__nonnull error))handle;

/** 删除设备中绑定的一个或多个tag
 @warning 添加tag的先决条件是已经成功获取到device_token，否则失败(kUMessageErrorDependsErr)
 @param tag tag标记,可以为单个tag（NSString）也可以为tag集合（NSArray、NSSet），单个tag最大允许长度50字节，编码UTF-8，超过长度自动截取
 @param handle responseTags为绑定的tag集合,remain剩余可用的tag数,为-1时表示异常,error为获取失败时的信息(ErrCode:kUMessageError)
 */
+ (void)removeTag:(id __nonnull)tag response:(nullable void (^)(id __nonnull responseObject,NSInteger remain,NSError *__nonnull error))handle;

/** 删除设备中所有绑定的tag,handle responseObject
 @warning 删除tag的先决条件是已经成功获取到device_token，否则失败(kUMessageErrorDependsErr)
 @param handle responseTags为绑定的tag集合,remain剩余可用的tag数,为-1时表示异常,error为获取失败时的信息(ErrCode:kUMessageError)
 */
+ (void)removeAllTags:(nullable void (^)(id __nonnull responseObject,NSInteger remain,NSError *__nonnull error))handle;


///---------------------------------------------------------------------------------------
/// @name alias (optional)
///---------------------------------------------------------------------------------------


/** 绑定一个别名至设备（含账户，和平台类型）
 @warning 添加Alias的先决条件是已经成功获取到device_token，否则失败(kUMessageErrorDependsErr)
 @param name 账户，例如email
 @param type 平台类型，参见本文件头部的`kUMessageAliasType...`，例如：kUMessageAliasTypeSina
 @param handle block返回数据，error为获取失败时的信息，responseObject为成功返回的数据
 */
+ (void)addAlias:(NSString * __nonnull)name type:(NSString * __nonnull)type response:(nullable void (^)(id __nonnull responseObject,NSError *__nonnull error))handle;

/** 绑定一个别名至设备（含账户，和平台类型）,并解绑这个别名曾今绑定过的设备。
 @warning 添加Alias的先决条件是已经成功获取到device_token，否则失败(kUMessageErrorDependsErr)
 @param name 账户，例如email
 @param type 平台类型，参见本文件头部的`kUMessageAliasType...`，例如：kUMessageAliasTypeSina
 @param handle block返回数据，error为获取失败时的信息，responseObject为成功返回的数据
 */
+ (void)setAlias:(NSString *__nonnull )name type:(NSString * __nonnull)type response:(nullable void (^)(id __nonnull responseObject,NSError *__nonnull error))handle;

/** 删除一个设备的别名绑定
 @warning 删除Alias的先决条件是已经成功获取到device_token，否则失败(kUMessageErrorDependsErr)
 @param name 账户，例如email
 @param type 平台类型，参见本文件头部的`kUMessageAliasType...`，例如：kUMessageAliasTypeSina
 @param handle block返回数据，error为获取失败时的信息，responseObject为成功返回的数据
 */
+ (void)removeAlias:(NSString * __nonnull)name type:(NSString * __nonnull)type response:(nullable void (^)(id __nonnull responseObject, NSError *__nonnull error))handle;

@end
