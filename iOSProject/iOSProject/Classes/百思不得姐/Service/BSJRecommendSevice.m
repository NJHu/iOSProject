//
//  BSJRecommendSevice.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/5/14.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "BSJRecommendSevice.h"
#import "BSJRecommendUser.h"


@interface BSJRecommendSevice ()

@end

@implementation BSJRecommendSevice


- (void)getRecommendCategorys:(void(^)(NSError *error))completion
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    parameters[@"a"] = @"category";
    parameters[@"c"] = @"subscribe";
    
    [self GET:BSJBaiSiJieHTTPAPI parameters:parameters completion:^(LMJBaseResponse *response) {
        
        if (!response.error) {
            [self.recommendCategorys removeAllObjects];
            self.recommendCategorys = [BSJRecommendCategory mj_objectArrayWithKeyValuesArray:response.responseObject[@"list"]];
            BSJRecommendCategory *defaultCategory = [BSJRecommendCategory new];
            defaultCategory.ID = @"";
            defaultCategory.name = @"全部";
            [self.recommendCategorys insertObject:defaultCategory atIndex:0];
            
        }
        completion(response.error);
    }];

}


- (void)getDefaultRecommendCategoryUserList:(BOOL)isMore completion:(void(^)(NSError *error))completion
{
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    parameters[@"a"] = @"friend_recommend";
    parameters[@"c"] = @"user";
    
    if (isMore) {
        parameters[@"last_flag"] = @"toplist";
        parameters[@"last_record"] = self.recommendCategorys.firstObject.users.lastObject.uid;
    }
    
    NSInteger page = isMore ? (self.recommendCategorys.firstObject.page + 1) : 1;
    
    [self GET:BSJBaiSiJieHTTPAPI parameters:parameters completion:^(LMJBaseResponse *response) {
        if (response.error) {
            completion(response.error);
            return ;
        }
        
        if (!isMore) {
            [self.recommendCategorys.firstObject.users removeAllObjects];
        }
        
        if (!LMJIsEmpty(response.responseObject)) {
            [self.recommendCategorys.firstObject.users addObjectsFromArray:[BSJRecommendUser mj_objectArrayWithKeyValuesArray:response.responseObject[@"top_list"]]];
        }
        
        self.recommendCategorys.firstObject.page = page;
        self.recommendCategorys.firstObject.totalPage = INFINITY;
        completion(nil);
    }];
}


- (void)getSelectedRecommendCategoryUserList:(BSJRecommendCategory *)category isMore:(BOOL)isMore completion:(void(^)(NSError *error))completion
{
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];

    NSInteger page = isMore ? (category.page + 1) : 1;
    
    parameters[@"a"] = @"list";
    parameters[@"c"] = @"subscribe";
    parameters[@"page"] = @(page);
    parameters[@"pagesize"] = @20;
    parameters[@"category_id"] = category.ID;
    
    [self GET:BSJBaiSiJieHTTPAPI parameters:parameters completion:^(LMJBaseResponse *response) {
        
        if (response.error) {
            NSLog(@"%@", response.error);
            completion(response.error);
            return ;
        }
        
        
        if (!isMore) {
            [category.users removeAllObjects];
        }
        
        if (!LMJIsEmpty(response.responseObject)) {
            [category.users addObjectsFromArray:[BSJRecommendUser mj_objectArrayWithKeyValuesArray:response.responseObject[@"list"]]];
        }
        
        category.page = [response.responseObject[@"next_page"] integerValue] - 1;
        category.totalPage = [response.responseObject[@"total_page"] integerValue];
        
        completion(nil);
    }];
}



- (NSMutableArray<BSJRecommendCategory *> *)recommendCategorys
{
    if(_recommendCategorys == nil)
    {
        _recommendCategorys = [NSMutableArray array];
    }
    return _recommendCategorys;
}

@end
