//
//  UMSocialTaskManager.h
//  UMSocialSDK
//
//  Created by 张军华 on 16/8/12.
//  Copyright © 2016年 dongjianxiong. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UMSocialTask;
@class UMSocialTaskOperation;

NS_ASSUME_NONNULL_BEGIN

/**
 *  所有task的管理类
 */
@interface UMSocialTaskManager : NSObject

+(instancetype)shareManager;

/**
 *  创建好task直接执行task
 *
 *  @param task @see UMSocialTask
 */
-(void)addAndExcuteSocialTask:(UMSocialTask*)task;

@end

NS_ASSUME_NONNULL_END
