//
//  WeiboSDK+Statistics.h
//  WeiboSDK
//
//  Created by DannionQiu on 15/4/13.
//  Copyright (c) 2015年 SINA iOS Team. All rights reserved.
//

#import "WeiboSDK.h"

@interface WeiboSDK(Statistics)

/** 设置是否开启统计模式, 默认为NO.
 @param value 为YES, SDK会开启统计功能，记录日志，并在合适的实际传上服务器。
 @return void.
 */
+ (void)setStatisticsEnabled:(BOOL)value;

#pragma mark - Optional Configs Setting
/** 设置是否打印SDK的log信息, 默认NO(不打印log).
 @param value 设置为YES, WeiboSDK 会输出log信息可供调试参考. 除非特殊需要，否则发布产品时需改回NO.
 @return void.
 */
+ (void)setStatisticsLogEnabled:(BOOL)value;

/** 设置版本信息.
 @param version 版本号，为nil或@""时, 默认为Build号(CFBundleVersion)
 @return void.
 */
+ (void)setVersion:(NSString*)version;

/** 设置渠道信息.
 @param channelID 渠道名称, 为nil或@""时, 默认为@"AppStore"渠道
 @return void.
 */
+ (void)setChannelID:(NSString*)channelID;

/** 设定日志上传的发送间隔
 @param frequecy 单位为秒，最小30秒，最大8*60*60秒(8小时)。默认为180秒(3分钟)
 @return void.
 */
+ (void)setUploadFrequecy:(NSTimeInterval)frequecy;

#pragma mark - Statistics Api
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


/** 自动事件时长统计, 开始记录某个事示时长.
 使用方法：调用event:函数来完成自动统计。
 @param eventID 统计的事件标识符.
 @warning eventID不能使用空格和特殊字符，且长度不能超过255个字符（否则将截取前255个字符）
 */
+ (void)event:(NSString *)eventID;

/** 自动事件时长统计, 开始记录某个事示时长.
 使用方法：调用event:函数来完成自动统计。
 @param eventID 统计的事件标识符.
 @param pageName 事件发生时所在页面.
 @param userInfo 事件相关信息.
 @return void.
 
 @warning 每个event的userInfo不能超过10个
 eventID、pageName、userInfo中key和value都不能使用空格和特殊字符，且长度不能超过255个字符（否则将截取前255个字符）
 */
+ (void)event:(NSString *)eventID onPageView:(NSString*)pageName withUserInfo:(NSDictionary*)userInfo;

/** 强制日志上传
 调用后，若距离上次成功上传日志时间不小于30秒，立刻上传日志。
 */
+ (void)forceUploadRecords;




@end
