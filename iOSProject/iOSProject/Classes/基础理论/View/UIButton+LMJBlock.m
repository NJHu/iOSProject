//
//  UIButton+LMJBlock.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/4/14.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "UIButton+LMJBlock.h"

static const void *timeIntervalKey = &timeIntervalKey;
static const void *isIgnoreEventKey = &isIgnoreEventKey;
static const CGFloat defaultTimeInterval = 0.5;

@interface UIButton ()

/** <#digest#> */
@property (nonatomic, assign) BOOL isIgnoreEvent;
@end


@implementation UIButton (LMJBlock)


//load方法会在类第一次加载的时候被调用,调用的时间比较靠前，适合在这个方法里做方法交换,方法交换应该被保证，在程序中只会执行一次

+ (void)load {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        Class selfClass = [self class];
        
        SEL oriSEL = @selector(sendAction:to:forEvent:);
        Method oriMethod = class_getInstanceMethod(selfClass, oriSEL);
        
        SEL cusSEL = @selector(mySendAction:to:forEvent:);
        Method cusMethod = class_getInstanceMethod(selfClass, cusSEL);
        
        BOOL addSucc = class_addMethod(selfClass, oriSEL, method_getImplementation(cusMethod), method_getTypeEncoding(cusMethod));
        if (addSucc) {
            class_replaceMethod(selfClass, cusSEL, method_getImplementation(oriMethod), method_getTypeEncoding(oriMethod));
        }else {
            method_exchangeImplementations(oriMethod, cusMethod);
        }
        
    });
}

- (void)mySendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    NSLog(@"这里面存放着我其它操作");
    //这边要写自个的 在swizzling的过程中，方法中的[self mySendAction...]已经被重新指定到self类的sendAction:中  不会产生无限循环 如果调用sendAction就会产生无限循环
    if ([NSStringFromClass(self.class) isEqualToString:@"UIButton"]) {
        
        if (self.isIgnoreEvent) {
            return;
        }else {
            self.timeInterval = (self.timeInterval == 0) ?defaultTimeInterval : self.timeInterval;
        }
        
        self.isIgnoreEvent = YES;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.timeInterval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.isIgnoreEvent = NO;
        });
        
    }
    
    
    [self mySendAction:action to:target forEvent:event];
}

- (void)setTimeInterval:(NSTimeInterval)timeInterval {
    objc_setAssociatedObject(self, timeIntervalKey, @(timeInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSTimeInterval)timeInterval {
    return ((NSNumber *)objc_getAssociatedObject(self, timeIntervalKey)).doubleValue;
}

- (void)setIsIgnoreEvent:(BOOL)isIgnoreEvent {
        objc_setAssociatedObject(self, isIgnoreEventKey, @(isIgnoreEvent), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isIgnoreEvent {
    return ((NSNumber *)objc_getAssociatedObject(self, isIgnoreEventKey)).boolValue;
}


@end

















