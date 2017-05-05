//
//  LMJRequestManager.h
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/4/24.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum : NSUInteger {
    LMJRequestManagerStatusCodeSuccess,
    LMJRequestManagerStatusCodeNoReachable,
} LMJRequestManagerStatusCode;

typedef LMJBaseResponse *(^ResponseFormat)(LMJBaseResponse *response);


@interface LMJRequestManager : AFHTTPSessionManager


+ (instancetype)sharedManager;


//本地数据模式
@property (assign, nonatomic) BOOL isLocal;

//预处理返回的数据
@property (copy, nonatomic) ResponseFormat responseFormat;


//当前的网络状态
@property (assign, nonatomic) AFNetworkReachabilityStatus currentNetworkStatus;



- (void)POST:(NSString *)urlString parameters:(id)parameters completion:(void (^)(LMJBaseResponse *response))completion;

- (void)GET:(NSString *)urlString parameters:(id)parameters completion:(void (^)(LMJBaseResponse *response))completion;

/**
  data 对应的二进制数据
  name 服务端需要参数
 */
- (void)upload:(NSString *)urlString parameters:(id)parameters formDataBlock:(void(^)(id<AFMultipartFormData> formData))formDataBlock progress:(void (^)(NSProgress *progress))progress completion:(void (^)(LMJBaseResponse *response))completion;


@end
