//
//  LMJBlockLoopOperation.h
//  iOSProject
//
//  Created by HuXuPeng on 2018/1/2.
//  Copyright © 2018年 HuXuPeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LMJBlockLoopOperation : NSObject

+ (void)operateWithSuccessBlock:(void(^)(void))successBlock;

/** <#digest#> */
@property (nonatomic, copy) NSString *address;

/** <#digest#> */
@property (nonatomic, copy) void(^logAddress)(NSString *address);

@end
