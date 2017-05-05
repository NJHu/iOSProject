//
//  LMJBaseRequest.h
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/4/24.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import <Foundation/Foundation.h>

UIKIT_EXTERN NSString *const LMJBaseRequestURL;

@class LMJBaseResponse;

@interface LMJBaseRequest : NSObject


- (void)GET:(NSString *)URLString parameters:(id)parameters completion:(void(^)(LMJBaseResponse *response))completion;


- (void)POST:(NSString *)URLString parameters:(id)parameters completion:(void(^)(LMJBaseResponse *response))completion;


@end
