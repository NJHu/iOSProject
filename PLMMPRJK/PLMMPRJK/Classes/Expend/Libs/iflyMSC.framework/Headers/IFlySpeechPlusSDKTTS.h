//
//  IFlySpeechPlusSDKTTS.h
//  IFlySpeechPlusSDK
//
//  Created by 张剑 on 14/12/18.
//  Copyright (c) 2014年 iflytek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IFlySpeechPlusSDKBusiness.h"



/*!
 *  语音+合成接口
 */
@interface IFlySpeechPlusSDKTTS : NSObject

/*!
 *  从语音+获取更多发音人
 *  @return 如果支持SDK版本的语音+已安装，跳转到语音+，返回YES；否则返回NO；
 */
+(BOOL)moreVcn;

/*!
 *  获取本地支持的发音人
 *
 *  数组中的本地发音人是一个包含name(发音人参数，用于设置)和
 *  nickname(发音人昵称，用于界面显示)字段的NSDictionary
 *
 *  @return 本地的发音人数组
 */
+(NSArray*)localVcnList;

/*!
 *  清空本地发音人资源
 *  该操作会清除本地的离线发音人资源
 *
 *  @return 成功返回YES；否则返回NO；
 */
+(BOOL)clearLocalVcns;

/*
 *  功能描述：
 *  1.获取TTS发音人资源列表；
 *  2.检测资源列表文件是否存在；
 *  3.检测资源列表对应的资源文件是否存在；
 *  4.如果1，2，3任意一个不存在，则返回NO；
 *  全部存在返回YES；
 *  返回值：
 *  TTS资源正常：YES；
 *  TTS资源异常：NO；
 */
+(BOOL) checkAllVcnRes;

/**
 *  获取指定发音人的资源路径
 *  路径为MSC要求的格式化路径，包含common和具体发音人
 *
 *  @param vcn 发音人名字
 *
 *  @return 资源路径
 */
+ (NSString *)resPathForVcn:(NSString *)vcn;


/** 返回识别对象的单例
 */
+ (instancetype) sharedInstance;

/** 销毁识别对象的单例
 */
+ (void) purgeSharedInstance;


/** 设置委托对象
 */
@property(nonatomic,assign) id<IFlySpeechPlusSDKBusinessDelegate> delegate ;

@end
