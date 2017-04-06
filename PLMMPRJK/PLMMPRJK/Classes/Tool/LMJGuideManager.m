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
