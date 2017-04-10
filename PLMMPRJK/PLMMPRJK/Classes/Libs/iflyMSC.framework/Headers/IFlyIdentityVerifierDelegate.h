//
//  IFlyIdentityVerifierDelegate.h
//  IFlyMSC
//
//  Created by 张剑 on 15/4/22.
//  Copyright (c) 2015年 iflytek. All rights reserved.
//



#import <Foundation/Foundation.h>

@class IFlySpeechError;
@class IFlyIdentityResult;

/**
 *  身份验证功能类回调
 */
@protocol IFlyIdentityVerifierDelegate <NSObject>

/*!
 *  错误回调
 *
 *  @param error 错误描述类
 */
- (void)onError:(IFlySpeechError *)error;

/*!
 *  结果回调
 *
 *  @param results -[out] 结果。
 *  @param isLast  -[out] 是否最后一条结果
 */
- (void)onResults:(IFlyIdentityResult *)results isLast:(BOOL)isLast;

/**
 *  扩展接口，用于抛出音量和vad_eos消息
 *
 *  @param eventType 消息类型
 *  @param arg1      eventType为 Event_volume 时 arg1为音量值
 *  @param arg2      参数2
 *  @param obj       扩展参数
 */
- (void)onEvent:(int)eventType arg1:(int)arg1 arg2:(int)arg2 extra:(id)obj;

@end

