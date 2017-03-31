// The MIT License (MIT)
//
// Copyright (c) 2015-2016 forkingdog ( https://github.com/forkingdog )
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

#import "UIView+FDCollapsibleConstraints.h"
#import <objc/runtime.h>

/// A stored property extension for NSLayoutConstraint's original constant.
@implementation NSLayoutConstraint (_FDOriginalConstantStorage)

- (void)setFd_originalConstant:(CGFloat)originalConstant
{
    objc_setAssociatedObject(self, @selector(fd_originalConstant), @(originalConstant), OBJC_ASSOCIATION_RETAIN);
}

- (CGFloat)fd_originalConstant
{
#if CGFLOAT_IS_DOUBLE
    return [objc_getAssociatedObject(self, _cmd) doubleValue];
#else
    return [objc_getAssociatedObject(self, _cmd) floatValue];
#endif
}

@end

@implementation UIView (FDCollapsibleConstraints)

#pragma mark - Hacking KVC

+ (void)load
{
    // Swizzle setValue:forKey: to intercept assignments to `fd_collapsibleConstraints`
    // from Interface Builder. We should not do so by overriding setvalue:forKey:
    // as the primary class implementation would be bypassed.
    SEL originalSelector = @selector(setValue:forKey:);
    SEL swizzledSelector = @selector(fd_setValue:forKey:);

    Class class = UIView.class;
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    method_exchangeImplementations(originalMethod, swizzledMethod);
}

- (void)fd_setValue:(id)value forKey:(NSString *)key
{
    NSString *injectedKey = [NSString stringWithUTF8String:sel_getName(@selector(fd_collapsibleConstraints))];
    if ([key isEqualToString:injectedKey]) {
        // This kind of IBOutlet won't trigger property's setter, so we forward it.
        self.fd_collapsibleConstraints = value;
    } else {
        // Forward the rest of KVC's to original implementation.
        [self fd_setValue:value forKey:key];
    }
}

#pragma mark - Dynamic Properties

- (void)setFd_collapsed:(BOOL)collapsed
{
    [self.fd_collapsibleConstraints enumerateObjectsUsingBlock:
     ^(NSLayoutConstraint *constraint, NSUInteger idx, BOOL *stop) {
         if (collapsed) {
             constraint.constant = 0;
         } else {
             constraint.constant = constraint.fd_originalConstant;
         } 
     }];

    objc_setAssociatedObject(self, @selector(fd_collapsed), @(collapsed), OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)fd_collapsed
{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (NSMutableArray *)fd_collapsibleConstraints
{
    NSMutableArray *constraints = objc_getAssociatedObject(self, _cmd);
    if (!constraints) {
        constraints = @[].mutableCopy;
        objc_setAssociatedObject(self, _cmd, constraints, OBJC_ASSOCIATION_RETAIN);
    }
    return constraints;
}

- (void)setFd_collapsibleConstraints:(NSArray *)fd_collapsibleConstraints
{
    // Hook assignments to our custom `fd_collapsibleConstraints` property.
    NSMutableArray *constraints = (NSMutableArray *)self.fd_collapsibleConstraints;
    
    [fd_collapsibleConstraints enumerateObjectsUsingBlock:^(NSLayoutConstraint *constraint, NSUInteger idx, BOOL *stop) {
        // Store original constant value
        constraint.fd_originalConstant = constraint.constant;
        [constraints addObject:constraint];
    }];
}

@end

@implementation UIView (FDAutomaticallyCollapseByIntrinsicContentSize)

#pragma mark - Hacking "-updateConstraints"

+ (void)load
{
    // Swizzle to hack "-updateConstraints" method
    SEL originalSelector = @selector(updateConstraints);
    SEL swizzledSelector = @selector(fd_updateConstraints);
    
    Class class = UIView.class;
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    method_exchangeImplementations(originalMethod, swizzledMethod);
}

- (void)fd_updateConstraints
{
    // Call primary method's implementation
    [self fd_updateConstraints];
 
    if (self.fd_autoCollapse && self.fd_collapsibleConstraints.count > 0) {
        
        // "Absent" means this view doesn't have an intrinsic content size, {-1, -1} actually.
        const CGSize absentIntrinsicContentSize = CGSizeMake(UIViewNoIntrinsicMetric, UIViewNoIntrinsicMetric);
        
        // Calculated intrinsic content size
        const CGSize contentSize = [self intrinsicContentSize];
        
        // When this view doesn't have one, or has no intrinsic content size after calculating,
        // it going to be collapsed.
        if (CGSizeEqualToSize(contentSize, absentIntrinsicContentSize) ||
            CGSizeEqualToSize(contentSize, CGSizeZero)) {
            self.fd_collapsed = YES;
        } else {
            self.fd_collapsed = NO;
        }
    }
}

#pragma mark - Dynamic Properties

- (BOOL)fd_autoCollapse
{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setFd_autoCollapse:(BOOL)autoCollapse
{
    objc_setAssociatedObject(self, @selector(fd_autoCollapse), @(autoCollapse), OBJC_ASSOCIATION_RETAIN);
}

- (void)setAutoCollapse:(BOOL)collapse
{
    // Just forwarding
    self.fd_autoCollapse = collapse;
}

@end
