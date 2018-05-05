//
//  VIDCachesTool.m
//  iOSProject
//
//  Created by HuXuPeng on 2018/4/23.
//  Copyright © 2018年 github.com/njhu. All rights reserved.
//

#import "VIDCachesTool.h"

static NSString *const VIDCachesToolId = @"VIDCachesToolId";

@interface VIDCachesTool ()
{
    NSMutableArray<NSString *> *_cachesUrls;
}
@end

@implementation VIDCachesTool

- (void)downLoad:(NSString *)url {
    [_cachesUrls addObject:url.copy];
    [self.downloadManager download:url];
    [_cachesUrls writeToFile:self.filePath atomically:YES];
}

- (void)deleteFile:(NSString *)url {
    [_cachesUrls enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isEqualToString:url]) {
            [self->_cachesUrls removeObject:obj];
        }
    }];
    
    [self.downloadManager.downloadInfoArray removeObject:[self.downloadManager downloadInfoForURL:url]];
    [_cachesUrls writeToFile:self.filePath atomically:YES];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _cachesUrls = [NSMutableArray arrayWithContentsOfFile:self.filePath];
        
        if (!_cachesUrls) {
            [[NSFileManager defaultManager] createDirectoryAtPath:[self.filePath stringByDeletingLastPathComponent] withIntermediateDirectories:YES attributes:nil error:nil];
            _cachesUrls = [NSMutableArray array];
            // 写入文件
            [_cachesUrls writeToFile:self.filePath atomically:YES];
        }
        
        [_cachesUrls enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.downloadManager downloadInfoForURL:obj];
        }];
    }
    return self;
}

- (NSString *)filePath
{
    NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:@"videoDownload/downloadData.plist"];
    return filePath;
}

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
