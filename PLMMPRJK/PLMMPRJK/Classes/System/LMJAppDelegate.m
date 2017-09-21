//
//  LMJAppDelegate.m
//  PLMMPRJK
//
//  Created by NJHu on 2017/3/29.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJAppDelegate.h"
#import "IMHAppDelegate.h"

@implementation LMJAppDelegate

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

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    [LMJGuideManager sharedManager].keyWindow = self.window;
    
    self.launchOptions = launchOptions;
    
    if (launchOptions) {

        
        [WJYAlertView showOneButtonWithTitle:@"有launchOptions!!" Message:launchOptions.description ButtonType:WJYAlertViewButtonTypeCancel ButtonTitle:@"知道了" Click:^{
            
        }];

        
    }
    
    // 10以下的推送
    if (launchOptions && kSystemVersion < 10.0) { // 只处理10以下的推送
        // 10 > 先3后1,,,,,,,,,,,,,9就是1
        [WJYAlertView showOneButtonWithTitle:@"1_launchOptions" Message:launchOptions.description ButtonType:WJYAlertViewButtonTypeCancel ButtonTitle:@"123" Click:^{
            
        }];
        
    }
    
    
    
    
    return YES;
}



#pragma mark -应用跳转
//Universal link
- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray * _Nullable))restorationHandler
{
    if (userActivity.webpageURL) {
        
        NSLog(@"%@", userActivity.webpageURL);
        
        [WJYAlertView showOneButtonWithTitle:@"web跳转应用" Message:userActivity.webpageURL.description ButtonType:WJYAlertViewButtonTypeCancel ButtonTitle:@"确认" Click:^{
            
        }];
    
    }
    
    return YES;
    
    //如果使用了Universal link ，此方法必写
//    return [MWApi continueUserActivity:userActivity];
    
}



// 支持所有iOS9以下系统,scheme 跳转
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    //必写
    //    [MWApi routeMLink:url];

    
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    
    if (!result) {
        // 其他如支付等SDK的回调
        
        
        
    }
    
    if (url) {
        
        NSLog(@"%@", url);
        
        [WJYAlertView showOneButtonWithTitle:@"web跳转应用" Message:url.description ButtonType:WJYAlertViewButtonTypeCancel ButtonTitle:@"确认" Click:^{
            
        }];
        
    }
    
    
    
    return result;
}




//iOS9+scheme跳转
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(nonnull NSDictionary *)options
{
    //必写
//        [MWApi routeMLink:url];
    
    
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url options:options];
    
    if (!result) {
        // 其他如支付等SDK的回调
        
        
        
    }
    
    if (url) {
        
        NSLog(@"%@", url);
        
        [WJYAlertView showOneButtonWithTitle:@"web跳转应用" Message:url.description ButtonType:WJYAlertViewButtonTypeCancel ButtonTitle:@"确认" Click:^{
            
        }];
        
    }
    
    
    
    return result;
}




#pragma mark - deviceToken
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString * string =[[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]
                         stringByReplacingOccurrencesOfString: @">" withString: @""]
                        stringByReplacingOccurrencesOfString: @" " withString: @""];
    
    NSLog(@"%@", string);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[EMClient sharedClient] bindDeviceToken:deviceToken];
    });
}


- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    
    NSLog(@"注册远程通知失败: %@", error);
    
}



#pragma mark - life
- (void)applicationWillResignActive:(UIApplication *)application {
    
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    
}


- (void)applicationWillTerminate:(UIApplication *)application {
    
    [self saveContext];
}







#pragma mark - 通知
//iOS10以下后台使用这个方法接收通知
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    
    [UMessage didReceiveRemoteNotification:userInfo];
    

    if (userInfo) {
        
        [WJYAlertView showOneButtonWithTitle:@"4iOS10以下使用这个方法接收通知" Message:userInfo.description ButtonType:WJYAlertViewButtonTypeCancel ButtonTitle:@"123" Click:^{
            
        }];
        
    }
}


//iOS10新增：处理前台收到通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    
    NSDictionary * userInfo = notification.request.content.userInfo;
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于前台时的远程推送接受
        //关闭U-Push自带的弹出框
        [UMessage setAutoAlert:NO];
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        
        [WJYAlertView showOneButtonWithTitle:@"2_iOS10新增：处理前台收到通知的代理方法" Message:userInfo.description ButtonType:WJYAlertViewButtonTypeCancel ButtonTitle:@"123" Click:^{
            
        }];
        
    }else{
        //应用处于前台时的本地推送接受
    }
    //当应用处于前台时提示设置，需要哪个可以设置哪一个
    completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
}

//iOS10新增：处理后台点击通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
    
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        
        //应用处于后台时的远程推送接受
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        
        
        [WJYAlertView showOneButtonWithTitle:@"3_iOS10新增：处理后台点击通知的代理方法" Message:userInfo.description ButtonType:WJYAlertViewButtonTypeCancel ButtonTitle:@"123" Click:^{
            
        }];
        
    }else{
        //应用处于后台时的本地推送接受
    }
    
    
}




#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"PLMMPRJK"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                     */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

- (void)setLaunchOptions:(NSDictionary *)launchOptions
{
    _launchOptions = launchOptions;
    
    //配置DDLog
    [DDLog addLogger:[DDTTYLogger sharedInstance]]; // TTY = Xcode console
    [DDLog addLogger:[DDASLLogger sharedInstance]]; // ASL = Apple System Logs
    
    
    
    // 友盟
    [MPUmengHelper UMAnalyticStart];
    [MPUmengHelper UMSocialStart];
    [MPUmengHelper UMPushStart:launchOptions];
}

@end
