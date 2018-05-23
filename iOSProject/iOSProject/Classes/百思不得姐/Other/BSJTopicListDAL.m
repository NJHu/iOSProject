//
//  BSJTopicListDAL.m
//  iOSProject
//
//  Created by HuXuPeng on 2018/1/26.
//  Copyright © 2018年 github.com/njhu. All rights reserved.
//

#import "BSJTopicListDAL.h"
#import "BSJSQLiteManager.h"

static NSString *const listTableName_ = @"t_topics";
static NSString *const nweListTableName_ = @"new_t_topics";

static const NSTimeInterval  maxTime_ = -7 * 24 * 3600;

@implementation BSJTopicListDAL
+ (void)cachesTopicList:(NSMutableArray<NSMutableDictionary *> *)topics areaType:(NSString *)areaType;
{
    if (LMJIsEmpty(topics)) {
        return;
    }
    
//    if ([self.parentViewController isMemberOfClass:NSClassFromString(@"BSJEssenceViewController")]) {
//        return @"list";
//    }
//
//    if ([self.parentViewController isMemberOfClass:NSClassFromString(@"BSJNewViewController")]) {
//        return @"newlist";
//    }
    NSString *tableName = nil;
    if ([areaType isEqualToString:@"list"]) {
        tableName = listTableName_;
    }else if ([areaType isEqualToString:@"newlist"]) {
        tableName = nweListTableName_;
    }
    
    /*
    NSString *creatTableSql = @"CREATE TABLE IF NOT EXISTS t_topics \n\
    (id INTEGER PRIMARY KEY AUTOINCREMENT, \n\
    topic BLOB NOT NULL, \n\
     topicType
    type TEXT NOT NULL, \n\
     timeID
    t INTEGER NOT NULL, \n\
    time TEXT NOT NULL  DEFAULT (datetime('now', 'localtime'))\n\
    )\n";
     */
    
//    parameters[@"a"] = typeA;
//    parameters[@"c"] = @"data";
//    parameters[@"type"] = @(topicType);
//    parameters[@"maxtime"] = isMore ? self.maxtime : nil;
//    parameters[@"per"] = @10;
    
    NSString *sql = [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@(topic, type, t) VALUES(?, ?, ?)", tableName];
    
    [[BSJSQLiteManager sharedManager].dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        [topics enumerateObjectsUsingBlock:^(NSMutableDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            
            @try {
                
                NSData *topicData = [NSJSONSerialization dataWithJSONObject:obj options:0 error:nil];
                
                if (![db executeUpdate:sql withArgumentsInArray:@[topicData, obj[@"type"], obj[@"t"]]])
                {
                    *stop = YES;
                    *rollback = YES;
                }
                
            } @catch (NSException *exception) {
                
                NSLog(@"存储错误: %@", exception);
                
                
            } @finally {
                
//                *stop = YES;
//                *rollback = YES;
                
            }
        
            NSLog(@"向数据库新增%d条数据", db.changes);
            
        }];
        
    }];
    
    
    
    
}


+ (void)queryTopicListFromDiskWithAreaType:(NSString *)areaType topicType:(NSString *)topicType maxTime:(NSString *)maxTime per:(NSInteger)per completion:(void(^)(NSMutableArray<NSMutableDictionary *> *dictArrayM))completion
{
    
    NSString *tableName = nil;
    if ([areaType isEqualToString:@"list"]) {
        tableName = listTableName_;
    }else if ([areaType isEqualToString:@"newlist"]) {
        tableName = nweListTableName_;
    }
    
    NSString *sql = nil;
    NSString *count = [NSString stringWithFormat:@"%zd", per];
    /*
     NSString *creatTableSql = @"CREATE TABLE IF NOT EXISTS t_topics \n\
     (id INTEGER PRIMARY KEY AUTOINCREMENT, \n\
     topic BLOB NOT NULL, \n\
     topicType
     type TEXT NOT NULL, \n\
     topicTimeID
     t INTEGER NOT NULL, \n\
     time TEXT NOT NULL  DEFAULT (datetime('now', 'localtime'))\n\
     )\n";
     */
    
    //    parameters[@"a"] = typeA;
    //    parameters[@"c"] = @"data";
    //    parameters[@"type"] = @(topicType);
    //    parameters[@"maxtime"] = isMore ? self.maxtime : nil;
    //    parameters[@"per"] = @10;
    
    if (!maxTime && (LMJRequestManager.sharedManager.reachabilityManager.networkReachabilityStatus == AFNetworkReachabilityStatusUnknown || LMJRequestManager.sharedManager.reachabilityManager.networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable)) {
        
        if ([topicType isEqualToString:@"1"]) {
            sql = [NSString stringWithFormat:@"SELECT * FROM %@ ORDER BY t DESC LIMIT %@", tableName, count];
        }else
        {
           sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE type = %@  ORDER BY t DESC LIMIT %@", tableName, topicType, count];
        }
        
    }else if (maxTime) {
        
        if ([topicType isEqualToString:@"1"]) {
           sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE t < %@ ORDER BY t DESC LIMIT %@", tableName, maxTime, count];
        }else
        {
            sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE type = %@ AND t < %@ ORDER BY t DESC LIMIT %@", tableName, topicType, maxTime, count];
        }
    }

    
    
    [[BSJSQLiteManager sharedManager] queryArrayOfDicts:sql completion:^(NSMutableArray<NSMutableDictionary *> *dictArrayM) {
        
        NSMutableArray<NSMutableDictionary *> *dictArrayM_new = [NSMutableArray array];
        
        [dictArrayM enumerateObjectsUsingBlock:^(NSMutableDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSData *topicData = obj[@"topic"];
            
            @try {
                
                NSDictionary *topicDict = [NSJSONSerialization JSONObjectWithData:topicData options:NSJSONReadingMutableContainers error:nil];
                
                [dictArrayM_new addObject:[NSMutableDictionary dictionaryWithDictionary:topicDict]];
                
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
    
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE time < '%@'", listTableName_, earlyTimeStr];
    
    [[BSJSQLiteManager sharedManager].dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        BOOL isSucceed = [db executeUpdate:sql withArgumentsInArray:@[]];
        
        if (isSucceed) {
            NSLog(@"%d 删除数据成功", db.changes);
            *rollback = NO;
        }else
        {
            *rollback = YES;
        }
        
    }];
    
    NSString *newsql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE time < '%@'", nweListTableName_, earlyTimeStr];
    
    [[BSJSQLiteManager sharedManager].dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        BOOL isSucceed = [db executeUpdate:newsql withArgumentsInArray:@[]];
        
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
