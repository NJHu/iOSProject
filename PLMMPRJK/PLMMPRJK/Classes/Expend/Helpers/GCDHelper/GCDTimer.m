//
//  GCDTimer.m
//  GCD
//
//  用法
//  http://www.cnblogs.com/YouXianMing/p/3659204.html
//
//  Created by XianMingYou on 15/3/15.
//  Copyright (c) 2015年 XianMingYou. All rights reserved.
//

#import "GCDTimer.h"
#import "GCDQueue.h"

@interface GCDTimer ()

@property (strong, readwrite, nonatomic) dispatch_source_t dispatchSource;

@end

@implementation GCDTimer

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        
        self.dispatchSource = \
        dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));
    }
    
    return self;
}

- (instancetype)initInQueue:(GCDQueue *)queue {
    
    self = [super init];
    
    if (self) {
        
        self.dispatchSource = \
        dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue.dispatchQueue);
    }
    
    return self;
}

- (void)event:(dispatch_block_t)block timeInterval:(uint64_t)interval {
    
    NSParameterAssert(block);
    dispatch_source_set_timer(self.dispatchSource, dispatch_time(DISPATCH_TIME_NOW, 0), interval, 0);
    dispatch_source_set_event_handler(self.dispatchSource, block);
}

- (void)event:(dispatch_block_t)block timeInterval:(uint64_t)interval delay:(uint64_t)delay {
    
    NSParameterAssert(block);
    dispatch_source_set_timer(self.dispatchSource, dispatch_time(DISPATCH_TIME_NOW, delay), interval, 0);
    dispatch_source_set_event_handler(self.dispatchSource, block);
}

- (void)event:(dispatch_block_t)block timeIntervalWithSecs:(float)secs {
    
    NSParameterAssert(block);
    dispatch_source_set_timer(self.dispatchSource, dispatch_time(DISPATCH_TIME_NOW, 0), secs * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(self.dispatchSource, block);
}

- (void)event:(dispatch_block_t)block timeIntervalWithSecs:(float)secs delaySecs:(float)delaySecs {
    
    NSParameterAssert(block);
    dispatch_source_set_timer(self.dispatchSource, dispatch_time(DISPATCH_TIME_NOW, delaySecs * NSEC_PER_SEC), secs * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(self.dispatchSource, block);
}

- (void)start {
    
    dispatch_resume(self.dispatchSource);
}

- (void)destroy {
    
    dispatch_source_cancel(self.dispatchSource);
}

@end
