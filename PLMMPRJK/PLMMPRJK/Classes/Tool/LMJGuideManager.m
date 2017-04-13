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
    
    NSArray <NSString *> *imagesURLS = @[@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1492065129100&di=806501f009bc2ed7f66f5a4c14bf7ef5&imgtype=0&src=http%3A%2F%2Fi6.hexunimg.cn%2F2016-01-05%2F181610293.jpg", @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1492065176573&di=e92995ed544feb29d5d0fcd87cbdb4e8&imgtype=0&src=http%3A%2F%2Fhycstatics.b0.upaiyun.com%2Fuploads%2Fredactor%2F5093%2Fg1vg1azsv29z.png", @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1492065176574&di=723abf48305febba636554de3c862995&imgtype=0&src=http%3A%2F%2Fbbs.goldzhan.com%2Fdata%2Fattachment%2Fforum%2F201509%2F01%2F164634a73dxnr9l3rdzu37.jpeg"];
    
    
    [AdvertiseHelper showAdvertiserView:imagesURLS];
    
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
