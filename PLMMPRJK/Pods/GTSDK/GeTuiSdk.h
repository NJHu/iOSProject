//
//  GeTuiSdk.h
//  GeTuiSdk
//
//  Created by gexin on 15-5-5.
//  Copyright (c) 2015年 Gexin Interactive (Beijing) Network Technology Co.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    SdkStatusStarting, // 正在启动
    SdkStatusStarted,  // 启动
    SdkStatusStoped    // 停止
} SdkStatus;

#define kGtResponseBindType @"bindAlias"
#define kGtResponseUnBindType @"unbindAlias"

@protocol GeTuiSdkDelegate;

@interface GeTuiSdk : NSObject

#pragma mark - 基本功能

/**
 *  启动个推SDK
 *
 *  @param appid     设置app的个推appId，此appId从个推网站获取
 *  @param appKey    设置app的个推appKey，此appKey从个推网站获取
 *  @param appSecret 设置app的个推appSecret，此appSecret从个推网站获取
 *  @param delegate  回调代理delegate
 */
+ (void)startSdkWithAppId:(NSString *)appid appKey:(NSString *)appKey appSecret:(NSString *)appSecret delegate:(id<GeTuiSdkDelegate>)delegate;

/**
 *  销毁SDK，并且释放资源
 */
+ (void)destroy;

/**
 *  恢复SDK运行,IOS7 以后支持Background Fetch方式，后台定期更新数据,该接口需要在Fetch起来后被调用，保证SDK 数据获取。
 */
+ (void)resume;

#pragma mark -

/**
 *  获取SDK版本号
 *
 *  @return 版本值
 */
+ (NSString *)version;

/**
 *  获取SDK的Cid
 *
 *  @return Cid值
 */
+ (NSString *)clientId;

/**
 *  获取SDK运行状态
 *
 *  @return 运行状态
 */
+ (SdkStatus)status;

#pragma mark -

/**
 *  是否允许SDK 后台运行（默认值：NO）
 *  备注：可以未启动SDK就调用该方法
 *  警告：该功能会和音乐播放冲突，使用时请注意
 *
 *  @param isEnable 支持当APP进入后台后，个推是否运行,YES.允许
 */
+ (void)runBackgroundEnable:(BOOL)isEnable;

/**
 *  地理围栏功能，设置地理围栏是否运行
 *  备注：SDK可以未启动就调用该方法
 *
 *  @param isEnable 设置地理围栏功能是否运行（默认值：NO）
 *  @param isVerify 设置是否SDK主动弹出用户定位请求（默认值：NO）
 */
+ (void)lbsLocationEnable:(BOOL)isEnable andUserVerify:(BOOL)isVerify;

#pragma mark -

/**
 *  设置渠道
 *  备注：SDK可以未启动就调用该方法
 *
 *  SDK-1.5.0+
 *
 *  @param aChannelId 渠道值，可以为空值
 */
+ (void)setChannelId:(NSString *)aChannelId;

/**
 *  向个推服务器注册DeviceToken
 *  备注：可以未启动SDK就调用该方法
 *
 *  @param deviceToken 推送时使用的deviceToken
 *
 */
+ (void)registerDeviceToken:(NSString *)deviceToken;

/**
 *  绑定别名功能:后台可以根据别名进行推送
 *
 *  @param alias 别名字符串
 *  @param aSn   绑定序列码, 不为nil
 */
+ (void)bindAlias:(NSString *)alias andSequenceNum:(NSString *)aSn;

/**
 *  取消绑定别名功能
 *
 *  @param alias 别名字符串
 *  @param aSn   绑定序列码, 不为nil
 */
+ (void)unbindAlias:(NSString *)alias andSequenceNum:(NSString *)aSn;

/**
 *  给用户打标签 , 后台可以根据标签进行推送
 *
 *  @param tags 别名数组
 *
 *  @return 提交结果，YES表示尝试提交成功，NO表示尝试提交失败
 */
+ (BOOL)setTags:(NSArray *)tags;

/**
 *  设置关闭推送模式（默认值：NO）
 *
 *  @param isValue 消息推送开发，YES.关闭消息推送 NO.开启消息推送
 *
 *  SDK-1.2.1+
 *
 */
+ (void)setPushModeForOff:(BOOL)isValue;

/**
 *  同步角标值到个推服务器
 *  该方法只是同步角标值到个推服务器，本地仍须调用setApplicationIconBadgeNumber函数
 *
 *  SDK-1.4.0+
 *
 *  @param value 角标数值
 */
+ (void)setBadge:(NSUInteger)value;

/**
 *  复位角标，等同于"setBadge:0"
 *
 *  SDK-1.4.0+
 *
 */
+ (void)resetBadge;

#pragma mark -

/**
 *  远程推送消息处理
 *
 *  @param userInfo 远程推送消息
 */
+ (void)handleRemoteNotification:(NSDictionary *)userInfo;

/**
 *  SDK发送上行消息结果
 *
 *  @param body  需要发送的消息数据
 *  @param error 如果发送成功返回messageid，发送失败返回nil
 *
 *  @return 消息的msgId
 */
+ (NSString *)sendMessage:(NSData *)body error:(NSError **)error;

/**
 *  上行第三方自定义回执actionid
 *
 *  @param actionId 用户自定义的actionid，int类型，取值90001-90999。
 *  @param taskId   下发任务的任务ID
 *  @param msgId    下发任务的消息ID
 *
 *  @return BOOL，YES表示尝试提交成功，NO表示尝试提交失败。注：该结果不代表服务器收到该条数据
 *  该方法需要在回调方法“GeTuiSdkDidReceivePayload:andTaskId:andMessageId:andOffLine:fromApplication:”使用
 */
+ (BOOL)sendFeedbackMessage:(NSInteger)actionId andTaskId:(NSString *)taskId andMsgId:(NSString *)msgId;

/**
 *  清空下拉通知栏全部通知,并将角标置“0”，不显示角标
 */
+ (void)clearAllNotificationForNotificationBar;

@end

#pragma mark - SDK Delegate
@protocol GeTuiSdkDelegate <NSObject>

@optional

/**
 *  SDK登入成功返回clientId
 *
 *  @param clientId 标识用户的clientId
 *  说明:启动GeTuiSdk后，SDK会自动向个推服务器注册SDK，当成功注册时，SDK通知应用注册成功。
 *  注意: 注册成功仅表示推送通道建立，如果appid/appkey/appSecret等验证不通过，依然无法接收到推送消息，请确保验证信息正确。
 */
- (void)GeTuiSdkDidRegisterClient:(NSString *)clientId;

/**
 *  SDK通知收到个推推送的透传消息
 *
 *  @param payloadData 推送消息内容
 *  @param taskId      推送消息的任务id
 *  @param msgId       推送消息的messageid
 *  @param offLine     是否是离线消息，YES.是离线消息
 *  @param appId       应用的appId
 */
- (void)GeTuiSdkDidReceivePayloadData:(NSData *)payloadData andTaskId:(NSString *)taskId andMsgId:(NSString *)msgId andOffLine:(BOOL)offLine fromGtAppId:(NSString *)appId;

/**
 *  SDK通知发送上行消息结果，收到sendMessage消息回调
 *
 *  @param messageId “sendMessage:error:”返回的id
 *  @param result    成功返回1, 失败返回0
 *  说明: 当调用sendMessage:error:接口时，消息推送到个推服务器，服务器通过该接口通知sdk到达结果，result为 1 说明消息发送成功
 *  注意: 需第三方服务器接入个推,SendMessage 到达第三方服务器后返回 1
 */
- (void)GeTuiSdkDidSendMessage:(NSString *)messageId result:(int)result;

/**
 *  SDK遇到错误消息返回error
 *
 *  @param error SDK内部发生错误，通知第三方，返回错误
 */
- (void)GeTuiSdkDidOccurError:(NSError *)error;

/**
 *  SDK运行状态通知
 *
 *  @param aStatus 返回SDK运行状态
 */
- (void)GeTuiSDkDidNotifySdkState:(SdkStatus)aStatus;

/**
 *  SDK设置关闭推送模式回调
 *
 *  @param isModeOff 关闭模式，YES.服务器关闭推送功能 NO.服务器开启推送功能
 *  @param error     错误回调，返回设置时的错误信息
 */
- (void)GeTuiSdkDidSetPushMode:(BOOL)isModeOff error:(NSError *)error;

/**
 *  SDK绑定、解绑回调
 *
 *  @param action       回调动作类型 kGtResponseBindType 或 kGtResponseUnBindType
 *  @param isSuccess    成功返回 YES, 失败返回 NO
 *  @param aSn          返回请求的序列码
 *  @param aError       成功返回nil, 错误返回相应error信息
 */
- (void)GeTuiSdkDidAliasAction:(NSString *)action result:(BOOL)isSuccess sequenceNum:(NSString *)aSn error:(NSError *)aError;

@end
