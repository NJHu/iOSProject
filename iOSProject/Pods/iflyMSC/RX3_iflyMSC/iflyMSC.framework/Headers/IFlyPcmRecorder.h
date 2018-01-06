//
//  IFlyPcmRecorder.h
//  MSC

//  description:

//  Created by ypzhao on 12-11-15.
//  Copyright (c) 2012年 iflytek. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AudioToolbox/AudioQueue.h>
#import <AudioToolbox/AudioFile.h>
#import <AudioToolbox/AudioServices.h>
#import <AudioToolbox/AudioConverter.h>
#import <AVFoundation/AVAudioSession.h>


@class IFlyPcmRecorder;

/**
 *  录音协议
 */
@protocol IFlyPcmRecorderDelegate<NSObject>

/**
 *  回调音频数据
 *
 *  @param buffer 音频数据
 *  @param size   表示音频的长度
 */
- (void) onIFlyRecorderBuffer: (const void *)buffer bufferSize:(int)size;

/**
 *  回调音频的错误码
 *
 *  @param recoder 录音器
 *  @param error   错误码
 */
- (void) onIFlyRecorderError:(IFlyPcmRecorder*)recoder theError:(int) error;

@optional

/**
 *  回调录音音量
 *
 *  @param power 音量值
 */
- (void) onIFlyRecorderVolumeChanged:(int) power;

@end


/**
 *  录音封装
 */
@interface IFlyPcmRecorder : NSObject<AVAudioSessionDelegate>

/**
 *  录音委托对象
 */
@property (assign) id<IFlyPcmRecorderDelegate> delegate;

/**
 *  单例模式
 *
 *  @return 返回录音对象单例
 */
+ (id) sharedInstance;

/**
 *  开始录音
 *
 *  @return  开启录音成功返回YES，否则返回NO
 */
- (BOOL) start;

/**
 *  停止录音
 */
- (void) stop;

/**
 *  设置音频采样率
 *
 *  @param rate -[in] 采样率，8k/16k
 */
- (void) setSample:(NSString *) rate;

/*
 * 设置录音时间间隔参数
 */
- (void) setPowerCycle:(float) cycle;

/**
 *  保存录音
 *
 *  @param savePath 音频保存路径
 */
-(void) setSaveAudioPath:(NSString *)savePath;

@end

