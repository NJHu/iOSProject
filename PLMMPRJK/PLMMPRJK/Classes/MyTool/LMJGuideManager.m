//
//  LMJGuideMananger.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/4/6.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJGuideManager.h"
#import "LMJTabBarController.h"


@implementation LMJGuideManager


- (void)setKeyWindow:(UIWindow *)keyWindow
{
    
    keyWindow.rootViewController = [[LMJTabBarController alloc] init];

    
    if (![GVUserDefaults standardUserDefaults].isNoFirstLaunch) {
        
        [introductoryPagesHelper showIntroductoryPageView:@[@"wishPage_1.gif", @"wishPage_2.gif", @"wishPage_3.gif", @"wishPage_4.gif"]];
        
        BBUserDefault.isNoFirstLaunch = YES;
    }
    
    NSArray <NSString *> *imagesURLS = @[@"http://img.zcool.cn/community/01822357bbc7ef0000018c1b0dd7da.gif", @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1494930801&di=073a9246f1b571fac4ad6a5065801300&imgtype=jpg&er=1&src=http%3A%2F%2Fimg.zcool.cn%2Fcommunity%2F0128f957d274250000012e7efe7de4.gif"];
    
    
    [AdvertiseHelper showAdvertiserView:imagesURLS];
    
    
    [kKeyWindow addSubview:[[YYFPSLabel alloc] initWithFrame:CGRectMake(20, 70, 0, 0)]];
}

- (void)setupOnce
{
    
    
}



#pragma mark - 单例


- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self setupOnce];
    }
    return self;
}

static id _instance = nil;
+ (instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _instance = [[self alloc] init];
        
        
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
