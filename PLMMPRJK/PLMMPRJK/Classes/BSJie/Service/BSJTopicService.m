//
//  BSJTopicService.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/5/18.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "BSJTopicService.h"

@interface BSJTopicService ()

/** <#digest#> */
@property (assign, nonatomic) NSInteger currentPage;

/** <#digest#> */
@property (nonatomic, copy) NSString *maxtime;

@end

@implementation BSJTopicService



- (void)getTopicIsMore:(BOOL)isMore typeA:(NSString *)typeA topicType:(NSInteger)topicType completion:(void(^)(NSError *error, NSInteger totalCount, NSInteger currentCount))completion
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    
    NSInteger page = isMore ? (self.currentPage + 1) : 1;
    
    
    parameters[@"a"] = typeA ?: @"";
    parameters[@"c"] = @"data";
    parameters[@"type"] = @(topicType);
    parameters[@"maxtime"] = isMore ? self.maxtime : @"";
    parameters[@"per"] = @10;
    
    [self GET:BSJBaiSiJieHTTPAPI parameters:parameters completion:^(LMJBaseResponse *response) {
        
        if (response.error) {
            completion(response.error, 0, 0);
            return ;
        }
        
        
        if (!isMore) {
            
            [self.topicViewModels removeAllObjects];
        }
        
        self.currentPage = page;
        
        self.maxtime = [response.responseObject[@"info"][@"maxtime"] copy];
        
        
        NSMutableArray<BSJTopicViewModel *> *newTopicViewModels = [NSMutableArray array];
        
        
        [[BSJTopic mj_objectArrayWithKeyValuesArray:response.responseObject[@"list"]] enumerateObjectsUsingBlock:^(BSJTopic  *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            [newTopicViewModels addObject:[BSJTopicViewModel viewModelWithTopic:obj]];
            
        }];
        
        [self.topicViewModels addObjectsFromArray:newTopicViewModels];
        
        
        completion(nil, [response.responseObject[@"count"] integerValue], self.topicViewModels.count);
    }];
    
    
}



- (NSMutableArray<BSJTopicViewModel *> *)topicViewModels
{
    if(_topicViewModels == nil)
    {
        _topicViewModels = [NSMutableArray array];
    }
    return _topicViewModels;
}

@end
