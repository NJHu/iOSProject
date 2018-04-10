//
//  BSJTopic.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/5/18.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "BSJTopic.h"

@implementation BSJTopic

/**
 *  数组中需要转换的模型类
 *
 *  @return 字典中的key是数组属性名，value是数组中存放模型的Class（Class类型或者NSString类型）
 */
+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"topCmts" : [BSJTopicTopComent class]};
}

/**
 *  将属性名换为其他key去字典中取值
 *
 *  @return 字典中的key是属性名，value是从字典中取值用的key
 */
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"ID" : @"id",
             
             @"smallPicture" : @"image0",
             
             @"middlePicture" : @"image2",
             
             @"largePicture" : @"image1",
             
             @"voiceUrl" : @"voiceuri",
             
             @"videoUrl" : @"videouri",
             
             @"gif" : @"is_gif",
             
             @"topCmts" : @"top_cmt",
             };
}


/**
 *  这个数组中的属性名将会被忽略：不进行字典和模型的转换
 */
+ (NSArray *)mj_ignoredPropertyNames
{
    return @[];
}

@end
