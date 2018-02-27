//
//  NJDownloadManager.m
//  iOSProject
//
//  Created by HuXuPeng on 2018/2/26.
//  Copyright © 2018年 github.com/njhu. All rights reserved.
//

#import "NJDownloadManager.h"

@implementation NJDownloadManager


- (void)configSettings {
    
    
}

- (NSMutableDictionary<NSString *,NJDownloadOffLineTask *> *)downloadTasksPool
{
    if(!_downloadTasksPool)
    {
        _downloadTasksPool = [NSMutableDictionary dictionary];
    }
    return _downloadTasksPool;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configSettings];
    }
    return self;
}

static id instance_ = nil;
+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance_ = [[self alloc] init];
    });
    return instance_;
}

@end
