//
//  MobClickGameAnalytics.h
//  Analytics
//
//  Copyright (C) 2010-2014 Umeng.com . All rights reserved.

@interface MobClickGameAnalytics : NSObject

#pragma mark - account function
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

#pragma mark GameLevel methods
///---------------------------------------------------------------------------------------
/// @name  set game level
///---------------------------------------------------------------------------------------

/** 设置玩家的等级.
 */

/** 设置玩家等级属性.
 @param level 玩家等级
 @return void
 */
+ (void)setUserLevelId:(int)level;

///---------------------------------------------------------------------------------------
/// @name  关卡统计
///---------------------------------------------------------------------------------------

/** 记录玩家进入关卡，通过关卡及失败的情况.
 */


/** 进入关卡.
 @param level 关卡
 @return void
 */
+ (void)startLevel:(NSString *)level;

/** 通过关卡.
 @param level 关卡,如果level == nil 则为当前关卡
 @return void
 */
+ (void)finishLevel:(NSString *)level;

/** 未通过关卡.
 @param level 关卡,如果level == nil 则为当前关卡
 @return void
 */

+ (void)failLevel:(NSString *)level;


#pragma mark -
#pragma mark Pay methods

///---------------------------------------------------------------------------------------
/// @name  支付统计
///---------------------------------------------------------------------------------------

/** 记录玩家交易兑换货币的情况
 @param currencyAmount 现金或等价物总额
 @param currencyType 为ISO4217定义的3位字母代码，如CNY,USD等（如使用其它自定义等价物作为现金，可使￼用ISO4217中未定义的3位字母组合传入货币类型）￼
 @param virtualAmount 虚拟币数量
 @param channel 支付渠道
 @param orderId 交易订单ID
 @return void
 */
+ (void)exchange:(NSString *)orderId currencyAmount:(double)currencyAmount currencyType:(NSString *)currencyType virtualCurrencyAmount:(double)virtualAmount paychannel:(int)channel;

/** 玩家支付货币兑换虚拟币.
 @param cash 真实货币数量
 @param source 支付渠道
 @param coin 虚拟币数量
 @return void
 */

+ (void)pay:(double)cash source:(int)source coin:(double)coin;

/** 玩家支付货币购买道具.
 @param cash 真实货币数量
 @param source 支付渠道
 @param item 道具名称
 @param amount 道具数量
 @param price 道具单价
 @return void
 */
+ (void)pay:(double)cash source:(int)source item:(NSString *)item amount:(int)amount price:(double)price;


#pragma mark -
#pragma mark Buy methods

///---------------------------------------------------------------------------------------
/// @name  虚拟币购买统计
///---------------------------------------------------------------------------------------

/** 记录玩家使用虚拟币的消费情况
 */


/** 玩家使用虚拟币购买道具
@param item 道具名称
@param amount 道具数量
@param price 道具单价
@return void
 */
+ (void)buy:(NSString *)item amount:(int)amount price:(double)price;


#pragma mark -
#pragma mark Use methods


///---------------------------------------------------------------------------------------
/// @name  道具消耗统计
///---------------------------------------------------------------------------------------

/** 记录玩家道具消费情况
 */


/** 玩家使用虚拟币购买道具
@param item 道具名称
@param amount 道具数量
@param price 道具单价
@return void
 */

+ (void)use:(NSString *)item amount:(int)amount price:(double)price;


#pragma mark -
#pragma mark Bonus methods


///---------------------------------------------------------------------------------------
/// @name  虚拟币及道具奖励统计
///---------------------------------------------------------------------------------------

/** 记录玩家获赠虚拟币及道具的情况
 */


/** 玩家获虚拟币奖励
@param coin 虚拟币数量
@param source 奖励方式
@return void
 */

+ (void)bonus:(double)coin source:(int)source;

/** 玩家获道具奖励
@param item 道具名称
@param amount 道具数量
@param price 道具单价
@param source 奖励方式
@return void
 */

+ (void)bonus:(NSString *)item amount:(int)amount price:(double)price source:(int)source;

#pragma mark DEPRECATED

//已经被新的setUserLevelId:方法替代，请使用新的API。
+ (void)setUserLevel:(NSString *)level;

//已经被新的active user方法替代，请使用新的API。
+ (void)setUserID:(NSString *)userId sex:(int)sex age:(int)age platform:(NSString *)platform;

@end
