//
//  IFlyDataUploader.h
//  MSC
//
//  Created by ypzhao on 13-4-8.
//  Copyright (c) 2013年 iflytek. All rights reserved.
//

#import <Foundation/Foundation.h>


@class IFlySpeechError;

/*!
 *  数据上传类
 */
@interface IFlyDataUploader : NSObject

/*!
 *  数据名称
 */
@property(nonatomic,copy) NSString *dataName;
/*!
 *  数据
 */
@property(nonatomic,copy) NSString *data;

/*!
 *  上传完成回调
 *
 *  @param result 结果
 *  @param error  错误码
 */
typedef void(^IFlyUploadDataCompletionHandler)(NSString* result,IFlySpeechError * error);

/*!
 *  上传数据
 *  此函数用于上传数据，下载的过程是**异步**的。
 *
 *  @param completionHandler -[in] 上传完成回调
 *  @param name              -[in] 上传的内容名称，名称最好和你要上传的数据内容相关,不可以为nil
 *  @param data              -[in] 上传的数据，以utf8编码,不可以为nil
 */
- (void) uploadDataWithCompletionHandler:(IFlyUploadDataCompletionHandler)completionHandler name:(NSString *)name data:(NSString *)data;

/*!
 *  设置上传数据参数
 *
 *  @param parameter 参数值
 *  @param key       参数名
 */
-(void) setParameter:(NSString*) parameter forKey:(NSString*) key;

@end
