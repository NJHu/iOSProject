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
@property (nonatomic, copy) NSString *maxtime;

@end

@implementation BSJTopicService



- (void)getTopicIsMore:(BOOL)isMore typeA:(NSString *)typeA topicType:(NSInteger)topicType completion:(void(^)(NSError *error, NSInteger totalCount, NSInteger currentCount))completion
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    parameters[@"a"] = typeA;
    parameters[@"c"] = @"data";
    parameters[@"type"] = @(topicType);
    parameters[@"maxtime"] = isMore ? self.maxtime : nil;
    parameters[@"per"] = @10;
    
    [self GET:BSJBaiSiJieHTTPAPI parameters:parameters completion:^(LMJBaseResponse *response) {
        
        if (response.error) {
            completion(response.error, 0, 0);
            return ;
        }
        
        
        if (!isMore) {
            
            [self.topicViewModels removeAllObjects];
        }

        NSMutableArray<BSJTopicViewModel *> *newTopicViewModels = [NSMutableArray array];
        
        [[BSJTopic mj_objectArrayWithKeyValuesArray:response.responseObject[@"list"]] enumerateObjectsUsingBlock:^(BSJTopic  *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            [newTopicViewModels addObject:[BSJTopicViewModel viewModelWithTopic:obj]];
            
        }];
        
        [self.topicViewModels addObjectsFromArray:newTopicViewModels];
        
        self.maxtime = self.topicViewModels.lastObject.topic.t;
        
        completion(nil, [response.responseObject[@"info"][@"count"] integerValue], self.topicViewModels.count);
        
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
