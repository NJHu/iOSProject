//
//  VIDCachesTool.m
//  iOSProject
//
//  Created by HuXuPeng on 2018/4/23.
//  Copyright © 2018年 github.com/njhu. All rights reserved.
//

#import "VIDCachesTool.h"

static NSString *const VIDCachesToolId = @"VIDCachesToolId";

@implementation VIDCachesTool





#pragma mark - getter
+ (instancetype)sharedTool {
    static VIDCachesTool *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (MJDownloadManager *)downloadManager
{
    if(!_downloadManager)
    {
        _downloadManager = [MJDownloadManager managerWithIdentifier:VIDCachesToolId];
    }
    return _downloadManager;
}

@end
