//
//  NSObject+EasyCopy.m
//  NSObject-EasyCopy
//
//  Created by York on 15/12/1.
//  Copyright © 2015年 YK-Unit. All rights reserved.
//

#import "NSObject+EasyCopy.h"
#import <objc/runtime.h>

@implementation NSObject (EasyCopy)

- (BOOL)easyShallowCopy:(NSObject *)instance
{
    Class currentClass = [self class];
    Class instanceClass = [instance class];
    
    if (self == instance) {
        //相同实例
        return NO;
    }
    
    if (![instance isMemberOfClass:currentClass] ) {
        //不是当前类的实例
        return NO;
    }
    
    while (instanceClass != [NSObject class]) {
        unsigned int propertyListCount = 0;
        objc_property_t *propertyList = class_copyPropertyList(currentClass, &propertyListCount);
        for (int i = 0; i < propertyListCount; i++) {
            objc_property_t property = propertyList[i];
            const char *property_name = property_getName(property);
            NSString *propertyName = [NSString stringWithCString:property_name encoding:NSUTF8StringEncoding];

            //check if property is dynamic and readwrite
            char *dynamic = property_copyAttributeValue(property, "D");
            char *readonly = property_copyAttributeValue(property, "R");
            if (propertyName && !readonly) {
                id propertyValue = [instance valueForKey:propertyName];
                [self setValue:propertyValue forKey:propertyName];
            }
            free(dynamic);
            free(readonly);
        }
        free(propertyList);
        instanceClass = class_getSuperclass(instanceClass);
    }
    
    return YES;
}

- (BOOL)easyDeepCopy:(NSObject *)instance
{
    Class currentClass = [self class];
    Class instanceClass = [instance class];
    
    if (self == instance) {
        //相同实例
        return NO;
    }
    
    if (![instance isMemberOfClass:currentClass] ) {
        //不是当前类的实例
        return NO;
    }
    
    while (instanceClass != [NSObject class]) {
        unsigned int propertyListCount = 0;
        objc_property_t *propertyList = class_copyPropertyList(currentClass, &propertyListCount);
        for (int i = 0; i < propertyListCount; i++) {
            objc_property_t property = propertyList[i];
            const char *property_name = property_getName(property);
            NSString *propertyName = [NSString stringWithCString:property_name encoding:NSUTF8StringEncoding];

            //check if property is dynamic and readwrite
            char *dynamic = property_copyAttributeValue(property, "D");
            char *readonly = property_copyAttributeValue(property, "R");
            if (propertyName && !readonly) {
                id propertyValue = [instance valueForKey:propertyName];
                Class propertyValueClass = [propertyValue class];
                BOOL flag = [NSObject isNSObjectClass:propertyValueClass];
                if (flag) {
                    if ([propertyValue conformsToProtocol:@protocol(NSCopying)]) {
                        NSObject *copyValue = [propertyValue copy];
                        [self setValue:copyValue forKey:propertyName];
                    }else{
                        NSObject *copyValue = [[[propertyValue class]alloc]init];
                        [copyValue easyDeepCopy:propertyValue];
                        [self setValue:copyValue forKey:propertyName];
                    }
                }else{
                    [self setValue:propertyValue forKey:propertyName];
                }
            }
            free(dynamic);
            free(readonly);
        }
        free(propertyList);
        instanceClass = class_getSuperclass(instanceClass);
    }
    
    return YES;
}


+ (BOOL)isNSObjectClass:(Class)clazz{
    
    BOOL flag = class_conformsToProtocol(clazz, @protocol(NSObject));
    if (flag) {
        return flag;
    }else{
        Class superClass = class_getSuperclass(clazz);
        if (!superClass) {
            return NO;
        }else{
            return  [NSObject isNSObjectClass:superClass];
        }
    }
}
@end
