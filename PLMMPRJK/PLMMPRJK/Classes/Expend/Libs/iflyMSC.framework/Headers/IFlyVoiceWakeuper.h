//
//  IFlyVoiceWakeuper.h
//  wakeup
//
//  Created by admin on 14-3-18.
//  Copyright (c) 2014年 iflytek. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "IFlyVoiceWakeuperDelegate.h"

/**
 
  版本描述：唤醒1.0.0.1
 
  语音唤醒资源占用（iPhone5s实测）
  内存占用：3M
  CPU占用：< 12%
 
 
  唤醒服务接口时序描述
 
  sharedInstance 创建唤醒实例
  setParameter 设置服务参数
 
    例：[_voiceWakeuper setParameter:@"wake" forKey:@"sst"];
        sst 表示服务类型，wake是唤醒，enroll是注册
 
    例：[_voiceWakeuper setParameter:@"m_wakeupResPath" forKey:@"ivw_wake_list"];
        ivw_wake_list 表示唤醒资源的路径
 
    例：[_voiceWakeuper setParameter:@"holdValue" forKey:@"ivw_threshold"];
        ivw_threshold 表示唤醒资源的阀值，holdValue形式：
            ID：20；15；30
            每个数字代表对应资源的阀值，15表示资源1阀值，20表示资源2阀值，30表示资源3阀值
            本demo只有一个资源设置为ID：20 则可
 
  startListening启动服务
  stopListening 取消服务，但是不释放内部资源
  cancel 终止服务，并释放内部资源

 
 *参数定义

 * 服务设置参数
  sst=wake表示唤醒
  sst=enroll表示注册
     SESSION_TYPE                @"sst"    //服务类型
 
     WAKEUP                  @"wake"             //唤醒
     ENROLL                  @"enroll"           //注册
 
 * 唤醒时，表示资源对应的阀值，为输入值，参数类型为：ID:20;20;3
       已ID为起始，中间用“;”隔开，表示公三个资源，各自阀值对应为20，20和3
     IVW_THRESHOLD           @"ivw_threshold"    //唤醒词对应的门限

 
 * 传入参数
  主要是没有定义的参数，依赖params传入
     PARAM                   @"params"


 * 训练，合并生成的资源路径
 
  例：ivw_word_path=/abc/123/newpath.irf
     IVW_WORD_PATH               @"ivw_word_path"



 * 业务成功后的会话持续状态
    keep_alive 0:唤醒一次就结束，1：唤醒后继续
     KEEP_ALIVE              @"keep_alive"


 * focus_type注册和唤醒的返回参数
  wake 唤醒
  enroll 注册
     FOCUS_TYPE              @"focus_type"       //服务类型


 * 服务状态
  status=success 服务正常
  status=failed 服务失败
  status=done 注册完成
     STATUS                  @"status"     //服务状态
     SUCESS                  @"success"   //服务成功
     FAILED                  @"failed"   //服务失败
     DONE                    @"done"     //训练完成


 * 唤醒结果的位置
     ID                      @"id"     //唤醒结果的id


 * 唤醒资源的阀值
  注册时返回，表示注册资源对应的阀值，为输出值
     THRESHOLD               @"threshold"  //训练资源的阀值


 * 服务结果的可信度
     SCORE                   @"score"  //服务结果可信度


 * 为注册时返回，表示已经注册成功的次数
     NUM                     @"num"     //已训练成功次数


 * 表示服务传入音频对应的起始点和结束点
     BOS                     @"bos"     //前端点
     EOS                     @"eos"     //后端点


 * 录音方式，如果是外部数据，设置为-1，通过WriteAudio送入音频
    注意：目前紧紧支持唤醒服务，注册业务尚不支持
     AUDIO_SOURCE            @"audio_source"


 * 表示资源合并操作
 MERGE_RES_ACTION @"merge"

*/


@interface IFlyVoiceWakeuper : NSObject
{

}

@property(assign) id<IFlyVoiceWakeuperDelegate> delegate;

/**
  创建唤醒实例，采用单例模式
 */
+ (instancetype) sharedInstance;


/**
  启动唤醒
  返回值:YES 成功，NO：失败
 */
-(BOOL) startListening;

/**
  取消唤醒会话
  注意与cancel的区别，紧紧停止服务，并不释放资源
 */
-(BOOL) stopListening;

/**
  获取工作参数
 */
-(NSString*) getParameter:(NSString *)key;

/**
  设置工作参数
  注意服务正在运行中，不能设置参数
 */
-(BOOL) setParameter:(NSString *) value forKey:(NSString*)key;

/**
  取消唤醒会话，并释放内部资源
 */
-(BOOL) cancel;

/**
  唤醒业务更新，目前支持合并资源操作
 */
//+(int) updateWords:(NSString *)action params:(NSString*) params;

/**
  写入录音数据
  暂时紧紧支持唤醒的写入，注册服务尚不支持
 */
//-(int) writeAudio:(const void*)buffer offset:(int)offset  length:(int)length;

@property (readonly) BOOL isListening;

@end
