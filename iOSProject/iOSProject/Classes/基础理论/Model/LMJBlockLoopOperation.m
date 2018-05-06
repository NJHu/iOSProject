//
//  LMJBlockLoopOperation.m
//  iOSProject
//
//  Created by HuXuPeng on 2018/1/2.
//  Copyright © 2018年 HuXuPeng. All rights reserved.
//

#import "LMJBlockLoopOperation.h"

@implementation LMJBlockLoopOperation

+ (void)operateWithSuccessBlock:(void(^)(void))successBlock
{
    if (successBlock) {
        successBlock();
    }
}

- (void)setLogAddress:(void (^)(NSString *address))logAddress {
    _logAddress = logAddress;
    
    !_logAddress ?: _logAddress(self.address);
}

- (void)dealloc {
    NSLog(@"dealloc- %@", self.class);
}

@end
