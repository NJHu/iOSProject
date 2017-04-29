//
//  NSException+Trace.m
//  iOS-Categories (https://github.com/shaojiankui/iOS-Categories)
//
//  Created by Jakey on 14/12/30.
//  Copyright (c) 2014年 www.skyfox.org. All rights reserved.
//

#import "NSException+Trace.h"
#include <execinfo.h>

@implementation NSException (Trace)
- (NSArray *)backtrace
{
    NSArray *addresses = self.callStackReturnAddresses;
    unsigned count = (int)addresses.count;
    void **stack = malloc(count * sizeof(void *));
    
    for (unsigned i = 0; i < count; ++i)
        stack[i] = (void *)[addresses[i] longValue];
    
    char **strings = backtrace_symbols(stack, count);
    NSMutableArray *ret = [NSMutableArray arrayWithCapacity:count];
    
    for (int i = 0; i < count; ++i)
        [ret addObject:@(strings[i])];
    
    free(stack);
    free(strings);
    
    return ret;
}
@end
