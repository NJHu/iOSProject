//
//  NSObject+Reflection.m
//  NSObject-Reflection
//
//  Created by Jakey on 15/12/22.
//  Copyright © 2015年 Jakey. All rights reserved.
//

#import "NSObject+Reflection.h"
#import <objc/runtime.h>

@implementation NSObject (Reflection)
- (NSString *)className
{
    return NSStringFromClass([self class]);
}
- (NSString *)superClassName
{
    return NSStringFromClass([self superclass]);
}
+ (NSString *)className
{
    return NSStringFromClass([self class]);
}
+ (NSString *)superClassName
{
    return NSStringFromClass([self superclass]);
}
-(NSDictionary *)propertyDictionary
{
    //创建可变字典
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    unsigned int outCount;
    objc_property_t *props = class_copyPropertyList([self class], &outCount);
    for(int i=0;i<outCount;i++){
        objc_property_t prop = props[i];
        NSString *propName = [[NSString alloc]initWithCString:property_getName(prop) encoding:NSUTF8StringEncoding];
        id propValue = [self valueForKey:propName];
        [dict setObject:propValue?:[NSNull null] forKey:propName];
    }
    free(props);
    return dict;
}
- (NSArray*)propertyKeys
{
    return [[self class] propertyKeys];
}
+ (NSArray *)propertyKeys {
    unsigned int propertyCount = 0;
    objc_property_t * properties = class_copyPropertyList(self, &propertyCount);
    NSMutableArray * propertyNames = [NSMutableArray array];
    for (unsigned int i = 0; i < propertyCount; ++i) {
        objc_property_t property = properties[i];
        const char * name = property_getName(property);
        [propertyNames addObject:[NSString stringWithUTF8String:name]];
    }
    free(properties);
    return propertyNames;
}
- (NSArray *)propertiesInfo
{
    return [[self class] propertiesInfo];
}
/**
 *  @author Jakey, 15-12-22 11:12:38
 *
 *  属性列表与属性的各种信息
 *
 *  @return <#return value description#>
 */
+ (NSArray *)propertiesInfo
{
    NSMutableArray *propertieArray = [NSMutableArray array];
    
    unsigned int propertyCount;
    objc_property_t *properties = class_copyPropertyList([self class], &propertyCount);
    
    for (int i = 0; i < propertyCount; i++)
    {
        [propertieArray addObject:({
            
            NSDictionary *dictionary = [self dictionaryWithProperty:properties[i]];
            
            dictionary;
        })];
    }
    
    free(properties);
    
    return propertieArray;
}
+ (NSArray *)propertiesWithCodeFormat
{
    NSMutableArray *array = [NSMutableArray array];
    
    NSArray *properties = [[self class] propertiesInfo];
    
    for (NSDictionary *item in properties)
    {
        NSMutableString *format = ({
            
            NSMutableString *formatString = [NSMutableString stringWithFormat:@"@property "];
            //attribute
            NSArray *attribute = [item objectForKey:@"attribute"];
            attribute = [attribute sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                return [obj1 compare:obj2 options:NSNumericSearch];
            }];
            if (attribute && attribute.count > 0)
            {
                NSString *attributeStr = [NSString stringWithFormat:@"(%@)",[attribute componentsJoinedByString:@", "]];
                
                [formatString appendString:attributeStr];
            }
            
            //type
            NSString *type = [item objectForKey:@"type"];
            if (type) {
                [formatString appendString:@" "];
                [formatString appendString:type];
            }
            
            //name
            NSString *name = [item objectForKey:@"name"];
            if (name) {
                [formatString appendString:@" "];
                [formatString appendString:name];
                [formatString appendString:@";"];
            }
            
            formatString;
        });
        
        [array addObject:format];
    }
    
    return array;
}
-(NSArray*)methodList{
    u_int               count;
    NSMutableArray *methodList = [NSMutableArray array];
    Method *methods= class_copyMethodList([self class], &count);
    for (int i = 0; i < count ; i++)
    {
        SEL name = method_getName(methods[i]);
        NSString *strName = [NSString  stringWithCString:sel_getName(name) encoding:NSUTF8StringEncoding];
        [methodList addObject:strName];
    }
    free(methods);
    return methodList;
}
-(NSArray*)methodListInfo{
    u_int               count;
    NSMutableArray *methodList = [NSMutableArray array];
    Method *methods= class_copyMethodList([self class], &count);
    for (int i = 0; i < count ; i++)
    {
        NSMutableDictionary *info = [NSMutableDictionary dictionary];
        
        Method method = methods[i];
        IMP imp_f = method_getImplementation(method);
        SEL name = method_getName(method);
        // 返回方法的参数的个数
        int argumentsCount = method_getNumberOfArguments(method);
        //获取描述方法参数和返回值类型的字符串
        const char *encoding =method_getTypeEncoding(method);
        //取方法的返回值类型的字符串
        const char *returnType =method_copyReturnType(method);
       
        NSMutableArray *arguments = [NSMutableArray array];
        for (int index=0; index<argumentsCount; index++) {
            // 获取方法的指定位置参数的类型字符串
          char *arg =   method_copyArgumentType(method,index);
//            NSString *argString = [NSString stringWithCString:arg encoding:NSUTF8StringEncoding];
            [arguments addObject:[[self class] decodeType:arg]];
        }
        
        NSString *returnTypeString =[[self class] decodeType:returnType];
        NSString *encodeString = [[self class] decodeType:encoding];
        NSString *nameString = [NSString  stringWithCString:sel_getName(name) encoding:NSUTF8StringEncoding];

        [info setObject:arguments forKey:@"arguments"];
        [info setObject:[NSString stringWithFormat:@"%d",argumentsCount] forKey:@"argumentsCount"];
        [info setObject:returnTypeString forKey:@"returnType"];
        [info setObject:encodeString forKey:@"encode"];
        [info setObject:nameString forKey:@"name"];
//        [info setObject:imp_f forKey:@"imp"];
         [methodList addObject:info];
    }
    free(methods);
    return methodList;
}
+(NSArray*)methodList{
    u_int               count;
    NSMutableArray *methodList = [NSMutableArray array];
    Method * methods= class_copyMethodList([self class], &count);
    for (int i = 0; i < count ; i++)
    {
        SEL name = method_getName(methods[i]);
        NSString *strName = [NSString  stringWithCString:sel_getName(name) encoding:NSUTF8StringEncoding];
        [methodList addObject:strName];
    }
    free(methods);

    return methodList;
}
//创建并返回一个指向所有已注册类的指针列表
+ (NSArray *)registedClassList
{
    NSMutableArray *result = [NSMutableArray array];
    
    unsigned int count;
    Class *classes = objc_copyClassList(&count);
    for (int i = 0; i < count; i++)
    {
        [result addObject:NSStringFromClass(classes[i])];
    }
    free(classes);
    [result sortedArrayUsingSelector:@selector(compare:)];
    
    return result;
}

/**
 *  @author Jakey, 15-12-22 12:12:17
 *
 *  <>协议列表信息
 *
 *  @return 协议列表信息
 */
-(NSDictionary *)protocolList{
    return [[self class]protocolList];
}
+ (NSDictionary *)protocolList
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    unsigned int count;
    Protocol * __unsafe_unretained * protocols = class_copyProtocolList([self class], &count);
    for (int i = 0; i < count; i++)
    {
        Protocol *protocol = protocols[i];
        
        NSString *protocolName = [NSString stringWithCString:protocol_getName(protocol) encoding:NSUTF8StringEncoding];
        
        NSMutableArray *superProtocolArray = ({
            
            NSMutableArray *array = [NSMutableArray array];
            
            unsigned int superProtocolCount;
            Protocol * __unsafe_unretained * superProtocols = protocol_copyProtocolList(protocol, &superProtocolCount);
            for (int ii = 0; ii < superProtocolCount; ii++)
            {
                Protocol *superProtocol = superProtocols[ii];
                
                NSString *superProtocolName = [NSString stringWithCString:protocol_getName(superProtocol) encoding:NSUTF8StringEncoding];
                
                [array addObject:superProtocolName];
            }
            free(superProtocols);
            
            array;
        });
        
        [dictionary setObject:superProtocolArray forKey:protocolName];
    }
    free(protocols);
    
    return dictionary;
}

+ (NSArray *)instanceVariable
{
    unsigned int outCount;
    Ivar *ivars = class_copyIvarList([self class], &outCount);
    NSMutableArray *result = [NSMutableArray array];
    for (int i = 0; i < outCount; i++) {
        NSString *type = [[self class] decodeType:ivar_getTypeEncoding(ivars[i])];
        NSString *name = [NSString stringWithCString:ivar_getName(ivars[i]) encoding:NSUTF8StringEncoding];
        NSString *ivarDescription = [NSString stringWithFormat:@"%@ %@", type, name];
        [result addObject:ivarDescription];
    }
    free(ivars);
    return result.count ? [result copy] : nil;
}

- (BOOL)hasPropertyForKey:(NSString*)key
{
    objc_property_t property = class_getProperty([self class], [key UTF8String]);
    return (BOOL)property;
}
- (BOOL)hasIvarForKey:(NSString*)key
{
    Ivar ivar = class_getInstanceVariable([self class], [key UTF8String]);
    return (BOOL)ivar;
}
#pragma mark -- help
+ (NSDictionary *)dictionaryWithProperty:(objc_property_t)property
{
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    
    //name
    
    NSString *propertyName = [NSString stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
    [result setObject:propertyName forKey:@"name"];
    
    //attribute
    
    NSMutableDictionary *attributeDictionary = ({
        
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
        
        unsigned int attributeCount;
        objc_property_attribute_t *attrs = property_copyAttributeList(property, &attributeCount);
        
        for (int i = 0; i < attributeCount; i++)
        {
            NSString *name = [NSString stringWithCString:attrs[i].name encoding:NSUTF8StringEncoding];
            NSString *value = [NSString stringWithCString:attrs[i].value encoding:NSUTF8StringEncoding];
            [dictionary setObject:value forKey:name];
        }
        
        free(attrs);
        
        dictionary;
    });
    
    NSMutableArray *attributeArray = [NSMutableArray array];
    
    /***
     https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtPropertyIntrospection.html#//apple_ref/doc/uid/TP40008048-CH101-SW6
     
     R           | The property is read-only (readonly).
     C           | The property is a copy of the value last assigned (copy).
     &           | The property is a reference to the value last assigned (retain).
     N           | The property is non-atomic (nonatomic).
     G<name>     | The property defines a custom getter selector name. The name follows the G (for example, GcustomGetter,).
     S<name>     | The property defines a custom setter selector name. The name follows the S (for example, ScustomSetter:,).
     D           | The property is dynamic (@dynamic).
     W           | The property is a weak reference (__weak).
     P           | The property is eligible for garbage collection.
     t<encoding> | Specifies the type using old-style encoding.
     */
    
    //R
    if ([attributeDictionary objectForKey:@"R"])
    {
        [attributeArray addObject:@"readonly"];
    }
    //C
    if ([attributeDictionary objectForKey:@"C"])
    {
        [attributeArray addObject:@"copy"];
    }
    //&
    if ([attributeDictionary objectForKey:@"&"])
    {
        [attributeArray addObject:@"strong"];
    }
    //N
    if ([attributeDictionary objectForKey:@"N"])
    {
        [attributeArray addObject:@"nonatomic"];
    }
    else
    {
        [attributeArray addObject:@"atomic"];
    }
    //G<name>
    if ([attributeDictionary objectForKey:@"G"])
    {
        [attributeArray addObject:[NSString stringWithFormat:@"getter=%@", [attributeDictionary objectForKey:@"G"]]];
    }
    //S<name>
    if ([attributeDictionary objectForKey:@"S"])
    {
        [attributeArray addObject:[NSString stringWithFormat:@"setter=%@", [attributeDictionary objectForKey:@"G"]]];
    }
    //D
    if ([attributeDictionary objectForKey:@"D"])
    {
        [result setObject:[NSNumber numberWithBool:YES] forKey:@"isDynamic"];
    }
    else
    {
        [result setObject:[NSNumber numberWithBool:NO] forKey:@"isDynamic"];
    }
    //W
    if ([attributeDictionary objectForKey:@"W"])
    {
        [attributeArray addObject:@"weak"];
    }
    //P
    if ([attributeDictionary objectForKey:@"P"])
    {
        //TODO:P | The property is eligible for garbage collection.
    }
    //T
    if ([attributeDictionary objectForKey:@"T"])
    {
        /*
         https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html
         c               A char
         i               An int
         s               A short
         l               A long l is treated as a 32-bit quantity on 64-bit programs.
         q               A long long
         C               An unsigned char
         I               An unsigned int
         S               An unsigned short
         L               An unsigned long
         Q               An unsigned long long
         f               A float
         d               A double
         B               A C++ bool or a C99 _Bool
         v               A void
         *               A character string (char *)
         @               An object (whether statically typed or typed id)
         #               A class object (Class)
         :               A method selector (SEL)
         [array type]    An array
         {name=type...}  A structure
         (name=type...)  A union
         bnum            A bit field of num bits
         ^type           A pointer to type
         ?               An unknown type (among other things, this code is used for function pointers)
         
         */
        
        NSDictionary *typeDic = @{@"c":@"char",
                                  @"i":@"int",
                                  @"s":@"short",
                                  @"l":@"long",
                                  @"q":@"long long",
                                  @"C":@"unsigned char",
                                  @"I":@"unsigned int",
                                  @"S":@"unsigned short",
                                  @"L":@"unsigned long",
                                  @"Q":@"unsigned long long",
                                  @"f":@"float",
                                  @"d":@"double",
                                  @"B":@"BOOL",
                                  @"v":@"void",
                                  @"*":@"char *",
                                  @"@":@"id",
                                  @"#":@"Class",
                                  @":":@"SEL",
                                  };
        //TODO:An array
        NSString *key = [attributeDictionary objectForKey:@"T"];
        
        id type_str = [typeDic objectForKey:key];
        
        if (type_str == nil)
        {
            if ([[key substringToIndex:1] isEqualToString:@"@"] && [key rangeOfString:@"?"].location == NSNotFound)
            {
                type_str = [[key substringWithRange:NSMakeRange(2, key.length - 3)] stringByAppendingString:@"*"];
            }
            else if ([[key substringToIndex:1] isEqualToString:@"^"])
            {
                id str = [typeDic objectForKey:[key substringFromIndex:1]];
                
                if (str)
                {
                    type_str = [NSString stringWithFormat:@"%@ *",str];
                }
            }
            else
            {
                type_str = @"unknow";
            }
        }
        
        [result setObject:type_str forKey:@"type"];
    }
    
    [result setObject:attributeArray forKey:@"attribute"];
    
    return result;
}
+ (NSString *)decodeType:(const char *)cString
{
    if (!strcmp(cString, @encode(char)))
        return @"char";
    if (!strcmp(cString, @encode(int)))
        return @"int";
    if (!strcmp(cString, @encode(short)))
        return @"short";
    if (!strcmp(cString, @encode(long)))
        return @"long";
    if (!strcmp(cString, @encode(long long)))
        return @"long long";
    if (!strcmp(cString, @encode(unsigned char)))
        return @"unsigned char";
    if (!strcmp(cString, @encode(unsigned int)))
        return @"unsigned int";
    if (!strcmp(cString, @encode(unsigned short)))
        return @"unsigned short";
    if (!strcmp(cString, @encode(unsigned long)))
        return @"unsigned long";
    if (!strcmp(cString, @encode(unsigned long long)))
        return @"unsigned long long";
    if (!strcmp(cString, @encode(float)))
        return @"float";
    if (!strcmp(cString, @encode(double)))
        return @"double";
    if (!strcmp(cString, @encode(bool)))
        return @"bool";
    if (!strcmp(cString, @encode(_Bool)))
        return @"_Bool";
    if (!strcmp(cString, @encode(void)))
        return @"void";
    if (!strcmp(cString, @encode(char *)))
        return @"char *";
    if (!strcmp(cString, @encode(id)))
        return @"id";
    if (!strcmp(cString, @encode(Class)))
        return @"class";
    if (!strcmp(cString, @encode(SEL)))
        return @"SEL";
    if (!strcmp(cString, @encode(BOOL)))
        return @"BOOL";
    
//    NSDictionary *typeDic = @{@"c":@"char",
//                              @"i":@"int",
//                              @"s":@"short",
//                              @"l":@"long",
//                              @"q":@"long long",
//                              @"C":@"unsigned char",
//                              @"I":@"unsigned int",
//                              @"S":@"unsigned short",
//                              @"L":@"unsigned long",
//                              @"Q":@"unsigned long long",
//                              @"f":@"float",
//                              @"d":@"double",
//                              @"B":@"BOOL",
//                              @"v":@"void",
//                              @"*":@"char *",
//                              @"@":@"id",
//                              @"#":@"Class",
//                              @":":@"SEL",
//                              };
    
    //@TODO: do handle bitmasks
    NSString *result = [NSString stringWithCString:cString encoding:NSUTF8StringEncoding];
//    if ([typeDic objectForKey:result]) {
//        return [typeDic objectForKey:result];
//    }
    if ([[result substringToIndex:1] isEqualToString:@"@"] && [result rangeOfString:@"?"].location == NSNotFound) {
        result = [[result substringWithRange:NSMakeRange(2, result.length - 3)] stringByAppendingString:@"*"];
    } else
    {
        if ([[result substringToIndex:1] isEqualToString:@"^"]) {
            result = [NSString stringWithFormat:@"%@ *",
                      [NSString decodeType:[[result substringFromIndex:1] cStringUsingEncoding:NSUTF8StringEncoding]]];
        }
    }
    return result;
}

@end
