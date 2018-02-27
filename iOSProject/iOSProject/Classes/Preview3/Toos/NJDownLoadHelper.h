//
//  NJDownLoadHelper.h
//  iOSProject
//
//  Created by HuXuPeng on 2018/2/26.
//  Copyright © 2018年 github.com/njhu. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 获取文件名
 */
NSString * nj_getFileName(NSString *taskUrl);

/**
 获取文件路径
 */
NSString * nj_getFilePath(NSString *taskUrl);


/**
 获取需要下载的文件总大小
 */
NSInteger nj_getExpectedContentLength(NSString *taskUrl, BOOL *isHaveCacheThisTaskUrl);


/**
 储存需要下载的文件总大小
 */
void nj_saveExpectedContentLength(NSString *taskUrl, NSInteger expectedContentLength);

/**
 获取已经下载的文件大小
 */
NSInteger nj_getCompleteContentLength(NSString *taskUrl, BOOL *isHaveCacheThisTaskUrl);


@interface NJDownLoadHelper : NSObject

@end
