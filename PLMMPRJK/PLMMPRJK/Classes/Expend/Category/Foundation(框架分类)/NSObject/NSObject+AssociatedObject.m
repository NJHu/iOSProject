//
//  NSObject+AssociatedObject.m
//  iOS-Categories (https://github.com/shaojiankui/iOS-Categories)
//
//  Created by Jakey on 14/12/11.
//  Copyright (c) 2014年 www.skyfox.org. All rights reserved.
//

#import "NSObject+AssociatedObject.h"
#import  <objc/runtime.h>
@implementation NSObject (AssociatedObject)
/**
 *  @brief  附加一个stong对象
 *
 *  @param value 被附加的对象
 *  @param key   被附加对象的key
 */
- (void)associateValue:(id)value withKey:(void *)key
{
    objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_RETAIN);
}
/**
 *  @brief  附加一个weak对象
 *
 *  @param value 被附加的对象
 *  @param key   被附加对象的key
 */
- (void)weaklyAssociateValue:(id)value withKey:(void *)key
{
    objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_ASSIGN);
}
/**
 *  @brief  根据附加对象的key取出附加对象
 *
 *  @param key 附加对象的key
 *
 *  @return 附加对象
 */
- (id)associatedValueForKey:(void *)key
{
    return objc_getAssociatedObject(self, key);
}
@end

