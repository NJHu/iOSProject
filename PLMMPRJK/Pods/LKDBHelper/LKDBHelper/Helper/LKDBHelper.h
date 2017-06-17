//
//  LKDBHelper.h
//  LJH
//
//  Created by LJH on 12-12-6.
//  Copyright (c) 2012年 LJH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB/FMDB.h>
#import "LKDBUtils.h"
#import "LKDB+Mapping.h"
#import "NSObject+LKDBHelper.h"
#import "NSObject+LKModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LKDBHelper : NSObject

/**
 *  @brief Log error message, Default: NO
 */
+ (void)setLogError:(BOOL)logError;

/**
 *  @brief null is '' , Default: NO
 */
+ (void)setNullToEmpty:(BOOL)empty;

/**
 *	@brief  filepath the use of : "documents/db/" + fileName + ".db"
 *  refer:  FMDatabase.h  + (instancetype)databaseWithPath:(NSString *)inPath;
 */
- (instancetype)initWithDBName:(NSString *)dbname;
- (void)setDBName:(NSString *)fileName;

/**
 *	@brief  path of database file
 *  refer:  FMDatabase.h  + (instancetype)databaseWithPath:(NSString *)inPath;
 */
- (instancetype)initWithDBPath:(NSString *)filePath;
- (void)setDBPath:(NSString *)filePath;

/**
 *  @brief current encryption key.
 */
@property (nullable, nonatomic, copy, readonly) NSString *encryptionKey;

/**
 *  @brief Set encryption key
 refer: FMDatabase.h  - (BOOL)setKey:(NSString *)key;
 *  invoking after the `LKDBHelper initialize` in YourModelClass.m `getUsingLKDBHelper` function
 */
- (BOOL)setKey:(NSString *)key;

/// Reset encryption key
- (BOOL)rekey:(NSString *)key;

/**
 *	@brief  execute database operations synchronously,not afraid of recursive deadlock  
            
            同步执行数据库操作 可递归调用
 */
- (void)executeDB:(void (^)(FMDatabase *db))block;

- (BOOL)executeSQL:(NSString *)sql arguments:(nullable NSArray *)args;
- (nullable NSString *)executeScalarWithSQL:(NSString *)sql arguments:(nullable NSArray *)args;

/**
 *	@brief  execute database operations synchronously in a transaction
            block return the YES commit transaction returns the NO rollback transaction
 
            同步执行数据库操作  在事务内部  
            block 返回 YES commit 事务    返回 NO  rollback 事务
 */
- (void)executeForTransaction:(BOOL (^)(LKDBHelper *helper))block;

@end

@interface LKDBHelper (DatabaseManager)

///get table has created
- (BOOL)getTableCreatedWithClass:(Class)model;
- (BOOL)getTableCreatedWithTableName:(NSString *)tableName;

///drop all table
- (void)dropAllTable;

///drop table with entity class
- (BOOL)dropTableWithClass:(Class)modelClass;
- (BOOL)dropTableWithTableName:(NSString *)tableName;

@end

@interface LKDBHelper (DatabaseExecute)
/**
 *	@brief	The number of rows query table
 *
 *	@param 	modelClass      entity class
 *	@param 	where           can use NSString or NSDictionary or nil
 *
 *	@return	rows number
 */
- (NSInteger)rowCount:(Class)modelClass where:(nullable id)where;
- (void)rowCount:(Class)modelClass where:(nullable id)where callback:(void (^)(NSInteger rowCount))callback;
- (NSInteger)rowCountWithTableName:(NSString *)tableName where:(nullable id)where;

/**
 *	@brief	query table
 *  
 *  @param 	params query condition
 */
- (nullable NSMutableArray *)searchWithParams:(LKDBQueryParams *)params;

/**
 *	@brief	query table
 *
 *	@param 	modelClass      entity class
 *	@param 	where           can use NSString or NSDictionary or nil
 
 *	@param 	orderBy         The Sort: Ascending "name asc",Descending "name desc"
 For example: @"rowid desc"x  or @"rowid asc"
 
 *	@param 	offset          Skip how many rows
 *	@param 	count           Limit the number
 *
 *	@return	query finished result is an array(model instance collection)
 */
- (nullable NSMutableArray *)search:(Class)modelClass
                              where:(nullable id)where
                            orderBy:(nullable NSString *)orderBy
                             offset:(NSInteger)offset
                              count:(NSInteger)count;

/**
 *  query sql, query finished result is an array(model instance collection)
 *  you can use the "@t" replace Model TableName
 *  query sql use lowercase string
 *  查询的sql语句 请使用小写 ，否则会不能自动获取 rowid
 *  example: 
            NSMutableArray *array = [[LKDBHelper getUsingLKDBHelper] searchWithSQL:@"select * from @t where blah blah.." toClass:[ModelClass class]];
 *
 */
- (nullable NSMutableArray *)searchWithSQL:(NSString *)sql toClass:(nullable Class)modelClass;

/**
 *  @brief don't do any operations of the sql
 */
- (nullable NSMutableArray *)searchWithRAWSQL:(NSString *)sql toClass:(nullable Class)modelClass;

/**
 *  query sql, query finished result is an array(model instance collection)
 *  you can use the "@t" replace Model TableName and replace all ? placeholders with the va_list
 *  example:
 NSMutableArray *array = [[LKDBHelper getUsingLKDBHelper] searc:[ModelClass class] withSQL:@"select rowid from name_table where name = ?", @"Swift"];
 *
 */
- (nullable NSMutableArray *)search:(Class)modelClass withSQL:(NSString *)sql, ...;

/**
    columns may NSArray or NSString   if query column count == 1  return single column string array
    other return models entity array
 */
- (nullable NSMutableArray *)search:(Class)modelClass
                             column:(nullable id)columns
                              where:(nullable id)where
                            orderBy:(nullable NSString *)orderBy
                             offset:(NSInteger)offset
                              count:(NSInteger)count;

/**
 *  @brief  async search
 */
- (void)search:(Class)modelClass
         where:(nullable id)where
       orderBy:(nullable NSString *)orderBy
        offset:(NSInteger)offset
         count:(NSInteger)count
      callback:(void (^)(NSMutableArray * _Nullable array))block;

///return first model or nil
- (nullable id)searchSingle:(Class)modelClass where:(nullable id)where orderBy:(nullable NSString *)orderBy;

/**
 *	@brief	insert table
 *
 *	@param 	model 	you want to insert the entity
 *
 *	@return	the inserted was successful
 */
- (BOOL)insertToDB:(NSObject *)model;
- (void)insertToDB:(NSObject *)model callback:(void (^)(BOOL result))block;

/**
 *	@brief	insert when the entity primary key does not exist
 *
 *	@param 	model 	you want to insert the entity
 *
 *	@return	the inserted was successful
 */
- (BOOL)insertWhenNotExists:(NSObject *)model;
- (void)insertWhenNotExists:(NSObject *)model callback:(void (^)(BOOL result))block;

/**
 *	@brief update table
 *
 *	@param 	model 	you want to update the entity
 *	@param 	where 	can use NSString or NSDictionary or nil
                    when "where" is nil : update the value based on rowid column or primary key column
 *
 *	@return	the updated was successful
 */
- (BOOL)updateToDB:(NSObject *)model where:(nullable id)where;
- (void)updateToDB:(NSObject *)model where:(nullable id)where callback:(void (^)(BOOL result))block;
- (BOOL)updateToDB:(Class)modelClass set:(NSString *)sets where:(nullable id)where;
- (BOOL)updateToDBWithTableName:(NSString *)tableName set:(NSString *)sets where:(nullable id)where;

/**
 *	@brief	delete table
 *
 *	@param 	model 	you want to delete entity
                    when entity property "rowid" == 0  based on the primary key to delete
 *
 *	@return	the deleted was successful
 */
- (BOOL)deleteToDB:(NSObject *)model;
- (void)deleteToDB:(NSObject *)model callback:(void (^)(BOOL result))block;

/**
 *	@brief	delete table with "where" constraint
 *
 *	@param 	modelClass      entity class
 *	@param 	where           can use NSString or NSDictionary,  can not is nil
 *
 *	@return	the deleted was successful
 */
- (BOOL)deleteWithClass:(Class)modelClass where:(nullable id)where;
- (void)deleteWithClass:(Class)modelClass where:(nullable id)where callback:(void (^)(BOOL result))block;
- (BOOL)deleteWithTableName:(NSString *)tableName where:(nullable id)where;

/**
 *	@brief   entity exists?
 *           for primary key column
            （if rowid > 0 would certainly exist so we do not rowid judgment）
 *	@param 	model 	entity
 *
 *	@return	YES: entity presence , NO: entity not exist
 */
- (BOOL)isExistsModel:(NSObject *)model;
- (BOOL)isExistsClass:(Class)modelClass where:(nullable id)where;
- (BOOL)isExistsWithTableName:(NSString *)tableName where:(nullable id)where;

/**
 *	@brief	Clear data based on the entity class
 *
 *	@param 	modelClass 	entity class
 */
+ (void)clearTableData:(Class)modelClass;

/**
 *	@brief	Clear Unused Data File
            if you property has UIImage or NSData, will save their data in the (documents dir)
 *
 *	@param 	modelClass      entity class
 *	@param 	columns         UIImage or NSData Column Name
 */
+ (void)clearNoneImage:(Class)modelClass columns:(NSArray<NSString *> *)columns;
+ (void)clearNoneData:(Class)modelClass columns:(NSArray<NSString *> *)columns;

@end

@interface LKDBHelper (Deprecated_Nonfunctional)
/// you can use [LKDBHelper getUsingLKDBHelper]
#pragma mark - deprecated
+ (LKDBHelper *)sharedDBHelper __deprecated_msg("Method deprecated. Use `[Model getUsingLKDBHelper]`");
- (BOOL)createTableWithModelClass:(Class)modelClass __deprecated_msg("Now you can not call it. Will automatically determine whether you need to create");
- (void)setEncryptionKey:(NSString *)encryptionKey __deprecated_msg("Method deprecated. Use `setKey: OR resetKey:` invoking after the `LKDBHelper initialize` in YourModelClass.m `getUsingLKDBHelper` function");
#pragma mark -
@end

NS_ASSUME_NONNULL_END
