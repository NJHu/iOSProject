//
//  SINStatusListDAL.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/9/15.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "SINStatusListDAL.h"
#import "SINStatusListService.h"
#import "SINSQLiteManager.h"

@interface SINStatusListDAL ()
@property (nonatomic, copy) NSString *userId;
@end

static NSString *const tableName_ = @"t_statuses";

static const NSTimeInterval  maxTime_ = -7 * 24 * 3600;


@implementation SINStatusListDAL

+ (void)cachesStatusList:(NSMutableArray<NSMutableDictionary *> *)status
{
    if (LMJIsEmpty(status)) {
        return;
    }
    
    NSString *sql = [NSString stringWithFormat:@"INSERT OR REPLACE INTO t_statuses(statusid, status, userid) VALUES(?, ?, ?)"];
    
    [[SINSQLiteManager sharedManager].dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        [status enumerateObjectsUsingBlock:^(NSMutableDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            @try {
                
                NSData *statusData = [NSJSONSerialization dataWithJSONObject:obj options:0 error:nil];
                
                if (![db executeUpdate:sql withArgumentsInArray:@[obj[@"idstr"], statusData, [SINUserManager sharedManager].uid]]){
                    *stop = YES;
                    *rollback = YES;
                }
                
            } @catch (NSException *exception) {
                NSLog(@"存储错误: %@", exception);
            } @finally {
            }
            NSLog(@"向数据库新增%d条数据", db.changes);
        }];
    }];
}


+ (void)queryStatusListFromDiskWithSinceId:(NSString *)since_id maxId:(NSString *)max_id completion:(void(^)(NSMutableArray<NSMutableDictionary *> *dictArrayM))completion
{
    
    NSString *sql = nil;
    
    if (![max_id isEqualToString:@"0"]) {
        sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE statusid <= %@ AND userid = %@ ORDER BY statusid DESC LIMIT 10", tableName_, max_id, [SINUserManager sharedManager].uid];
    }else
    {
        sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE statusid > %@ AND userid = %@ ORDER BY statusid DESC LIMIT 10", tableName_, since_id, [SINUserManager sharedManager].uid];
    }
    
    [[SINSQLiteManager sharedManager] queryArrayOfDicts:sql completion:^(NSMutableArray<NSMutableDictionary *> *dictArrayM) {
        
        NSMutableArray<NSMutableDictionary *> *dictArrayM_new = [NSMutableArray array];
        
        [dictArrayM enumerateObjectsUsingBlock:^(NSMutableDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSData *statusData = obj[@"status"];
            @try {
                NSDictionary *statusDict = [NSJSONSerialization JSONObjectWithData:statusData options:NSJSONReadingMutableLeaves error:nil];
                [dictArrayM_new addObject:[NSMutableDictionary dictionaryWithDictionary:statusDict]];
            } @catch (NSException *exception) {
            } @finally {
            }
        }];
        completion(dictArrayM_new);
    }];
}

+ (void)clearOutTimeCashes
{
    NSDate *earlyTime = [NSDate dateWithTimeIntervalSinceNow:maxTime_];
    
    NSString *earlyTimeStr = [earlyTime stringWithFormat:@"yyyy-MM-dd HH:mm:ss" timeZone:nil locale:[NSLocale localeWithLocaleIdentifier:@"en_US"]];
    
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE time < '%@'", tableName_, earlyTimeStr];
    
    [[SINSQLiteManager sharedManager].dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        BOOL isSucceed = [db executeUpdate:sql withArgumentsInArray:@[]];
        
        if (isSucceed) {
            NSLog(@"%d 删除数据成功", db.changes);
            *rollback = NO;
        }else
        {
            *rollback = YES;
        }
        
    }];
    
}


@end
