//
//  IFlySpeechUnderstander.h
//  MSC
//
//  Created by iflytek on 2014-03-12.
//  Copyright (c) 2014年 iflytek. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IFlySpeechError;
@protocol IFlySpeechRecognizerDelegate;

/*!
 *  语义理解接口
 */
@interface IFlySpeechUnderstander : NSObject

/*!
 *  是否正在语义理解
 */
@property (readonly)  BOOL isUnderstanding;

/*!
 *  设置委托对象
 */
@property(nonatomic,retain) id<IFlySpeechRecognizerDelegate> delegate ;

/*!
 *  创建语义理解对象的单例
 *
 *  @return 语义理解对象
 */
+(instancetype) sharedInstance;

/*!
 *  开始义理解
 *    同时只能进行一路会话，这次会话没有结束不能进行下一路会话，否则会报错。若有需要多次回话，请在onError回调返回后请求下一路回话。
 *
 *  @return 成功返回YES，失败返回NO
 */
- (BOOL) startListening;

/*!
 *  停止录音
 *    调用此函数会停止录音，并开始进行语义理解
 */
- (void) stopListening;

/*!
 *  取消本次会话
 */
- (void) cancel;

/*
 *  | ------------- |-----------------------------------------------------------
 *  | 参数           | 描述
 *  | ------------- |-----------------------------------------------------------
 *  | domain        |应用的领域: 取值为:iat、search、video、poi、music、asr；
 *  |               |           iat：普通文本听写；
 *  |               |        search：热词搜索；
 *  |               |         video：视频音乐搜索；
 *  |               |           asr：关键词识别;
 *  | ------------- |-----------------------------------------------------------
 *  | vad_bos       |前端点检测: 静音超时时间，即用户多长时间不说话则当做超时处理； 单位：ms；
 *  |               |          engine指定iat识别默认值为5000；
 *  |               |          其他情况默认值为 4000，范围 0-10000。
 *  | ------------- |-----------------------------------------------------------
 *  | vad_eos       |后断点检测: 后端点静音检测时间,即用户停止说话多长时间内即认为不再输入,
 *  |               |          自动停止录音；单位:ms;
 *  |               |          sms 识别默认值为 1800;
 *  |               |          其他默认值为 700，范围 0-10000。
 *  | ------------- |-----------------------------------------------------------
 *  | sample_rate   |采样率:目前支持的采样率设置有 16000 和 8000。
 *  | ------------- |-----------------------------------------------------------
 *  | asr_ptt       |标点符号设置: 默认为 1，当设置为 0 时，将返回无标点符号文本。
 *  | ------------- |-----------------------------------------------------------
 *  | result_type   |返回结果的数据格式: 可设置为json，xml，plain，默认为json。
 *  | ------------- |-----------------------------------------------------------
 *  | grammarID     |识别的语法id: 只针对 domain 设置为”asr”的应用。
 *  | ------------- |-----------------------------------------------------------
 *  | asr_audio_path|音频文件名: 设置此参数后，将会自动保存识别的录音文件。
 *  |               |          路径为Documents/(指定值)。
 *  |               |          不设置或者设置为nil，则不保存音频。
 *  | ------------- |-----------------------------------------------------------
 *  | params        |扩展参数: 对于一些特殊的参数可在此设置，一般用于设置语义。
 *  | ------------- |-----------------------------------------------------------
 *
 */

/*!
 *  设置语义理解引擎的参数
 *    语义理解的引擎参数(key)取值如下：
 *  <table>
 *  <thead>
 *  <tr><th>*参数</th><th><em>描述</em></th>
 *  </tr>
 *  </thead>
 *  <tbody>
 *  <tr><td>domain</td><td>应用的领域: 取值为:iat、search、video、poi、music、asr；<br/>iat：普通文本听写；<br/>search：热词搜索；<br/>video：视频音乐搜索；<br/>video：视频音乐搜索；<br/>asr：关键词识别;</td></tr>
 *  <tr><td>vad_bos</td><td>前端点检测: 静音超时时间，即用户多长时间不说话则当做超时处理； 单位：ms；<br/>engine指定iat识别默认值为5000；<br/>其他情况默认值为 4000，范围 0-10000。</td></tr>
 *  <tr><td>vad_eos</td><td>后断点检测: 后端点静音检测时间,即用户停止说话多长时间内即认为不再输入,<br/>自动停止录音；单位:ms;<br/>sms 识别默认值为 1800;<br/>其他默认值为 700，范围 0-10000。</td></tr>
 *  <tr><td>sample_rate</td><td>采样率:目前支持的采样率设置有 16000 和 8000。</td></tr>
 *  <tr><td>asr_ptt</td><td>标点符号设置: 默认为 1，当设置为 0 时，将返回无标点符号文本。</td></tr>
 *  <tr><td>result_type</td><td>返回结果的数据格式: 可设置为json，xml，plain，默认为json。</td></tr>
 *  <tr><td>grammarID</td><td>识别的语法id: 只针对 domain 设置为”asr”的应用。</td></tr>
 *  <tr><td>asr_audio_path</td><td>音频文件名: 设置此参数后，将会自动保存识别的录音文件。<br/> 路径为Documents/(指定值)。<br/>不设置或者设置为nil，则不保存音频。</td></tr>
 *  <tr><td>params</td><td>扩展参数: 对于一些特殊的参数可在此设置，一般用于设置语义。</td></tr>
 *  </tbody>
 *  </table>
 *  @param value 参数对应的取值
 *  @param key   语义理解引擎参数
 *
 *  @return 成功返回YES；失败返回NO
 */
-(BOOL) setParameter:(NSString *) value forKey:(NSString*)key;

/*!
 *  写入音频流
 *
 *  @param audioData 音频数据
 *
 *  @return 写入成功返回YES，写入失败返回NO
 */
- (BOOL) writeAudio:(NSData *) audioData;

/*!
 *  销毁语义理解对象。
 *
 *  @return 成功返回YES；失败返回NO
 */
- (BOOL) destroy;

@end
