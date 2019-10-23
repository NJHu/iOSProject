//
//  LMJAppDelegate.m
//  PLMMPRJK
//
//  Created by NJHu on 2017/3/29.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJAppDelegate.h"
#import "LMJTabBarController.h"
#import "LMJIntroductoryPagesHelper.h"
#import "AdvertiseHelper.h"
#import "YYFPSLabel.h"
#import "LMJUMengHelper.h"
#import <UserNotificationsUI/UserNotificationsUI.h>

@implementation LMJAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window.rootViewController = [[LMJTabBarController alloc] init];
    
    // 检查更新
    [[LMJRequestManager sharedManager] GET:[LMJNJHuBaseUrl stringByAppendingPathComponent:@"jsons/updateapp.json"] parameters:nil completion:^(LMJBaseResponse *response) {
        [self checkVersion:response];
    }];
    
    // 欢迎视图
    [LMJIntroductoryPagesHelper showIntroductoryPageView:@[@"intro_0.jpg", @"intro_1.jpg", @"intro_2.jpg", @"intro_3.jpg"]];
    
    NSArray <NSString *> *imagesURLS = @[@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1495189872684&di=03f9df0b71bb536223236235515cf227&imgtype=0&src=http%3A%2F%2Fatt1.dzwww.com%2Fforum%2F201405%2F29%2F1033545qqmieznviecgdmm.gif", @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1495189851096&di=224fad7f17468c2cc080221dd78a4abf&imgtype=0&src=http%3A%2F%2Fimg3.duitang.com%2Fuploads%2Fitem%2F201505%2F12%2F20150512124019_GPjEJ.gif"];
    // 启动广告
    [AdvertiseHelper showAdvertiserView:imagesURLS];
    
    // 检查版本更新
    NSLog(@"%zd", [LMJRequestManager sharedManager].reachabilityManager.networkReachabilityStatus);
    
    // 刷新率
    [self.window addSubview:[[YYFPSLabel alloc] initWithFrame:CGRectMake(20, 70, 0, 0)]];
    
    // 友盟统计
    [LMJUMengHelper UMAnalyticStart];
    // 友盟社交化
    [LMJUMengHelper UMSocialStart];
    // 友盟推送
    [LMJUMengHelper UMPushStart:launchOptions];

    if (launchOptions) {
        [UIAlertController mj_showAlertWithTitle:@"有launchOptions!!" message:launchOptions.description appearanceProcess:^(JXTAlertController * _Nonnull alertMaker) {
            alertMaker.addActionCancelTitle(@"cancel").addActionDestructiveTitle(@"按钮1");
        } actionsBlock:^(NSInteger buttonIndex, UIAlertAction * _Nonnull action, JXTAlertController * _Nonnull alertSelf) {
        }];
    }
    return YES;
}



#pragma mark -应用跳转
//Universal link
- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray<id<UIUserActivityRestoring>> * _Nullable))restorationHandler
{
    if (userActivity.webpageURL) {
        NSLog(@"%@", userActivity.webpageURL);
        [UIAlertController mj_showAlertWithTitle:@"web跳转应用" message:userActivity.webpageURL.description appearanceProcess:^(JXTAlertController * _Nonnull alertMaker) {
            
            alertMaker.addActionDefaultTitle(@"确认");
        } actionsBlock:^(NSInteger buttonIndex, UIAlertAction * _Nonnull action, JXTAlertController * _Nonnull alertSelf) {
            
        }];
    }
    
    return YES;
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-implementations"
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
        BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    if (!result) {
        // 其他如支付等SDK的回调
        
    }
    return result;
}
#pragma clang diagnostic pop
//iOS9+scheme跳转
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(nonnull NSDictionary *)options
{
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url options:options];
    
    if (!result) {
        // 其他如支付等SDK的回调
    }
    
    if (url) {
        NSLog(@"%@", url);
        [UIAlertController mj_showAlertWithTitle:@"iOS9+scheme跳转应用" message:url.description appearanceProcess:^(JXTAlertController * _Nonnull alertMaker) {

            alertMaker.addActionDefaultTitle(@"确认");
        } actionsBlock:^(NSInteger buttonIndex, UIAlertAction * _Nonnull action, JXTAlertController * _Nonnull alertSelf) {

        }];
    }
    
    return result;
}


#pragma mark - deviceToken
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString * string = [[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]
                         stringByReplacingOccurrencesOfString: @">" withString: @""]
                        stringByReplacingOccurrencesOfString: @" " withString: @""];
    
    NSLog(@"%@", string);
    
    [UIAlertController mj_showAlertWithTitle:@"get deviceToken" message:string appearanceProcess:^(JXTAlertController * _Nonnull alertMaker) {

        alertMaker.addActionDefaultTitle(@"确认");
    } actionsBlock:^(NSInteger buttonIndex, UIAlertAction * _Nonnull action, JXTAlertController * _Nonnull alertSelf) {

    }];
}


- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"注册远程通知失败: %@", error);
}



#pragma mark - 通知
//iOS10新增：处理前台收到通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    
    NSDictionary * userInfo = notification.request.content.userInfo;
    
    if (@available(iOS 10.0, *)) {
        if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
            //应用处于前台时的远程推送接受
            //关闭U-Push自带的弹出框
            [UMessage setAutoAlert:NO];
            //必须加这句代码
            [UMessage didReceiveRemoteNotification:userInfo];
            
            [UIAlertController mj_showAlertWithTitle:@"2_iOS10新增：处理前台收到通知的代理方法" message:userInfo.description appearanceProcess:^(JXTAlertController * _Nonnull alertMaker) {
                
                alertMaker.addActionDefaultTitle(@"确认");
            } actionsBlock:nil];
            
        }else{
            //应用处于前台时的本地推送接受
        }
    } else {
        // Fallback on earlier versions
    }
    //当应用处于前台时提示设置，需要哪个可以设置哪一个
    completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
}

//iOS10新增：处理后台点击通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler{
    
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        
        //应用处于后台时的远程推送接受
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        [UIAlertController mj_showAlertWithTitle:@"3_iOS10新增：处理后台点击通知的代理方法" message:userInfo.description appearanceProcess:^(JXTAlertController * _Nonnull alertMaker) {
            alertMaker.addActionDefaultTitle(@"确认");
        } actionsBlock:nil];
    }else{
        //应用处于后台时的本地推送接受
    }
}


#pragma mark - checkVersion
- (void)checkVersion:(LMJBaseResponse *)response
{
    if (response.error || LMJIsEmpty(response.responseObject)) {
        return;
    }
    
    NSDictionary *responseData = response.responseObject;
    NSInteger lastest = [responseData[@"lastest"] integerValue];
    NSString *lastestUrl = responseData[@"lastestUrl"];
    
    if (!lastest || LMJIsEmpty(lastestUrl)) {
        return;
    }
    
    BOOL isForce = [responseData[@"isForce"] boolValue];
    // 是否在审核
    BOOL isInGod = [responseData[@"isInGod"] boolValue];
    NSInteger minSupport = [responseData[@"minSupport"] integerValue];
    NSString *suggestion = responseData[@"suggestion"];
    
    NSInteger currentVersion = [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] integerValue];
    
    if (currentVersion < lastest) {
        [UIAlertController mj_showAlertWithTitle:@"提示" message:suggestion appearanceProcess:^(JXTAlertController * _Nonnull alertMaker) {
            
            alertMaker.addActionDefaultTitle(@"确认升级");
            if (!isForce && minSupport <= currentVersion) {
                alertMaker.addActionCancelTitle(@"先用着吧");
            }
            
        } actionsBlock:^(NSInteger buttonIndex, UIAlertAction * _Nonnull action, JXTAlertController * _Nonnull alertSelf) {
            
            if (buttonIndex == 0) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:lastestUrl] options:@{} completionHandler:^(BOOL success) {
                    NSLog(@"%d", success);
                }];
            }
        }];
    }else {
        if (isInGod) {
//            LMJNJIsInGod = isInGod;
//            self.window.rootViewController = [[LMJTabBarController alloc] init];
        }
    }
}

#pragma mark - getter
- (UIWindow *)window
{
    if(!_window)
    {
        _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _window.backgroundColor = [UIColor RandomColor];
        [_window makeKeyAndVisible];
    }
    return _window;
}

@end

