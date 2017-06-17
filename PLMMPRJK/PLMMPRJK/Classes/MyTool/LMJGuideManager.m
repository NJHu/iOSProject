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
    
    NSArray <NSString *> *imagesURLS = @[@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1495189872684&di=03f9df0b71bb536223236235515cf227&imgtype=0&src=http%3A%2F%2Fatt1.dzwww.com%2Fforum%2F201405%2F29%2F1033545qqmieznviecgdmm.gif", @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1495189851096&di=224fad7f17468c2cc080221dd78a4abf&imgtype=0&src=http%3A%2F%2Fimg3.duitang.com%2Fuploads%2Fitem%2F201505%2F12%2F20150512124019_GPjEJ.gif"];
    
    
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
