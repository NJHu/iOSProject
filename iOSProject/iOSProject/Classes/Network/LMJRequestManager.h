//
//  LMJRequestManager.h
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/4/24.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LMJBaseResponse.h"
#import <AFNetworking.h>

typedef NSString LMJDataName;

typedef enum : NSInteger {
    // 自定义错误码
    LMJRequestManagerStatusCodeCustomDemo = -10000,
} LMJRequestManagerStatusCode;

typedef LMJBaseResponse *(^ResponseFormat)(LMJBaseResponse *response);

@interface LMJRequestManager : AFHTTPSessionManager

+ (instancetype)sharedManager;

//本地数据模式
@property (assign, nonatomic) BOOL isLocal;

//预处理返回的数据
@property (copy, nonatomic) ResponseFormat responseFormat;

// https 验证
@property (nonatomic, copy) NSString *cerFilePath;

- (void)POST:(NSString *)urlString parameters:(id)parameters completion:(void (^)(LMJBaseResponse *response))completion;

- (void)GET:(NSString *)urlString parameters:(id)parameters completion:(void (^)(LMJBaseResponse *response))completion;

/*
  上传
   data 数据对应的二进制数据
   LMJDataName data对应的参数
 */
- (void)upload:(NSString *)urlString parameters:(id)parameters formDataBlock:(NSDictionary<NSData *, LMJDataName *> *(^)(id<AFMultipartFormData> formData, NSMutableDictionary<NSData *, LMJDataName *> *needFillDataDict))formDataBlock progress:(void (^)(NSProgress *progress))progress completion:(void (^)(LMJBaseResponse *response))completion;

@end
