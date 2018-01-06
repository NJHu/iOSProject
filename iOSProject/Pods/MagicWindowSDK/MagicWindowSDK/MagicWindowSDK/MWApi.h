//
//  MagicWindowApi.h
//  Created by 刘家飞 on 14/11/18.
//  Copyright (c) 2014年 MagicWindow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MWCampaignConfig.h"
#import <CoreLocation/CoreLocation.h>
#import "MWApiObject.h"

#define DEPRECATED(_version) __attribute__((deprecated))

/**
 *  当活动有更新的时候会触发该notification
 **/
#define MWUpdateCampaignNotification            @"MWUpdateCampaignNotification"
/**
 *  活动详情页面即将打开的时候会触发
 **/
#define MWWebViewWillAppearNotification         @"MWWebViewWillAppearNotification"
/**
 *  活动详情页面关闭的时候会触发
 **/
#define MWWebViewDidDisappearNotification       @"MWWebViewDidDisappearNotification"
/**
 *  @deprecated This method is deprecated starting in version 3.66
 *  @note Please use @code MWUpdateCampaignNotification @code instead.
 **/
#define MWRegisterAppSuccessedNotification      @"MWRegisterAppSuccessedNotification"  DEPRECATED(3.66)


typedef  void (^ _Nullable CallbackWithCampaignSuccess) (NSString *__nonnull key, UIView *__nonnull view, MWCampaignConfig *__nonnull campaignConfig);
typedef void (^ _Nullable CallbackWithCampaignFailure) (NSString *__nonnull key, UIView *__nonnull view, NSString *__nullable errorMessage);
typedef  BOOL (^ CallbackWithTapCampaign) (NSString *__nonnull key, UIView *__nonnull view);
typedef void(^ _Nullable CallBackMLink)(NSURL * __nonnull url ,NSDictionary * __nullable params);
typedef  NSDictionary * _Nullable (^ CallbackWithMLinkCampaign) (NSString *__nonnull key, UIView *__nonnull view);
typedef  NSDictionary * _Nullable (^ CallbackWithMLinkLandingPage) (NSString *__nonnull key, UIView *__nonnull view);
typedef  NSDictionary * _Nullable (^ CallbackWithReturnMLink) (NSString *__nonnull key, UIView *__nonnull view);

@interface MWApi : NSObject

/**
 *  注册app
 *  需要在 application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions 中调用
 *  @param appKey 魔窗后台注册的appkey
 *  @return void
 */
+ (void)registerApp:(nonnull NSString *)appKey;

/**
 *  设置用户基本信息
 *  @param userPhone 用户手机号
 *  @return void
 */
+ (void)setUserPhone:(nonnull NSString *)userPhone;

/**
 *  设置用户基本信息
 *  @param user MWUserProfile对象
 *  @return void
 */
+ (void)setUserProfile:(nonnull MWUserProfile *)user;

/**
 * 退出登录的时候，取消当前的用户基本信息
 */
+ (void)cancelUserProfile;

/**
 *  设置渠道,默认为appStore
 *  @param channel 渠道key
 *  @return void
 */
+ (void)setChannelId:(nonnull NSString *)channel;

/** 
 *  设置是否打印sdk的log信息,默认不开启,在release情况下，不要忘记设为NO.
 *  @param enable YES:打开,NO:关闭
 *  @return void
 */
+ (void)setLogEnable:(BOOL)enable;

/**
 *  设置是否抓取crash信息,默认开启.
 *  @param enable YES:打开,NO:关闭
 *  @return void
 */
+ (void)setCaughtCrashesEnable:(BOOL)enable;

/**
 *  @deprecated This method is deprecated starting in version 3.9
 *  @note default true
 **/
+ (void)setMlinkEnable:(BOOL)enable DEPRECATED(3.9);

/**
 * 用来获得当前sdk的版本号
 * return 返回sdk版本号
 */
+ (nonnull NSString *)sdkVersion;

#pragma mark Campaign
/**
 *  获取UserAgent
 *  当使用自己的WebView打开活动的时候，需要修改UserAgent（新UserAgent=原UserAgent + SDK的UserAgent），用作数据监测和统计
 *  @param key 魔窗位key
 *  @return SDK的UserAgent
 */
+ (nullable NSString *)getUserAgentWithKey:(nonnull NSString *)key;

/**
 *  获取活动相关配置信息
 *  适用于pushViewController
 *  @param key 魔窗位key
 *  @param view 展示活动简介的view
 *  @param success callback 当成功获取到该魔窗位上活动的时候会调用这个回调
 *  @param failure callback 当获取到该魔窗位上活动失败的时候会调用这个回调
 *  @return void
 */
+ (void)configAdViewWithKey:(nonnull NSString *)key withTarget:(nonnull UIView *)view
                    success:(CallbackWithCampaignSuccess)success
                    failure:(CallbackWithCampaignFailure)failure;

/**
 *  获取活动相关配置信息
 *  适用于presentViewController
 *  @param key 魔窗位key
 *  @param view 展示活动简介的view
 *  @param controller 展示活动简介的UIViewController
 *  @param success callback 当成功获取到该魔窗位上活动的时候会调用这个回调
 *  @param failure callback 当获取到该魔窗位上活动失败的时候会调用这个回调
 *  @return void
 */
+ (void)configAdViewWithKey:(nonnull NSString *)key withTargetView:(nonnull UIView *)view withTargetViewController:(nonnull UIViewController *)controller
                    success:(CallbackWithCampaignSuccess)success
                    failure:(CallbackWithCampaignFailure)failure;

/**
 *  获取活动相关配置信息
 *  适用于所有的UIViewController
 *  @param key 魔窗位key
 *  @param view 展示活动简介的view
 *  @param controller 展示活动简介的UIViewController
 *  @param success callback 当成功获取到该魔窗位上活动的时候会调用这个回调
 *  @param failure callback 当获取到该魔窗位上活动失败的时候会调用这个回调
 *  @param tap callback 当点击该魔窗位上活动的时候会调用这个回调，return YES 允许跳转，NO 不允许跳转
 *  @return void
 */
+ (void)configAdViewWithKey:(nonnull NSString *)key withTargetView:(nonnull UIView *)view withTargetViewController:(nullable UIViewController *)controller
                    success:(CallbackWithCampaignSuccess)success
                    failure:(CallbackWithCampaignFailure)failure
                        tap:(nullable CallbackWithTapCampaign)tap;

/**
 *  获取活动相关配置信息
 *  适用于所有的UIViewController
 *  @param key 魔窗位key
 *  @param view 展示活动简介的view
 *  @param controller 展示活动简介的UIViewController
 *  @param success callback 当成功获取到该魔窗位上活动的时候会调用这个回调
 *  @param failure callback 当获取到该魔窗位上活动失败的时候会调用这个回调
 *  @param tap callback 当点击该魔窗位上活动的时候会调用这个回调，return YES 允许跳转，NO 不允许跳转
 *  @param mLinkHandler callback 当活动类型为mlink的时候，点击的该活动的时候，会调用这个回调，return mlink需要的相关参数
 *  @return void
 */
+ (void)configAdViewWithKey:(nonnull NSString *)key withTargetView:(nonnull UIView *)view withTargetViewController:(nullable UIViewController *)controller
                    success:(CallbackWithCampaignSuccess)success
                    failure:(CallbackWithCampaignFailure)failure
                        tap:(nullable CallbackWithTapCampaign)tap
               mLinkHandler:(nullable CallbackWithMLinkCampaign)mLinkHandler;

/**
 *  获取活动相关配置信息
 *  适用于所有的UIViewController
 *  @param key 魔窗位key
 *  @param view 展示活动简介的view
 *  @param controller 展示活动简介的UIViewController
 *  @param success callback 当成功获取到该魔窗位上活动的时候会调用这个回调
 *  @param failure callback 当获取到该魔窗位上活动失败的时候会调用这个回调
 *  @param tap callback 当点击该魔窗位上活动的时候会调用这个回调，return YES 允许跳转，NO 不允许跳转
 *  @param mLinkHandler callback 当活动类型为mlink的时候，点击的该活动的时候，会调用这个回调，return mlink需要的相关参数
 *  @param mLinkLandingPageHandler callback 当活动类型为mlink landing page的时候，点击的该活动的时候，会调用这个回调，return mlink landing page需要的相关参数
 *  @return void
 */
+ (void)configAdViewWithKey:(nonnull NSString *)key withTargetView:(nonnull UIView *)view withTargetViewController:(nullable UIViewController *)controller
                    success:(CallbackWithCampaignSuccess)success
                    failure:(CallbackWithCampaignFailure)failure
                        tap:(nullable CallbackWithTapCampaign)tap
               mLinkHandler:(nullable CallbackWithMLinkCampaign)mLinkHandler
    mLinkLandingPageHandler:(nullable CallbackWithMLinkLandingPage)landingPageHandler;

/**
 *  获取活动相关配置信息，支持A跳到B，B返回A，魔窗位即代表A
 *  适用于所有的UIViewController
 *  @param key 魔窗位key
 *  @param view 展示活动简介的view
 *  @param controller 展示活动简介的UIViewController
 *  @param callBackMLinkKey : mLink key ,当从B返回回来的时候，会根据mLink key来跳转到相应的页面
 *  @param success callback 当成功获取到该魔窗位上活动的时候会调用这个回调
 *  @param failure callback 当获取到该魔窗位上活动失败的时候会调用这个回调
 *  @param tap callback 当点击该魔窗位上活动的时候会调用这个回调，return YES 允许跳转，NO 不允许跳转
 *  @param mLinkHandler callback 当活动类型为mlink的时候，点击的该活动的时候，会调用这个回调，return mlink需要的相关参数
 *  @param mLinkLandingPageHandler callback 当活动类型为mlink landing page的时候，点击的该活动的时候，会调用这个回调，return mlink landing page需要的相关参数
 *  @param MLinkCallBackParamas :callback 当从B返回过来的时候，需要的相关参数
 *  @return void
 */
+ (void)configAdViewWithKey:(nonnull NSString *)key withTargetView:(nonnull UIView *)view withTargetViewController:(nullable UIViewController *)controller WithCallBackMLinkKey:(nullable NSString *)callBackMLinkKey
                    success:(CallbackWithCampaignSuccess)success
                    failure:(CallbackWithCampaignFailure)failure
                        tap:(nullable CallbackWithTapCampaign)tap
                      mLinkHandler:(nullable CallbackWithMLinkCampaign)mLinkHandler
                mLinkLandingPageHandler:(nullable CallbackWithMLinkLandingPage)landingPageHandler
       MLinkCallBackParamas:(nullable CallbackWithReturnMLink)mLinkCallBackParamas;

/**
 *  发送展现日志
 *  @param key 魔窗位key
 *  确定视图显示在window上之后再调用trackImpression，不要太早调用，在tableview或scrollview中使用时尤其要注意
 */
+ (void)trackImpressionWithKey:(nonnull NSString *)key;

/**
 *  判断单个魔窗位上是否有活动
 *  @param mwkey 魔窗位key
 *  @return yes:有处于活跃状态的活动；no：没有处于活跃状态的活动
 */
+(BOOL)isActiveOfmwKey:(nonnull NSString *)mwkey;

/**
 *  批量判断魔窗位上是否有活动
 *  @param mwKeys 魔窗位keys
 *  @return NSArray 有活动的魔窗位keys
 */
+(nullable NSArray *)mwkeysWithActiveCampign:(nonnull NSArray *)mwKeys;

/**
 *  自动打开webView,显示活动
 *  只有在成功获取到活动信息的时候，该方法才有效
 *  @param key 魔窗位key
 *  @param view 展示活动简介的view
 *  @return void
 */
+ (void)autoOpenWebViewWithKey:(nonnull NSString *)key withTargetView:(nonnull UIView *)view;

/**
 *  判断是否发送webview的相关通知（进入webView，关闭webView）
 *  只有在成功获取到活动信息的时候，该方法才有效
 *  @param enable YES:打开，NO:关闭。默认状态为NO
 *  @return void
 */
+ (void)setWebViewNotificationEnable:(BOOL)enable;

/**
 *  是否自定义活动详情页面的导航条按钮
 *  @param enable YES:自定义，NO:不自定义。默认状态为NO
 *  @return void
 */
+ (void)setWebViewBarEditEnable:(BOOL)enable;

#pragma mark Custom event

/**
 *  标识某个页面访问的开始，在合适的位置调用,name不能为空。
 *  @param name 页面的唯一标示，不能为空
 *  @return void
 */
+ (void)pageviewStartWithName:(nonnull NSString *)name;

/**
 *  标识某个页面访问的结束，与pageviewStartWithName配对使用，name不能为空。
 *  @param name 页面的唯一标示，不能为空
 *  @return void
 */
+ (void)pageviewEndWithName:(nonnull NSString *)name;

/**
 * 自定义事件
 *  @param eventId 自定义事件的唯一标示，不能为空
 *  @return void
 */
+ (void)setCustomEvent:(nonnull NSString *)eventId;

/**
 * 自定义事件
 *  @param eventId 自定义事件的唯一标示，不能为空
 *  @param attributes 动态参数，最多可包含9个
 *  @return void
 */
+ (void)setCustomEvent:(nonnull NSString *)eventId attributes:(nullable NSDictionary *)attributes;


#pragma mark Location
/**
 *  设置经纬度信息
 *  @param latitude 纬度
 *  @param longitude 经度
 *  @return void
 */
+ (void)setLatitude:(double)latitude longitude:(double)longitude;

/** 
 *  设置经纬度信息
 *  @param location CLLocation 经纬度信息
 *  @return void
 */
+ (void)setLocation:(nonnull CLLocation *)location;

/**
 *  设置城市编码，以便获取相应城市的活动数据，目前仅支持到地级市
 *  国家标准的行政区划代码:http://files2.mca.gov.cn/www/201510/20151027164514222.htm
 *  @param code 城市编码
 *  @return void
 */
+ (void)setCityCode:(nonnull NSString *)code;

#pragma mark Share

/**
 *  处理第三方app通过URL启动App时传递的数据
 *  需要在 application:handleOpenURL中调用。
 *  @param url 启动App的URL
 *  @param delegate 用来接收第三方app触发的消息。
 *  @return 成功返回YES，失败返回NO。
 */
+ (BOOL)handleOpenURL:(nonnull NSURL *)url delegate:(nullable id)delegate;

/**
 *  @deprecated This method is deprecated starting in version 3.66
 *  @note Please use @code handleOpenURL:delegate: @code instead.
 **/
+ (BOOL)handleOpenURL:(nonnull NSURL *)url sourceApplication:(nullable NSString *)sourceApplication annotation:(nullable id)annotation delegate:(nullable id)delegate DEPRECATED(3.66);

#pragma mark mLink
/**
 * 获得最近一次的mLink短链接的渠道来源
 * @return stirng
 */
+ (nullable NSString *)getLastChannelForMLink;

/**
 * 注册一个mLink handler，当接收到URL的时候，会根据mLink key进行匹配，当匹配成功会调用相应的handler
 * 需要在 AppDelegate 的 didFinishLaunchingWithOptions 中调用
 * @param key 后台注册mlink时生成的mlink key
 * @param handler mlink的回调
 * @param params 动态参数
 * @return void
 */
+ (void)registerMLinkHandlerWithKey:(nonnull NSString *)key handler:(CallBackMLink)handler;

/**
 * 注册一个默认的mLink handler，当接收到URL，并且所有的mLink key都没有匹配成功，就会调用默认的mLink handler
 * 需要在 AppDelegate 的 didFinishLaunchingWithOptions 中调用
 * @param handler mlink的回调
 * @return void
 */
+ (void)registerMLinkDefaultHandler:(CallBackMLink)handler;

/**
 * 根据不同的URL路由到不同的app展示页
 * 需要在 application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation 中调用
 * @param url 传入上面方法中的openUrl
 *  @return void
 */
+ (void)routeMLink:(nonnull NSURL *)url;

/**
 *  根据universal link路由到不同的app展示页
 *  需要在 application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void(^)(NSArray * __nullable restorableObjects))restorationHandler 中调用
 *  @param userActivity 传入上面方法中的userActivity
 *  @return BOOL
 */
+ (BOOL)continueUserActivity:(nonnull NSUserActivity *)userActivity;

/**
 *  A跳B，B判断是否需要返回A
 *  @return BOOL YES：需要返回，NO：不需要返回
 */
+ (BOOL)callbackEnable;

/**
 *  A跳B，B返回A的时候，调用此方法
 *  @param params 返回A时需要传入的参数
 *  @return BOOL YES：成功返回，NO：失败
 */
+ (BOOL)returnOriginAppWithParams:(nullable NSDictionary *)params;

/**
 *  获取无码邀请中传回来的相关值
 *  @param paramKey，比如:u_id
 *  @return id 返回相应的值
 */
+ (nullable id)getMLinkParam:(nonnull NSString *)paramKey;

@end
