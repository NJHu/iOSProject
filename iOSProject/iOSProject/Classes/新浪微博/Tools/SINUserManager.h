//
//  SINUserManager.h
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/6/20.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SINUserManager : NSObject

+ (instancetype)sharedManager;

/** 是否登录了 */
@property (assign, nonatomic) BOOL isLogined;

/** 昵称 */
@property (nonatomic, copy) NSString *name;

/** 过期时间 */
@property (nonatomic, strong) NSDate *expiration;

/** accessToken */
@property (nonatomic, copy) NSString *accessToken;

/** 头像 */
@property (nonatomic, copy) NSString *iconurl;

/** 用户 ID */
@property (nonatomic, copy) NSString *uid;


// 归档
- (void)saveToFile;

- (void)sinaLogin:(void(^)(NSError *error))completion;

@end
