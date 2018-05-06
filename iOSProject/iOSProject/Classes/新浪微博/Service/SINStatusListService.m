//
//  SINStatusListService.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/6/21.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "SINStatusListService.h"
#import "SINDictURL.h"
#import "SINStatusListDAL.h"
#import "NSDecimalNumber+Addtion.h"

@interface SINStatusListService ()

@property (nonatomic, strong) id lastParams;

@end

@implementation SINStatusListService

- (void)getStatusList:(BOOL)isFresh complation:(void(^)(NSError *error, BOOL isEnd))completion {
    
    NSString *URL = @"https://api.weibo.com/2/statuses/home_timeline.json";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = [SINUserManager sharedManager].accessToken.copy;
    params[@"count"] = @"10";
    
    //    since_id	false	int64	若指定此参数，则返回ID比since_id大的微博（即比since_id时间晚的微博），默认为0。
    //    max_id	false	int64	若指定此参数，则返回ID小于或等于max_id的微博，默认为0。
    
    if (isFresh) {
        
        params[@"since_id"] = self.statusViewModels.firstObject.status.idstr ?: @"0";
        params[@"max_id"] = @"0";
        
    }else
    {
        params[@"since_id"] = @"0";
        params[@"max_id"] = self.statusViewModels.lastObject.status.idstr.length ? SNSub(self.statusViewModels.lastObject.status.idstr, @"1").stringValue : @"0";
    }
    
    self.lastParams = params;
    [SINStatusListDAL queryStatusListFromDiskWithSinceId:params[@"since_id"] maxId:params[@"max_id"] completion:^(NSMutableArray<NSMutableDictionary *> *dictArrayM) {
        if (self.lastParams != params) {
            return ;
        }
        
        if (dictArrayM.count >= 1) {
            [self dictConverModels:dictArrayM complation:^(NSError *error, NSMutableArray<SINStatusViewModel *> *statusViewModels) {
                if (self.lastParams != params) {
                    return ;
                }
                if (isFresh) {
                    [self.statusViewModels insertObjects:statusViewModels atIndex:0];
                }else{
                    [self.statusViewModels addObjectsFromArray:statusViewModels];
                }
                completion(nil, NO);
            }];
            
        }else
        {
            [self GET:URL parameters:params completion:^(LMJBaseResponse *response) {
                if (self.lastParams != params) {
                    return ;
                }
                if (response.error || !response.responseObject) {
                    completion(response.error, NO);
                    return ;
                }
                NSDictionary *responObj = response.responseObject;
                NSLog(@"%@", response.responseObject);
                
                [SINStatusListDAL cachesStatusList:responObj[@"statuses"]];
                [self dictConverModels:responObj[@"statuses"] complation:^(NSError *error, NSMutableArray<SINStatusViewModel *> *statusViewModels) {
                    if (self.lastParams != params) {
                        return ;
                    }
                    if (isFresh) {
                        [self.statusViewModels insertObjects:statusViewModels atIndex:0];
                    }else{
                        [self.statusViewModels addObjectsFromArray:statusViewModels];
                    }
                    completion(nil, (SNCompare(@(self.statusViewModels.count), responObj[@"total_number"])) != LMJXY);
                }];
            }];
        }
    }];
}


- (void)dictConverModels:(NSMutableArray<NSMutableDictionary *> *)dictArray complation:(void(^)(NSError *error, NSMutableArray<SINStatusViewModel *>  *statusViewModels))completion
{
    
    NSMutableArray<SINStatus *> *statuses = [SINStatus mj_objectArrayWithKeyValuesArray:dictArray];
    
    NSMutableArray<SINStatusViewModel *> *statusViewModels = [NSMutableArray array];
    
    [statuses enumerateObjectsUsingBlock:^(SINStatus * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [statusViewModels addObject:[SINStatusViewModel statusModelWithStatus:obj]];
    }];
    
    completion(nil, statusViewModels);
    
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        [SINStatusListDAL clearOutTimeCashes];
    }
    return self;
}

- (NSMutableArray<SINStatusViewModel *> *)statusViewModels
{
    if(_statusViewModels == nil)
    {
        _statusViewModels = [NSMutableArray array];
    }
    return _statusViewModels;
}

@end
