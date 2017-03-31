//
//  NSObject+AssociatedObject.h
//  iOS-Categories (https://github.com/shaojiankui/iOS-Categories)
//
//  Created by Jakey on 14/12/11.
//  Copyright (c) 2014年 www.skyfox.org. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (AssociatedObject)
/**
 *  @brief  附加一个stong对象
 *
 *  @param value 被附加的对象
 *  @param key   被附加对象的key
 */
- (void)associateValue:(id)value withKey:(void *)key; // Strong reference
/**
 *  @brief  附加一个weak对象
 *
 *  @param value 被附加的对象
 *  @param key   被附加对象的key
 */
- (void)weaklyAssociateValue:(id)value withKey:(void *)key;

/**
 *  @brief  根据附加对象的key取出附加对象
 *
 *  @param key 附加对象的key
 *
 *  @return 附加对象
 */
- (id)associatedValueForKey:(void *)key;
@end
