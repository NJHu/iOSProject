//
//  LMJBaseRequest.h
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/4/24.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LMJBaseRequest;
@class LMJBaseResponse;
@protocol LMJBaseRequestDataSource <NSObject>

@required
- (NSDictionary *)requestParameters:(LMJBaseRequest *)request;

- (NSString *)requestURL:(LMJBaseRequest *)request;

@end

@interface LMJBaseRequest : NSObject<LMJBaseRequestDataSource>

- (void)GET:(void(^)(LMJBaseResponse *response))completion;

- (void)POST:(void(^)(LMJBaseResponse *response))completion;

@end
