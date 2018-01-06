//
//  IFlySpeechEvent.h
//  MSCDemo
//
//  Created by admin on 14-8-12.
//  Copyright (c) 2014年 iflytek. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 *  事件类型
 */
typedef NS_ENUM(NSUInteger,IFlySpeechEventType){
    /*!
     *  网络状态消息 
     *  在消息到达时,可通过onEvent的第2个参数arg1,获取当前网络连接状态值
     */
    IFlySpeechEventTypeNetPref = 10001,
    /**
     * 转写音频文件消息
     * 在录音模式下，成功创建音频文件时返回。可通过onEvent
     * 第4个参数data 指定Key为[IFlySpeechConstant IST_AUDIO_PATH],获取音频文件绝对路径.
     * 或通过[IFlySpeechTranscripter getParameter:[IFlySpeechConstant IST_AUDIO_PATH]],
     * 获取音频文件绝对路径.
     */
    IFlySpeechEventTypeISTAudioFile = 10004,
    /**
     * 转写已上传字节消息
     * 在消息到达时,通过onEvent
     * 的第二个参数arg1,获取已确认上传到服务器的字节数.
     * 若当前音频源为非写音频模式,还可通过onEvent
     * 的第三个参数arg2,获取当前所有音频的字节大小.录音模式时，由于所有音频字节大小会变。
     * 当停止音频输入后（等待录音时间超时
     * [IFlySpeechConstant SPEECH_TIMEOUT]
     * ，或调用[IFlySpeechTranscripter stopTranscripting]），
     * 且服务器收到所有音频时，第四个参数data，将包含完成标记的布尔值(true)，可通过data调用
     * 指定KEY为KCIFlySpeechEventKeyISTUploadComplete获取。
     * 此消息可能多次返回.
     */
    IFlySpeechEventTypeISTUploadBytes = 10006,
    
    /**
     * 转写缓存剩余
     * 此消息仅在音频源为-1时需要关注
     * 在调用[IFlySpeechTranscripter writeAudio]写音频时，应该关注此事件。
     * 此事件在调用写音频接口、及音频最后被写入底库库时分别回调一次。当事件回调时，通过onEvent
     * 的第二个参数arg1,获取当前剩余的缓存大小，当缓存小于要写入的音频时，应该先暂停写音频数据，直到下次缓存大小大于要写入的音频时.
     * 最大缓存为128KByte。
     */
    IFlySpeechEventTypeISTCacheLeft = 10007,
    
    /**
     * 转写结果等待时间消息
     * 在消息到达时,通过 onEvent
     * 的第二个参数arg1,获取当前结果需要的时间.
     * 此消息可能多次返回，返回时间不定，且不一定会返回.
     */
    IFlySpeechEventTypeISTResultTime= 10008,
    
    /**
     * 转写转写音频同步ID消息
     * 在消息到达时,通过 onEvent
     * 的第二个参数arg1,获取当前写音频同步ID.
     * 此消息可能多次返回.
     */
    IFlySpeechEventTypeISTSyncID= 10009,
    
    /**
     * 会话开始消息
     * 在会话开始成功后返回
     */
    IFlySpeechEventTypeSessionBegin = 10010,
    
    /**
     * 会话结束消息
     * 在会话结束前返回
     */
    IFlySpeechEventTypeSessionEnd = 10011,
    
    /**
     * 音量消息，在得到音量时抛出，暂时只有身份验证的声纹业务用到
     */
    IFlySpeechEventTypeVolume = 10012,
    
    /**
     * VAD后端点消息，在检测到VAD后端点时抛出，暂时只有身份验证的声纹业务用到
     */
    IFlySpeechEventTypeVadEOS = 10013,
    
    /*!
     *  服务端会话id
     *  在消息到达时,可通过onEvent的第4个参数data(字典类型)，
     *  指定key KCIFlySpeechEventKeySessionID,获取服务端会话id.
     */
    IFlySpeechEventTypeSessionID = 20001,
    
    /*!
     *  TTS合成数据消息 
     * -(void)onEvent:(int)eventType arg0:(int)arg0 arg1:(int)arg1 data:(NSData *)eventData 
     * 其中eventData中包含数据 
     *
     */
    IFlySpeechEventTypeTTSBuffer = 21001,
    
    /*!
     *  通知cancel方法被调用的回调
     *
     */
    IFlySpeechEventTypeTTSCancel = 21002,
    
    /*!
     *  IVW onshot 听写 or 识别结果
     * 在消息到达时,第2个参数arg1包含是否为最后一个结果:1为是,0为否;
     * 第4个参数data中包含数据，通过指定KEY为KCIFlySpeechEventKeyIVWResult获取.
     */
    IFlySpeechEventTypeIVWResult = 22001,
    
    /*!
     * 开始处理录音数据
     * 
     */
    IFlySpeechEventTypeSpeechStart= 22002,
    
    /*!
     * 录音停止
     * 
     */
    IFlySpeechEventTypeRecordStop= 22003,
    
    /*!
     *  服务端音频url
     *  在消息到达时,
     * 第4个参数data,包含数据,通过
     * 指定KEY为KCIFlySpeechEventKeyAudioUrl获取.
     */
    IFlySpeechEventTypeAudioUrl = 23001,
    
    /*!
     *  变声数据结果返回
     *
     * 设置voice_change参数获取结果.
     */
    IFlySpeechEventTypeVoiceChangeResult = 24001

};

#pragma mark - keys for event data

/**
 *  转写是否已上传完标记key
 */
extern NSString* const KCIFlySpeechEventKeyISTUploadComplete;

/**
 *  服务端会话key
 */
extern NSString* const KCIFlySpeechEventKeySessionID;
/**
 *  TTS取音频数据key
 */
extern NSString* const KCIFlySpeechEventKeyTTSBuffer;
/**
 *  IVW oneshot 听写 or 识别结果 key
 */
extern NSString* const KCIFlySpeechEventKeyIVWResult;
/**
 *  服务端音频url key
 */
extern NSString* const KCIFlySpeechEventKeyAudioUrl;

