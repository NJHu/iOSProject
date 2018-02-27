//
//  NJDownLoadHelper.m
//  iOSProject
//
//  Created by HuXuPeng on 2018/2/26.
//  Copyright © 2018年 github.com/njhu. All rights reserved.
//

#import "NJDownLoadHelper.h"
#import <NSString+YYAdd.h>

static NSString *const NJDownLoadDirName_ = @"NJ_Download_Files";
static NSString *NJDownloadFilesDirPath_ = nil;

@implementation NJDownLoadHelper

+ (void)load {
    NSFileManager *fileManager = [NSFileManager defaultManager];
   NSString *dirPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:NJDownLoadDirName_];
    BOOL isDir = NO;
    if (![fileManager fileExistsAtPath:dirPath isDirectory:&isDir]) {
        [fileManager createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:nil];
    } else {
        if (!isDir) {
             [fileManager createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
    }
    NJDownloadFilesDirPath_ = dirPath;
}

@end

NSMutableDictionary *nj_getCachesRecord() {
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:[NJDownloadFilesDirPath_ stringByAppendingPathComponent:(@"NJ_CONTENT_DOWNLOAD_DATA_CACHES_PLISTFILE_NAME")]];
    if (!dict) {
        dict = [NSMutableDictionary dictionary];
    }
    return dict;
}

NSString * nj_getFileName(NSString *taskUrl) {
    return taskUrl.md5String;
}

NSString * nj_getFilePath(NSString *taskUrl) {
    return [NJDownloadFilesDirPath_ stringByAppendingPathComponent:nj_getFileName(taskUrl)];
}

NSInteger nj_getExpectedContentLength(NSString *taskUrl, BOOL *isHaveCacheThisTaskUrl) {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (isHaveCacheThisTaskUrl) {
        *isHaveCacheThisTaskUrl = [fileManager fileExistsAtPath:nj_getFilePath(taskUrl)];
    }
    return [nj_getCachesRecord()[nj_getFileName(taskUrl)] integerValue];
}

void nj_saveExpectedContentLength(NSString *taskUrl, NSInteger expectedContentLength) {
    NSMutableDictionary *caches = nj_getCachesRecord();
    caches[nj_getFileName(taskUrl)] = @(expectedContentLength);
    [caches writeToFile:[NJDownloadFilesDirPath_ stringByAppendingPathComponent:(@"NJ_CONTENT_DOWNLOAD_DATA_CACHES_PLISTFILE_NAME")] atomically:YES];
}

NSInteger nj_getCompleteContentLength(NSString *taskUrl, BOOL *isHaveCacheThisTaskUrl) {
    if (isHaveCacheThisTaskUrl) {
    *isHaveCacheThisTaskUrl = [[NSFileManager defaultManager] fileExistsAtPath:nj_getFilePath(taskUrl)];
    }
    return [[[NSFileManager defaultManager] attributesOfItemAtPath:nj_getFilePath(taskUrl) error:nil][NSFileSize] integerValue];
}

