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
    return [NSString stringWithFormat:@"%zd, %@, %@, %@", self.statusCode, self.error, self.headers, self.data];
}

@end
