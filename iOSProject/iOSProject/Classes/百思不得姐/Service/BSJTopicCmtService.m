//
//  BSJTopicCmtService.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/6/4.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "BSJTopicCmtService.h"
#import "BSJ.h"


@interface BSJTopicCmtService ()

/** <#digest#> */
@property (assign, nonatomic) NSInteger cmtPage;

/** <#digest#> */
@property (nonatomic, strong) NSDictionary *latestParams;

@end

@implementation BSJTopicCmtService


- (void)getCmtsWithTopicID:(NSString *)topicID isMore:(BOOL)isMore completion:(void(^)(NSError *error,BOOL isHaveNextPage))completion
{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"a"] = @"dataList";
    params[@"c"] = @"comment";
    // 加载哪一个帖子的评论
    params[@"data_id"] = topicID.copy;
    
    
    // 加载热评贴的确认参数
    if (!isMore) {
        params[@"hot"] = @"1";
    }else
    {
        params[@"lastcid"] = self.latestCmts.lastObject.ID.copy;
    }
    
    
    
    NSInteger page = isMore ? (self.cmtPage + 1) : 0;
    params[@"page"] = @(page);
    
    self.latestParams = params;
    [self GET:BSJBaiSiJieHTTPAPI parameters:params completion:^(LMJBaseResponse *response) {
        // 用户上拉后有快速下拉, 下拉的数据先回来, 上拉的数据后回来
        if (self.latestParams != params) {
            return;
        }
        
        
        // 数据是空的时候不是字典了
        if (![response.responseObject isKindOfClass:[NSDictionary class]]) {
            response.error = [NSError errorWithDomain:NSGlobalDomain code:-1 userInfo:nil];
            completion(response.error, YES);
            return;
        }
        
        if (!response.responseObject || response.error) {
            completion(response.error, YES);
            return;
        }
        
        
        //记录页码
        self.cmtPage = page;
        
        
        if (!isMore) {
            [self.hotCmts removeAllObjects];
            [self.latestCmts removeAllObjects];
        }
        
        if (!isMore) {
            [self.hotCmts addObjectsFromArray:[BSJComment mj_objectArrayWithKeyValuesArray:response.responseObject[@"hot"]]];
        }
        
        
        [self.latestCmts addObjectsFromArray:[BSJComment mj_objectArrayWithKeyValuesArray:response.responseObject[@"data"]]];
        
        completion(nil, [response.responseObject[@"total"] integerValue] > self.latestCmts.count);
        
    }];
}


- (NSMutableArray<BSJComment *> *)latestCmts
{
    if(_latestCmts == nil)
    {
        _latestCmts = [NSMutableArray array];
    }
    return _latestCmts;
}


- (NSMutableArray<BSJComment *> *)hotCmts
{
    if(_hotCmts == nil)
    {
        _hotCmts = [NSMutableArray array];
    }
    return _hotCmts;
}

@end
