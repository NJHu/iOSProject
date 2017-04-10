//
//  MPLKDBHelper.m
//  MobileProject
//
//  Created by wujunyang on 16/7/13.
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#import "MPLKDBHelper.h"

@implementation MPLKDBHelper

+(LKDBHelper *)getUsingLKDBHelper
{
    static LKDBHelper* db;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *sqlitePath = [MPLKDBHelper downloadPath];
        NSString* dbpath = [sqlitePath stringByAppendingPathComponent:[NSString stringWithFormat:@"MPData.db"]];
        NSLog(@"当前创建数据库地址路径:%@",dbpath);
        db = [[LKDBHelper alloc]initWithDBPath:dbpath];
    });
    return db;
}

/**
 *  @author wujunyang, 15-05-21 16:05:44
 *
 *  @brief  路径
 *  @return <#return value description#>
 */
+ (NSString *)downloadPath{
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *downloadPath = [documentPath stringByAppendingPathComponent:@"DataBase"];
    NSLog(@"%@",downloadPath);
    return downloadPath;
}

@end
