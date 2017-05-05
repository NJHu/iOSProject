//
//  LMJBaseResponse.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/4/24.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJBaseResponse.h"

@implementation LMJBaseResponse


NSString *const LMJBaseResponseSystemErrorMsgKey = @"LMJBaseResponseSystemErrorMsgKey";

NSString *const LMJBaseResponseCustomErrorMsgKey = @"LMJBaseResponseCustomErrorMsgKey";



- (NSString *)description
{
    return [NSString stringWithFormat:@"\n状态吗: %zd,\n错误: %@,\n响应头: %@,\n响应体: %@", self.statusCode, self.error, self.headers, self.responseObject];
}

@end
