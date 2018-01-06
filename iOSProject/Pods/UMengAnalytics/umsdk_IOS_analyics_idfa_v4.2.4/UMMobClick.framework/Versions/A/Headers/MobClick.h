//
//  MobClick.h
//  Analytics
//
//  Copyright (C) 2010-2016 Umeng.com . All rights reserved.

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#define XcodeAppVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
typedef void(^CallbackBlock)();

/**
  REALTIME只在“集成测试”设备的DEBUG模式下有效，其它情况下的REALTIME会改为使用BATCH策略。
 */
typedef enum {
    REALTIME = 0,       //实时发送              (只在“集成测试”设备的DEBUG模式下有效)
    BATCH = 1,          //启动发送
    SEND_INTERVAL = 6,  //最小间隔发送           ([90-86400]s, default 90s)
    SMART_POLICY = 8,
} ReportPolicy;

/**
 统计的场景类别，默认为普通统计；若使用游戏统计API，则需选择游戏场景类别，如E_UM_GAME。
 */
typedef NS_ENUM (NSUInteger, eScenarioType)
{
    E_UM_NORMAL = 0,    // default value
    E_UM_GAME = 1,      // game
};

/** @brief 统计SDK的配置实例，具体参照该类成员的参数定义
 * 示例代码: UMConfigInstance.appKey = @"xxxxxxxxxxxxxx...";
 *         UMConfigInstance.token = @"yyyyyyyy....";
 *         [MobClick startWithConfigure:UMConfigInstance];
 */
#define UMConfigInstance [UMAnalyticsConfig sharedInstance]
@interface UMAnalyticsConfig : NSObject
/** required:  appkey string */
@property(nonatomic, copy) NSString *appKey;
/** optional:  default: nil*/
@property(nonatomic, copy) NSString *secret;
/** optional:  default: "App Store"*/
@property(nonatomic, copy) NSString *channelId;
/** optional:  default: YES */
@property(nonatomic) BOOL  bCrashReportEnabled;
/** optional:  default: BATCH */
@property(nonatomic) ReportPolicy   ePolicy;
/** optional:  default: E_UM_NORMAL */
@property(nonatomic) eScenarioType  eSType;

+ (instancetype)sharedInstance;
@end

@class CLLocation;
@interface MobClick : NSObject <UIAlertViewDelegate>

#pragma mark basics
///---------------------------------------------------------------------------------------
/// @name  初始化统计
///---------------------------------------------------------------------------------------

/** 初始化友盟统计模块
 @param UMAnalyticsConfig 实例类，具体参照该类成员的参数定义
 @return void
 */
+ (void) startWithConfigure:(UMAnalyticsConfig *)configure;

///---------------------------------------------------------------------------------------
/// @name  设置
///---------------------------------------------------------------------------------------

/** 设置app版本号。由于历史原因需要和xcode3工程兼容,友盟提取的是Build号(CFBundleVersion)，
    如果需要和App Store上的版本一致,请调用此方法。
 @param appVersion 版本号，例如设置成`XcodeAppVersion`.
 @return void.
*/
+ (void)setAppVersion:(NSString *)appVersion;

/** 开启CrashReport收集, 默认YES(开启状态).
 @param value 设置为NO,可关闭友盟CrashReport收集功能.
 @return void.
*/
+ (void)setCrashReportEnabled:(BOOL)value;

/** 设置是否打印sdk的log信息, 默认NO(不打印log).
 @param value 设置为YES,umeng SDK 会输出log信息可供调试参考. 除非特殊需要，否则发布产品时需改回NO.
 @return void.
 */
+ (void)setLogEnabled:(BOOL)value;

/** 设置是否对日志信息进行加密, 默认NO(不加密).
 @param value 设置为YES, umeng SDK 会将日志信息做加密处理
 @return void.
 */
+ (void)setEncryptEnabled:(BOOL)value;

/** 当reportPolicy == SEND_INTERVAL 时设定log发送间隔
 @param second 单位为秒,最小90秒,最大86400秒(24hour).
 @return void.
*/
+ (void)setLogSendInterval:(double)second;



#pragma mark event logs
///---------------------------------------------------------------------------------------
/// @name  页面计时
///---------------------------------------------------------------------------------------

/** 手动页面时长统计, 记录某个页面展示的时长.
 @param pageName 统计的页面名称.
 @param seconds 单位为秒，int型.
 @return void.
 */
+ (void)logPageView:(NSString *)pageName seconds:(int)seconds;

/** 自动页面时长统计, 开始记录某个页面展示时长.
 使用方法：必须配对调用beginLogPageView:和endLogPageView:两个函数来完成自动统计，若只调用某一个函数不会生成有效数据。
 在该页面展示时调用beginLogPageView:，当退出该页面时调用endLogPageView:
 @param pageName 统计的页面名称.
 @return void.
 */
+ (void)beginLogPageView:(NSString *)pageName;

/** 自动页面时长统计, 结束记录某个页面展示时长.
 使用方法：必须配对调用beginLogPageView:和endLogPageView:两个函数来完成自动统计，若只调用某一个函数不会生成有效数据。
 在该页面展示时调用beginLogPageView:，当退出该页面时调用endLogPageView:
 @param pageName 统计的页面名称.
 @return void.
 */
+ (void)endLogPageView:(NSString *)pageName;


///---------------------------------------------------------------------------------------
/// @name  事件统计
///---------------------------------------------------------------------------------------
/** 结构化事件
 使用前，请先到友盟App管理后台的设置->编辑自定义事件 中添加相应的事件ID。
 
 @param  keyPath 字符串数组代表的结构化事件路径，其长度最大为8，不能使用unicode 48以内的字符，keyPath[0]必须在网站注册事件ID.
 @param  value 事件的数值
 @param  (optional) label 标签
 @return void.
 */
+ (void)event:(NSArray *)keyPath value:(int)value label:(NSString *)label;

/** 自定义事件,数量统计.
使用前，请先到友盟App管理后台的设置->编辑自定义事件 中添加相应的事件ID，然后在工程中传入相应的事件ID
 
 @param  eventId 网站上注册的事件Id.
 @param  label 分类标签。不同的标签会分别进行统计，方便同一事件的不同标签的对比,为nil或空字符串时后台会生成和eventId同名的标签.
 @param  accumulation 累加值。为减少网络交互，可以自行对某一事件ID的某一分类标签进行累加，再传入次数作为参数。
 @return void.
 */
+ (void)event:(NSString *)eventId; //等同于 event:eventId label:eventId;
/** 自定义事件,数量统计.
 使用前，请先到友盟App管理后台的设置->编辑自定义事件 中添加相应的事件ID，然后在工程中传入相应的事件ID
 */
+ (void)event:(NSString *)eventId label:(NSString *)label; // label为nil或@""时，等同于 event:eventId label:eventId;

/** 自定义事件,数量统计.
 使用前，请先到友盟App管理后台的设置->编辑自定义事件 中添加相应的事件ID，然后在工程中传入相应的事件ID
 */
+ (void)event:(NSString *)eventId attributes:(NSDictionary *)attributes;

+ (void)event:(NSString *)eventId attributes:(NSDictionary *)attributes counter:(int)number;

/** 自定义事件,时长统计.
    使用前，请先到友盟App管理后台的设置->编辑自定义事件 中添加相应的事件ID，然后在工程中传入相应的事件ID.
    beginEvent,endEvent要配对使用,也可以自己计时后通过durations参数传递进来
 
 @param  eventId 网站上注册的事件Id.
 @param  label 分类标签。不同的标签会分别进行统计，方便同一事件的不同标签的对比,为nil或空字符串时后台会生成和eventId同名的标签.
 @param  primarykey 这个参数用于和event_id一起标示一个唯一事件，并不会被统计；对于同一个事件在beginEvent和endEvent 中要传递相同的eventId 和 primarykey
 @param millisecond 自己计时需要的话需要传毫秒进来
 @return void.
 
 @warning 每个event的attributes不能超过10个
    eventId、attributes中key和value都不能使用空格和特殊字符，必须是NSString,且长度不能超过255个字符（否则将截取前255个字符）
    id， ts， du是保留字段，不能作为eventId及key的名称
*/
+ (void)beginEvent:(NSString *)eventId;

/** 自定义事件,时长统计.
 使用前，请先到友盟App管理后台的设置->编辑自定义事件 中添加相应的事件ID，然后在工程中传入相应的事件ID.
 */

+ (void)endEvent:(NSString *)eventId;
/** 自定义事件,时长统计.
 使用前，请先到友盟App管理后台的设置->编辑自定义事件 中添加相应的事件ID，然后在工程中传入相应的事件ID.
 */

+ (void)beginEvent:(NSString *)eventId label:(NSString *)label;
/** 自定义事件,时长统计.
 使用前，请先到友盟App管理后台的设置->编辑自定义事件 中添加相应的事件ID，然后在工程中传入相应的事件ID.
 */

+ (void)endEvent:(NSString *)eventId label:(NSString *)label;
/** 自定义事件,时长统计.
 使用前，请先到友盟App管理后台的设置->编辑自定义事件 中添加相应的事件ID，然后在工程中传入相应的事件ID.
 */

+ (void)beginEvent:(NSString *)eventId primarykey :(NSString *)keyName attributes:(NSDictionary *)attributes;
/** 自定义事件,时长统计.
 使用前，请先到友盟App管理后台的设置->编辑自定义事件 中添加相应的事件ID，然后在工程中传入相应的事件ID.
 */

+ (void)endEvent:(NSString *)eventId primarykey:(NSString *)keyName;
/** 自定义事件,时长统计.
 使用前，请先到友盟App管理后台的设置->编辑自定义事件 中添加相应的事件ID，然后在工程中传入相应的事件ID.
 */

+ (void)event:(NSString *)eventId durations:(int)millisecond;
/** 自定义事件,时长统计.
 使用前，请先到友盟App管理后台的设置->编辑自定义事件 中添加相应的事件ID，然后在工程中传入相应的事件ID.
 */

+ (void)event:(NSString *)eventId label:(NSString *)label durations:(int)millisecond;
/** 自定义事件,时长统计.
 使用前，请先到友盟App管理后台的设置->编辑自定义事件 中添加相应的事件ID，然后在工程中传入相应的事件ID.
 */
+ (void)event:(NSString *)eventId attributes:(NSDictionary *)attributes durations:(int)millisecond;


#pragma mark - user methods
/** active user sign-in.
 使用sign-In函数后，如果结束该PUID的统计，需要调用sign-Off函数
 @param puid : user's ID
 @param provider : 不能以下划线"_"开头，使用大写字母和数字标识; 如果是上市公司，建议使用股票代码。
 @return void.
 */
+ (void)profileSignInWithPUID:(NSString *)puid;
+ (void)profileSignInWithPUID:(NSString *)puid provider:(NSString *)provider;

/** active user sign-off.
 停止sign-in PUID的统计
 @return void.
 */
+ (void)profileSignOff;

///---------------------------------------------------------------------------------------
/// @name 地理位置设置
/// 需要链接 CoreLocation.framework 并且 #import <CoreLocation/CoreLocation.h>
///---------------------------------------------------------------------------------------

/** 设置经纬度信息
 @param latitude 纬度.
 @param longitude 经度.
 @return void
 */
+ (void)setLatitude:(double)latitude longitude:(double)longitude;

/** 设置经纬度信息
 @param location CLLocation 经纬度信息
 @return void
 */
+ (void)setLocation:(CLLocation *)location;

///---------------------------------------------------------------------------------------
/// @name Utility函数
///---------------------------------------------------------------------------------------

/** 判断设备是否越狱，依据是否存在apt和Cydia.app
 */
+ (BOOL)isJailbroken;

/** 判断App是否被破解
 */
+ (BOOL)isPirated;

#pragma mark DEPRECATED
/** 友盟模块启动
 [MobClick startWithConfigure:]通常在application:didFinishLaunchingWithOptions:里被调用监听App启动和退出事件，
 如果开发者无法在此处添加友盟的[MobClick startWithConfigure:]方法，App的启动事件可能会无法监听，此时需要手动调用[MobClick startSession:nil]来启动友盟的session。
 上述情况通常发生在某些第三方框架生成的app里，普通app不用关注该API.
 */
+ (void)startSession:(NSNotification *)notification;

+ (void)setCrashCBBlock:(CallbackBlock)cbBlock;
@end
