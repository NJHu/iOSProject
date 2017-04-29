//
//  NSInvocation+Bb.h
//  Bb_revised
//
//  Created by Travis Henspeter on 1/21/15.
//  Copyright (c) 2015 birdSound. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSInvocation (Bb)


+ (id)doInstanceMethodTarget:(id)target
                selectorName:(NSString *)selectorName
                        args:(NSArray *)args;

+ (id)doClassMethod:(NSString *)className
       selectorName:(NSString *)selectorName
               args:(NSArray *)args;

- (void)setArgumentWithObject:(id)object atIndex:(NSUInteger)index;


@end
