//
//  NSObject+LKDBHelper.h
//  LKDBHelper
//
//  Created by LJH on 13-6-8.
//  Copyright (c) 2013年 ljh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LKDBHelper.h"

NS_ASSUME_NONNULL_BEGIN

@class LKDBHelper;

@interface NSObject (LKDBHelper_Delegate)

+ (void)dbDidCreateTable:(LKDBHelper *)helper tableName:(NSString *)tableName;
+ (void)dbDidAlterTable:(LKDBHelper *)helper tableName:(NSString *)tableName addColumns:(NSArray *)columns;

+ (BOOL)dbWillInsert:(NSObject *)entity;
+ (void)dbDidInserted:(NSObject *)entity result:(BOOL)result;

+ (BOOL)dbWillUpdate:(NSObject *)entity;
+ (void)dbDidUpdated:(NSObject *)entity result:(BOOL)result;

+ (BOOL)dbWillDelete:(NSObject *)entity;
+ (void)dbDidDeleted:(NSObject *)entity result:(BOOL)result;

///data read finish
+ (void)dbDidSeleted:(NSObject *)entity;

@end

//only simplify synchronous function
@interface NSObject (LKDBHelper_Execute)

/**
 *  返回行数
 *
 *  @param where type can NSDictionary or NSString
 *
 *  @return  row count
 */
+ (NSInteger)rowCountWithWhere:(nullable id)where, ...;
+ (NSInteger)rowCountWithWhereFormat:(nullable id)where, ...;

/**
 *  搜索
 *
 *  @param columns type can NSArray or NSString(Search for a specific column.  Search only one, only to return the contents of the column collection)
 
 *  @param where   where type can NSDictionary or NSString
 *  @param orderBy
 *  @param offset
 *  @param count
 *
 *  @return model collection  or   contents of the columns collection
 */
+ (nullable NSMutableArray *)searchColumn:(nullable id)columns
                                    where:(nullable id)where
                                  orderBy:(nullable NSString *)orderBy
                                   offset:(NSInteger)offset
                                    count:(NSInteger)count;

+ (nullable NSMutableArray *)searchWithWhere:(nullable id)where
                                     orderBy:(nullable NSString *)orderBy
                                      offset:(NSInteger)offset
                                       count:(NSInteger)count;

+ (nullable NSMutableArray *)searchWithWhere:(nullable id)where;

+ (nullable NSMutableArray *)searchWithSQL:(NSString *)sql;

+ (nullable id)searchSingleWithWhere:(nullable id)where
                             orderBy:(nullable NSString *)orderBy;

+ (BOOL)insertToDB:(NSObject *)model;
+ (BOOL)insertWhenNotExists:(NSObject *)model;

+ (BOOL)updateToDB:(NSObject *)model
             where:(nullable id)where, ...;
+ (BOOL)updateToDBWithSet:(NSString *)sets
                    where:(nullable id)where, ...;

+ (BOOL)deleteToDB:(NSObject *)model;
+ (BOOL)deleteWithWhere:(nullable id)where, ...;

+ (BOOL)isExistsWithModel:(NSObject *)model;

- (BOOL)updateToDB;
- (BOOL)saveToDB;
- (BOOL)deleteToDB;
- (BOOL)isExistsFromDB;

///异步插入数据 async insert array ， completed 也是在子线程直接回调的
+ (void)insertArrayByAsyncToDB:(NSArray *)models;
+ (void)insertArrayByAsyncToDB:(NSArray *)models completed:(void (^ _Nullable)(BOOL allInserted))completedBlock;

///begin translate for insert models  开始事务插入数组
+ (void)insertToDBWithArray:(NSArray *)models
                     filter:(void (^ _Nullable)(id model, BOOL inserted, BOOL * _Nullable rollback))filter;

+ (void)insertToDBWithArray:(NSArray *)models
                     filter:(void (^ _Nullable)(id model, BOOL inserted, BOOL * _Nullable rollback))filter
                  completed:(void (^ _Nullable)(BOOL allInserted))completedBlock;

@end

NS_ASSUME_NONNULL_END
