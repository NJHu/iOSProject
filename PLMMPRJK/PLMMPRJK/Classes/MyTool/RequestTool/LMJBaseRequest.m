//
//  LMJBaseRequest.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/4/24.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJBaseRequest.h"

NSString *const LMJBaseRequestURL = @"http://120.25.226.186:32812";

@implementation LMJBaseRequest


- (void)GET:(NSString *)URLString parameters:(id)parameters completion:(void(^)(LMJBaseResponse *response))completion
{
    if ([LMJRequestManager sharedManager].currentNetworkStatus == AFNetworkReachabilityStatusNotReachable) {
        
        LMJBaseResponse *response = [LMJBaseResponse new];
        response.statusCode = LMJRequestManagerStatusCodeNoReachable;
        response.error = [NSError errorWithDomain:NSNetServicesErrorDomain code:LMJRequestManagerStatusCodeNoReachable userInfo:@{LMJBaseResponseSystemErrorMsgKey : @"网络无法连接"}];
        
        completion(response);
        
        return;
    }
    
    LMJWeakSelf(self);
    [[LMJRequestManager sharedManager] GET:URLString parameters:parameters completion:^(LMJBaseResponse *response) {
        
        if (!weakself) {
            return ;
        }
        
        
        !completion ?: completion(response);
        
    }];
}

- (void)POST:(NSString *)URLString parameters:(id)parameters completion:(void(^)(LMJBaseResponse *response))completion
{
    if ([LMJRequestManager sharedManager].currentNetworkStatus == AFNetworkReachabilityStatusNotReachable) {
        
        LMJBaseResponse *response = [LMJBaseResponse new];
        response.statusCode = LMJRequestManagerStatusCodeNoReachable;
        response.error = [NSError errorWithDomain:NSNetServicesErrorDomain code:LMJRequestManagerStatusCodeNoReachable userInfo:@{LMJBaseResponseSystemErrorMsgKey : @"网络无法连接"}];
        
        completion(response);
        
        return;
    }
    
    LMJWeakSelf(self);
    [[LMJRequestManager sharedManager] POST:URLString parameters:parameters completion:^(LMJBaseResponse *response) {
        
        if (!weakself) {
            return ;
        }
        
        
        !completion ?: completion(response);
        
    }];
}



@end
