//
//  LMJLKDBPerson.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/4/30.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJLKDBPerson.h"
#import <LKDBHelper.h>

@implementation LMJLKDBPerson


+ (void)initialize
{
    [self removePropertyWithColumnNameArray:@[@"error"]];
}



+ (BOOL)isContainParent
{
    return YES;
}




+ (NSString *)getTableName
{
    return @"PersonDB1";
}




+ (NSString *)getPrimaryKey
{
    return @"ID";
}

@end
