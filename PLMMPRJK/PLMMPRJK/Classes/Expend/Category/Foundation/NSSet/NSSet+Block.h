//
//  NSSet+Block.h
//  iOS-Categories (https://github.com/shaojiankui/iOS-Categories)
//
//  Created by Jakey on 14/12/15.
//  Copyright (c) 2014年 www.skyfox.org. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSSet (Block)
- (void)each:(void (^)(id))block;
- (void)eachWithIndex:(void (^)(id, int))block;
- (NSArray *)map:(id (^)(id object))block;
- (NSArray *)select:(BOOL (^)(id object))block;
- (NSArray *)reject:(BOOL (^)(id object))block;
- (NSArray *)sort;
- (id)reduce:(id(^)(id accumulator, id object))block;
- (id)reduce:(id)initial withBlock:(id(^)(id accumulator, id object))block;
@end
