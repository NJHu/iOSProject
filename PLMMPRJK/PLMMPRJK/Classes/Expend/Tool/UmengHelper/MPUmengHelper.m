//
//  MPUmengHelper.m
//  MobileProject
//
//  Created by wujunyang on 16/1/15.
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#import "MPUmengHelper.h"

@implementation MPUmengHelper

+ (void)UMAnalyticStart {

    UMConfigInstance.appKey=kUmengKey;
    UMConfigInstance.channelId=@"App Store";
    [MobClick startWithConfigure:UMConfigInstance];
    // version标识
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    
#if DEBUG
    // 打开友盟sdk调试，注意Release发布时需要注释掉此行,减少io消耗
    [MobClick setLogEnabled:YES];
#endif
    return;
}

+ (void)beginLogPageView:(__unsafe_unretained Class)pageView {
    [MobClick beginLogPageView:NSStringFromClass(pageView)];
    return;
}

+ (void)endLogPageView:(__unsafe_unretained Class)pageView {
    [MobClick endLogPageView:NSStringFromClass(pageView)];
    return;
}

+(void)beginLogPageViewName:(NSString *)pageViewName
{
    [MobClick beginLogPageView:pageViewName];
    return;
}

+(void)endLogPageViewName:(NSString *)pageViewName
{
    [MobClick endLogPageView:pageViewName];
    return;
}

@end
