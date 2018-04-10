//
//  BSJRecommendCategory.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/5/14.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "BSJRecommendCategory.h"
#import "BSJRecommendUser.h"

@implementation BSJRecommendCategory

- (NSMutableArray<BSJRecommendUser *> *)users
{
    if(_users == nil)
    {
        _users = [NSMutableArray array];
    }
    return _users;
}


/**
 *  数组中需要转换的模型类
 *
 *  @return 字典中的key是数组属性名，value是数组中存放模型的Class（Class类型或者NSString类型）
 */
//+ (NSDictionary *)mj_objectClassInArray;


+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID" : @"id"};
}

+ (NSArray *)mj_ignoredPropertyNames
{
    return @[@"users"];
}


@end
