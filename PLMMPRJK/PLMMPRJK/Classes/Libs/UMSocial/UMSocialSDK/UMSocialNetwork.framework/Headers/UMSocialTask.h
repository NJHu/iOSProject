//
//  UMSocialTask.h
//  UMSocialSDK
//
//  Created by 张军华 on 16/8/11.
//  Copyright © 2016年 dongjianxiong. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "UMSocialTaskConfig.h"

@class UMSocialTaskOperation;
@class UMSocialTask;

NS_ASSUME_NONNULL_BEGIN
/**
 *  task的回调代理
 */
@protocol UMSocialTaskDelegate <NSObject>

-(void)handleTask:(UMSocialTask*)task withError:(NSError*) error;

@end

/**
 *  所有网络请求的基本任务类
 */
@interface UMSocialTask : NSObject<NSCopying,NSCoding>

@property(nonatomic,assign)UMSocialHttpMethodType httpMethodType; //http请求类型
@property(nonatomic,copy)NSString* hostUrlPath;//http请求的host
@property(nonatomic,copy)NSString* relatedUrlPath;  //http请求的相对url
@property(nonatomic,strong)NSDictionary* paramDic;  //post或者get请求需要的字典
@property(nonatomic,copy)UMSocialTaskCompletion completion;//回调

@property(nonatomic,readonly,assign)NSInteger taskIdentifier; //唯一id
@property(nonatomic,readonly,assign)NSInteger retryCount;//retryCount
@property(nonatomic,readonly,assign)UMSoicalTaskState taskState;//task的状态


#pragma mark - override
/**
 *  创建的NSURLRequest
 *
 *  @return @see NSURLRequest
 *  @discuss 用户可以重载此函数，自己实现makeURLRequest的逻辑，
 *  如果不重载此函数会用
 *  默认会用httpMethodType,relatedUrlPath，paramDic来产生对应的NSURLRequest
 */
-(NSURLRequest*)makeURLRequest;

#pragma mark - private
/**
 *  在指定的operationTaskQueue的执行对应task的任务
 *
 *  @param operationTaskQueue @see NSOperationQueue
 *  @discuss 本函数不需要直接调用，UMSocialNetworkCore会自动调用
 *  @see  UMSocialTaskManager -(void)addAndExcuteSocialTask:(UMSocialTask*)task
 */
-(void)executeTaskWithOperationQueue:(NSOperationQueue*)operationTaskQueue;

@end

NS_ASSUME_NONNULL_END
