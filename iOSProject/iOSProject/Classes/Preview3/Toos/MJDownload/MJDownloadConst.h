//
//  MJDownloadConst.h
//  MJDownloadExample
//
//  Created by MJ Lee on 15/7/16.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//
#import <Foundation/Foundation.h>

/******** 通知 Begin ********/
/** 下载进度发生改变的通知 */
extern NSString * const MJDownloadProgressDidChangeNotification;
/** 下载状态发生改变的通知 */
extern NSString * const MJDownloadStateDidChangeNotification;
/** 利用这个key从通知中取出对应的MJDownloadInfo对象 */
extern NSString * const MJDownloadInfoKey;

#define MJDownloadNoteCenter [NSNotificationCenter defaultCenter]
/******** 通知 End ********/