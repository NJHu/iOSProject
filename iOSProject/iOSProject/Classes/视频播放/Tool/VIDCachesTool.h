//
//  VIDCachesTool.h
//  iOSProject
//
//  Created by HuXuPeng on 2018/4/23.
//  Copyright © 2018年 github.com/njhu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJDownload.h"

@interface VIDCachesTool : NSObject

+ (instancetype)sharedTool;

/** <#digest#> */
@property (nonatomic, strong) MJDownloadManager *downloadManager;

@end
