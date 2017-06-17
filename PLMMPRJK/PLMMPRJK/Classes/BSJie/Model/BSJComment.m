//
//  BSJComment.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/6/4.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "BSJComment.h"

@implementation BSJComment




/**
 *  数组中需要转换的模型类
 *
 *  @return 字典中的key是数组属性名，value是数组中存放模型的Class（Class类型或者NSString类型）
 */
+ (NSDictionary *)mj_objectClassInArray
{
    return @{};
}

/**
 *  将属性名换为其他key去字典中取值
 *
 *  @return 字典中的key是属性名，value是从字典中取值用的key
 */
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"voiceurl" : @"voiceuri",
             
             @"ID" : @"id"
             };
}


/**
 *  这个数组中的属性名将会被忽略：不进行字典和模型的转换
 */
+ (NSArray *)mj_ignoredPropertyNames
{
    return @[];
}



- (NSString *)like_count
{
    NSString *likeCount = nil;
    
    likeCount = [self checkNumberString:_like_count];
    
    return likeCount ? likeCount : @"赞";
}

- (NSString *)checkNumberString:(NSString *)numberStr
{
    NSInteger number = [numberStr integerValue];
    
    if(number >= 1000)
    {
        return [NSString stringWithFormat:@"%.1f千", number / 1000.0];
    }
    else if (number > 0 && number < 1000)
    {
        return [NSString stringWithFormat:@"%zd", number];
    }else
    {
        return nil;
    }
}

@end
