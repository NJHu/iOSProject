//
//  IFlyISVDelegate.h
//  msc_UI
//
//  Created by admin on 14-9-15.
//  Copyright (c) 2014年 iflytek. All rights reserved.
//


#import <Foundation/Foundation.h>

@class IFlySpeechError;

/**
 *  声纹回调协议
 */
@protocol IFlyISVDelegate

/**
 *  声纹结果回调
 *
 *  @param dic 结果
 */
-(void) onResult:(NSDictionary *)dic;

/**
 *  错误码回调
 *
 *  @param errorCode 错误码
 */
-(void) onError:(IFlySpeechError *) errorCode;

@optional

/**
 *  等待结果
 */
-(void) onRecognition;

/**
 *  音量改变回调
 *
 *  @param volume 音量值
 */
-(void) onVolumeChanged: (int)volume;

@end

