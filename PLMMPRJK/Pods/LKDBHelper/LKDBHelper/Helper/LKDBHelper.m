//
//  LKDBHelper.m
//  LJH
//
//  Created by LJH on 12-12-6.
//  Copyright (c) 2012年 LJH. All rights reserved.
//

#import "LKDBHelper.h"
#import <sqlite3.h>

#define LKDBCheck_tableNameIsInvalid(tableName)                           \
    if ([LKDBUtils checkStringIsEmpty:tableName]) {                       \
        LKErrorLog(@" \n Fail!Fail!Fail!Fail! \n with TableName is nil"); \
        return NO;                                                        \
    }

#define LKDBCode_Async_Begin             \
    __LKDBWeak LKDBHelper *wself = self; \
    [self asyncBlock :^{__strong LKDBHelper *sself = wself;           \
                        if (sself) {

#define LKDBCode_Async_End \
    }                      \
    }];

#define LKDBCheck_modelIsInvalid(model)                                                            \
    if (model == nil) {                                                                            \
        LKErrorLog(@"model is nil");                                                               \
        return NO;                                                                                 \
    }                                                                                              \
    if ([model.class getModelInfos].count == 0) {                                                  \
        LKErrorLog(@"class: %@  property count is 0!!", NSStringFromClass(model.class));           \
        return NO;                                                                                 \
    }                                                                                              \
    NSString *_model_tableName = model.db_tableName ?: [model.class getTableName];                 \
    if ([LKDBUtils checkStringIsEmpty:_model_tableName]) {                                         \
        LKErrorLog(@"model class name %@ table name is invalid!", NSStringFromClass(model.class)); \
        return NO;                                                                                 \
    }

@interface NSObject (LKTabelStructure_Private)
- (void)setDb_inserting:(BOOL)db_inserting;
@end

@interface LKDBWeakObject : NSObject
@property (nonatomic, LKDBWeak) LKDBHelper *obj;
@end

@interface LKDBHelper ()
@property (nonatomic, LKDBWeak) FMDatabase *usingdb;
@property (nonatomic, strong) FMDatabaseQueue *bindingQueue;
@property (nonatomic, copy) NSString *dbPath;
@property (nonatomic, strong) NSMutableArray *createdTableNames;
@property (nonatomic, strong) NSRecursiveLock *threadLock;
@end

@implementation LKDBHelper
@synthesize encryptionKey = _encryptionKey;

static BOOL LKDBLogErrorEnable = NO;
+ (void)setLogError:(BOOL)logError
{
    if (LKDBLogErrorEnable == logError) {
        return;
    }
#ifdef DEBUG
    LKDBLogErrorEnable = logError;
    NSMutableArray *dbArray = [self dbHelperSingleArray];
    @synchronized(dbArray)
    {
        [dbArray enumerateObjectsUsingBlock:^(LKDBWeakObject *weakObj, NSUInteger idx, BOOL *stop) {
            [weakObj.obj executeDB:^(FMDatabase *db) {
                db.logsErrors = LKDBLogErrorEnable;
            }];
        }];
    }
#endif
}
static BOOL LKDBNullIsEmptyString = NO;
+ (void)setNullToEmpty:(BOOL)empty
{
    LKDBNullIsEmptyString = empty;
}
+ (BOOL)nullIsEmpty
{
    return LKDBNullIsEmptyString;
}

+ (NSMutableArray *)dbHelperSingleArray
{
    static __strong NSMutableArray *dbArray;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dbArray = [NSMutableArray array];
    });
    return dbArray;
}

+ (LKDBHelper *)dbHelperWithPath:(NSString *)dbFilePath save:(LKDBHelper *)helper
{
    NSMutableArray *dbArray = [self dbHelperSingleArray];
    LKDBHelper *instance = nil;
    @synchronized(dbArray)
    {
        if (helper) {
            LKDBWeakObject *weakObj = [[LKDBWeakObject alloc] init];
            weakObj.obj = helper;
            [dbArray addObject:weakObj];
        }
        else if (dbFilePath) {
            for (NSInteger i = 0; i < dbArray.count;) {
                LKDBWeakObject *weakObj = [dbArray objectAtIndex:i];
                if (weakObj.obj == nil) {
                    [dbArray removeObjectAtIndex:i];
                    continue;
                }
                else if ([weakObj.obj.dbPath isEqualToString:dbFilePath]) {
                    instance = weakObj.obj;
                    break;
                }
                i++;
            }
        }
    }
    return instance;
}

- (instancetype)init
{
    return [self initWithDBName:@"LKDB"];
}

- (instancetype)initWithDBName:(NSString *)dbname
{
    return [self initWithDBPath:[LKDBHelper getDBPathWithDBName:dbname]];
}

- (instancetype)initWithDBPath:(NSString *)filePath
{
    if ([LKDBUtils checkStringIsEmpty:filePath]) {
        ///release self
        self = nil;
        return nil;
    }

    LKDBHelper *helper = [LKDBHelper dbHelperWithPath:filePath save:nil];

    if (helper) {
        self = helper;
    }
    else {
        self = [super init];

        if (self) {
            self.threadLock = [[NSRecursiveLock alloc] init];
            self.createdTableNames = [NSMutableArray array];

            [self setDBPath:filePath];
            [LKDBHelper dbHelperWithPath:nil save:self];
        }
    }

    return self;
}

#pragma mark - init FMDB
+ (NSString *)getDBPathWithDBName:(NSString *)dbName
{
    NSString *fileName = nil;

    if ([dbName hasSuffix:@".db"] == NO) {
        fileName = [NSString stringWithFormat:@"%@.db", dbName];
    }
    else {
        fileName = dbName;
    }

    NSString *filePath = [LKDBUtils getPathForDocuments:fileName inDir:@"db"];
    return filePath;
}

- (void)setDBName:(NSString *)dbName
{
    [self setDBPath:[LKDBHelper getDBPathWithDBName:dbName]];
}

- (void)setDBPath:(NSString *)filePath
{
    if (self.bindingQueue && [self.dbPath isEqualToString:filePath]) {
        return;
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    // 创建数据库目录
    NSRange lastComponent = [filePath rangeOfString:@"/" options:NSBackwardsSearch];

    if (lastComponent.length > 0) {
        NSString *dirPath = [filePath substringToIndex:lastComponent.location];
        BOOL isDir = NO;
        BOOL isCreated = [fileManager fileExistsAtPath:dirPath isDirectory:&isDir];

        if ((isCreated == NO) || (isDir == NO)) {
            NSError *error = nil;
#ifdef __IPHONE_OS_VERSION_MIN_REQUIRED
            NSDictionary *attributes = @{ NSFileProtectionKey : NSFileProtectionNone };
#else
            NSDictionary *attributes = nil;
#endif
            BOOL success = [fileManager createDirectoryAtPath:dirPath
                                  withIntermediateDirectories:YES
                                                   attributes:attributes
                                                        error:&error];
            if (success == NO) {
                LKErrorLog(@"create dir error: %@", error.debugDescription);
            }
        }
        else {
            /**
             *  @brief  Disk I/O error when device is locked
             *          https://github.com/ccgus/fmdb/issues/262
             */
#ifdef __IPHONE_OS_VERSION_MIN_REQUIRED
            [fileManager setAttributes:@{ NSFileProtectionKey : NSFileProtectionNone }
                          ofItemAtPath:dirPath
                                 error:nil];
#endif
        }
    }

    [self.threadLock lock];

    self.dbPath = filePath;
    [self.bindingQueue close];
    [self.createdTableNames removeAllObjects];

#ifndef SQLITE_OPEN_FILEPROTECTION_NONE
#define SQLITE_OPEN_FILEPROTECTION_NONE 0x00400000
#endif
    self.bindingQueue = [[FMDatabaseQueue alloc] initWithPath:filePath
                                                        flags:SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE | SQLITE_OPEN_FILEPROTECTION_NONE];
#ifdef __IPHONE_OS_VERSION_MIN_REQUIRED
    if ([fileManager fileExistsAtPath:filePath]) {
        [fileManager setAttributes:@{ NSFileProtectionKey : NSFileProtectionNone } ofItemAtPath:filePath error:nil];
    }
#endif
    
    ///reset encryptionKey
    _encryptionKey = nil;

    [self.bindingQueue inDatabase:^(FMDatabase *db) {
        db.logsErrors = LKDBLogErrorEnable;
    }];
    [self.threadLock unlock];
}

#pragma mark - core
- (void)executeDB:(void (^)(FMDatabase *db))block
{
    if (!block) {
        NSAssert(NO, @"block is nil!");
        return;
    }
    [self.threadLock lock];

    if (self.usingdb != nil) {
        block(self.usingdb);
    }
    else {
        if (self.bindingQueue == nil) {
            self.bindingQueue = [[FMDatabaseQueue alloc] initWithPath:_dbPath];
            [self.createdTableNames removeAllObjects];
            [self.bindingQueue inDatabase:^(FMDatabase *db) {
                db.logsErrors = LKDBLogErrorEnable;
                if (_encryptionKey.length > 0) {
                    [db setKey:_encryptionKey];
                }
            }];
        }
        [self.bindingQueue inDatabase:^(FMDatabase *db) {
            self.usingdb = db;
            block(db);
            self.usingdb = nil;
        }];
    }

    [self.threadLock unlock];
}

- (BOOL)executeSQL:(NSString *)sql arguments:(NSArray *)args
{
    __block BOOL execute = NO;

    [self executeDB:^(FMDatabase *db) {
        if (args.count > 0) {
            execute = [db executeUpdate:sql withArgumentsInArray:args];
        }
        else {
            execute = [db executeUpdate:sql];
        }

        if (db.hadError) {
            LKErrorLog(@" sql:%@ \n args:%@ \n sqlite error :%@ \n", sql, args, db.lastErrorMessage);
        }
    }];
    return execute;
}

- (NSString *)executeScalarWithSQL:(NSString *)sql arguments:(NSArray *)args
{
    __block NSString *scalar = nil;

    [self executeDB:^(FMDatabase *db) {
        FMResultSet *set = nil;

        if (args.count > 0) {
            set = [db executeQuery:sql withArgumentsInArray:args];
        }
        else {
            set = [db executeQuery:sql];
        }

        if (db.hadError) {
            LKErrorLog(@" sql:%@ \n args:%@ \n sqlite error :%@ \n", sql, args, db.lastErrorMessage);
        }

        if (([set columnCount] > 0) && [set next]) {
            scalar = [set stringForColumnIndex:0];
        }

        [set close];
    }];
    return scalar;
}

- (void)executeForTransaction:(BOOL (^)(LKDBHelper *))block
{
    LKDBHelper *helper = self;

    [self executeDB:^(FMDatabase *db) {
        BOOL inTransacttion = db.inTransaction;

        if (!inTransacttion) {
            [db beginTransaction];
        }

        BOOL isCommit = NO;

        if (block) {
            isCommit = block(helper);
        }

        if (!inTransacttion) {
            if (isCommit) {
                [db commit];
            }
            else {
                [db rollback];
            }
        }
    }];
}

// splice 'where' 拼接where语句
- (NSMutableArray *)extractQuery:(NSMutableString *)query where:(id)where
{
    NSMutableArray *values = nil;

    if ([where isKindOfClass:[NSString class]] && ([LKDBUtils checkStringIsEmpty:where] == NO)) {
        [query appendFormat:@" where %@", where];
    }
    else if ([where isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dicWhere = where;

        if (dicWhere.count > 0) {
            values = [NSMutableArray arrayWithCapacity:dicWhere.count];
            NSString *wherekey = [self dictionaryToSqlWhere:where andValues:values];
            [query appendFormat:@" where %@", wherekey];
        }
    }

    return values;
}

// dic where parse
- (NSString *)dictionaryToSqlWhere:(NSDictionary *)dic andValues:(NSMutableArray *)values
{
    if (dic.count == 0) {
        return @"";
    }
    NSMutableString *wherekey = [NSMutableString stringWithCapacity:0];
    [dic enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL *stop) {
        if ([obj isKindOfClass:[NSArray class]]) {
            NSArray *vlist = obj;
            if (vlist.count == 0) {
                return;
            }
            if (wherekey.length > 0) {
                [wherekey appendString:@" and"];
            }
            [wherekey appendFormat:@" %@ in(", key];
            [vlist enumerateObjectsUsingBlock:^(id vlist_obj, NSUInteger idx, BOOL *stop) {
                if (idx > 0) {
                    [wherekey appendString:@","];
                }
                [wherekey appendString:@"?"];
                [values addObject:vlist_obj];
            }];
            [wherekey appendString:@")"];
        }
        else {
            if (wherekey.length > 0) {
                [wherekey appendFormat:@" and %@=?", key];
            }
            else {
                [wherekey appendFormat:@" %@=?", key];
            }
            [values addObject:obj];
        }
    }];
    return [wherekey copy];
}

// where sql statements about model primary keys
- (NSMutableString *)primaryKeyWhereSQLWithModel:(NSObject *)model addPValues:(NSMutableArray *)addPValues
{
    LKModelInfos *infos = [model.class getModelInfos];
    NSArray *primaryKeys = infos.primaryKeys;
    NSMutableString *pwhere = [NSMutableString string];

    if (primaryKeys.count > 0) {
        for (NSInteger i = 0; i < primaryKeys.count; i++) {
            NSString *pk = [primaryKeys objectAtIndex:i];

            if ([LKDBUtils checkStringIsEmpty:pk] == NO) {
                LKDBProperty *property = [infos objectWithSqlColumnName:pk];
                id pvalue = nil;

                if (property && [property.type isEqualToString:LKSQL_Mapping_UserCalculate]) {
                    pvalue = [model userGetValueForModel:property];
                }
                else if (pk && property) {
                    pvalue = [model modelGetValue:property];
                }

                if (pvalue) {
                    if (pwhere.length > 0) {
                        [pwhere appendString:@"and"];
                    }

                    if (addPValues) {
                        [pwhere appendFormat:@" %@=? ", pk];
                        [addPValues addObject:pvalue];
                    }
                    else {
                        [pwhere appendFormat:@" %@='%@' ", pk, pvalue];
                    }
                }
            }
        }
    }

    return pwhere;
}

#pragma mark - set key
- (BOOL)setKey:(NSString *)key
{
    [self.threadLock lock];
    _encryptionKey = [key copy];
    __block BOOL success = NO;
    if (self.bindingQueue && _encryptionKey.length > 0) {
        [self executeDB:^(FMDatabase *db) {
            success = [db setKey:_encryptionKey];
        }];
    }
    [self.threadLock unlock];
    return success;
}
- (BOOL)rekey:(NSString *)key
{
    [self.threadLock lock];
    _encryptionKey = [key copy];
    __block BOOL success = NO;
    if (self.bindingQueue && _encryptionKey.length > 0) {
        [self executeDB:^(FMDatabase *db) {
            success = [db rekey:_encryptionKey];
        }];
    }
    [self.threadLock unlock];
    return success;
}
- (NSString *)encryptionKey
{
    [self.threadLock lock];
    NSString *key = _encryptionKey;
    [self.threadLock unlock];
    return key;
}
#pragma mark - dealloc
- (void)dealloc
{
    NSArray *array = [LKDBHelper dbHelperSingleArray];
    @synchronized(array)
    {
        for (LKDBWeakObject *weakObject in array) {
            if ([weakObject.obj isEqual:self]) {
                weakObject.obj = nil;
            }
        }
    }

    [self.bindingQueue close];
    self.usingdb = nil;
    self.bindingQueue = nil;
    self.dbPath = nil;
    self.threadLock = nil;
}

@end
@implementation LKDBHelper (DatabaseManager)

- (void)dropAllTable
{
    [self executeDB:^(FMDatabase *db) {
        FMResultSet *set = [db executeQuery:@"select name from sqlite_master where type='table'"];
        NSMutableArray *dropTables = [NSMutableArray arrayWithCapacity:0];

        while ([set next]) {
            NSString *tableName = [set stringForColumnIndex:0];
            if (tableName) {
                [dropTables addObject:tableName];
            }
        }

        [set close];

        for (NSString *tableName in dropTables) {
            if ([tableName hasPrefix:@"sqlite_"] == NO) {
                NSString *dropTable = [NSString stringWithFormat:@"drop table %@", tableName];
                [db executeUpdate:dropTable];
            }
        }

        [self.createdTableNames removeAllObjects];
    }];
}

- (BOOL)dropTableWithClass:(Class)modelClass
{
    return [self dropTableWithTableName:[modelClass getTableName]];
}

- (BOOL)dropTableWithTableName:(NSString *)tableName
{
    LKDBCheck_tableNameIsInvalid(tableName);

    NSString *dropTable = [NSString stringWithFormat:@"drop table %@", tableName];

    BOOL isDrop = [self executeSQL:dropTable arguments:nil];

    [self.threadLock lock];
    [self.createdTableNames removeObject:tableName];
    [self.threadLock unlock];

    return isDrop;
}

- (void)fixSqlColumnsWithClass:(Class)clazz tableName:(NSString *)tableName
{
    [self executeDB:^(FMDatabase *db) {
        LKModelInfos *infos = [clazz getModelInfos];

        NSString *select = [NSString stringWithFormat:@"select * from %@ limit 0", tableName];
        FMResultSet *set = [db executeQuery:select];
        NSArray *columnArray = set.columnNameToIndexMap.allKeys;
        [set close];

        NSMutableArray *alterAddColumns = [NSMutableArray array];

        for (NSInteger i = 0; i < infos.count; i++) {
            LKDBProperty *property = [infos objectWithIndex:i];

            if ([property.sqlColumnName.lowercaseString isEqualToString:@"rowid"]) {
                continue;
            }

            ///数据库中不存在 需要alter add
            if ([columnArray containsObject:property.sqlColumnName.lowercaseString] == NO) {
                NSMutableString *addColumePars = [NSMutableString stringWithFormat:@"%@ %@", property.sqlColumnName, property.sqlColumnType];
                [clazz columnAttributeWithProperty:property];

                if ((property.length > 0) && [property.sqlColumnType isEqualToString:LKSQL_Type_Text]) {
                    [addColumePars appendFormat:@"(%ld)", (long)property.length];
                }

                if (property.isNotNull) {
                    [addColumePars appendFormat:@" %@", LKSQL_Attribute_NotNull];
                }

                if (property.checkValue) {
                    [addColumePars appendFormat:@" %@(%@)", LKSQL_Attribute_Check, property.checkValue];
                }

                if (property.defaultValue) {
                    [addColumePars appendFormat:@" %@ %@", LKSQL_Attribute_Default, property.defaultValue];
                }
                NSString *alertSQL = [NSString stringWithFormat:@"alter table %@ add column %@", tableName, addColumePars];
                NSString *defaultValue = @"0";
                if ([property.sqlColumnType isEqualToString:LKSQL_Type_Text]) {
                    if (LKDBNullIsEmptyString) {
                        defaultValue = @"";
                    }
                    else {
                        defaultValue = @"null";
                    }
                }
                NSString *initColumnValue = [NSString stringWithFormat:@"update %@ set %@=%@", tableName, property.sqlColumnName, defaultValue];
                BOOL success = [db executeUpdate:alertSQL];
                if (success) {
                    [db executeUpdate:initColumnValue];
                    [alterAddColumns addObject:property];
                }
            }
        }

        if (alterAddColumns.count > 0) {
            [clazz dbDidAlterTable:self tableName:tableName addColumns:alterAddColumns];
        }
    }];
}

- (BOOL)_createTableWithModelClass:(Class)modelClass tableName:(NSString *)tableName
{
    if (!tableName.length) {
        NSAssert(NO, @"none table name");
        return NO;
    }
    if ([self getTableCreatedWithTableName:tableName]) {
        // 已创建表 就跳过
        [self.threadLock lock];
        if ([self.createdTableNames containsObject:tableName] == NO) {
            [self.createdTableNames addObject:tableName];
        }
        [self.threadLock unlock];

        [self fixSqlColumnsWithClass:modelClass tableName:tableName];
        return YES;
    }

    LKModelInfos *infos = [modelClass getModelInfos];

    if (infos.count == 0) {
        LKErrorLog(@"Class: %@ 0属性 不需要创建表", NSStringFromClass(modelClass));
        return NO;
    }

    NSArray *primaryKeys = infos.primaryKeys;
    NSString *rowidAliasName = [modelClass db_rowidAliasName];

    NSMutableString *table_pars = [NSMutableString string];

    for (NSInteger i = 0; i < infos.count; i++) {
        if (i > 0) {
            [table_pars appendString:@","];
        }

        LKDBProperty *property = [infos objectWithIndex:i];
        [modelClass columnAttributeWithProperty:property];

        NSString *columnType = property.sqlColumnType;

        [table_pars appendFormat:@"%@ %@", property.sqlColumnName, columnType];

        if ([property.sqlColumnType isEqualToString:LKSQL_Type_Text]) {
            if (property.length > 0) {
                [table_pars appendFormat:@"(%ld)", (long)property.length];
            }
        }

        if (property.isNotNull) {
            [table_pars appendFormat:@" %@", LKSQL_Attribute_NotNull];
        }

        if (property.isUnique) {
            [table_pars appendFormat:@" %@", LKSQL_Attribute_Unique];
        }

        if (property.checkValue) {
            [table_pars appendFormat:@" %@(%@)", LKSQL_Attribute_Check, property.checkValue];
        }

        if (property.defaultValue) {
            [table_pars appendFormat:@" %@ %@", LKSQL_Attribute_Default, property.defaultValue];
        }

        if (rowidAliasName.length > 0) {
            if ([property.sqlColumnName isEqualToString:rowidAliasName]) {
                [table_pars appendString:@" primary key autoincrement"];
            }
        }
    }

    NSMutableString *pksb = [NSMutableString string];

    ///联合主键
    if (rowidAliasName.length == 0) {
        if (primaryKeys.count > 0) {
            pksb = [NSMutableString string];

            for (NSInteger i = 0; i < primaryKeys.count; i++) {
                NSString *pk = [primaryKeys objectAtIndex:i];

                if (pksb.length > 0) {
                    [pksb appendString:@","];
                }

                [pksb appendString:pk];
            }

            if (pksb.length > 0) {
                [pksb insertString:@",primary key(" atIndex:0];
                [pksb appendString:@")"];
            }
        }
    }

    NSString *createTableSQL = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(%@%@)", tableName, table_pars, pksb];

    BOOL isCreated = [self executeSQL:createTableSQL arguments:nil];

    [self.threadLock lock];
    if (isCreated) {
        [self.createdTableNames addObject:tableName];
        [modelClass dbDidCreateTable:self tableName:tableName];
    }
    [self.threadLock unlock];

    return isCreated;
}

- (BOOL)getTableCreatedWithClass:(Class)modelClass
{
    return [self getTableCreatedWithTableName:[modelClass getTableName]];
}

- (BOOL)getTableCreatedWithTableName:(NSString *)tableName
{
    __block BOOL isTableCreated = NO;

    [self executeDB:^(FMDatabase *db) {
        FMResultSet *set = [db executeQuery:@"select count(name) from sqlite_master where type='table' and name=?", tableName];
        if ([set next]) {
            if ([set intForColumnIndex:0] > 0) {
                isTableCreated = YES;
            }
        }
        [set close];
    }];
    return isTableCreated;
}

@end

@implementation LKDBHelper (DatabaseExecute)

- (id)modelValueWithProperty:(LKDBProperty *)property model:(NSObject *)model
{
    id value = nil;

    if (property.isUserCalculate) {
        value = [model userGetValueForModel:property];
    }
    else {
        value = [model modelGetValue:property];
    }

    if (value == nil) {
        if (LKDBNullIsEmptyString) {
            value = @"";
        }
        else {
            value = [NSNull null];
        }
    }
    
    return value;
}

- (void)asyncBlock:(void (^)(void))block
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block);
}

#pragma mark - row count operation
- (NSInteger)rowCount:(Class)modelClass where:(id)where
{
    return [self rowCountWithTableName:[modelClass getTableName] where:where];
}

- (void)rowCount:(Class)modelClass where:(id)where callback:(void (^)(NSInteger))callback
{
    if (!callback) {
        return;
    }
    LKDBCode_Async_Begin;
    NSInteger result = [sself rowCountWithTableName:[modelClass getTableName] where:where];
    callback(result);
    LKDBCode_Async_End;
}

- (NSInteger)rowCountWithTableName:(NSString *)tableName where:(id)where
{
    LKDBCheck_tableNameIsInvalid(tableName);

    NSMutableString *rowCountSql = [NSMutableString stringWithFormat:@"select count(rowid) from %@", tableName];

    NSMutableArray *valuesarray = [self extractQuery:rowCountSql where:where];
    NSInteger result = [[self executeScalarWithSQL:rowCountSql arguments:valuesarray] integerValue];

    return result;
}

#pragma mark - search operation
- (NSMutableArray *)search:(Class)modelClass where:(id)where orderBy:(NSString *)orderBy offset:(NSInteger)offset count:(NSInteger)count
{
    return [self searchBase:modelClass columns:nil where:where orderBy:orderBy offset:offset count:count];
}

- (NSMutableArray *)search:(Class)modelClass column:(id)columns where:(id)where orderBy:(NSString *)orderBy offset:(NSInteger)offset count:(NSInteger)count
{
    return [self searchBase:modelClass columns:columns where:where orderBy:orderBy offset:offset count:count];
}

- (id)searchSingle:(Class)modelClass where:(id)where orderBy:(NSString *)orderBy
{
    NSMutableArray *array = [self searchBase:modelClass columns:nil where:where orderBy:orderBy offset:0 count:1];

    if (array.count > 0) {
        return [array objectAtIndex:0];
    }

    return nil;
}

- (void)search:(Class)modelClass where:(id)where orderBy:(NSString *)orderBy offset:(NSInteger)offset count:(NSInteger)count callback:(void (^)(NSMutableArray *))block
{
    if (!block) {
        return;
    }
    LKDBCode_Async_Begin;
    LKDBQueryParams *params = [[LKDBQueryParams alloc] init];
    params.toClass = modelClass;

    if ([where isKindOfClass:[NSDictionary class]]) {
        params.whereDic = where;
    }
    else if ([where isKindOfClass:[NSString class]]) {
        params.where = where;
    }

    params.orderBy = orderBy;
    params.offset = offset;
    params.count = count;

    NSMutableArray *array = [sself searchBaseWithParams:params];
    block(array);
    LKDBCode_Async_End;
}

- (NSMutableArray *)searchBaseWithParams:(LKDBQueryParams *)params
{
    if (params.toClass == nil) {
        LKErrorLog(@"you search pars:%@! \n toClass is nil", params.getAllPropertysString);
        return nil;
    }

    NSString *db_tableName = params.tableName;

    if ([LKDBUtils checkStringIsEmpty:db_tableName]) {
        db_tableName = [params.toClass getTableName];
    }

    if ([LKDBUtils checkStringIsEmpty:db_tableName]) {
        LKErrorLog(@"you search pars:%@! \n tableName is empty", params.getAllPropertysString);
        return nil;
    }
    
    // 检测是否创建过表
    [self.threadLock lock];
    if ([self.createdTableNames containsObject:db_tableName] == NO) {
        [self _createTableWithModelClass:params.toClass tableName:db_tableName];
    }
    [self.threadLock unlock];

    NSString *columnsString = nil;
    NSUInteger columnCount = 0;

    if (params.columnArray.count > 0) {
        columnCount = params.columnArray.count;
        columnsString = [params.columnArray componentsJoinedByString:@","];
    }
    else if ([LKDBUtils checkStringIsEmpty:params.columns] == NO) {
        columnsString = params.columns;
        NSArray *array = [params.columns componentsSeparatedByString:@","];
        columnCount = array.count;
    }
    else {
        columnsString = @"*";
    }

    NSMutableString *query = [NSMutableString stringWithFormat:@"select %@,rowid from @t", columnsString];
    NSMutableArray *whereValues = nil;

    if (params.whereDic.count > 0) {
        whereValues = [NSMutableArray arrayWithCapacity:params.whereDic.count];
        NSString *wherekey = [self dictionaryToSqlWhere:params.whereDic andValues:whereValues];
        [query appendFormat:@" where %@", wherekey];
    }
    else if ([LKDBUtils checkStringIsEmpty:params.where] == NO) {
        [query appendFormat:@" where %@", params.where];
    }

    [self sqlString:query groupBy:params.groupBy orderBy:params.orderBy offset:params.offset count:params.count];

    // replace @t to model table name
    NSString *replaceTableName = [NSString stringWithFormat:@" %@ ", db_tableName];

    if ([query hasSuffix:@" @t"]) {
        [query appendString:@" "];
    }

    [query replaceOccurrencesOfString:@" @t " withString:replaceTableName options:NSCaseInsensitiveSearch range:NSMakeRange(0, query.length)];

    __block NSMutableArray *results = nil;
    [self executeDB:^(FMDatabase *db) {
        FMResultSet *set = nil;

        if (whereValues.count == 0) {
            set = [db executeQuery:query];
        }
        else {
            set = [db executeQuery:query withArgumentsInArray:whereValues];
        }

        if (columnCount == 1) {
            results = [self executeOneColumnResult:set];
        }
        else {
            results = [self executeResult:set Class:params.toClass tableName:db_tableName];
        }

        [set close];
    }];
    return results;
}

- (NSMutableArray *)searchWithParams:(LKDBQueryParams *)params
{
    if (params.callback) {
        LKDBCode_Async_Begin;
        NSMutableArray *array = [sself searchBaseWithParams:params];
        params.callback(array);
        LKDBCode_Async_End;
        return nil;
    }
    else {
        return [self searchBaseWithParams:params];
    }
}

- (NSMutableArray *)searchBase:(Class)modelClass columns:(id)columns where:(id)where orderBy:(NSString *)orderBy offset:(NSInteger)offset count:(NSInteger)count
{
    LKDBQueryParams *params = [[LKDBQueryParams alloc] init];

    params.toClass = modelClass;

    if ([columns isKindOfClass:[NSArray class]]) {
        params.columnArray = columns;
    }
    else if ([columns isKindOfClass:[NSString class]]) {
        params.columns = columns;
    }

    if ([where isKindOfClass:[NSDictionary class]]) {
        params.whereDic = where;
    }
    else if ([where isKindOfClass:[NSString class]]) {
        params.where = where;
    }

    params.orderBy = orderBy;
    params.offset = offset;
    params.count = count;

    return [self searchBaseWithParams:params];
}

- (NSString *)replaceTableNameIfNeeded:(NSString *)sql withModelClass:(Class)modelClass
{
    if (!modelClass) {
        return sql;
    }
    
    // replace @t to model table name
    NSString *replaceString = [[modelClass getTableName] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([sql hasSuffix:@" @t"]) {
        sql = [sql stringByAppendingString:@" "];
    }
    if ([sql componentsSeparatedByString:@" from "].count == 2 && [sql rangeOfString:@" join "].length == 0) {
        sql = [sql stringByReplacingOccurrencesOfString:@" from " withString:[NSString stringWithFormat:@",%@.rowid from ", replaceString]];
    }

    sql = [sql stringByReplacingOccurrencesOfString:@" @t "
                                         withString:
                                             [NSString stringWithFormat:@" %@ ", replaceString]];
    sql = [sql stringByReplacingOccurrencesOfString:@" @t,"
                                         withString:
                                             [NSString stringWithFormat:@" %@,", replaceString]];
    sql = [sql stringByReplacingOccurrencesOfString:@",@t "
                                         withString:
                                             [NSString stringWithFormat:@",%@ ", replaceString]];

    return sql;
}

- (NSMutableArray *)searchWithSQL:(NSString *)sql toClass:(Class)modelClass
{
    sql = [self replaceTableNameIfNeeded:sql withModelClass:modelClass];
    return [self searchWithRAWSQL:sql toClass:modelClass];
}

- (NSMutableArray *)searchWithRAWSQL:(NSString *)sql toClass:(Class)modelClass
{
    __block NSMutableArray *results = nil;
    [self executeDB:^(FMDatabase *db) {
        FMResultSet *set = [db executeQuery:sql];
        results = [self executeResult:set Class:modelClass tableName:nil];
        [set close];
    }];
    return results;
}

- (NSMutableArray *)search:(Class)modelClass withSQL:(NSString *)sql, ...
{
    va_list args;
    va_start(args, sql);

    sql = [self replaceTableNameIfNeeded:sql withModelClass:modelClass];

    va_list *argsPoint = &args;
    __block NSMutableArray *results = nil;
    [self executeDB:^(FMDatabase *db) {
        FMResultSet *set = [db executeQuery:sql withVAList:*argsPoint];
        results = [self executeResult:set Class:modelClass tableName:nil];
        [set close];
    }];

    va_end(args);
    return results;
}

- (void)sqlString:(NSMutableString *)sql groupBy:(NSString *)groupBy orderBy:(NSString *)orderby offset:(NSInteger)offset count:(NSInteger)count
{
    if ([LKDBUtils checkStringIsEmpty:groupBy] == NO) {
        [sql appendFormat:@" group by %@", groupBy];
    }

    if ([LKDBUtils checkStringIsEmpty:orderby] == NO) {
        [sql appendFormat:@" order by %@", orderby];
    }

    if (count > 0) {
        [sql appendFormat:@" limit %ld offset %ld", (long)count, (long)offset];
    }
    else if (offset > 0) {
        [sql appendFormat:@" limit %d offset %ld", INT_MAX, (long)offset];
    }
}

- (NSMutableArray *)executeOneColumnResult:(FMResultSet *)set
{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];

    while ([set next]) {
        NSString *string = [set stringForColumnIndex:0];

        if (string) {
            [array addObject:string];
        }
        else {
            NSData *data = [set dataForColumnIndex:0];

            if (data) {
                [array addObject:data];
            }
        }
    }

    return array;
}

- (NSMutableArray *)executeResult:(FMResultSet *)set Class:(Class)modelClass tableName:(NSString *)tableName
{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    if (!modelClass) {
        while ([set next]) {
            NSDictionary * dict = [set resultDictionary];
            if (dict) {
                [array addObject:dict];
            }
        }
    }
    else {
        LKModelInfos *infos = [modelClass getModelInfos];
        NSInteger columnCount = [set columnCount];
        
        ///当主键是int类型时 会替换掉rowid
        NSString *rowidAliasName = [modelClass db_rowidAliasName];
        
        while ([set next]) {
            NSObject *bindingModel = [[modelClass alloc] init];
            if (bindingModel == nil) {
                continue;
            }
            for (int i = 0; i < columnCount; i++) {
                NSString *sqlName = [set columnNameForIndex:i];
                LKDBProperty *property = [infos objectWithSqlColumnName:sqlName];
                
                BOOL isRowid = [[sqlName lowercaseString] isEqualToString:@"rowid"];
                
                if ((isRowid == NO) && (property == nil)) {
                    continue;
                }
                
                if (isRowid && ((property == nil) || [property.sqlColumnType isEqualToString:LKSQL_Type_Int])) {
                    bindingModel.rowid = [set longForColumnIndex:i];
                }
                else {
                    BOOL isUserCalculate = [property.type isEqualToString:LKSQL_Mapping_UserCalculate];
                    
                    if (property.propertyName && (isUserCalculate == NO)) {
                        NSString *sqlValue = [set stringForColumnIndex:i];
                        [bindingModel modelSetValue:property value:sqlValue];
                        
                        if ([rowidAliasName isEqualToString:sqlName]) {
                            bindingModel.rowid = [set longForColumnIndex:i];
                        }
                    }
                    else {
                        NSData *sqlData = [set dataForColumnIndex:i];
                        NSString *sqlValue = nil;
                        if (sqlData) {
                            sqlValue = [[NSString alloc] initWithData:sqlData encoding:NSUTF8StringEncoding];
                        }
                        [bindingModel userSetValueForModel:property value:sqlValue ?: sqlData];
                    }
                }
            }
            bindingModel.db_tableName = tableName;
            [modelClass dbDidSeleted:bindingModel];
            [array addObject:bindingModel];
        }
    }
    return array;
}

#pragma mark - insert operation
- (BOOL)insertToDB:(NSObject *)model
{
    return [self insertBase:model];
}

- (void)insertToDB:(NSObject *)model callback:(void (^)(BOOL))block
{
    LKDBCode_Async_Begin;
    BOOL result = [sself insertBase:model];
    if (block) {
        block(result);
    }
    LKDBCode_Async_End;
}

- (BOOL)insertWhenNotExists:(NSObject *)model
{
    if ([self isExistsModel:model] == NO) {
        return [self insertToDB:model];
    }
    return NO;
}

- (void)insertWhenNotExists:(NSObject *)model callback:(void (^)(BOOL))block
{
    LKDBCode_Async_Begin;
    BOOL result = [sself insertWhenNotExists:model];
    if (block) {
        block(result);
    }
    LKDBCode_Async_End;
}

- (BOOL)insertBase:(NSObject *)model
{
    LKDBCheck_modelIsInvalid(model);

    Class modelClass = model.class;

    // callback
    if ([modelClass dbWillInsert:model] == NO) {
        LKErrorLog(@"your cancel %@ insert", model);
        return NO;
    }

    [model setDb_inserting:YES];

    NSString *db_tableName = model.db_tableName ?: [modelClass getTableName];

    // 检测是否创建过表
    [self.threadLock lock];
    if ([self.createdTableNames containsObject:db_tableName] == NO) {
        [self _createTableWithModelClass:modelClass tableName:db_tableName];
    }
    [self.threadLock unlock];

    // --
    LKModelInfos *infos = [modelClass getModelInfos];

    NSMutableString *insertKey = [NSMutableString stringWithCapacity:0];
    NSMutableString *insertValuesString = [NSMutableString stringWithCapacity:0];
    NSMutableArray *insertValues = [NSMutableArray arrayWithCapacity:infos.count];

    LKDBProperty *primaryProperty = [model singlePrimaryKeyProperty];

    for (NSInteger i = 0; i < infos.count; i++) {
        LKDBProperty *property = [infos objectWithIndex:i];

        if ([LKDBUtils checkStringIsEmpty:property.sqlColumnName]) {
            continue;
        }

        if ([property isEqual:primaryProperty]) {
            if ([property.sqlColumnType isEqualToString:LKSQL_Type_Int] && [model singlePrimaryKeyValueIsEmpty]) {
                continue;
            }
        }

        id value = [self modelValueWithProperty:property model:model];
        if (value == nil) {
            continue;
        }
        ///跳过 rowid = 0 的属性
        if ([property.sqlColumnName isEqualToString:@"rowid"] && ([value intValue] == 0)) {
            continue;
        }

        if (insertKey.length > 0) {
            [insertKey appendString:@","];
            [insertValuesString appendString:@","];
        }

        [insertKey appendString:property.sqlColumnName];
        [insertValuesString appendString:@"?"];

        [insertValues addObject:value];
    }

    // 拼接insertSQL 语句  采用 replace 插入
    NSString *insertSQL = [NSString stringWithFormat:@"replace into %@(%@) values(%@)", db_tableName, insertKey, insertValuesString];

    __block BOOL execute = NO;
    __block sqlite_int64 lastInsertRowId = 0;

    [self executeDB:^(FMDatabase *db) {
        execute = [db executeUpdate:insertSQL withArgumentsInArray:insertValues];
        lastInsertRowId = db.lastInsertRowId;

        if (db.hadError) {
            LKErrorLog(@" sql:%@ \n args:%@ \n sqlite error :%@ \n", insertSQL, insertValues, db.lastErrorMessage);
        }
    }];

    model.rowid = (NSInteger)lastInsertRowId;

    [model setDb_inserting:NO];

    // callback
    [modelClass dbDidInserted:model result:execute];
    return execute;
}

#pragma mark - update operation
- (BOOL)updateToDB:(NSObject *)model where:(id)where
{
    return [self updateToDBBase:model where:where];
}

- (void)updateToDB:(NSObject *)model where:(id)where callback:(void (^)(BOOL))block
{
    LKDBCode_Async_Begin;
    BOOL result = [sself updateToDBBase:model where:where];
    if (block) {
        block(result);
    }
    LKDBCode_Async_End;
}

- (BOOL)updateToDBBase:(NSObject *)model where:(id)where
{
    LKDBCheck_modelIsInvalid(model);

    Class modelClass = model.class;

    // callback
    if ([modelClass dbWillUpdate:model] == NO) {
        LKErrorLog(@"you cancel %@ update.", model);
        return NO;
    }

    NSString *db_tableName = model.db_tableName ?: [modelClass getTableName];

    // 检测是否创建过表
    [self.threadLock lock];
    if ([self.createdTableNames containsObject:db_tableName] == NO) {
        [self _createTableWithModelClass:modelClass tableName:db_tableName];
    }
    [self.threadLock unlock];

    LKModelInfos *infos = [modelClass getModelInfos];

    NSMutableString *updateKey = [NSMutableString string];
    NSMutableArray *updateValues = [NSMutableArray arrayWithCapacity:infos.count];

    for (NSInteger i = 0; i < infos.count; i++) {
        LKDBProperty *property = [infos objectWithIndex:i];
        if ([LKDBUtils checkStringIsEmpty:property.sqlColumnName]) {
            continue;
        }
        id value = [self modelValueWithProperty:property model:model];
        if (value == nil) {
            continue;
        }
        ///跳过 rowid = 0 的属性
        if ([property.sqlColumnName isEqualToString:@"rowid"]) {
            int rowid = [value intValue];
            if (rowid > 0) {
                ///如果rowid 已经存在就不修改
                NSString *rowidWhere = [NSString stringWithFormat:@"rowid=%d", rowid];
                NSInteger rowCount = [self rowCountWithTableName:db_tableName where:rowidWhere];
                if (rowCount > 0) {
                    continue;
                }
            }
            else {
                continue;
            }
        }
        if (updateKey.length > 0) {
            [updateKey appendString:@","];
        }
        [updateKey appendFormat:@"%@=?", property.sqlColumnName];
        [updateValues addObject:value];
    }

    NSMutableString *updateSQL = [NSMutableString stringWithFormat:@"update %@ set %@ where ", db_tableName, updateKey];
    // 添加where 语句
    if ([where isKindOfClass:[NSString class]] && ([LKDBUtils checkStringIsEmpty:where] == NO)) {
        [updateSQL appendString:where];
    }
    else if ([where isKindOfClass:[NSDictionary class]] && ([(NSDictionary *)where count] > 0)) {
        NSMutableArray *valuearray = [NSMutableArray array];
        NSString *sqlwhere = [self dictionaryToSqlWhere:where andValues:valuearray];

        [updateSQL appendString:sqlwhere];
        [updateValues addObjectsFromArray:valuearray];
    }
    else if (model.rowid > 0) {
        [updateSQL appendFormat:@" rowid=%ld", (long)model.rowid];
    }
    else {
        // 如果不通过 rowid 来 更新数据  那 primarykey 一定要有值
        NSString *pwhere = [self primaryKeyWhereSQLWithModel:model addPValues:updateValues];

        if (pwhere.length == 0) {
            LKErrorLog(@"database update fail : %@ no find primary key!", NSStringFromClass(modelClass));
            return NO;
        }

        [updateSQL appendString:pwhere];
    }

    BOOL execute = [self executeSQL:updateSQL arguments:updateValues];
    // callback
    [modelClass dbDidUpdated:model result:execute];

    return execute;
}

- (BOOL)updateToDB:(Class)modelClass set:(NSString *)sets where:(id)where
{
    return [self updateToDBWithTableName:[modelClass getTableName] set:sets where:where];
}

- (BOOL)updateToDBWithTableName:(NSString *)tableName set:(NSString *)sets where:(id)where
{
    LKDBCheck_tableNameIsInvalid(tableName);

    NSMutableString *updateSQL = [NSMutableString stringWithFormat:@"update %@ set %@ ", tableName, sets];
    NSMutableArray *updateValues = [self extractQuery:updateSQL where:where];

    BOOL execute = [self executeSQL:updateSQL arguments:updateValues];

    return execute;
}

#pragma mark - delete operation
- (BOOL)deleteToDB:(NSObject *)model
{
    return [self deleteToDBBase:model];
}

- (void)deleteToDB:(NSObject *)model callback:(void (^)(BOOL))block
{
    LKDBCode_Async_Begin;
    BOOL isDeleted = [sself deleteToDBBase:model];
    if (block) {
        block(isDeleted);
    }
    LKDBCode_Async_End;
}

- (BOOL)deleteToDBBase:(NSObject *)model
{
    LKDBCheck_modelIsInvalid(model);

    Class modelClass = model.class;

    // callback
    if ([modelClass dbWillDelete:model] == NO) {
        LKErrorLog(@"you cancel %@ delete", model);
        return NO;
    }

    NSString *db_tableName = model.db_tableName ?: [modelClass getTableName];

    NSMutableString *deleteSQL = [NSMutableString stringWithFormat:@"delete from %@ where ", db_tableName];
    NSMutableArray *parsArray = [NSMutableArray array];

    if (model.rowid > 0) {
        [deleteSQL appendFormat:@"rowid = %ld", (long)model.rowid];
    }
    else {
        NSString *pwhere = [self primaryKeyWhereSQLWithModel:model addPValues:parsArray];

        if (pwhere.length == 0) {
            LKErrorLog(@"delete fail : %@ primary value is nil", NSStringFromClass(modelClass));
            return NO;
        }

        [deleteSQL appendString:pwhere];
    }

    if (parsArray.count == 0) {
        parsArray = nil;
    }

    BOOL execute = [self executeSQL:deleteSQL arguments:parsArray];

    // callback
    [modelClass dbDidDeleted:model result:execute];

    return execute;
}

- (BOOL)deleteWithClass:(Class)modelClass where:(id)where
{
    return [self deleteWithTableName:[modelClass getTableName] where:where];
}

- (void)deleteWithClass:(Class)modelClass where:(id)where callback:(void (^)(BOOL))block
{
    LKDBCode_Async_Begin;
    BOOL isDeleted = [sself deleteWithTableName:[modelClass getTableName] where:where];
    if (block) {
        block(isDeleted);
    }
    LKDBCode_Async_End;
}

- (BOOL)deleteWithTableName:(NSString *)tableName where:(id)where
{
    LKDBCheck_tableNameIsInvalid(tableName);

    NSMutableString *deleteSQL = [NSMutableString stringWithFormat:@"delete from %@", tableName];
    NSMutableArray *values = [self extractQuery:deleteSQL where:where];

    BOOL result = [self executeSQL:deleteSQL arguments:values];
    return result;
}

#pragma mark - other operation
- (BOOL)isExistsModel:(NSObject *)model
{
    LKDBCheck_modelIsInvalid(model);
    NSString *pwhere = nil;

    if (model.rowid > 0) {
        pwhere = [NSString stringWithFormat:@"rowid=%ld", (long)model.rowid];
    }
    else {
        pwhere = [self primaryKeyWhereSQLWithModel:model addPValues:nil];
    }

    if (pwhere.length == 0) {
        LKErrorLog(@"exists model fail: primary key is nil or invalid");
        return NO;
    }

    return [self isExistsClass:model.class where:pwhere];
}

- (BOOL)isExistsClass:(Class)modelClass where:(id)where
{
    return [self isExistsWithTableName:[modelClass getTableName] where:where];
}

- (BOOL)isExistsWithTableName:(NSString *)tableName where:(id)where
{
    return [self rowCountWithTableName:tableName where:where] > 0;
}

#pragma mark - clear operation

+ (void)clearTableData:(Class)modelClass
{
    [[modelClass getUsingLKDBHelper] executeDB:^(FMDatabase *db) {
        NSString *delete = [NSString stringWithFormat:@"DELETE FROM %@", [modelClass getTableName]];
        [db executeUpdate:delete];
    }];
}

+ (void)clearNoneImage:(Class)modelClass columns:(NSArray *)columns
{
    [self clearFileWithTable:modelClass columns:columns type:1];
}

+ (void)clearNoneData:(Class)modelClass columns:(NSArray *)columns
{
    [self clearFileWithTable:modelClass columns:columns type:2];
}

#define LKTestDirFilename @"LKTestDirFilename111"
+ (void)clearFileWithTable:(Class)modelClass columns:(NSArray *)columns type:(NSInteger)type
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        NSString *testpath = nil;
        switch (type) {
        case 1:
            testpath = [modelClass getDBImagePathWithName:LKTestDirFilename];
            break;

        case 2:
            testpath = [modelClass getDBDataPathWithName:LKTestDirFilename];
            break;
        }

        if ([LKDBUtils checkStringIsEmpty:testpath]) {
            return;
        }

        NSString *dir = [testpath stringByReplacingOccurrencesOfString:LKTestDirFilename withString:@""];

        NSUInteger count = columns.count;

        // 获取该目录下所有文件名
        NSArray *files = [LKDBUtils getFilenamesWithDir:dir];

        NSString *seleteColumn = [columns componentsJoinedByString:@","];
        NSMutableString *whereStr = [NSMutableString string];

        for (NSInteger i = 0; i < count; i++) {
            [whereStr appendFormat:@" %@ != '' ", [columns objectAtIndex:i]];

            if (i < count - 1) {
                [whereStr appendString:@" or "];
            }
        }

        NSString *querySql = [NSString stringWithFormat:@"select %@ from %@ where %@", seleteColumn, [modelClass getTableName], whereStr];
        __block NSArray *dbfiles;
        [[modelClass getUsingLKDBHelper] executeDB:^(FMDatabase *db) {
            NSMutableArray *tempfiles = [NSMutableArray arrayWithCapacity:6];
            FMResultSet *set = [db executeQuery:querySql];

            while ([set next]) {
                for (int j = 0; j < count; j++) {
                    NSString *str = [set stringForColumnIndex:j];

                    if ([LKDBUtils checkStringIsEmpty:str] == NO) {
                        [tempfiles addObject:str];
                    }
                }
            }

            [set close];
            dbfiles = tempfiles;
        }];

        // 遍历  当不再数据库记录中 就删除
        for (NSString *deletefile in files) {
            if ([dbfiles indexOfObject:deletefile] == NSNotFound) {
                [LKDBUtils deleteWithFilepath:[dir stringByAppendingPathComponent:deletefile]];
            }
        }
    });
}

@end

@implementation LKDBHelper (Deprecated_Nonfunctional)
- (void)setEncryptionKey:(NSString *)encryptionKey
{
    [self setKey:encryptionKey];
}
+ (LKDBHelper *)sharedDBHelper
{
    return [LKDBHelper getUsingLKDBHelper];
}
- (BOOL)createTableWithModelClass:(Class)modelClass
{
    return [self _createTableWithModelClass:modelClass tableName:[modelClass getTableName]];
}
+ (LKDBHelper *)getUsingLKDBHelper
{
    return [[LKDBHelper alloc] init];
}
@end

@implementation LKDBWeakObject

@end
