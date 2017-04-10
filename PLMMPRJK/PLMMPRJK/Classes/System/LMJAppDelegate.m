//
//  LMJAppDelegate.m
//  PLMMPRJK
//
//  Created by NJHu on 2017/3/29.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJAppDelegate.h"
#import "LMJActivityViewController.h"




@interface LMJAppDelegate ()

@end

@implementation LMJAppDelegate

- (UIWindow *)window
{
    if(!_window)
    {
        _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [_window makeKeyAndVisible];
    }
    return _window;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [LMJGuideManager sharedManager].keyWindow = self.window;
    
    //配置DDLog
    [DDLog addLogger:[DDTTYLogger sharedInstance]]; // TTY = Xcode console
    [DDLog addLogger:[DDASLLogger sharedInstance]]; // ASL = Apple System Logs
    
    // 友盟统计
    // UM统计
    UMConfigInstance.appKey = CFPThirdSDKManagerUMConfigInstanceAppKey;
    UMConfigInstance.channelId = CFPThirdSDKManagerUMConfigInstanceChannelId;
    
    [MobClick setAppVersion:appMPVersion];
    [MobClick startWithConfigure:UMConfigInstance];//配置以上参数后调用此方法初始化SDK！
    /** 设置是否开启background模式, 默认YES. */
    //    [MobClick setBackgroundTaskEnabled:YES];
    
    // 友盟分享
    
    //设置友盟appkey
    [[UMSocialManager defaultManager] setUmSocialAppkey:CFPThirdSDKManagerUMSocialAppkey];
    
    // 获取友盟social版本号
    //NSLog(@"UMeng social version: %@", [UMSocialGlobal umSocialSDKVersion]);
    
    //设置微信的appKey和appSecret
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:CFPThirdSDKManagerWeChatAppKey appSecret:CFPThirdSDKManagerWeChatAppSecret redirectURL:CFPThirdSDKManagerWeChatRedirectURL];
    
    
    //设置分享到QQ互联的appKey和appSecret
    //    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:CFPThirdSDKManagerQQAppKey  appSecret:CFPThirdSDKManagerQQAppSecret redirectURL:CFPThirdSDKManagerQQRedirectURL];
    //
    //    //设置新浪的appKey和appSecret
    //    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:CFPThirdSDKManagerSinaAppKey  appSecret:CFPThirdSDKManagerSinaAppSecret redirectURL:CFPThirdSDKManagerSinaRedirectURL];
    
    // 如果不想显示平台下的某些类型，可用以下接口设置
    [[UMSocialManager defaultManager] removePlatformProviderWithPlatformTypes:@[@(UMSocialPlatformType_AlipaySession),@(UMSocialPlatformType_YixinSession),@(UMSocialPlatformType_LaiWangSession), @(UMSocialPlatformType_Linkedin), @(UMSocialPlatformType_Twitter), @(UMSocialPlatformType_Sina), @(UMSocialPlatformType_WechatFavorite), @(UMSocialPlatformType_QQ), @(UMSocialPlatformType_Qzone), @(UMSocialPlatformType_TencentWb)]];
    

    
    // 魔窗
    [MWApi registerApp:kMagicWindowKey];
    
    [MWApi registerMLinkHandlerWithKey:@"test1Key" handler:^(NSURL *url, NSDictionary *params) {
        
        if ([params[@"url"] length] == 0) {
            return ;
        }
        
        
        Log(@"%@\n\n%@", url.absoluteString, params);
        
        
        [SVProgressHUD showSuccessWithStatus:params.description];
        
        //跳转到app展示页，示例如下：
        LMJActivityViewController *activityWebVc = [[LMJActivityViewController alloc] init];
        
        
        activityWebVc.gotoURL = params[@"url"];
        

        
        [kKeyWindow.rootViewController.childViewControllers.firstObject.childViewControllers.firstObject.navigationController pushViewController:activityWebVc animated:NO];
    }];
    
    return YES;
}



#pragma mark - 魔窗
- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray * _Nullable))restorationHandler
{
    //如果使用了Universal link ，此方法必写
    return [MWApi continueUserActivity:userActivity];
}




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

//iOS9以下
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    //必写
    [MWApi routeMLink:url];
    return YES;
}
//iOS9+
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(nonnull NSDictionary *)options
{
    //必写
    [MWApi routeMLink:url];
    return YES;
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

@end
