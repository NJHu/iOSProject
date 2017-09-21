/*!
 *  \~chinese
 *  @header EMCallSession.h
 *  @abstract 会话
 *  @author Hyphenate
 *  @version 3.00
 *
 *  \~english
 *  @header EMCallSession.h
 *  @abstract Call session
 *  @author Hyphenate
 *  @version 3.00
 */

#import <Foundation/Foundation.h>

#import "EMCallLocalView.h"
#import "EMCallRemoteView.h"
#import "EMCallEnum.h"
#import "EMCommonDefs.h"

/*!
 *  \~chinese
 *  1v1会话
 *
 *  \~english
 *  Call session
 */
@class EMError;
@interface EMCallSession : NSObject

/*!
 *  \~chinese
 *  会话标识符
 *
 *  \~english
 *  Unique call id. The call session ID is obtained after initiated a call startCall:remoteName:ext:completion:(void (^)(EMCallSession *aCallSession, EMError *aError))aCompletionBlock;
 */
@property (nonatomic, strong, readonly) NSString *callId;

/*!
 *  \~chinese 
 *  通话本地的username
 *
 *  \~english
 *  Local username
 */
@property (nonatomic, strong, readonly) NSString *localName;

/*!
 *  \~chinese
 *  通话的类型
 *
 *  \~english
 *  Call type
 */
@property (nonatomic, readonly) EMCallType type;

/*!
 *  \~chinese
 *  主叫还是被叫
 *
 *  \~english
 *  Whether it is the caller, the call initiator
 */
@property (nonatomic, readonly) BOOL isCaller;

/*!
 *  \~chinese 
 *  对方的username
 *
 *  \~english
 *  Remote party's username
 */
@property (nonatomic, strong, readonly) NSString *remoteName;

/*!
 *  \~chinese 
 *  通话的状态
 *
 *  \~english 
 *  Call session status
 */
@property (nonatomic, readonly) EMCallSessionStatus status;

/*!
 *  \~chinese
 *  视频通话时自己的图像显示区域
 *
 *  \~english
 *  Local display view
 */
@property (nonatomic, strong) EMCallLocalView *localVideoView;

/*!
 *  \~chinese
 *  视频通话时对方的图像显示区域
 *
 *  \~english
 *  Remote display view
 */
@property (nonatomic, strong) EMCallRemoteView *remoteVideoView;

#pragma mark - Statistics Property

/*!
 *  \~chinese
 *  连接类型
 *
 *  \~english
 *  Connection type
 */
@property (nonatomic, readonly) EMCallConnectType connectType;

/*!
 *  \~chinese
 *  视频的延迟时间，单位是毫秒，实时变化
 *  未获取到返回-1
 *
 *  \~english
 *  Video latency, in milliseconds, changing in real time
 *  return -1 if no data is available. Usually no data until few seconds of calling later.
 */
@property (nonatomic, readonly) int videoLatency;

/*!
 *  \~chinese
 *  本地视频的帧率，实时变化
 *  未获取到返回-1
 *
 *  \~english
 *  Local video frame rate, changing in real time
 *  return -1 if no data is available. Usually no data until few seconds of calling later.
 */
@property (nonatomic, readonly) int localVideoFrameRate;

/*!
 *  \~chinese
 *  对方视频的帧率，实时变化
 *  未获取到返回-1
 *
 *  \~english
 *  Remote party video frame rate, changing in real time
 *  return -1 if no data is available. Usually no data until few seconds of calling later.
 */
@property (nonatomic, readonly) int remoteVideoFrameRate;

/*!
 *  \~chinese
 *  本地视频通话对方的比特率kbps，实时变化
 *  未获取到返回-1
 *
 *  \~english
 *  Local bitrate, changing in real time
 *  return -1 if no data is available. Usually no data until few seconds of calling later.
 */
@property (nonatomic, readonly) int localVideoBitrate;

/*!
 *  \~chinese
 *  对方视频通话对方的比特率kbps，实时变化
 *  未获取到返回-1
 *
 *  \~english
 *  Remote party bitrate, changing in real time
 *  return -1 if no data is available. Usually no data until few seconds of calling later.
 */
@property (nonatomic, readonly) int remoteVideoBitrate;

/*!
 *  \~chinese
 *  本地视频丢包率，实时变化
 *  未获取到返回-1
 *
 *  \~english
 *  Local video package lost rate, changing in real time
 *  return -1 if no data is available. Usually no data until few seconds of calling later.
 */
@property (nonatomic, readonly) int localVideoLostRateInPercent;

/*!
 *  \~chinese
 *  对方视频丢包率，实时变化
 *  未获取到返回-1
 *
 *  \~english
 *  Remote video package lost rate, changing in real time
 *  Didn't get to show -1
 */
@property (nonatomic, readonly) int remoteVideoLostRateInPercent;

/*!
 *  \~chinese
 *  对方视频分辨率
 *  未获取到返回 (-1,-1)
 *
 *  \~english
 *  Remote video resolution
 *  return (-1, 1) if no data is available. Usually no data until few seconds of calling later.
 */
@property (nonatomic, readonly) CGSize remoteVideoResolution;

/*!
 *  \~chinese
 *  消息扩展
 *
 *  类型必须是NSString
 *
 *  \~english
 *  Call extention
 *
 *  Type must be NSString
 */
@property (nonatomic, readonly) NSString *ext;

#pragma mark - Control Stream

/*!
 *  \~chinese
 *  暂停语音数据传输
 *
 *  @result 错误
 *
 *  \~english
 *  Mute the voice during call by suspending voice data transmission
 *
 *  @result Error
 */
- (EMError *)pauseVoice;

/*!
 *  \~chinese
 *  恢复语音数据传输
 *
 *  @result 错误
 *
 *  \~english
 *  Unmute the voice during call by suspending voice data transmission
 *
 *  @result Error
 */
- (EMError *)resumeVoice;

/*!
 *  \~chinese
 *  暂停视频图像数据传输
 *
 *  @result 错误
 *
 *  \~english
 * Suspend video data transmission
 *
 *  @result Error
 */
- (EMError *)pauseVideo;

/*!
 *  \~chinese
 *  恢复视频图像数据传输
 *
 *  @result 错误
 *
 *  \~english
 *  Resume video data transmission
 *
 *  @result Error
 */
- (EMError *)resumeVideo;

#pragma mark - Camera

/*!
 *  \~chinese
 *  设置使用前置摄像头还是后置摄像头,默认使用前置摄像头
 *
 *  @param  aIsFrontCamera    是否使用前置摄像头, YES使用前置, NO使用后置
 *
 *  \~english
 *  Use front camera or back camera. Default is front camera
 *
 *  @param  aIsFrontCamera    YES for front camera, NO for back camera.
 */
- (void)switchCameraPosition:(BOOL)aIsFrontCamera;

#pragma mark - EM_DEPRECATED_IOS 3.2.0

/*!
 *  \~chinese
 *  会话标识符
 *
 *  \~english
 *  Unique session id
 */
@property (nonatomic, strong, readonly) NSString *sessionId EM_DEPRECATED_IOS(3_1_0, 3_1_5, "Use EMCallSession.callId");

/*!
 *  \~chinese
 *  通话本地的username
 *
 *  \~english
 *  Local username
 */
@property (nonatomic, strong, readonly) NSString *username EM_DEPRECATED_IOS(3_1_0, 3_1_5, "Use EMCallSession.localName");

/*!
 *  \~chinese
 *  对方的username
 *
 *  \~english
 *  The other side's username
 */
@property (nonatomic, strong, readonly) NSString *remoteUsername EM_DEPRECATED_IOS(3_1_0, 3_1_5, "Use EMCallSession.remoteName");

/*!
 *  \~chinese
 *  设置视频码率，必须在通话开始前设置
 *
 *  码率范围为150-1000， 默认为600
 *
 *  \~english
 *  Video bit rate, must be set before call session is started.
 *
 *  Value range is 150-1000, the default is 600.
 */
@property (nonatomic) int videoBitrate EM_DEPRECATED_IOS(3_1_0, 3_1_5, "Use EMCallOptions.videoKbps");

/*!
 *  \~chinese
 *  获取音频音量，实时变化
 *
 *  @return 音量
 *
 *  \~english
 *  Get voice volume of the call
 *
 *  @return Volume
 */
- (int)getVoiceVolume EM_DEPRECATED_IOS(3_1_0, 3_1_5, "Delete");

/*!
 *  \~chinese
 *  获取视频的延迟时间，单位是毫秒，实时变化
 *
 *  @result 视频延迟时间
 *
 *  \~english
 *  Get video latency, in milliseconds, changing in real time
 *
 *  @result The delay time
 */
- (int)getVideoLatency EM_DEPRECATED_IOS(3_1_0, 3_1_5, "Use -EMCallSession.videoLatency");

/*!
 *  \~chinese
 *  获取视频的帧率，实时变化
 *
 *  @result 视频帧率数值
 *
 *  \~english
 *  Get video frame rate, changing in real time
 *
 *  @result The video frame rate
 */
- (int)getVideoFrameRate EM_DEPRECATED_IOS(3_1_0, 3_1_5, "Use -EMCallSession.remoteVideoFrameRate");

/*!
 *  \~chinese
 *  获取视频丢包率
 *
 *  @result 视频丢包率
 *
 *  \~english
 *  Get video package lost rate
 *
 *  @result Video package lost rate
 */
- (int)getVideoLostRateInPercent EM_DEPRECATED_IOS(3_1_0, 3_1_5, "Use -EMCallSession.remoteVideoLostRateInPercent");

/*!
 *  \~chinese
 *  获取视频的宽度，固定值，不会实时变化
 *
 *  @result 视频宽度
 *
 *  \~english
 *  Get video original width
 *
 *  @result Video original width
 */
- (int)getVideoWidth EM_DEPRECATED_IOS(3_1_0, 3_1_5, "Use -EMCallSession.remoteVideoResolution");

/*!
 *  \~chinese
 *  获取视频的高度，固定值，不会实时变化
 *
 *  @result 视频高度
 *
 *  \~english
 *  Get fixed video original height
 *
 *  @result Video original height
 */
- (int)getVideoHeight EM_DEPRECATED_IOS(3_1_0, 3_1_5, "Use -EMCallSession.remoteVideoResolution");

/*!
 *  \~chinese
 *  获取视频通话对方的比特率kbps，实时变化
 *
 *  @result 对方比特率
 *
 *  \~english
 *  Get the other party's bitrate, changing in real time
 *
 *  @result The other party's bitrate
 */
- (int)getVideoRemoteBitrate EM_DEPRECATED_IOS(3_1_0, 3_1_5, "Use -EMCallSession.remoteVideoBitrate");

/*!
 *  \~chinese
 *  获取视频的比特率kbps，实时变化
 *
 *  @result 视频比特率
 *
 *  \~english
 *  Get bitrate of video call, changing in real time
 *
 *  @result Bitrate of video call
 */
- (int)getVideoLocalBitrate EM_DEPRECATED_IOS(3_1_0, 3_1_5, "Use -EMCallSession.localVideoBitrate");

/*!
 *  \~chinese
 *  获取视频快照，只支持JPEG格式
 *
 *  @param aPath  图片存储路径
 *
 *  \~english
 *  Get a snapshot of current video screen as jpeg picture and save to the local file system.
 *
 *  @param aPath  Saved path of picture
 */
- (void)screenCaptureToFilePath:(NSString *)aPath
                          error:(EMError**)pError EM_DEPRECATED_IOS(3_1_0, 3_1_5, "Use -[EMPluginVideoRecorder screenCaptureToFilePath:error:]");

/*!
 *  \~chinese
 *  开始录制视频
 *
 *  @param aPath            文件保存路径
 *  @param aError           错误
 *
 *  \~english
 *  Start recording video
 *
 *  @param aPath            File saved path
 *  @param aError           Error
 
 *
 */
- (void)startVideoRecordingToFilePath:(NSString*)aPath
                                error:(EMError**)aError EM_DEPRECATED_IOS(3_1_0, 3_1_5, "Use -[EMPluginVideoRecorder startVideoRecordingToFilePath:error]");

/*!
 *  \~chinese
 *  停止录制视频
 *
 *  @param aError           错误
 *
 *  \~english
 *  Stop recording video
 *
 *  @param aError           Error
 *
 */
- (NSString *)stopVideoRecording:(EMError**)aError EM_DEPRECATED_IOS(3_1_0, 3_1_5, "Use -[EMPluginVideoRecorder stopVideoRecording:]");

#pragma mark - EM_DEPRECATED_IOS < 3.2.0

/*!
 *  \~chinese
 *  获取视频的延迟时间，单位是毫秒，实时变化
 *
 *  @result 视频延迟时间
 *
 *  \~english
 *  Get video delay time, in milliseconds, it's real time changed
 *
 *  @result The delay time
 */
- (int)getVideoTimedelay __deprecated_msg("Use -getVideoLatency");

/*!
 *  \~chinese
 *  获取视频的帧率，实时变化
 *
 *  @result 视频帧率数值
 *
 *  \~english
 *  Get video frame rate, it's real time changed
 *
 *  @result The frame rate
 */
- (int)getVideoFramerate __deprecated_msg("Use -getVideoFrameRate");

/*!
 *  \~chinese
 *  获取视频丢包率
 *
 *  @result 视频丢包率
 *
 *  \~english
 *  Get video package lost rate
 *
 *  @result Package lost rate
 */
- (int)getVideoLostcnt __deprecated_msg("Use -getVideoLostRateInPercent");

/*!
 *  \~chinese
 *  获取视频快照
 *
 *  @param aFullPath  图片存储路径
 *
 *  \~english
 *  Get snapshot of video
 *
 *  @param aFullPath  Save path of picture
 */
- (void)takeRemotePicture:(NSString *)aFullPath __deprecated_msg("Use -screenCaptureToFilePath:");

/*!
 *  \~chinese
 *  开始录制视频
 *
 *  @param  aPath    文件保存路径
 *
 *  \~english
 *  Start recording video
 *
 *  @param  aPath    File save path
 */
- (BOOL)startVideoRecord:(NSString*)aPath __deprecated_msg("Use startVideoRecordingToFilePath:error:");

/*!
 *  \~chinese
 *  停止录制视频
 *
 *  @result 录制视频的路径
 *
 *  \~english
 *  Stop recording video
 *
 *  @result path of record file
 */
- (NSString *)stopVideoRecord __deprecated_msg("Use -stopVideoRecording:");

/*!
 *  \~chinese
 *  设置使用前置摄像头还是后置摄像头,默认使用前置摄像头
 *
 *  @param  isFont    是否使用前置摄像头,YES使用前置,NO使用后置
 *
 *  \~english
 *  Use front camera or back camera,default use front
 *
 *  @param  isFont    Weather use front camera or not,Yes is Front,No is Back
 */
- (void)setCameraBackOrFront:(BOOL)isFont __deprecated_msg("Use -switchCameraPosition:");


@end
