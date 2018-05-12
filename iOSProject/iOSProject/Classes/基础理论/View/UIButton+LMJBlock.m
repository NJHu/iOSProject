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
    
//
//        " 周全起见，有两种情况要考虑一下。第一种情况是要复写的方法(overridden)并没有在目标类中实现(notimplemented)，而是在其父类中实现了。
//        第二种情况是这个方法已经存在于目标类中(does existin the class itself)。这两种情况要区别对待。 (译注: 这个地方有点要明确一下，它的目的是为了使用一个重写的方法替换掉原来的方法。
//        但重写的方法可能是在父类中重写的，也可能是在子类中重写的。)
//        对于第一种情况，应当先在目标类增加一个新的实现方法(override)，然后将复写的方法替换为原先(的实现(original one)。
//        对于第二情况(在目标类重写的方法)。这时可以通过method_exchangeImplementations来完成交换."
        
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class buttonClass = self;
        SEL oriSel = @selector(sendAction:to:forEvent:);
        Method oriMethod = class_getInstanceMethod(buttonClass, oriSel);
        
        SEL mySel = @selector(mySendAction:to:forEvent:);
        Method myMethod = class_getInstanceMethod(buttonClass, mySel);
        
        BOOL isAdd = class_addMethod(buttonClass, oriSel, method_getImplementation(myMethod), method_getTypeEncoding(myMethod));
        
        if (isAdd) {
            class_replaceMethod(buttonClass, mySel, method_getImplementation(oriMethod), method_getTypeEncoding(oriMethod));
        }else {
            method_exchangeImplementations(oriMethod, myMethod);
        }
        
    });
        
        
}

- (void)mySendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    NSLog(@"button 发送了 mySendAction");
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

















