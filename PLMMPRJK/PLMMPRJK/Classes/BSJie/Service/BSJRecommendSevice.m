//
//  BSJRecommendSevice.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/5/14.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "BSJRecommendSevice.h"


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
            
            
            
        }
        
        
        completion(response.error);
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
