
//
//  IFlyVoiceWakeuperDel.h
//  wakeup
//
//  Created by admin on 14-3-18.
//  Copyright (c) 2014年 iflytek. All rights reserved.
//



#import <Foundation/Foundation.h>

@class IFlySpeechError;

/**
 *  代理返回时序描述
 
   onError 为唤醒会话错误反馈
   onBeginOfSpeech 表示录音开始
   onVolumeChanged 录音音量大小
   onEndOfSpeech 录音结束，当服务终止时返回onEndOfSpeech
   onResult 服务结果反馈，内容定义如下
 
 *  唤醒服务
 
    例：
    focus_type = wake   唤醒会话
    wakeup_result_id = 0    唤醒词位置
    wakeup_result_Score = 60    唤醒词可信度
 
 *  注册服务
 
    例：
    focus_type = enroll 注册会话
    enroll_success_num = 1  当前注册成功次数
    current_enroll_status = success/failed  当前会话是否成功
    wakeup_result_Score = 60    注册结果可信度
    threshold = 10  当注册达到3次后，反馈对应资源的阀值
 */
@protocol IFlyVoiceWakeuperDelegate <NSObject>

@optional

/**
 录音开始
 */
-(void) onBeginOfSpeech;

/**
 录音结束
 */
-(void) onEndOfSpeech;

/**
 会话错误
 @param errorCode 错误描述类，
*/
- (void) onError:(IFlySpeechError *) error;

/**
 唤醒
 resultID:唤醒词位置
 */
-(void) onResult:(NSMutableDictionary *)resultArray;

/**
 音量反馈，返回频率与录音数据返回回调频率一致
 volume:音量值
 */
- (void) onVolumeChanged: (int)volume;


/** 扩展事件回调
 
 根据事件类型返回额外的数据
 
 @param eventType 事件类型，具体参见IFlySpeechEvent枚举。
 
 */
- (void) onEvent:(int)eventType isLast:(BOOL)isLast arg1:(int)arg1 data:(NSMutableDictionary *)eventData;

@end

