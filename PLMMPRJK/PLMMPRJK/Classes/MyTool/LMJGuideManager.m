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
    
    NSArray <NSString *> *imagesURLS = @[@"http://lxc66188.blog.163.com/blog/#m=0", @"http://image68.360doc.com/DownloadImg/2014/02/1107/39016758_8.gif", @"http://image68.360doc.com/DownloadImg/2014/02/1107/39016758_19.gif"];
    
    
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
