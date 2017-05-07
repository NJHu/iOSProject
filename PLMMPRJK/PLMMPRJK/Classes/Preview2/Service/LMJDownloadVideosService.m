//
//  LMJDownloadVideosService.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/5/7.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJDownloadVideosService.h"
#import "LMJXGMVideo.h"

@interface LMJDownloadVideosService ()
/** <#digest#> */
@property (assign, nonatomic) NSInteger curVideoPage;
@end

@implementation LMJDownloadVideosService


- (void)getVideos:(BOOL)isMore success:(void(^)(NSInteger totalPage, NSInteger curPage))success failure:(void(^)(NSError *error))failure
{
    
    NSDictionary *parameters = @{@"type" : @"JSON"};
    
    NSInteger page = isMore ? (self.curVideoPage + 1) : 1;
    
    LMJWeakSelf(self);
    [self POST:[LMJBaseRequestURL stringByAppendingPathComponent:@"video"] parameters:parameters completion:^(LMJBaseResponse *response) {
        
        if (response.error) {
            
            failure(response.error);
            
            return ;
        }
        
        weakself.curVideoPage = page;
        
        if (!isMore) {
            [weakself.videos removeAllObjects];
        }
        
        [self.videos addObjectsFromArray:[LMJXGMVideo mj_objectArrayWithKeyValuesArray:response.responseObject[@"videos"]]];
        
        
        success(1, weakself.curVideoPage);
        
    }];
    
}


- (NSMutableArray<LMJXGMVideo *> *)videos
{
    if(_videos == nil)
    {
        _videos = [NSMutableArray array];
    }
    return _videos;
}

@end
