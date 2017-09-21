/*!
 *  \~chinese
 *  @header IEMCallManager.h
 *  @abstract 此协议定义了实时音频/视频通话相关操作
 *  @author Hyphenate
 *  @version 3.00
 *
 *  \~english
 *  @header IEMCallManager.h
 *  @abstract This protocol defined the operations of real time voice/video call
 *  @author Hyphenate
 *  @version 3.00
 */

#import <Foundation/Foundation.h>

#import "EMCallOptions.h"
#import "EMCallManagerDelegate.h"
#import "EMCallBuilderDelegate.h"

@class EMError;
@class EMCallStream;

/*!
 *  \~chinese 
 *  实时音频/视频通话相关操作
 *
 *  \~english
 *
 */
@protocol IEMCallManager <NSObject>

@optional

#pragma mark - Delegate

/*!
 *  \~chinese
 *  添加回调代理
 *
 *  @param aDelegate  要添加的代理
 *  @param aQueue     执行代理方法的队列
 *
 *  \~english
 *  Add delegate
 *
 *  @param aDelegate  Delegate
 *  @param aQueue     (optional) The queue of calling delegate methods. Pass in nil to run on main thread.
 */
- (void)addDelegate:(id<EMCallManagerDelegate>)aDelegate
      delegateQueue:(dispatch_queue_t)aQueue;

/*!
 *  \~chinese
 *  移除回调代理
 *
 *  @param aDelegate  要移除的代理
 *
 *  \~english
 *  Remove delegate
 *
 *  @param aDelegate  Delegate
 */
- (void)removeDelegate:(id<EMCallManagerDelegate>)aDelegate;

/*!
 *  \~chinese
 *  添加回调代理，该代理只能设置一个
 *
 *  @param aDelegate  要添加的代理
 *
 *  \~english
 *  Add delegate
 *
 *  @param aDelegate  Delegate
 */
- (void)setBuilderDelegate:(id<EMCallBuilderDelegate>)aDelegate;

#pragma mark - Options

/*!
 *  \~chinese
 *  设置设置项
 *
 *  @param aOptions  设置项
 *
 *  \~english
 *  Set setting options
 *
 *  @param aOptions  Setting options
 */
- (void)setCallOptions:(EMCallOptions *)aOptions;

/*!
 *  \~chinese
 *  获取设置项
 *
 *  @result 设置项
 *
 *  \~english
 *  Get setting options
 *
 *  @result Setting options
 */
- (EMCallOptions *)getCallOptions;

#pragma mark - Make and Answer and End

/*!
 *  \~chinese
 *  发起实时会话
 *
 *  @param aType            通话类型
 *  @param aRemoteName      被呼叫的用户（不能与自己通话）
 *  @param aExt             通话扩展信息，会传给被呼叫方
 *  @param aCompletionBlock 完成的回调
 *
 *  \~english
 *  Start a call
 *
 *  @param aType            Call type
 *  @param aRemoteName      The callee
 *  @param aExt             Call extention, to the callee
 *  @param aCompletionBlock The callback of completion
 *
 */
- (void)startCall:(EMCallType)aType
       remoteName:(NSString *)aRemoteName
              ext:(NSString *)aExt
       completion:(void (^)(EMCallSession *aCallSession, EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  接收方同意通话请求
 *
 *  @param  aCallId     通话ID
 *
 *  @result 错误信息
 *
 *  \~english
 *  Receiver answer the call
 *
 *  @param  aCallId     Call Id
 *  @param  aRemoteName Remote name
 *
 *  @result Error
 */
- (EMError *)answerIncomingCall:(NSString *)aCallId;

/*!
 *  \~chinese
 *  结束通话
 *
 *  @param aCallId     通话的ID
 *  @param aReason     结束原因
 *
 *  @result 错误
 *
 *  \~english
 *  End the call
 *
 *  @param aCallId     Call ID
 *  @param aReason     End reason
 *
 *  @result Error
 */
- (EMError *)endCall:(NSString *)aCallId
              reason:(EMCallEndReason)aReason;

#pragma mark - EM_DEPRECATED_IOS 3.2.1

/*!
 *  \~chinese
 *  发起语音会话
 *
 *  @param aUsername        被呼叫的用户（不能与自己通话）
 *  @param aCompletionBlock 完成的回调
 *
 *  \~english
 *  Start a voice call
 *
 *  @param aUsername        The callee
 *  @param aCompletionBlock The callback of completion
 *
 */
- (void)startVoiceCall:(NSString *)aUsername
            completion:(void (^)(EMCallSession *aCallSession, EMError *aError))aCompletionBlock EM_DEPRECATED_IOS(3_1_0, 3_2_0, "Use -[IEMCallManager startCall:remoteName:ext:completion:]");

/*!
 *  \~chinese
 *  发起视频会话
 *
 *  @param aUsername        被呼叫的用户（不能与自己通话）
 *  @param aCompletionBlock 完成的回调
 *
 *  \~english
 *  Start a video call
 *
 *  @param aUsername        The callee
 *  @param aSuccessBlock    The callback block of completion
 *
 */
- (void)startVideoCall:(NSString *)aUsername
            completion:(void (^)(EMCallSession *aCallSession, EMError *aError))aCompletionBlock EM_DEPRECATED_IOS(3_1_0, 3_2_0, "Use -[IEMCallManager startCall:remoteName:ext:completion:]");

#pragma mark - EM_DEPRECATED_IOS 3.2.0

/*!
 *  \~chinese
 *  暂停语音数据传输
 *
 *  @param aSessionId   通话的ID
 *
 *  \~english
 *  Pause voice streaming
 *
 *  @param aSessionId   Session ID
 */
- (void)pauseVoiceWithSession:(NSString *)aSessionId
                        error:(EMError**)pError EM_DEPRECATED_IOS(3_1_0, 3_1_5, "Use -[EMCallSession pauseVoice]");

/*!
 *  \~chinese
 *  恢复语音数据传输
 *
 *  @param aSessionId   通话的ID
 *
 *  \~english
 *  Resume voice streaming
 *
 *  @param aSessionId   Session ID
 */
- (void)resumeVoiceWithSession:(NSString *)aSessionId
                         error:(EMError**)pError EM_DEPRECATED_IOS(3_1_0, 3_1_5, "Use -[EMCallSession resumeVoice]");

/*!
 *  \~chinese
 *  暂停视频图像数据传输
 *
 *  @param aSessionId   通话的ID
 *
 *  \~english
 * Pause video streaming
 *
 *  @param aSessionId   Session ID
 */
- (void)pauseVideoWithSession:(NSString *)aSessionId
                        error:(EMError**)pError EM_DEPRECATED_IOS(3_1_0, 3_1_5, "Use -[EMCallSession pauseVideo]");

/*!
 *  \~chinese
 *  恢复视频图像数据传输
 *
 *  @param aSessionId   通话的ID
 *
 *  \~english
 *  Resume video streaming
 *
 *  @param aSessionId   Session ID
 */
- (void)resumeVideoWithSession:(NSString *)aSessionId
                         error:(EMError**)pError EM_DEPRECATED_IOS(3_1_0, 3_1_5, "Use -[EMCallSession resumeVideo]");

/*!
 *  \~chinese
 *  设置开启或者关闭视频自适应码率,默认是关闭状态
 *
 *  @param isAdaptive   YES开启, NO关闭
 *
 *  \~english
 *  Enable video adaptive, default is disable
 *
 *  @param isAdaptive   YES is enable, NO is disable
 */
- (void)enableAdaptiveBirateStreaming:(BOOL)isAdaptive EM_DEPRECATED_IOS(3_1_0, 3_1_5, "Use -[EMCallOptions videoKbps]");


#pragma mark - EM_DEPRECATED_IOS < 3.2.0

/*!
 *  \~chinese
 *  发起语音会话
 *
 *  @param aUsername  被呼叫的用户（不能与自己通话）
 *  @param pError     错误信息
 *
 *  @result 会话实例
 *
 *  \~english
 *  Start a voice call session
 *
 *  @param aUsername  The callee
 *  @param pError     Error
 *
 *  @result Session instance
 */
- (EMCallSession *)makeVoiceCall:(NSString *)aUsername
                           error:(EMError **)pError __deprecated_msg("Use -startVoiceCall:completion:");

/*!
 *  \~chinese
 *  将实时通话静音
 *
 *  @param aSessionId   通话的ID
 *  @param aIsSilence   是否静音
 *
 *  @result             错误信息
 *
 *  \~english
 *  Get video package lost rate
 *
 *  @param aSessionId   Session ID
 *  @param aIsSilence   Is Silence
 *
 *  @result             Error
 */
- (EMError *)markCallSession:(NSString *)aSessionId
                   isSilence:(BOOL)aIsSilence __deprecated_msg("Use -pauseVoiceWithSession:error:");


/*!
 *  \~chinese
 *  暂停语音数据传输
 *
 *  @param aSessionId   通话的ID
 *
 *  \~english
 *  Suspend voice data transmission
 *
 *  @param aSessionId   Session ID
 */
- (void)pauseVoiceTransfer:(NSString *)aSessionId __deprecated_msg("Use -pauseVoiceWithSession:error:");

/*!
 *  \~chinese
 *  恢复语音数据传输
 *
 *  @param aSessionId   通话的ID
 *
 *  \~english
 *  Resume voice data transmission
 *
 *  @param aSessionId   Session ID
 */
- (void)resumeVoiceTransfer:(NSString *)aSessionId __deprecated_msg("Use -resumeVoiceWithSession:error:");

/*!
 *  \~chinese
 *  发起视频会话
 *
 *  @param aUsername  被呼叫的用户（不能与自己通话）
 *  @param pError     错误信息
 *
 *  @result 会话的实例
 *
 *  \~english
 *  Start a video call session
 *
 *  @param aUsername  The callee
 *  @param pError     Error
 *
 *  @result Session instance
 */
- (EMCallSession *)makeVideoCall:(NSString *)aUsername
                           error:(EMError **)pError __deprecated_msg("Use -startVideoCall:completion:");

/*!
 *  \~chinese
 *  暂停视频图像数据传输
 *
 *  @param aSessionId   通话的ID
 *
 *  \~english
 * Suspend video data transmission
 *
 *  @param aSessionId   Session ID
 */
- (void)pauseVideoTransfer:(NSString *)aSessionId __deprecated_msg("Use -pauseVideoWithSession:error:");

/*!
 *  \~chinese
 *  恢复视频图像数据传输
 *
 *  @param aSessionId   通话的ID
 *
 *  \~english
 *  Resume video data transmission
 *
 *  @param aSessionId   Session ID
 */
- (void)resumeVideoTransfer:(NSString *)aSessionId __deprecated_msg("Use -resumeVideoWithSession:error:");

/*!
 *  \~chinese
 *  暂停通话语音和视频图像数据传输
 *
 *  @param aSessionId   通话的ID
 *
 *  \~english
 * Suspend voice and video data transmission
 *
 *  @param aSessionId   Session ID
 */
- (void)pauseVoiceAndVideoTransfer:(NSString *)aSessionId __deprecated_msg("Delete");

/*!
 *  \~chinese
 *  恢复通话语音和视频图像数据传输
 *
 *  @param aSessionId   通话的ID
 *
 *  \~english
 *  Resume voice and video data transmission
 *
 *  @param aSessionId   Session ID
 */
- (void)resumeVoiceAndVideoTransfer:(NSString *)aSessionId __deprecated_msg("Delete");

/*!
 *  \~chinese
 *  设置开启或者关闭视频自适应码率,默认是关闭状态
 *
 *  @param aFlag   YES开启, NO关闭
 *
 *  \~english
 *  Enable video adaptive, default is disable
 *
 *  @param aFlag   YES is enable, NO is disable
 */
- (void)setVideoAdaptive:(BOOL)aFlag  __deprecated_msg("Use -enableAdaptiveBirateStreaming:");


@end
