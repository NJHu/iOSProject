//
//  LMJDownloadVideosService.h
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/5/7.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJBaseRequest.h"

@class LMJXGMVideo;
@interface LMJDownloadVideosService : LMJBaseRequest

/** <#digest#> */
@property (nonatomic, strong) NSMutableArray<LMJXGMVideo *> *videos;

- (void)getVideos:(BOOL)isMore success:(void(^)(NSInteger totalPage, NSInteger curPage))success failure:(void(^)(NSError *error))failure;

@end
