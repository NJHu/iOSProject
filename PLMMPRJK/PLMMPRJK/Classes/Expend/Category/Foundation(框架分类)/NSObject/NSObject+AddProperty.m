//
//  NSObject+AddProperty.m
//  iOS-Categories (https://github.com/shaojiankui/iOS-Categories)
//
//  Created by Jakey on 14/12/15.
//  Copyright (c) 2014年 www.skyfox.org. All rights reserved.
//

#import "NSObject+AddProperty.h"
#import <objc/runtime.h>

//objc_getAssociatedObject和objc_setAssociatedObject都需要指定一个固定的地址，这个固定的地址值用来表示属性的key，起到一个常量的作用。
static const void *StringProperty = &StringProperty;
static const void *IntegerProperty = &IntegerProperty;
//static char IntegerProperty;
@implementation NSObject (AddProperty)

@dynamic stringProperty;
//set
/**
 *  @brief  catgory runtime实现get set方法增加一个字符串属性
 */
-(void)setStringProperty:(NSString *)stringProperty{
    //use that a static const as the key
    objc_setAssociatedObject(self, StringProperty, stringProperty, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    //use that property's selector as the key:
    //objc_setAssociatedObject(self, @selector(stringProperty), stringProperty, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
//get
-(NSString *)stringProperty{
    return objc_getAssociatedObject(self, StringProperty);
}

//set
/**
 *  @brief  catgory runtime实现get set方法增加一个NSInteger属性
 */
-(void)setIntegerProperty:(NSInteger)integerProperty{
    NSNumber *number = [[NSNumber alloc]initWithInteger:integerProperty];
    objc_setAssociatedObject(self, IntegerProperty, number, OBJC_ASSOCIATION_ASSIGN);
}
//get
-(NSInteger)integerProperty{
    return [objc_getAssociatedObject(self, IntegerProperty) integerValue];
}

@end
