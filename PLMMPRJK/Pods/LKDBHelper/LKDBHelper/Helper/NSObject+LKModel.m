//
//  NSObject+LKModel.m
//  LKDBHelper
//
//  Created by LJH on 13-4-15.
//  Copyright (c) 2013年 ljh. All rights reserved.
//

#import "NSObject+LKModel.h"
#import "LKDBHelper.h"
#import <objc/runtime.h>

#ifdef __IPHONE_OS_VERSION_MIN_REQUIRED
#import <UIKit/UIKit.h>
#define LKDBImage UIImage
#define LKDBColor UIColor
#else
#import <AppKit/AppKit.h>
#define LKDBImage NSImage
#define LKDBColor NSColor
#endif

static char LKModelBase_Key_RowID;
static char LKModelBase_Key_TableName;
static char LKModelBase_Key_Inserting;

@interface LKDBHelper (LKDBHelper_LKModel)
+ (BOOL)nullIsEmpty;
@end

@implementation NSObject (LKModel)

+ (LKDBHelper *)getUsingLKDBHelper
{
    ///ios8 能获取系统类的属性了  所以没有办法判断属性数量来区分自定义类和系统类
    ///可能系统类的存取会不正确
    static LKDBHelper *helper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[LKDBHelper alloc] init];
    });
    return helper;
}
#pragma mark Tabel Structure Function 表结构
+ (NSString *)getTableName
{
    return NSStringFromClass(self);
}

+ (NSString *)getPrimaryKey
{
    return @"rowid";
}

+ (NSArray *)getPrimaryKeyUnionArray
{
    return nil;
}

+ (void)columnAttributeWithProperty:(LKDBProperty *)property
{
    //overwrite
}
#pragma 属性
- (void)setRowid:(NSInteger)rowid
{
    objc_setAssociatedObject(self, &LKModelBase_Key_RowID, [NSNumber numberWithInteger:rowid], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSInteger)rowid
{
    return [objc_getAssociatedObject(self, &LKModelBase_Key_RowID) integerValue];
}

- (void)setDb_tableName:(NSString *)db_tableName
{
    objc_setAssociatedObject(self, &LKModelBase_Key_TableName, db_tableName, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (NSString *)db_tableName
{
    NSString *tableName = objc_getAssociatedObject(self, &LKModelBase_Key_TableName);
    if (tableName.length == 0) {
        tableName = [self.class getTableName];
    }
    return tableName;
}
- (BOOL)db_inserting
{
    return [objc_getAssociatedObject(self, &LKModelBase_Key_Inserting) boolValue];
}
- (void)setDb_inserting:(BOOL)db_inserting
{
    NSNumber *number = nil;
    if (db_inserting) {
        number = [NSNumber numberWithBool:YES];
    }
    objc_setAssociatedObject(self, &LKModelBase_Key_Inserting, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
#pragma 无关紧要的
+ (NSString *)getDBImagePathWithName:(NSString *)filename
{
    NSString *dir = [NSString stringWithFormat:@"dbimg/%@", NSStringFromClass(self)];
    return [LKDBUtils getPathForDocuments:filename inDir:dir];
}
+ (NSString *)getDBDataPathWithName:(NSString *)filename
{
    NSString *dir = [NSString stringWithFormat:@"dbdata/%@", NSStringFromClass(self)];
    return [LKDBUtils getPathForDocuments:filename inDir:dir];
}
+ (NSDictionary *)getTableMapping
{
    return nil;
}
#pragma mark - Table Data Function 表数据
+ (NSDateFormatter *)getModelDateFormatter
{
    return nil;
}

///get
- (id)modelGetValue:(LKDBProperty *)property
{
    id value = [self valueForKey:property.propertyName];
    id returnValue = value;
    if (value == nil) {
        return nil;
    }
    else if ([value isKindOfClass:[NSString class]]) {
        returnValue = [value copy];
    }
    else if ([value isKindOfClass:[NSNumber class]]) {
        returnValue = [[LKDBUtils numberFormatter] stringFromNumber:value];
    }
    else if ([value isKindOfClass:[NSDate class]]) {
        NSDateFormatter *formatter = [self.class getModelDateFormatter];
        if (formatter) {
            returnValue = [formatter stringFromDate:value];
        }
        else {
            returnValue = [LKDBUtils stringWithDate:value];
        }
        returnValue = [returnValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    else if ([value isKindOfClass:[LKDBColor class]]) {
        LKDBColor *color = value;
        CGFloat r, g, b, a;
        [color getRed:&r green:&g blue:&b alpha:&a];
        returnValue = [NSString stringWithFormat:@"%.3f,%.3f,%.3f,%.3f", r, g, b, a];
    }
    else if ([value isKindOfClass:[NSValue class]]) {
        NSString *columnType = property.propertyType;
#ifdef __IPHONE_OS_VERSION_MIN_REQUIRED
        if ([columnType isEqualToString:@"CGRect"]) {
            returnValue = NSStringFromCGRect([value CGRectValue]);
        }
        else if ([columnType isEqualToString:@"CGPoint"]) {
            returnValue = NSStringFromCGPoint([value CGPointValue]);
        }
        else if ([columnType isEqualToString:@"CGSize"]) {
            returnValue = NSStringFromCGSize([value CGSizeValue]);
        }
        else if ([columnType isEqualToString:@"_NSRange"]) {
            returnValue = NSStringFromRange([value rangeValue]);
        }
#else
        if ([columnType hasSuffix:@"Rect"]) {
            returnValue = NSStringFromRect([value rectValue]);
        }
        else if ([columnType hasSuffix:@"Point"]) {
            returnValue = NSStringFromPoint([value pointValue]);
        }
        else if ([columnType hasSuffix:@"Size"]) {
            returnValue = NSStringFromSize([value sizeValue]);
        }
        else if ([columnType hasSuffix:@"Range"]) {
            returnValue = NSStringFromRange([value rangeValue]);
        }
#endif
    }
    else if ([value isKindOfClass:[LKDBImage class]]) {
        long random = arc4random();
        long date = [[NSDate date] timeIntervalSince1970];
        NSString *filename = [NSString stringWithFormat:@"img%ld%ld", date & 0xFFFFF, random & 0xFFF];

#ifdef __IPHONE_OS_VERSION_MIN_REQUIRED
        NSData *datas = UIImageJPEGRepresentation(value, 1);
#else
        [value lockFocus];
        NSBitmapImageRep *srcImageRep = [NSBitmapImageRep imageRepWithData:[value TIFFRepresentation]];
        NSData *datas = [srcImageRep representationUsingType:NSJPEGFileType properties:@{}];
        [value unlockFocus];
#endif
        [datas writeToFile:[self.class getDBImagePathWithName:filename]
                atomically:YES];

        returnValue = filename;
    }
    else if ([value isKindOfClass:[NSData class]]) {
        long random = arc4random();
        long date = [[NSDate date] timeIntervalSince1970];
        NSString *filename = [NSString stringWithFormat:@"data%ld%ld", date & 0xFFFFF, random & 0xFFF];

        [value writeToFile:[self.class getDBDataPathWithName:filename] atomically:YES];

        returnValue = filename;
    }
    else if ([value isKindOfClass:[NSURL class]]) {
        returnValue = [value absoluteString];
    }
    else {
        if ([value isKindOfClass:[NSArray class]]) {
            returnValue = [self db_jsonObjectFromArray:value];
        }
        else if ([value isKindOfClass:[NSDictionary class]]) {
            returnValue = [self db_jsonObjectFromDictionary:value];
        }
        else {
            returnValue = [self db_jsonObjectFromModel:value];
        }
        returnValue = [self db_jsonStringFromObject:returnValue];
    }

    return returnValue;
}

///set
- (void)modelSetValue:(LKDBProperty *)property value:(NSString *)value
{
    ///参试获取属性的Class
    Class columnClass = NSClassFromString(property.propertyType);

    id modelValue = nil;

    if (columnClass == nil) {
        ///当找不到 class 时，就是 基础类型 int,float CGRect 之类的
        NSString *columnType = property.propertyType;
        if ([LKSQL_Convert_FloatType rangeOfString:columnType].location != NSNotFound) {
            if (value) {
                modelValue = [[LKDBUtils numberFormatter] numberFromString:value];
            }
        }
        else if ([LKSQL_Convert_IntType rangeOfString:columnType].location != NSNotFound) {
            if (value) {
                modelValue = [[LKDBUtils numberFormatter] numberFromString:value];
            }
        }
#ifdef __IPHONE_OS_VERSION_MIN_REQUIRED
        else if ([columnType isEqualToString:@"CGRect"]) {
            if (value) {
                CGRect rect = CGRectFromString(value);
                modelValue = [NSValue valueWithCGRect:rect];
            }
            else {
                modelValue = [NSValue valueWithCGRect:CGRectZero];
            }
        }
        else if ([columnType isEqualToString:@"CGPoint"]) {
            if (value) {
                CGPoint point = CGPointFromString(value);
                modelValue = [NSValue valueWithCGPoint:point];
            }
            else {
                modelValue = [NSValue valueWithCGPoint:CGPointZero];
            }
        }
        else if ([columnType isEqualToString:@"CGSize"]) {
            if (value) {
                CGSize size = CGSizeFromString(value);
                modelValue = [NSValue valueWithCGSize:size];
            }
            else {
                modelValue = [NSValue valueWithCGSize:CGSizeZero];
            }
        }
        else if ([columnType isEqualToString:@"_NSRange"]) {
            if (value) {
                NSRange range = NSRangeFromString(value);
                modelValue = [NSValue valueWithRange:range];
            }
            else {
                modelValue = [NSValue valueWithRange:NSMakeRange(0, 0)];
            }
        }
#else
        else if ([columnType hasSuffix:@"Rect"]) {
            if (value) {
                NSRect rect = NSRectFromString(value);
                modelValue = [NSValue valueWithRect:rect];
            }
            else {
                modelValue = [NSValue valueWithRect:NSZeroRect];
            }
        }
        else if ([columnType hasSuffix:@"Point"]) {
            if (value) {
                NSPoint point = NSPointFromString(value);
                modelValue = [NSValue valueWithPoint:point];
            }
            else {
                modelValue = [NSValue valueWithPoint:NSZeroPoint];
            }
        }
        else if ([columnType hasSuffix:@"Size"]) {
            if (value) {
                NSSize size = NSSizeFromString(value);
                modelValue = [NSValue valueWithSize:size];
            }
            else {
                modelValue = [NSValue valueWithSize:NSZeroSize];
            }
        }
        else if ([columnType hasSuffix:@"Range"]) {
            if (value) {
                NSRange range = NSRangeFromString(value);
                modelValue = [NSValue valueWithRange:range];
            }
            else {
                modelValue = [NSValue valueWithRange:NSMakeRange(0, 0)];
            }
        }
#endif
        ///如果都没有值 默认给个0
        if (modelValue == nil) {
            modelValue = @0;
        }
    }
    else if (!value || ![value isKindOfClass:[NSString class]]) {
        //不继续遍历
    }
    else if ([columnClass isSubclassOfClass:[NSString class]]) {
        if (![LKDBHelper nullIsEmpty] || value.length > 0) {
            modelValue = [columnClass stringWithString:value];
        }
    }
    else if ([columnClass isSubclassOfClass:[NSNumber class]]) {
        modelValue = [[LKDBUtils numberFormatter] numberFromString:value];
    }
    else if ([columnClass isSubclassOfClass:[NSDate class]]) {
        NSString *datestr = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSDateFormatter *formatter = [self.class getModelDateFormatter];
        if (formatter) {
            modelValue = [formatter dateFromString:datestr];
        }
        else {
            modelValue = [LKDBUtils dateWithString:datestr];
        }
    }
    else if ([columnClass isSubclassOfClass:[LKDBColor class]]) {
        NSString *colorString = value;
        NSArray *array = [colorString componentsSeparatedByString:@","];
        float r, g, b, a;
        r = [[array objectAtIndex:0] floatValue];
        g = [[array objectAtIndex:1] floatValue];
        b = [[array objectAtIndex:2] floatValue];
        a = [[array objectAtIndex:3] floatValue];
        
        modelValue = [LKDBColor colorWithRed:r green:g blue:b alpha:a];
    }
    else if ([columnClass isSubclassOfClass:[LKDBImage class]]) {
        NSString *filename = value;
        NSString *filepath = [self.class getDBImagePathWithName:filename];
        if ([LKDBUtils isFileExists:filepath]) {
            modelValue = [[LKDBImage alloc] initWithContentsOfFile:filepath];
        }
    }
    else if ([columnClass isSubclassOfClass:[NSData class]]) {
        NSString *filename = value;
        NSString *filepath = [self.class getDBDataPathWithName:filename];
        if ([LKDBUtils isFileExists:filepath]) {
            modelValue = [NSData dataWithContentsOfFile:filepath];
        }
    }
    else if ([columnClass isSubclassOfClass:[NSURL class]]) {
        NSString *urlString = value;
        modelValue = [NSURL URLWithString:urlString];
    }
    else {
        modelValue = [self db_modelWithJsonValue:value];
        BOOL isValid = NO;
        if ([modelValue isKindOfClass:[NSArray class]] && [columnClass isSubclassOfClass:[NSArray class]]) {
            isValid = YES;
            modelValue = [columnClass arrayWithArray:modelValue];
        }
        else if ([modelValue isKindOfClass:[NSDictionary class]] && [columnClass isSubclassOfClass:[NSDictionary class]]) {
            isValid = YES;
            modelValue = [columnClass dictionaryWithDictionary:modelValue];
        }
        else if ([modelValue isKindOfClass:columnClass]) {
            isValid = YES;
        }
        ///如果类型不对 则设置为空
        if (!isValid) {
            modelValue = nil;
        }
    }

    [self setValue:modelValue forKey:property.propertyName];
}
#pragma mark - 对 model NSArray NSDictionary 进行支持
- (id)db_jsonObjectFromDictionary:(NSDictionary *)dic
{
    if ([NSJSONSerialization isValidJSONObject:dic]) {
        NSDictionary *bomb = @{ LKDB_TypeKey : LKDB_TypeKey_JSON, LKDB_ValueKey : dic };
        return bomb;
    }
    else {
        NSMutableDictionary *toDic = [NSMutableDictionary dictionary];
        [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            id jsonObject = [self db_jsonObjectWithObject:obj];
            if (jsonObject) {
                toDic[key] = jsonObject;
            }
        }];
        if (toDic.count) {
            NSDictionary *bomb = @{ LKDB_TypeKey : LKDB_TypeKey_Combo, LKDB_ValueKey : toDic };
            return bomb;
        }
    }
    return nil;
}
- (id)db_jsonObjectFromArray:(NSArray *)array
{
    if ([NSJSONSerialization isValidJSONObject:array]) {
        NSDictionary *bomb = @{ LKDB_TypeKey : LKDB_TypeKey_JSON, LKDB_ValueKey : array };
        return bomb;
    }
    else {
        NSMutableArray *toArray = [NSMutableArray array];
        NSInteger count = array.count;
        for (NSInteger i = 0; i < count; i++) {
            id obj = [array objectAtIndex:i];
            id jsonObject = [self db_jsonObjectWithObject:obj];
            if (jsonObject) {
                [toArray addObject:jsonObject];
            }
        }

        if (toArray.count) {
            NSDictionary *bomb = @{ LKDB_TypeKey : LKDB_TypeKey_Combo, LKDB_ValueKey : toArray };
            return bomb;
        }
    }
    return nil;
}
///目前只支持 model、NSString、NSNumber 简单类型
- (id)db_jsonObjectWithObject:(id)obj
{
    id jsonObject = nil;
    if ([obj isKindOfClass:[NSString class]] || [obj isKindOfClass:[NSNumber class]]) {
        jsonObject = obj;
    }
    else if ([obj isKindOfClass:[NSDate class]]) {
        NSString *dateString = nil;
        NSDateFormatter *formatter = [self.class getModelDateFormatter];
        if (formatter) {
            dateString = [formatter stringFromDate:obj];
        }
        else {
            dateString = [LKDBUtils stringWithDate:obj];
        }
        dateString = [dateString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if (dateString.length > 0) {
            jsonObject = @{ LKDB_TypeKey : LKDB_TypeKey_Date, LKDB_ValueKey : dateString };
        }
    }
    else if ([obj isKindOfClass:[NSArray class]]) {
        jsonObject = [self db_jsonObjectFromArray:obj];
    }
    else if ([obj isKindOfClass:[NSDictionary class]]) {
        jsonObject = [self db_jsonObjectFromArray:obj];
    }
    else {
        jsonObject = [self db_jsonObjectFromModel:obj];
    }

    if (jsonObject == nil) {
        jsonObject = [obj description];
    }
    return jsonObject;
}

- (id)db_jsonObjectFromModel:(NSObject *)model
{
    Class clazz = model.class;
    NSDictionary *jsonObject = nil;
    if (model.rowid > 0) {
        [model updateToDB];
        jsonObject = [self db_readInfoWithModel:model class:clazz];
    }
    else {
        if (model.db_inserting == NO && [clazz getModelInfos].count > 0) {
            BOOL success = [model saveToDB];
            if (success) {
                jsonObject = [self db_readInfoWithModel:model class:clazz];
            }
        }
        else {
            NSAssert(NO, @"目前LKDB 还不支持 循环引用。  比如 A 持有 B，   B 持有 A，这种的存储");
        }
    }
    return jsonObject;
}
- (NSDictionary *)db_readInfoWithModel:(NSObject *)model class:(Class)clazz
{
    NSMutableDictionary *jsonObject = [NSMutableDictionary dictionary];
    if (!model.db_tableName) {
        NSAssert(NO, @"none table name");
        return nil;
    }
    if (!NSStringFromClass(clazz)) {
        NSAssert(NO, @"none class");
        return nil;
    }
    
    jsonObject[LKDB_TypeKey] = LKDB_TypeKey_Model;
    jsonObject[LKDB_TableNameKey] = model.db_tableName;
    jsonObject[LKDB_ClassKey] = NSStringFromClass(clazz);
    jsonObject[LKDB_RowIdKey] = @(model.rowid);
    
    NSDictionary *dic = [model db_getPrimaryKeysValues];
    if (dic.count > 0 && [NSJSONSerialization isValidJSONObject:dic]) {
        jsonObject[LKDB_PValueKey] = dic;
    }
    return jsonObject;
}

- (NSString *)db_jsonStringFromObject:(NSObject *)jsonObject
{
    if (jsonObject && [NSJSONSerialization isValidJSONObject:jsonObject]) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:jsonObject options:0 error:nil];
        if (data.length > 0) {
            NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            return jsonString;
        }
    }
    return nil;
}
- (id)db_modelWithJsonValue:(id)value
{
    NSData *jsonData = nil;
    if ([value isKindOfClass:[NSString class]]) {
        jsonData = [value dataUsingEncoding:NSUTF8StringEncoding];
    }
    else if ([value isKindOfClass:[NSData class]]) {
        jsonData = value;
    }

    if (jsonData.length > 0) {
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        return [self db_objectWithDictionary:jsonDic];
    }
    return nil;
}
- (id)db_objectWithArray:(NSArray *)array
{
    NSMutableArray *toArray = nil;

    NSInteger count = array.count;
    for (NSInteger i = 0; i < count; i++) {
        id value = [array objectAtIndex:i];
        if ([value isKindOfClass:[NSDictionary class]]) {
            value = [self db_objectWithDictionary:value];
        }
        else if ([value isKindOfClass:[NSArray class]]) {
            value = [self db_objectWithArray:value];
        }

        if (value) {
            if (toArray == nil) {
                toArray = [NSMutableArray array];
            }
            [toArray addObject:value];
        }
    }

    return toArray;
}
- (id)db_objectWithDictionary:(NSDictionary *)dic
{
    if (dic.count == 0) {
        return nil;
    }
    NSString *type = [dic objectForKey:LKDB_TypeKey];
    if (type) {
        if ([type isEqualToString:LKDB_TypeKey_Model]) {
            Class clazz = NSClassFromString([dic objectForKey:LKDB_ClassKey]);
            NSInteger rowid = [[dic objectForKey:LKDB_RowIdKey] integerValue];
            NSString *tableName = [dic objectForKey:LKDB_TableNameKey];

            NSString *where = nil;

            NSString *rowCountWhere = [NSString stringWithFormat:@"select count(rowid) from %@ where rowid=%ld limit 1", tableName, (long)rowid];
            NSInteger result = [[[clazz getUsingLKDBHelper] executeScalarWithSQL:rowCountWhere arguments:nil] integerValue];
            if (result > 0) {
                where = [NSString stringWithFormat:@"select rowid,* from %@ where rowid=%ld limit 1", tableName, (long)rowid];
            }
            else {
                NSDictionary *pv = [dic objectForKey:LKDB_PValueKey];
                if (pv.count > 0) {
                    BOOL isNeedAddDot = NO;
                    NSMutableString *sb = [NSMutableString stringWithFormat:@"select rowid,* from %@ where", tableName];

                    NSArray *allKeys = pv.allKeys;
                    for (NSString *key in allKeys) {
                        id obj = [pv objectForKey:key];
                        if (isNeedAddDot) {
                            [sb appendString:@" and"];
                        }
                        [sb appendFormat:@" %@ = '%@'", key, obj];

                        isNeedAddDot = YES;
                    }

                    [sb appendString:@" limit 1"];

                    where = [NSString stringWithString:sb];
                }
            }

            if (where) {
                NSArray *array = [[clazz getUsingLKDBHelper] searchWithSQL:where toClass:clazz];
                if (array.count > 0) {
                    NSObject *result = [array objectAtIndex:0];
                    result.db_tableName = tableName;
                    return result;
                }
            }
        }
        else if ([type isEqualToString:LKDB_TypeKey_JSON]) {
            id value = [dic objectForKey:LKDB_ValueKey];
            return value;
        }
        else if ([type isEqualToString:LKDB_TypeKey_Combo]) {
            id value = [dic objectForKey:LKDB_ValueKey];
            if ([value isKindOfClass:[NSArray class]]) {
                return [self db_objectWithArray:value];
            }
            else if ([value isKindOfClass:[NSDictionary class]]) {
                return [self db_objectWithDictionary:value];
            }
            else {
                return value;
            }
        }
        else if ([type isEqualToString:LKDB_TypeKey_Date]) {
            NSString *datestr = [dic objectForKey:LKDB_ValueKey];
            NSDateFormatter *formatter = [self.class getModelDateFormatter];
            if (formatter) {
                return [formatter dateFromString:datestr];
            }
            else {
                return [LKDBUtils dateWithString:datestr];
            }
        }
    }
    else {
        
        NSMutableDictionary *toDic = [NSMutableDictionary dictionary];
        [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull value, BOOL * _Nonnull stop) {
            id saveObj = value;
            if ([value isKindOfClass:[NSArray class]]) {
                saveObj = [self db_objectWithArray:value];
            }
            else if ([value isKindOfClass:[NSDictionary class]]) {
                saveObj = [self db_objectWithDictionary:value];
            }
            
            if (saveObj) {
                toDic[key] = saveObj;
            }
        }];
        return toDic;
    }
    return nil;
}
#pragma mark - your can overwrite
- (void)setNilValueForKey:(NSString *)key
{
    NSLog(@"nil 这种设置到了 int 等基础类型中");
}
- (id)valueForUndefinedKey:(NSString *)key
{
    NSLog(@"你有get方法没实现，key:%@", key);
    return nil;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@"你有set方法没实现，key:%@", key);
}

#pragma mark -
- (void)userSetValueForModel:(LKDBProperty *)property value:(id)value
{
}
- (id)userGetValueForModel:(LKDBProperty *)property
{
    return nil;
}

- (NSDictionary *)db_getPrimaryKeysValues
{
    LKModelInfos *infos = [self.class getModelInfos];
    NSArray *array = infos.primaryKeys;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [array enumerateObjectsUsingBlock:^(NSString *pname, NSUInteger idx, BOOL * _Nonnull stop) {
        LKDBProperty *property = [infos objectWithSqlColumnName:pname];
        id value = nil;
        if ([property.type isEqualToString:LKSQL_Mapping_UserCalculate]) {
            value = [self userGetValueForModel:property];
        }
        else {
            value = [self modelGetValue:property];
        }
        if (value) {
            dic[property.sqlColumnName] = value;
        }

    }];
    return dic;
}
//主键值 是否为空
- (BOOL)singlePrimaryKeyValueIsEmpty
{
    LKDBProperty *property = [self singlePrimaryKeyProperty];
    if (property) {
        id pkvalue = [self singlePrimaryKeyValue];
        if ([property.sqlColumnType isEqualToString:LKSQL_Type_Int]) {
            if ([pkvalue isKindOfClass:[NSString class]]) {
                if ([LKDBUtils checkStringIsEmpty:pkvalue])
                    return YES;

                if ([pkvalue integerValue] == 0)
                    return YES;

                return NO;
            }
            if ([pkvalue isKindOfClass:[NSNumber class]]) {
                if ([pkvalue integerValue] == 0)
                    return YES;
                else
                    return NO;
            }
            return YES;
        }
        else {
            return (pkvalue == nil);
        }
    }
    return NO;
}
- (LKDBProperty *)singlePrimaryKeyProperty
{
    LKModelInfos *infos = [self.class getModelInfos];
    if (infos.primaryKeys.count == 1) {
        NSString *name = [infos.primaryKeys objectAtIndex:0];
        return [infos objectWithSqlColumnName:name];
    }
    return nil;
}
- (id)singlePrimaryKeyValue
{
    LKDBProperty *property = [self singlePrimaryKeyProperty];
    if (property) {
        if ([property.type isEqualToString:LKSQL_Mapping_UserCalculate]) {
            return [self userGetValueForModel:property];
        }
        else {
            return [self modelGetValue:property];
        }
    }
    return nil;
}
+ (NSString *)db_rowidAliasName
{
    LKModelInfos *infos = [self getModelInfos];
    if (infos.primaryKeys.count == 1) {
        NSString *primaryType = [infos objectWithSqlColumnName:[infos.primaryKeys lastObject]].sqlColumnType;
        if ([primaryType isEqualToString:LKSQL_Type_Int]) {
            return [infos.primaryKeys lastObject];
        }
    }
    return nil;
}

#pragma mark - get model property info
+ (LKModelInfos *)getModelInfos
{
    static __strong NSMutableDictionary *oncePropertyDic;
    static __strong NSRecursiveLock *lock;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        lock = [[NSRecursiveLock alloc] init];
        oncePropertyDic = [[NSMutableDictionary alloc] initWithCapacity:8];
    });

    LKModelInfos *infos;
    [lock lock];
    NSString *className = NSStringFromClass(self);
    infos = [oncePropertyDic objectForKey:className];
    if (infos == nil) {
        NSMutableArray *pronames = [NSMutableArray array];
        NSMutableArray *protypes = [NSMutableArray array];
        NSDictionary *keymapping = [self getTableMapping];

        if ([self isContainSelf] && self != [NSObject class]) {
            [self getSelfPropertys:pronames protypes:protypes];
        }

        NSArray *pkArray = [self getPrimaryKeyUnionArray];
        if (pkArray.count == 0) {
            pkArray = nil;
            NSString *pk = [self getPrimaryKey];
            if ([LKDBUtils checkStringIsEmpty:pk] == NO) {
                pkArray = [NSArray arrayWithObject:pk];
            }
        }
        if ([self isContainParent] && [self superclass] != [NSObject class]) {
            LKModelInfos *superInfos = [[self superclass] getModelInfos];
            for (NSInteger i = 0; i < superInfos.count; i++) {
                LKDBProperty *db_p = [superInfos objectWithIndex:i];
                if (db_p.propertyName && db_p.propertyType && [db_p.propertyName isEqualToString:@"rowid"] == NO) {
                    [pronames addObject:db_p.propertyName];
                    [protypes addObject:db_p.propertyType];
                }
            }
        }
        if (pronames.count > 0) {
            infos = [[LKModelInfos alloc] initWithKeyMapping:keymapping propertyNames:pronames propertyType:protypes primaryKeys:pkArray];
        }
        else {
            infos = [[LKModelInfos alloc] init];
        }
        oncePropertyDic[className] = infos;
    }

    [lock unlock];
    return infos;
}

+ (BOOL)isContainParent
{
    return NO;
}

+ (BOOL)isContainSelf
{
    return YES;
}

/**
 *	@brief	获取自身的属性
 *
 *	@param 	pronames 	保存属性名称
 *	@param 	protypes 	保存属性类型
 */
+ (void)getSelfPropertys:(NSMutableArray *)pronames protypes:(NSMutableArray *)protypes
{
    unsigned int outCount = 0, i = 0;
    objc_property_t *properties = class_copyPropertyList(self, &outCount);

    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        NSString *propertyName = [NSString stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding];

        //取消rowid 的插入 //子类 已重载的属性 取消插入
        if (propertyName.length == 0 || [propertyName isEqualToString:@"rowid"] ||
            [pronames indexOfObject:propertyName] != NSNotFound) {
            continue;
        }
        NSString *propertyType = [NSString stringWithCString:property_getAttributes(property) encoding:NSUTF8StringEncoding];

        ///过滤只读属性
        if ([propertyType rangeOfString:@",R,"].length > 0 || [propertyType hasSuffix:@",R"]) {
            NSString *firstWord = [[propertyName substringToIndex:1] uppercaseString];
            NSString *otherWord = [propertyName substringFromIndex:1];
            NSString *setMethodString = [NSString stringWithFormat:@"set%@%@:", firstWord, otherWord];
            SEL setSEL = NSSelectorFromString(setMethodString);
            ///有set方法就不过滤了
            if ([self instancesRespondToSelector:setSEL] == NO) {
                continue;
            }
        }

        /*
         c char
         i int
         l long
         s short
         d double
         f float
         @ id //指针 对象
         ...  BOOL 获取到的表示 方式是 char
         .... ^i 表示  int * 一般都不会用到
         */

        NSString *propertyClassName = nil;
        if ([propertyType hasPrefix:@"T@"]) {

            NSRange range = [propertyType rangeOfString:@","];
            if (range.location > 4 && range.location <= propertyType.length) {
                range = NSMakeRange(3, range.location - 4);
                propertyClassName = [propertyType substringWithRange:range];
                if ([propertyClassName hasSuffix:@">"]) {
                    NSRange categoryRange = [propertyClassName rangeOfString:@"<"];
                    if (categoryRange.length > 0) {
                        propertyClassName = [propertyClassName substringToIndex:categoryRange.location];
                    }
                }
            }
        }
        else if ([propertyType hasPrefix:@"T{"]) {
            NSRange range = [propertyType rangeOfString:@"="];
            if (range.location > 2 && range.location <= propertyType.length) {
                range = NSMakeRange(2, range.location - 2);
                propertyClassName = [propertyType substringWithRange:range];
            }
        }
        else {
            propertyType = [propertyType lowercaseString];
            if ([propertyType hasPrefix:@"ti"] || [propertyType hasPrefix:@"tb"]) {
                propertyClassName = @"int";
            }
            else if ([propertyType hasPrefix:@"tf"]) {
                propertyClassName = @"float";
            }
            else if ([propertyType hasPrefix:@"td"]) {
                propertyClassName = @"double";
            }
            else if ([propertyType hasPrefix:@"tl"] || [propertyType hasPrefix:@"tq"]) {
                propertyClassName = @"long";
            }
            else if ([propertyType hasPrefix:@"tc"]) {
                propertyClassName = @"char";
            }
            else if ([propertyType hasPrefix:@"ts"]) {
                propertyClassName = @"short";
            }
        }

        if ([LKDBUtils checkStringIsEmpty:propertyClassName]) {
            ///没找到具体的属性就放弃
            continue;
        }
        ///添加属性
        [pronames addObject:propertyName];
        [protypes addObject:propertyClassName];
    }
    free(properties);
    if ([self isContainParent] && [self superclass] != [NSObject class]) {
        [[self superclass] getSelfPropertys:pronames protypes:protypes];
    }
}

#pragma mark - log all property
- (NSMutableString *)getAllPropertysString
{
    Class clazz = [self class];
    NSMutableString *sb = [NSMutableString stringWithFormat:@"\n <%@> :\n", NSStringFromClass(clazz)];
    [sb appendFormat:@"rowid : %ld\n", (long)self.rowid];
    [self mutableString:sb appendPropertyStringWithClass:clazz containParent:YES];
    return sb;
}
- (NSString *)printAllPropertys
{
    return [self printAllPropertysIsContainParent:NO];
}
- (NSString *)printAllPropertysIsContainParent:(BOOL)containParent
{
#ifdef DEBUG
    Class clazz = [self class];
    NSMutableString *sb = [NSMutableString stringWithFormat:@"\n <%@> :\n", NSStringFromClass(clazz)];
    [sb appendFormat:@"rowid : %ld\n", (long)self.rowid];
    [self mutableString:sb appendPropertyStringWithClass:clazz containParent:containParent];
    NSLog(@"%@", sb);
    return sb;
#else
    return @"";
#endif
}
- (void)mutableString:(NSMutableString *)sb appendPropertyStringWithClass:(Class)clazz containParent:(BOOL)containParent
{
    if (clazz == [NSObject class]) {
        return;
    }
    unsigned int outCount = 0, i = 0;
    objc_property_t *properties = class_copyPropertyList(clazz, &outCount);
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        NSString *propertyName = [NSString stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        [sb appendFormat:@" %@ : %@ \n", propertyName, [self valueForKey:propertyName]];
    }
    free(properties);
    if (containParent) {
        [self mutableString:sb appendPropertyStringWithClass:clazz.superclass containParent:containParent];
    }
}

@end
