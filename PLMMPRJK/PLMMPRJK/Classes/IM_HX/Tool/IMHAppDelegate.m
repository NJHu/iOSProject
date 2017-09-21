//
//  IMHAppDelegate.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/9/19.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#define  EMAppKey @"njhu007#zplan"
#define  EMApnsCertName @"iOS_Dev_APNS_Zplan"

#import "IMHAppDelegate.h"
#import "LMJAppDelegate.h"

@interface IMHAppDelegate ()<EMClientDelegate>

@end

@implementation IMHAppDelegate



- (void)setupEasyMob
{
    //AppKey:注册的AppKey，详细见下面注释。
    //apnsCertName:推送证书名（不需要加后缀），详细见下面注释。
    EMOptions *options = [EMOptions optionsWithAppkey:EMAppKey];
    options.apnsCertName = EMApnsCertName;
    [[EMClient sharedClient] initializeSDKWithOptions:options];
    
    EMCallOptions *CallOptionsoptions = [[EMClient sharedClient].callManager getCallOptions];
    //当对方不在线时，是否给对方发送离线消息和推送，并等待对方回应
    CallOptionsoptions.isSendPushIfOffline = YES;
    [[EMClient sharedClient].callManager setCallOptions:CallOptionsoptions];
    
    [[EaseSDKHelper shareHelper] hyphenateApplication:[UIApplication sharedApplication]
                        didFinishLaunchingWithOptions:[(LMJAppDelegate *)[UIApplication sharedApplication].delegate launchOptions]
                                               appkey:EMAppKey
                                         apnsCertName:EMApnsCertName
                                          otherConfig:@{kSDKConfigEnableConsoleLogger:[NSNumber numberWithBool:YES]}];
    
    
    [kNotificationCenter addObserver:self selector:@selector(applicationWillEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    
    [kNotificationCenter addObserver:self selector:@selector(applicationDidEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    
    
    
    
    [[EMClient sharedClient] addDelegate:self delegateQueue:nil];
}


- (void)applicationWillEnterForeground
{
    
    [[EMClient sharedClient] applicationWillEnterForeground:[UIApplication sharedApplication]];
}

- (void)applicationDidEnterBackground
{
    
    [[EMClient sharedClient] applicationDidEnterBackground:[UIApplication sharedApplication]];
}


/*!
 *  自动登录返回结果
 *
 *  @param error 错误信息
 */
- (void)autoLoginDidCompleteWithError:(EMError *)error
{
    [MBProgressHUD showAutoMessage:error.errorDescription];
}

/*!
 *  SDK连接服务器的状态变化时会接收到该回调
 *
 *  有以下几种情况，会引起该方法的调用：
 *  1. 登录成功后，手机无法上网时，会调用该回调
 *  2. 登录成功后，网络状态变化时，会调用该回调
 *
 *  @param aConnectionState 当前状态
 */
- (void)connectionStateDidChange:(EMConnectionState)aConnectionState
{
    [MBProgressHUD showAutoMessage:[NSString stringWithFormat:@"%zd 0已连接网络, 1未连接网络", aConnectionState]];
}

/*!
 *  当前登录账号在其它设备登录时会接收到该回调
 */
- (void)userAccountDidLoginFromOtherDevice;
{
       [MBProgressHUD showAutoMessage:[NSString stringWithFormat:@"当前登录账号在其它设备登录时会接收到该回调"]];
}

/*!
 *  当前登录账号已经被从服务器端删除时会收到该回调
 */
- (void)userAccountDidRemoveFromServer
{
    [MBProgressHUD showAutoMessage:[NSString stringWithFormat:@"当前登录账号已经被从服务器端删除时会收到该回调"]];
}


#pragma mark - 单例
- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self setupEasyMob];
        
    }
    return self;
}


static id _instance = nil;
+ (instancetype)sharedDelegate
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        if (!_instance) {
            _instance = [[self alloc] init];
        }
        
        
    });
    
    return _instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    
    return _instance;
}

- (id)copyWithZone:(NSZone *)zone
{
    return _instance;
}

- (id)mutableCopyWithZone:(NSZone *)zone
{
    return _instance;
}


@end
