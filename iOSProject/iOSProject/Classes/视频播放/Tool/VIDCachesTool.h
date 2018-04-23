//
//  VIDCachesTool.h
//  iOSProject
//
//  Created by HuXuPeng on 2018/4/23.
//  Copyright © 2018年 github.com/njhu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJDownload.h"
#define VIDSharedTool VIDCachesTool.sharedTool
#define VIDToolDownloadManager VIDSharedTool.downloadManager

@interface VIDCachesTool : NSObject

+ (instancetype)sharedTool;

@property (nonatomic, strong) MJDownloadManager *downloadManager;

// 缓存url
- (void)downLoad:(NSString *)url;

// 缓存url
- (void)deleteFile:(NSString *)url;

@end
