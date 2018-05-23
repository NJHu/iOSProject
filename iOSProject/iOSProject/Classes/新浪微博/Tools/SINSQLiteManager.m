//
//  SINSQLiteManager.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/9/15.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "SINSQLiteManager.h"



static NSString *const _dbName = @"sin_t_statuses.sqlite";

static NSString *_dbPath = nil;

@implementation SINSQLiteManager

+ (void)load
{
    _dbPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:_dbName];
    NSLog(@"%@", _dbPath);
}


// 查询
- (void)queryArrayOfDicts:(NSString *)sql completion:(void(^)(NSMutableArray<NSMutableDictionary *> *dictArrayM))completion
{
    
    NSMutableArray<NSMutableDictionary *> *dictArrayM = [NSMutableArray array];
    
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        
       FMResultSet *resultSet = [db executeQuery:sql withArgumentsInArray:@[]];
        
        while (resultSet.next) {
            
            NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
            
            for (int i = 0; i < resultSet.columnCount; i++) {
                
                
                NSString *colName = [resultSet columnNameForIndex:i];
                
                NSString *colValue = [resultSet objectForColumn:colName];
                
                dictM[colName] = colValue;
            }
            
            [dictArrayM addObject:dictM];
        }
        
        
        completion(dictArrayM);
        
    }];
    
    
}


// 全部查询
- (void)queryDatas
{
    NSString *sql = @"SELECT * FROM t_statuses";
    
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        
        FMResultSet *resultSet = [db executeQuery:sql withArgumentsInArray:@[]];
        
        while (resultSet.next) {
            
            NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
            
            for (int i = 0; i < resultSet.columnCount; i++) {
                
                NSString *colName = [resultSet columnNameForIndex:i];
                
                NSString *colValue = [resultSet objectForColumn:colName];
                
                dictM[colName] = colValue;
            }
            
            NSLog(@"%@", dictM);
        }
    }];
}

// 查询
- (void)queryCondition
{
    
    NSString *sql = @"SELECT id, userid, statusid FROM t_statuses";
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *resultSet = [db executeQuery:sql withArgumentsInArray:@[]];
        while (resultSet.next) {
            int ID = [resultSet intForColumn:@"id"];
            NSString *userid = [resultSet stringForColumn:@"userid"];
            NSString *statusid = [resultSet stringForColumn:@"statusid"];
            NSLog(@"%d, %@, %@", ID, userid, statusid);
        }
    }];
}


// 修改
- (void)update
{
    NSString *sql = @"UPDATE t_statuses SET userid=0000 WHERE id = 2";
    [self.dbQueue inDatabase:^(FMDatabase *db) {
       BOOL result = [db executeUpdate:sql withArgumentsInArray:@[]];
        
        if (result) {
            NSLog(@"更新成功");
        }else {
            NSLog(@"更新失败");
        }
        
    }];
    
}

// 删除
- (void)delete
{
    NSString *sql = @"DELETE FROM t_statuses WHERE id = 3";
    
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        
        BOOL result = [db executeUpdate:sql withArgumentsInArray:@[]];
        
        if (result) {
            NSLog(@"delete成功");
        }else {
            NSLog(@"delete失败");
        }
        
    }];
}


- (void)insert
{
    NSString *sql = @"INSERT INTO t_statuses(statusid, status, userid) VALUES (?, ?, ?)";
    
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        
        BOOL result = [db executeUpdate:sql withArgumentsInArray:@[@(134), @(1), @"4567"]];
        
        if (result) {
            NSLog(@"INSERT成功");
        }else {
            NSLog(@"INSERT失败");
        }
        
    }];
    
}

#pragma mark - creatTable
- (void)creatTable
{
    NSString *creatTableSql = @"CREATE TABLE IF NOT EXISTS t_statuses \n\
    (id INTEGER PRIMARY KEY AUTOINCREMENT, \n\
    statusid TEXT NOT NULL, \n\
    status BLOB NOT NULL, \n\
    userid TEXT NOT NULL, \n\
    time TEXT NOT NULL  DEFAULT (datetime('now', 'localtime'))\n\
    )\n";
    
    [self.dbQueue inDatabase:^(FMDatabase *db) {
       
       BOOL result = [db executeStatements:creatTableSql];
        
        if (result) {
            NSLog(@"创建表成功");
        }else {
            NSLog(@"创建表失败");
        }
        
    }];
    
}

#pragma mark - getter
- (FMDatabaseQueue *)dbQueue
{
    if(_dbQueue == nil)
    {
        _dbQueue = [FMDatabaseQueue databaseQueueWithPath:_dbPath];
    }
    return _dbQueue;
}


#pragma mark - 单例
- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self creatTable];
    }
    return self;
}


static id _instance = nil;
+ (instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_instance) {
            _instance = [[self alloc] init];
        }
    });
    
    return _instance;
}


+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    
    return _instance;
}

- (id)copyWithZone:(NSZone *)zone
{
    return _instance;
}

- (id)mutableCopyWithZone:(NSZone *)zone
{
    return _instance;
}


@end
