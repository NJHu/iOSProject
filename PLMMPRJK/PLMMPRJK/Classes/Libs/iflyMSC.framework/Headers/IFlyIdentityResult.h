//
//  IFlyIdentityResult.h
//  IFlyMSC
//
//  Created by 张剑 on 15/5/14.
//  Copyright (c) 2015年 iflytek. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  身份验证结果类
 */
@interface IFlyIdentityResult : NSObject

/**
 *  json字符串格式结果
 */
@property(nonatomic,retain)NSString* result;

/**
 *  创建身份验证结果类实例
 *
 *  @param jsonString json字符串
 *
 *  @return 身份验证结果类实例
 */
+(instancetype)identityResultWithString:(NSString*)jsonString;

/**
 *  返回字典格式的结果
 *
 *  @return 字典格式的结果
 */
-(NSDictionary*)dictionaryResults;

@end
