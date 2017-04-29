//
//  LMJBaseRequest.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/4/24.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJBaseRequest.h"

@implementation LMJBaseRequest

- (NSDictionary *)requestParameters:(LMJBaseRequest *)request
{
    NSAssert(0, @"需要重写");
    return nil;
}



- (NSString *)requestURL:(LMJBaseRequest *)request
{
    NSAssert(0, @"需要重写");
    return nil;
}

- (void)GET:(void (^)(LMJBaseResponse *))completion
{
    [[LMJRequestManager sharedManager] GET:[self requestURL:self] parameters:[self requestParameters:self] completion:completion];
}

- (void)POST:(void (^)(LMJBaseResponse *))completion
{
    [[LMJRequestManager sharedManager] POST:[self requestURL:self] parameters:[self requestParameters:self] completion:completion];
}

@end
