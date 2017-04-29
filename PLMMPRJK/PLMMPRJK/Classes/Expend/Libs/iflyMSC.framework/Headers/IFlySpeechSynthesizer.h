//
//  IFlySpeechSynthesizer.h
//  MSC
//
//  Created by ypzhao on 13-3-21.
//  Copyright (c) 2013年 iflytek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IFlySpeechSynthesizerDelegate.h"

/*!
 *  语音合成
 */
@interface IFlySpeechSynthesizer : NSObject

/*!
 *  设置识别的委托对象
 */
@property(nonatomic,assign) id<IFlySpeechSynthesizerDelegate> delegate;

/*!
 *  返回合成对象的单例
 *
 *  @return 合成对象
 */
+ (instancetype) sharedInstance;

/*!
 *  销毁合成对象。
 *
 *  @return 成功返回YES,失败返回NO.
 */
+ (BOOL) destroy;

/*
 *  | ------------- |-----------------------------------------------------------
 *  | 参数           | 描述
 *  | ------------- |-----------------------------------------------------------
 *  | speed         |合成语速,取值范围 0~100
 *  | ------------- |-----------------------------------------------------------
 *  | volume        |合成的音量,取值范围 0~100
 *  | ------------- |-----------------------------------------------------------
 *  | voice_name    |默认为”xiaoyan”；可以设置的参数列表可参考个性化发音人列表
 *  | ------------- |-----------------------------------------------------------
 *  | sample_rate   |采样率:目前支持的采样率设置有 16000 和 8000。
 *  | ------------- |-----------------------------------------------------------
 *  | tts_audio_path|音频文件名 设置此参数后，将会自动保存合成的音频文件。
 *  |               |路径为Documents/(指定值)。不设置或者设置为nil，则不保存音频。
 *  | ------------- |-----------------------------------------------------------
 *  | params        |扩展参数: 对于一些特殊的参数可在此设置。
 *  | ------------- |-----------------------------------------------------------
 *
 */

/*!
 *  设置合成参数
 *  <table>
 *  <thead>
 *  <tr><th>参数</th><th><em>描述</em></th>
 *  </tr>
 *  </thead>
 *  <tbody>
 *  <tr><td>speed</td><td>合成语速,取值范围 0~100</td></tr>
 *  <tr><td>volume</td><td>合成的音量,取值范围 0~100</td></tr>
 *  <tr><td>voice_name</td><td>默认为”xiaoyan”；可以设置的参数列表可参考个性化发音人列表</td></tr>
 *  <tr><td>sample_rate</td><td>采样率:目前支持的采样率设置有 16000 和 8000。</td></tr>
 *  <tr><td>tts_audio_path</td><td>音频文件名 设置此参数后，将会自动保存合成的音频文件。<br/>路径为Documents/(指定值)。不设置或者设置为nil，则不保存音频。</td></tr>
 *  <tr><td>params</td><td>扩展参数: 对于一些特殊的参数可在此设置。</td></tr>
 *  </tbody>
 *  </table>
 *
 *  @param value 参数取值
 *  @param key   合成参数
 *
 *  @return 设置成功返回YES，失败返回NO
 */
-(BOOL) setParameter:(NSString *) value forKey:(NSString*)key;

/*!
 *  获取合成参数
 *
 *  @param key 参数key
 *
 *  @return 参数值
 */
-(NSString*) parameterForKey:(NSString *)key;

/*!
 *  开始合成(播放)
 *   调用此函数进行合成，如果发生错误会回调错误`onCompleted`
 *
 *  @param text 合成的文本,最大的字节数为1k
 */
- (void) startSpeaking:(NSString *)text;

/*!
 *  开始合成(不播放)
 *    调用此函数进行合成，如果发生错误会回调错误`onCompleted`
 *
 *  @param text 合成的文本,最大的字节数为1k
 *  @param uri  合成后，保存再本地的音频路径
 */
-(void)synthesize:(NSString *)text toUri:(NSString*)uri;

/*!
 *  暂停播放
 *   暂停播放之后，合成不会暂停，仍会继续，如果发生错误则会回调错误`onCompleted`
 */
- (void) pauseSpeaking;

/*!
 *  恢复播放
 */
- (void) resumeSpeaking;

/*!
 *  停止播放并停止合成
 */
- (void) stopSpeaking;

/*!
 *  是否正在播放
 */
@property (nonatomic, readonly) BOOL isSpeaking;

@end
