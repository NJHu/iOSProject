//
//  NJDownloadManager.h
//  iOSProject
//
//  Created by HuXuPeng on 2018/2/26.
//  Copyright © 2018年 github.com/njhu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NJDownloadOffLineTask.h"

@interface NJDownloadManager : NSObject

/** <#digest#> */
@property (nonatomic, strong) NSMutableDictionary<NSString *, NJDownloadOffLineTask *> *downloadTasksPool;


+ (instancetype)sharedManager;

@end
