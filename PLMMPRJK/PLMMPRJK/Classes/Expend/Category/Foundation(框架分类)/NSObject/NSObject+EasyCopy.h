//
//  NSObject+EasyCopy.h
//  NSObject-EasyCopy
//
//  Created by York on 15/12/1.
//  Copyright © 2015年 YK-Unit. All rights reserved.
//

#import <Foundation/Foundation.h>
// a copy category for NSObject 
@interface NSObject (EasyCopy)

/**
 *  浅复制目标的所有属性
 *
 *  @param instance 目标对象
 *
 *  @return BOOL—YES:复制成功,NO:复制失败
 */
- (BOOL)easyShallowCopy:(NSObject *)instance;

/**
 *  深复制目标的所有属性
 *
 *  @param instance 目标对象
 *
 *  @return BOOL—YES:复制成功,NO:复制失败
 */
- (BOOL)easyDeepCopy:(NSObject *)instance;

@end
