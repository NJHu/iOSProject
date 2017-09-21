/*!
 *  @header EMClient.h
 *  @abstract SDK Client
 *  @author Hyphenate
 *  @version 3.00
 */

#import <Foundation/Foundation.h>

#import "EMClientDelegate.h"
#import "EMMultiDevicesDelegate.h"
#import "EMOptions.h"
#import "EMPushOptions.h"
#import "EMError.h"

#import "IEMChatManager.h"
#import "IEMContactManager.h"
#import "IEMGroupManager.h"
#import "IEMChatroomManager.h"

#import "EMDeviceConfig.h"

/*!
 *  SDK Client
 */
@interface EMClient : NSObject
{
    EMPushOptions *_pushOptions;
}

/*!
 *  \~chinese 
 *  SDK版本号
 *
 *  \~english 
 *  SDK version
 */
@property (nonatomic, strong, readonly) NSString *version;

/*!
 *  \~chinese 
 *  当前登录账号
 *
 *  \~english 
 *  Current logged in user's username
 */
@property (nonatomic, strong, readonly) NSString *currentUsername;

/*!
 *  \~chinese 
 *  SDK属性
 *
 *  \~english
 *  SDK setting options
 */
@property (nonatomic, strong, readonly) EMOptions *options;

/*!
 *  \~chinese 
 *  推送设置
 *
 *  \~english 
 *  Apple Push Notification Service setting
 */
@property (nonatomic, strong, readonly) EMPushOptions *pushOptions;

/*!
 *  \~chinese 
 *  聊天模块
 *
 *  \~english 
 *  Chat Management
 */
@property (nonatomic, strong, readonly) id<IEMChatManager> chatManager;

/*!
 *  \~chinese 
 *  好友模块
 *
 *  \~english 
 *  Contact Management
 */
@property (nonatomic, strong, readonly) id<IEMContactManager> contactManager;

/*!
 *  \~chinese 
 *  群组模块
 *
 *  \~english 
 *  Group Management
 */
@property (nonatomic, strong, readonly) id<IEMGroupManager> groupManager;

/*!
 *  \~chinese 
 *  聊天室模块
 *
 *  \~english 
 *  Chat Room Management
 */
@property (nonatomic, strong, readonly) id<IEMChatroomManager> roomManager;

/*!
 *  \~chinese 
 *  SDK是否自动登录上次登录的账号
 *
 *  \~english
 *  If SDK will automatically log into with previously logged in session. If the current login failed, then isAutoLogin attribute will be reset to NO, you need to set it back to YES in order to allow automatic login
 *  1. password changed
 *  2. deactivate, forced logout, etc
 */
@property (nonatomic, readonly) BOOL isAutoLogin;

/*!
 *  \~chinese 
 *  用户是否已登录
 *
 *  \~english 
 *  If a user logged in
 */
@property (nonatomic, readonly) BOOL isLoggedIn;

/*!
 *  \~chinese 
 *  是否连上聊天服务器
 *
 *  \~english 
 *  Connection status to Hyphenate IM server
 */
@property (nonatomic, readonly) BOOL isConnected;

/*!
 *  \~chinese 
 *  获取SDK实例
 *
 *  \~english
 *  Get SDK singleton instance
 */
+ (instancetype)sharedClient;


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
- (void)addDelegate:(id<EMClientDelegate>)aDelegate
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
- (void)removeDelegate:(id)aDelegate;

/*!
 *  \~chinese
 *  注册多设备回调代理
 *
 *  @param aDelegate  要添加的代理
 *  @param aQueue     执行代理方法的队列
 *
 *  \~english
 *  Add multi-device delegate
 *
 *  @param aDelegate  Delegate
 *  @param aQueue     The queue of calling delegate methods
 */
- (void)addMultiDevicesDelegate:(id<EMMultiDevicesDelegate>)aDelegate
                  delegateQueue:(dispatch_queue_t)aQueue;

/*!
 *  \~chinese
 *  移除多设备回调代理
 *
 *  @param aDelegate  要移除的代理
 *
 *  \~english
 *  Remove multi devices delegate
 *
 *  @param aDelegate  Delegate
 */
- (void)removeMultiDevicesDelegate:(id<EMMultiDevicesDelegate>)aDelegate;

#pragma mark - Initialize SDK

/*!
 *  \~chinese 
 *  初始化sdk
 *
 *  @param aOptions  SDK配置项
 *
 *  @result 错误信息
 *
 *  \~english 
 *  Initialize the SDK
 *  
 *  @param aOptions SDK setting options
 *
 *  @result Error
 */
- (EMError *)initializeSDKWithOptions:(EMOptions *)aOptions;


#pragma mark - Change AppKey

/*!
 *  \~chinese
 *  修改appkey，注意只有在未登录状态才能修改appkey
 *
 *  @param aAppkey  appkey
 *
 *  @result 错误信息
 *
 *  \~english
 *  Change appkey. Can only change appkey when the user is logged out
 *
 *  @param aAppkey  appkey
 *
 *  @result Error
 */
- (EMError *)changeAppkey:(NSString *)aAppkey;


#pragma mark - User Registeration

/*!
 *  \~chinese
 *  注册用户
 *
 *  同步方法，会阻塞当前线程. 不推荐使用，建议后台通过REST注册
 *
 *  @param aUsername  用户名
 *  @param aPassword  密码
 *
 *  @result 错误信息
 *
 *  \~english
 *  Register a new IM user
 *
 *  To ensure good reliability, registering new IM user via REST API from developer backend is highly recommended
 *
 *  @param aUsername  Username
 *  @param aPassword  Password
 *
 *  @result Error
 */
- (EMError *)registerWithUsername:(NSString *)aUsername
                         password:(NSString *)aPassword;

/*!
 *  \~chinese
 *  注册用户
 *
 *  不推荐使用，建议后台通过REST注册
 *
 *  @param aUsername        用户名
 *  @param aPassword        密码
 *  @param aCompletionBlock 完成的回调
 *
 *  \~english
 *  Register a new IM user
 *
 *  To ensure good reliability, registering new IM user via REST API from developer backend is highly recommended
 *
 *  @param aUsername        Username
 *  @param aPassword        Password
 *  @param aCompletionBlock The callback of completion block
 *
 */
- (void)registerWithUsername:(NSString *)aUsername
                    password:(NSString *)aPassword
                  completion:(void (^)(NSString *aUsername, EMError *aError))aCompletionBlock;


#pragma mark - Login

/*!
 *  \~chinese
 *  密码登录
 *
 *  同步方法，会阻塞当前线程
 *
 *  @param aUsername  用户名
 *  @param aPassword  密码
 *
 *  @result 错误信息
 *
 *  \~english
 *  Login with password
 *
 *  Synchronization method will block the current thread
 *
 *  @param aUsername  Username
 *  @param aPassword  Password
 *
 *  @result Error
 */
- (EMError *)loginWithUsername:(NSString *)aUsername
                      password:(NSString *)aPassword;

/*!
 *  \~chinese
 *  密码登录
 *
 *  @param aUsername        用户名
 *  @param aPassword        密码
 *  @param aCompletionBlock 完成的回调
 *
 *  \~english
 *  Login with password
 *
 *  @param aUsername        Username
 *  @param aPassword        Password
 *  @param aCompletionBlock The callback of completion block
 *
 */
- (void)loginWithUsername:(NSString *)aUsername
                 password:(NSString *)aPassword
               completion:(void (^)(NSString *aUsername, EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  token登录，不支持自动登录
 *
 *  同步方法，会阻塞当前线程
 *
 *  @param aUsername  用户名
 *  @param aToken     Token
 *
 *  @result 错误信息
 *
 *  \~english
 *  Login with token. Does not support automatic login
 *
 *  Synchronization method will block the current thread
 *
 *  @param aUsername  Username
 *  @param aToken     Token
 *
 *  @result Error
 */
- (EMError *)loginWithUsername:(NSString *)aUsername
                         token:(NSString *)aToken;

/*!
 *  \~chinese
 *  token登录，不支持自动登录
 *
 *  @param aUsername        用户名
 *  @param aToken           Token
 *  @param aCompletionBlock 完成的回调
 *
 *  \~english
 *  Login with token. Does not support automatic login
 *
 *  @param aUsername        Username
 *  @param aToken           Token
 *  @param aCompletionBlock The callback of completion block
 *
 */
- (void)loginWithUsername:(NSString *)aUsername
                    token:(NSString *)aToken
               completion:(void (^)(NSString *aUsername, EMError *aError))aCompletionBlock;

#pragma mark - Logout

/*!
 *  \~chinese
 *  退出
 *
 *  同步方法，会阻塞当前线程
 *
 *  @param aIsUnbindDeviceToken 是否解除device token的绑定，解除绑定后设备不会再收到消息推送
 *         如果传入YES, 解除绑定失败，将返回error
 *
 *  @result 错误信息
 *
 *  \~english
 *  Logout
 *
 *  Synchronization method will block the current thread
 *
 *  @param aIsUnbindDeviceToken Unbind device token to disable Apple Push Notification Service
 *
 *  @result Error
 */
- (EMError *)logout:(BOOL)aIsUnbindDeviceToken;

/*!
 *  \~chinese
 *  退出
 *
 *  @param aIsUnbindDeviceToken 是否解除device token的绑定，解除绑定后设备不会再收到消息推送
 *         如果传入YES, 解除绑定失败，将返回error
 *  @param aCompletionBlock 完成的回调
 *
 *  \~english
 *  Logout
 *
 *  @param aIsUnbindDeviceToken     Unbind device token to disable the Apple Push Notification Service
 *  @param aCompletionBlock         The callback of completion block
 *
 */
- (void)logout:(BOOL)aIsUnbindDeviceToken
    completion:(void (^)(EMError *aError))aCompletionBlock;

#pragma mark - APNs

/*!
 *  \~chinese
 *  绑定device token
 *
 *  同步方法，会阻塞当前线程
 *
 *  @param aDeviceToken  要绑定的token
 *
 *  @result 错误信息
 *
 *  \~english
 *  Device token binding is required to enable Apple Push Notification Service
 *
 *  Synchronization method will block the current thread
 *
 *  @param aDeviceToken  Device token to bind
 *
 *  @result Error
 */
- (EMError *)bindDeviceToken:(NSData *)aDeviceToken;

/*!
 *  \~chinese
 *  绑定device token
 *
 *  @param aDeviceToken     要绑定的token
 *  @param aCompletionBlock 完成的回调
 *
 *  \~english
 *  Device token binding is required to enable Apple push notification service
 *
 *  @param aDeviceToken         Device token to bind
 *  @param aCompletionBlock     The callback block of completion
 */
- (void)registerForRemoteNotificationsWithDeviceToken:(NSData *)aDeviceToken
                                           completion:(void (^)(EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  设置推送消息显示的昵称
 *
 *  同步方法，会阻塞当前线程
 *
 *  @param aNickname  要设置的昵称
 *
 *  @result 错误信息
 *
 *  \~english
 *  Set display name for Apple Push Notification message
 *
 *  Synchronization method will block the current thread
 *
 *  @param aNickname  Display name
 *
 *  @result Error
 */
- (EMError *)setApnsNickname:(NSString *)aNickname;

/*!
 *  \~chinese
 *  设置推送的显示名
 *
 *  @param aDisplayName     推送显示名
 *  @param aCompletionBlock 完成的回调
 *
 *  \~english
 *  Set display name for the push notification
 *
 *  @param aDisplayName     Display name of push
 *  @param aCompletionBlock The callback block of completion
 *
 */
- (void)updatePushNotifiationDisplayName:(NSString *)aDisplayName
                              completion:(void (^)(NSString *aDisplayName, EMError *aError))aCompletionBlock;

/*!
 *  \~chinese 
 *  从服务器获取推送属性
 *
 *  同步方法，会阻塞当前线程
 *
 *  @param pError  错误信息
 *
 *  @result 推送属性
 *
 *  \~english
 *  Get Apple Push Notification Service options from the server
 *
 *  Synchronization method will block the current thread
 *
 *  @param pError  Error
 *
 *  @result Apple Push Notification Service options
 */
- (EMPushOptions *)getPushOptionsFromServerWithError:(EMError **)pError;

/*!
 *  \~chinese
 *  从服务器获取推送属性
 *
 *  @param aCompletionBlock 完成的回调
 *
 *  \~english
 *  Get Apple Push Notification Service options from the server
 *
 *  @param aCompletionBlock The callback of completion block
 */
- (void)getPushNotificationOptionsFromServerWithCompletion:(void (^)(EMPushOptions *aOptions, EMError *aError))aCompletionBlock;

/*!
 *  \~chinese 
 *  更新推送设置到服务器
 *
 *  同步方法，会阻塞当前线程
 *
 *  @result 错误信息
 *
 *  \~english
 *  Update Apple Push Notification Service options to the server
 *
 *  Synchronization method will block the current thread
 *
 *  @result Error
 */
- (EMError *)updatePushOptionsToServer;

/*!
 *  \~chinese
 *  更新推送设置到服务器
 *
 *  @param aCompletionBlock 完成的回调
 *
 *  \~english
 *  Update Apple Push Notification Service options to the server
 *
 *  @param aCompletionBlock The callback block of completion
 */
- (void)updatePushNotificationOptionsToServerWithCompletion:(void (^)(EMError *aError))aCompletionBlock;

#pragma mark - Log

/*!
 *  \~chinese
 *  上传日志到服务器
 *
 *  同步方法，会阻塞当前线程
 *
 *  @result 错误信息
 *
 *  \~english
 *  Upload debugging log to server
 *
 *  Synchronization method will block the current thread
 *
 *  @result Error
 */
- (EMError *)uploadLogToServer;

/*!
 *  \~chinese
 *  上传日志到服务器
 *
 *  @param aCompletionBlock 完成的回调
 *
 *  \~english
 *  Upload debugging log to server
 *
 *  @param aCompletionBlock     The callback of completion block
 */
- (void)uploadDebugLogToServerWithCompletion:(void (^)(EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  将日志文件压缩成.gz文件，返回gz文件路径。强烈建议方法完成之后删除该压缩文件
 *
 *  同步方法，会阻塞当前线程
 *
 *  @param pError 错误信息
 *
 *  @result 文件路径
 *
 *  \~english
 *  Compress the log file into a .gz file and return the gz file path. Recommend delete the gz file if file is no longer used
 *
 *  Synchronization method will block the current thread
 *
 *  @param pError Error
 *
 *  @result File path
 */
- (NSString *)getLogFilesPath:(EMError **)pError;

/*!
 *  \~chinese
 *  将日志文件压缩成.gz文件，返回gz文件路径。强烈建议方法完成之后删除该压缩文件
 *
 *  @param aCompletionBlock 完成的回调
 *
 *  \~english
 *  Compress the log file into a .gz file and return the gz file path. Recommend delete the gz file if file is no longer used
 *
 *  @param aCompletionBlock     The callback of completion block
 */
- (void)getLogFilesPathWithCompletion:(void (^)(NSString *aPath, EMError *aError))aCompletionBlock;

#pragma mark - Multi Devices

/*!
 *  \~chinese
 *  从服务器获取所有已经登录的设备信息
 *
 *  同步方法，会阻塞当前线程
 *
 *  @param aUsername        用户名
 *  @param aPassword        密码
 *  @param pError           错误信息
 *
 *  @result 所有已经登录的设备信息<EMDeviceConfig>
 *
 *  \~english
 *  Get all the device information <EMDeviceConfig> that logged in to the server
 *
 *  Synchronization method will block the current thread
 *
 *  @param aUsername        Username
 *  @param aPassword        Password
 *  @param pError           Error
 *
 *  @result Information of logged in device <EMDeviceConfig>
 */
- (NSArray *)getLoggedInDevicesFromServerWithUsername:(NSString *)aUsername
                                             password:(NSString *)aPassword
                                                error:(EMError **)pError;

/*!
 *  \~chinese
 *  从服务器获取所有已经登录的设备信息
 *
 *  @param aUsername        用户名
 *  @param aPassword        密码
 *  @param aCompletionBlock 完成的回调
 *
 *  \~english
 *  Get all the device information <EMDeviceConfig> that logged in to the server
 *
 *  @param aUsername        Username
 *  @param aPassword        Password
 *  @param aCompletionBlock The callback block of completion
 *
 *  @result aList           Information of logged in device <EMDeviceConfig>
 */
- (void)getLoggedInDevicesFromServerWithUsername:(NSString *)aUsername
                                        password:(NSString *)aPassword
                                      completion:(void (^)(NSArray *aList, EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  强制指定的设备退出
 *
 *  同步方法，会阻塞当前线程
 *
 *  @param aDevice          设备信息
 *  @param aUsername        用户名
 *  @param aPassword        密码
 *
 *  @result 错误信息
 *
 *  \~english
 *  Force logout the specified device
 *
 *  device information can be obtained from getLoggedInDevicesFromServerWithUsername:password:error:
 *
 *  Synchronization method will block the current thread
 *
 *  @param aDevice          device information <EMDeviceConfig>
 *  @param aUsername        Username
 *  @param aPassword        Password
 *
 *  @result Error
 */
- (EMError *)kickDevice:(EMDeviceConfig *)aDevice
               username:(NSString *)aUsername
               password:(NSString *)aPassword;

/*!
 *  \~chinese
 *  强制指定的设备退出
 *
 *  @param aDevice          设备信息
 *  @param aUsername        用户名
 *  @param aPassword        密码
 *  @param aCompletionBlock 完成的回调
 *
 *  \~english
 *  Force logout the specified device
 *
 *  device information can be obtained from getLoggedInDevicesFromServerWithUsername:password:error:
 *
 *  @param aDevice          device information <EMDeviceConfig>
 *  @param aUsername        Username
 *  @param aPassword        Password
 *  @param aCompletionBlock The callback block of completion
 */
- (void)kickDevice:(EMDeviceConfig *)aDevice
          username:(NSString *)aUsername
          password:(NSString *)aPassword
        completion:(void (^)(EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  强制所有的登录设备退出
 *
 *  同步方法，会阻塞当前线程
 *
 *  @param aUsername        用户名
 *  @param aPassword        密码
 *
 *  @result 错误信息
 *
 *  \~english
 *  Force logout all logged in device for the specified user
 *
 *  Synchronization method will block the current thread
 *
 *  @param aUsername        Username
 *  @param aPassword        Password
 *
 *  @result Error
 */
- (EMError *)kickAllDevicesWithUsername:(NSString *)aUsername
                               password:(NSString *)aPassword;

/*!
 *  \~chinese
 *  强制所有的登录设备退出
 *
 *  @param aUsername        用户名
 *  @param aPassword        密码
 *  @param aCompletionBlock 完成的回调
 *
 *  \~english
 *  Force all logged in device to logout.
 *
 *  @param aUsername        Username
 *  @param aPassword        Password
 *  @param aCompletionBlock The callback block of completion
 */
- (void)kickAllDevicesWithUsername:(NSString *)aUsername
                          password:(NSString *)aPassword
                        completion:(void (^)(EMError *aError))aCompletionBlock;

#pragma mark - iOS

/*!
 *  \~chinese
 *  iOS专用，数据迁移到SDK3.0
 *
 *  同步方法，会阻塞当前线程
 *
 *  升级到SDK3.0版本需要调用该方法，开发者需要等该方法执行完后再进行数据库相关操作
 *
 *  @result 是否迁移成功
 *
 *  \~english
 *  Migrate the IM database to the latest SDK version
 *
 *  Synchronization method will block the current thread
 *
 *  @result Return YES for success
 */
- (BOOL)migrateDatabaseToLatestSDK;

/*!
 *  \~chinese 
 *  iOS专用，程序进入后台时，需要调用此方法断开连接
 *
 *  @param aApplication  UIApplication
 *
 *  \~english
 *  Disconnect from server when app enters background
 *
 *  @param aApplication  UIApplication
 */
- (void)applicationDidEnterBackground:(id)aApplication;

/*!
 *  \~chinese 
 *  iOS专用，程序进入前台时，需要调用此方法进行重连
 *
 *  @param aApplication  UIApplication
 *
 *  \~english
 *  Reconnect to server when app enters foreground
 *
 *  @param aApplication  UIApplication
 */
- (void)applicationWillEnterForeground:(id)aApplication;

/*!
 *  \~chinese
 *  iOS专用，程序在前台收到APNs时，需要调用此方法
 *
 *  @param application  UIApplication
 *  @param userInfo     推送内容
 *
 *  \~english
 *  Invoked when receiving APNs in foreground
 *
 *  @param application  UIApplication
 *  @param userInfo     Push content
 */
- (void)application:(id)application didReceiveRemoteNotification:(NSDictionary *)userInfo;

#pragma mark - EM_DEPRECATED_IOS 3.2.3

/*!
 *  \~chinese
 *  添加回调代理
 *
 *  @param aDelegate  要添加的代理
 *
 *  \~english
 *  Add delegate
 *
 *  @param aDelegate  Delegate
 */
- (void)addDelegate:(id<EMClientDelegate>)aDelegate EM_DEPRECATED_IOS(3_1_0, 3_2_2, "Use -[IEMCallManager addDelegate:delegateQueue:]");

#pragma mark - EM_DEPRECATED_IOS < 3.2.3

/*!
 *  \~chinese
 *  注册用户
 *
 *  不推荐使用，建议后台通过REST注册
 *
 *  @param aUsername        用户名
 *  @param aPassword        密码
 *  @param aSuccessBlock    成功的回调
 *  @param aFailureBlock    失败的回调
 *
 *  \~english
 *  Register a new user
 *
 *  To enhance the reliability, registering new IM user through REST API from backend is highly recommended
 *
 *  @param aUsername        Username
 *  @param aPassword        Password
 *  @param aSuccessBlock    The callback block of success
 *  @param aFailureBlock    The callback block of failure
 *
 */
- (void)asyncRegisterWithUsername:(NSString *)aUsername
                         password:(NSString *)aPassword
                          success:(void (^)())aSuccessBlock
                          failure:(void (^)(EMError *aError))aFailureBlock __deprecated_msg("Use -registerWithUsername:password:completion:");

/*!
 *  \~chinese
 *  登录
 *
 *  @param aUsername        用户名
 *  @param aPassword        密码
 *  @param aSuccessBlock    成功的回调
 *  @param aFailureBlock    失败的回调
 *
 *  \~english
 *  Login
 *
 *  @param aUsername        Username
 *  @param aPassword        Password
 *  @param aSuccessBlock    The callback block of success
 *  @param aFailureBlock    The callback block of failure
 *
 */
- (void)asyncLoginWithUsername:(NSString *)aUsername
                      password:(NSString *)aPassword
                       success:(void (^)())aSuccessBlock
                       failure:(void (^)(EMError *aError))aFailureBlock __deprecated_msg("Use -loginWithUsername:password:completion");

/*!
 *  \~chinese
 *  退出
 *
 *  @param aIsUnbindDeviceToken 是否解除device token的绑定，解除绑定后设备不会再收到消息推送
 *         如果传入YES, 解除绑定失败，将返回error
 *
 *  @result 错误信息
 *
 *  \~english
 *  Logout
 *
 *  @param aIsUnbindDeviceToken Unbind device token to disable the Apple Push Notification Service
 *
 *  @result Error
 */
- (void)asyncLogout:(BOOL)aIsUnbindDeviceToken
            success:(void (^)())aSuccessBlock
            failure:(void (^)(EMError *aError))aFailureBlock __deprecated_msg("Use -logout:completion:");

/*!
 *  \~chinese
 *  绑定device token
 *
 *  @param aDeviceToken     要绑定的token
 *  @param aSuccessBlock    成功的回调
 *  @param aFailureBlock    失败的回调
 *
 *  \~english
 *  Bind device token
 *
 *  @param aDeviceToken     Device token to bind
 *  @param aSuccessBlock    The callback block of success
 *  @param aFailureBlock    The callback block of failure
 */
- (void)asyncBindDeviceToken:(NSData *)aDeviceToken
                     success:(void (^)())aSuccessBlock
                     failure:(void (^)(EMError *aError))aFailureBlock __deprecated_msg("Use -registerForRemoteNotificationsWithDeviceToken:completion:");

/*!
 *  \~chinese
 *  设置推送消息显示的昵称
 *
 *  @param aNickname        要设置的昵称
 *  @param aSuccessBlock    成功的回调
 *  @param aFailureBlock    失败的回调
 *
 *  \~english
 *  Set display name for push notification
 *
 *  @param aNickname        Push Notification display name
 *  @param aSuccessBlock    The callback block of success
 *  @param aFailureBlock    The callback block of failure
 *
 */
- (void)asyncSetApnsNickname:(NSString *)aNickname
                     success:(void (^)())aSuccessBlock
                     failure:(void (^)(EMError *aError))aFailureBlock __deprecated_msg("Use -updatePushNotifiationDisplayName:copletion");

/*!
 *  \~chinese
 *  从服务器获取推送属性
 *
 *  @param aSuccessBlock    成功的回调
 *  @param aFailureBlock    失败的回调
 *
 *  \~english
 *  Get apns options from the server
 *
 *  @param aSuccessBlock    The callback block of success
 *  @param aFailureBlock    The callback block of failure
 */
- (void)asyncGetPushOptionsFromServer:(void (^)(EMPushOptions *aOptions))aSuccessBlock
                              failure:(void (^)(EMError *aError))aFailureBlock __deprecated_msg("Use -getPushOptionsFromServerWithCompletion:");

/*!
 *  \~chinese
 *  更新推送设置到服务器
 *
 *  @param aSuccessBlock    成功的回调
 *  @param aFailureBlock    失败的回调
 *
 *  \~english
 *  Update APNS options to the server
 *
 *  @param aSuccessBlock    The callback block of success
 *  @param aFailureBlock    The callback block of failure
 *
 */
- (void)asyncUpdatePushOptionsToServer:(void (^)())aSuccessBlock
                               failure:(void (^)(EMError *aError))aFailureBlock __deprecated_msg("Use -updatePushNotificationOptionsToServerWithCompletion:");

/*!
 *  \~chinese
 *  上传日志到服务器
 *
 *  @param aSuccessBlock    成功的回调
 *  @param aFailureBlock    失败的回调
 *
 *  \~english
 *  Upload log to server
 *
 *  @param aSuccessBlock    The callback block of success
 *  @param aFailureBlock    The callback block of failure
 */
- (void)asyncUploadLogToServer:(void (^)())aSuccessBlock
                       failure:(void (^)(EMError *aError))aFailureBlock __deprecated_msg("Use -uploadDebugLogToServerWithCompletion:");

/*!
 *  \~chinese 
 *  iOS专用，数据迁移到SDK3.0
 *
 *  同步方法，会阻塞当前线程
 *
 *  升级到SDK3.0版本需要调用该方法，开发者需要等该方法执行完后再进行数据库相关操作
 *
 *  @result 是否迁移成功
 *
 *  \~english 
 *  iOS-specific, data migration to SDK3.0
 *
 *  Synchronization method will block the current thread
 *
 *  It's needed to call this method when update to SDK3.0, developers need to wait this method complete before DB related operations
 *
 *  @result Whether migration successful
 */
- (BOOL)dataMigrationTo3 __deprecated_msg("Use -migrateDatabaseToLatestSDK");

@end
