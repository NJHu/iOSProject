// The MIT License (MIT)
//
// Copyright (c) 2015-2016 JazysYu ( https://github.com/JazysYu )
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

#import "UINavigationController+JZExtension.h"
#import <objc/runtime.h>
#import <objc/message.h>

#define objc_getProperty(objc,key) [objc valueForKey:key]
@implementation NSNumber (JZExtension)
- (CGFloat)CGFloatValue {
#if CGFLOAT_IS_DOUBLE
    return [self doubleValue];
#else
    return [self floatValue];
#endif
}
@end

@interface UINavigationController (_JZExtension)
@property (nonatomic, copy) void (^_interactivePopFinished)(BOOL);
@property (nonatomic, copy) void (^_push_pop_Finished)(BOOL);
@property (nonatomic, assign) CGFloat _navigationBarBackgroundReverseAlpha;
- (void)setInteractivePopedViewController:(UIViewController *)interactivePopedViewController;
- (BOOL)jz_isTransitioning;
- (BOOL)jz_isInteractiveTransition;
@end

@interface UIPercentDrivenInteractiveTransition (JZExtension)
- (id)__parent;
- (void)_updateInteractiveTransition:(CGFloat)percentComplete;
- (void)_cancelInteractiveTransition;
- (void)_finishInteractiveTransition;
@end

@protocol JZExtensionBarProtocol <NSObject>
@property (nonatomic, assign) CGSize size;
- (UIView * _Nullable)__backgroundView;
- (CGSize)_sizeThatFits:(CGSize)size;
@end

@interface UINavigationBar (JZExtension) <JZExtensionBarProtocol>
@end

@interface UIToolbar (JZExtension) <JZExtensionBarProtocol>
- (UIView * _Nullable)__shadowView;
@end

@implementation UINavigationController (JZExtension)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{

        void (^__method_swizzling)(Class, SEL, SEL) = ^(Class cls, SEL sel, SEL _sel) {
            Method  method = class_getInstanceMethod(cls, sel);
            Method _method = class_getInstanceMethod(cls, _sel);
            method_exchangeImplementations(method, _method);
        };
        /**
         *  rewrite the implementation of interactivePopGestureRecognizer's delegate.
         */
        {
            Class _UINavigationInteractiveTransition = NSClassFromString(@"_UINavigationInteractiveTransition");

            {
                Method gestureShouldReceiveTouch = class_getInstanceMethod(_UINavigationInteractiveTransition, @selector(gestureRecognizer:shouldReceiveTouch:));
                method_setImplementation(gestureShouldReceiveTouch, imp_implementationWithBlock(^(UIPercentDrivenInteractiveTransition *navTransition,UIGestureRecognizer *gestureRecognizer, UITouch *touch){
                    UINavigationController *navigationController = (UINavigationController *)[navTransition __parent];
                    return navigationController.viewControllers.count != 1 && ![navigationController jz_isTransitioning];
                }));
            }
            
            {
                NSString *selectorString = [NSString stringWithFormat:@"_%@",NSStringFromSelector(@selector(gestureRecognizer:shouldBeRequiredToFailByGestureRecognizer:))];
                Method gestureShouldSimultaneouslyGesture = class_getInstanceMethod(_UINavigationInteractiveTransition, NSSelectorFromString(selectorString));
                method_setImplementation(gestureShouldSimultaneouslyGesture, imp_implementationWithBlock(^{
                    return NO;
                }));
            
            }
            
            {
                __method_swizzling([UIPercentDrivenInteractiveTransition class], @selector(updateInteractiveTransition:), @selector(_updateInteractiveTransition:));
            }
            
            {
                __method_swizzling([UIPercentDrivenInteractiveTransition class], @selector(cancelInteractiveTransition), @selector(_cancelInteractiveTransition));
            }
            
            {
                __method_swizzling([UIPercentDrivenInteractiveTransition class], @selector(finishInteractiveTransition), @selector(_finishInteractiveTransition));
            }
            
            {
                __method_swizzling([UINavigationBar class], @selector(sizeThatFits:), @selector(_sizeThatFits:));
            }
            
            {
                __method_swizzling([UIToolbar class], @selector(sizeThatFits:), @selector(_sizeThatFits:));
            }
        }
        
        {

            {
                __method_swizzling(self, @selector(pushViewController:animated:),@selector(_pushViewController:animated:));
            }
            
            {
                __method_swizzling(self, @selector(popViewControllerAnimated:), @selector(_popViewControllerAnimated:));
            }
            
            {
                __method_swizzling(self, @selector(popToViewController:animated:), @selector(_popToViewController:animated:));
            }
            
            {
                __method_swizzling(self, @selector(popToRootViewControllerAnimated:), @selector(_popToRootViewControllerAnimated:));
            }
            
            {
                __method_swizzling(self, NSSelectorFromString(@"navigationTransitionView:didEndTransition:fromView:toView:"),@selector(jz_navigationTransitionView:didEndTransition:fromView:toView:));
            }
            
        }
    });
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^)(BOOL))completion {
    self._push_pop_Finished = completion;
    UIViewController *visibleViewController = [self visibleViewController];
    [self _pushViewController:viewController animated:animated];
    [self _navigationWillTransitFromViewController:visibleViewController toViewController:viewController animated:animated isInterActiveTransition:NO];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated completion:(void (^)(BOOL))completion {
    self._push_pop_Finished = completion;
    UIViewController *viewController = [self _popViewControllerAnimated:animated];
    UIViewController *visibleViewController = [self visibleViewController];
    [self _navigationWillTransitFromViewController:viewController toViewController:visibleViewController animated:animated isInterActiveTransition:YES];
    return viewController;
}

- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^)(BOOL finished))completion {
    self._push_pop_Finished = completion;
    NSArray *popedViewControllers = [self _popToViewController:viewController animated:animated];
    UIViewController *topPopedViewController = [popedViewControllers lastObject];
    [self _navigationWillTransitFromViewController:topPopedViewController toViewController:viewController animated:animated isInterActiveTransition:NO];
    return popedViewControllers;
}

- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated completion:(void (^)(BOOL finished))completion {
    self._push_pop_Finished = completion;
    NSArray *popedViewControllers = [self _popToRootViewControllerAnimated:animated];
    UIViewController *topPopedViewController = [popedViewControllers lastObject];
    UIViewController *topViewController = [self.viewControllers firstObject];
    [self _navigationWillTransitFromViewController:topPopedViewController toViewController:topViewController animated:animated isInterActiveTransition:NO];
    return popedViewControllers;
}

#pragma mark - private funcs

- (void)_pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [self pushViewController:viewController animated:animated completion:NULL];
}

- (UIViewController *)_popViewControllerAnimated:(BOOL)animated {
    return [self popViewControllerAnimated:animated completion:NULL];
}

- (NSArray *)_popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    return [self popToViewController:viewController animated:animated completion:NULL];
}

- (NSArray *)_popToRootViewControllerAnimated:(BOOL)animated {
    return [self popToRootViewControllerAnimated:animated completion:NULL];
}

- (void)jz_navigationTransitionView:(id)arg1 didEndTransition:(int)arg2 fromView:(id)arg3 toView:(id)arg4 {
    [self jz_navigationTransitionView:arg1 didEndTransition:arg2 fromView:arg3 toView:arg4];
    !self._push_pop_Finished ?: self._push_pop_Finished(YES);
}

- (void)_navigationWillTransitFromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController animated:(BOOL)animated isInterActiveTransition:(BOOL)isInterActiveTransition {
    [self setNavigationBarHidden:!toViewController.wantsNavigationBarVisible animated:animated];
    void (^_updateNavigationBarBackgroundAlpha)() = ^{
        if (fromViewController.navigationBarBackgroundHidden != toViewController.navigationBarBackgroundHidden) {
            [UIView animateWithDuration:animated ? UINavigationControllerHideShowBarDuration : 0.f animations:^{
                [self setNavigationBarBackgroundAlpha:toViewController.navigationBarBackgroundHidden ? 0 : 1-self._navigationBarBackgroundReverseAlpha];
            }];
        }
    };
    if (!isInterActiveTransition) {
        _updateNavigationBarBackgroundAlpha();
    } else {
        if (![self jz_isInteractiveTransition]) {
            _updateNavigationBarBackgroundAlpha();
        } else
            self.interactivePopedViewController = fromViewController;
    }
}

#pragma mark - setters

- (void)setInteractivePopGestureRecognizerCompletion:(void (^)(BOOL))completion {
    self._interactivePopFinished = completion;
}

- (void)setFullScreenInteractivePopGestureRecognizer:(BOOL)fullScreenInteractivePopGestureRecognizer {
    if (fullScreenInteractivePopGestureRecognizer) {
        if ([self.interactivePopGestureRecognizer isMemberOfClass:[UIPanGestureRecognizer class]]) return;
        object_setClass(self.interactivePopGestureRecognizer, [UIPanGestureRecognizer class]);
        [self.interactivePopGestureRecognizer setValue:@NO forKey:@"canPanVertically"];
    } else {
        if ([self.interactivePopGestureRecognizer isMemberOfClass:[UIScreenEdgePanGestureRecognizer class]]) return;
        object_setClass(self.interactivePopGestureRecognizer, [UIScreenEdgePanGestureRecognizer class]);
    }
}

- (void)setToolbarBackgroundAlpha:(CGFloat)toolbarBackgroundAlpha {
    [[self.toolbar __shadowView] setAlpha:toolbarBackgroundAlpha];
    [[self.toolbar __backgroundView] setAlpha:toolbarBackgroundAlpha];
}

- (void)setNavigationBarBackgroundAlpha:(CGFloat)navigationBarBackgroundAlpha {
    [[self.navigationBar __backgroundView] setAlpha:navigationBarBackgroundAlpha];
    // navigationBarBackgroundAlpha == 0 means hidden so do not set.
    if (!navigationBarBackgroundAlpha) return;
    self._navigationBarBackgroundReverseAlpha = 1-navigationBarBackgroundAlpha;
}

- (void)setNavigationBarSize:(CGSize)navigationBarSize {
    [self.navigationBar setSize:navigationBarSize];
}

- (void)setToolbarSize:(CGSize)toolbarSize {
    [self.toolbar setSize:toolbarSize];
}

- (void)set_push_pop_Finished:(void (^)(BOOL))_push_pop_Finished {
    objc_setAssociatedObject(self, @selector(_push_pop_Finished), _push_pop_Finished, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)setInteractivePopedViewController:(UIViewController *)interactivePopedViewController {
    objc_setAssociatedObject(self, @selector(interactivePopedViewController), interactivePopedViewController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)set_navigationBarBackgroundReverseAlpha:(CGFloat)_navigationBarBackgroundReverseAlpha {
    objc_setAssociatedObject(self, @selector(_navigationBarBackgroundReverseAlpha), @(_navigationBarBackgroundReverseAlpha), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)set_interactivePopFinished:(void (^)(BOOL))_interactivePopFinished {
    objc_setAssociatedObject(self, @selector(_interactivePopFinished), _interactivePopFinished, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

#pragma mark - getters

- (CGFloat)navigationBarBackgroundAlpha {
    return [[self.navigationBar __backgroundView] alpha];
}

- (CGFloat)toolbarBackgroundAlpha {
    return [[self.toolbar __backgroundView] alpha];
}

- (BOOL)fullScreenInteractivePopGestureRecognizer {
    return [self.interactivePopGestureRecognizer isMemberOfClass:[UIPanGestureRecognizer class]];
}

- (void (^)(BOOL))_push_pop_Finished {
    return objc_getAssociatedObject(self, _cmd);
}

- (void (^)(BOOL))_interactivePopFinished {
    return objc_getAssociatedObject(self, _cmd);
}

- (UIViewController *)interactivePopedViewController {
    return objc_getAssociatedObject(self, _cmd);
}

- (CGFloat)_navigationBarBackgroundReverseAlpha {
    return [objc_getAssociatedObject(self, _cmd) CGFloatValue];
}

- (CGSize)navigationBarSize {
    return [self.navigationBar size];
}

- (CGSize)toolbarSize {
    return [self.toolbar size];
}

- (BOOL)jz_isInteractiveTransition {
    return [objc_getProperty(self, @"isInteractiveTransition") boolValue];
}

- (BOOL)jz_isTransitioning {
    return [objc_getProperty(self, @"_isTransitioning") boolValue];
}

- (UIViewController *)previousViewControllerForViewController:(UIViewController *)viewController {
    NSUInteger index = [self.viewControllers indexOfObject:viewController];
    
    if (!index) return nil;
    
    return self.viewControllers[index - 1];
}

@end

@implementation UIViewController (JZExtension)

- (UIViewController *)previousViewController {
    return self.navigationController ? [self.navigationController previousViewControllerForViewController:self] : nil;
}

- (void)setNavigationBarBackgroundHidden:(BOOL)navigationBarBackgroundHidden {
    CGFloat alpha = navigationBarBackgroundHidden ? 0 : 1-self.navigationController._navigationBarBackgroundReverseAlpha;
    [[self.navigationController.navigationBar __backgroundView] setAlpha:alpha];
    objc_setAssociatedObject(self, @selector(isNavigationBarBackgroundHidden), @(navigationBarBackgroundHidden), OBJC_ASSOCIATION_ASSIGN);
}

- (void)setNavigationBarBackgroundHidden:(BOOL)navigationBarBackgroundHidden animated:(BOOL)animated {
    [UIView animateWithDuration:animated ? UINavigationControllerHideShowBarDuration : 0.f animations:^{
        [self setNavigationBarBackgroundHidden:navigationBarBackgroundHidden];
    }];
}

- (void)setWantsNavigationBarVisible:(BOOL)wantsNavigationBarVisible {
    objc_setAssociatedObject(self, @selector(wantsNavigationBarVisible), @(wantsNavigationBarVisible), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)isNavigationBarBackgroundHidden {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (BOOL)wantsNavigationBarVisible {
    id _wantsNavigationBarVisible = objc_getAssociatedObject(self, _cmd);
    return _wantsNavigationBarVisible != nil ? [_wantsNavigationBarVisible boolValue] : YES;
}

@end

#define JZExtensionBarImplementation \
- (CGSize)_sizeThatFits:(CGSize)size { \
    CGSize newSize = [self _sizeThatFits:size]; \
    return CGSizeMake(self.size.width == 0.f ? newSize.width : self.size.width, self.size.height == 0.f ? newSize.height : self.size.height); \
} \
- (void)setSize:(CGSize)size { \
    objc_setAssociatedObject(self, @selector(size), [NSValue valueWithCGSize:size], OBJC_ASSOCIATION_RETAIN_NONATOMIC); \
    [self sizeToFit]; \
} \
- (CGSize)size { \
    return [objc_getAssociatedObject(self, _cmd) CGSizeValue]; \
} \
- (UIView *)__backgroundView { \
    return objc_getProperty(self, @"_backgroundView"); \
}

@implementation UIToolbar (JZExtension)

JZExtensionBarImplementation

- (UIView *)__shadowView {
    return objc_getProperty(self, @"_shadowView");
}

@end

@implementation UINavigationBar (JZExtension)

JZExtensionBarImplementation

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if ([[self __backgroundView] alpha] < 1.0f) {
        return CGRectContainsPoint(CGRectMake(0, self.bounds.size.height - 44, self.bounds.size.width, 44), point);
    } else {
        return [super pointInside:point withEvent:event];
    }
}

@end

@implementation UIPercentDrivenInteractiveTransition (JZExtension)

- (void)_handleInteractiveTransition:(BOOL)isCancel {
    if (![self isMemberOfClass:NSClassFromString(@"_UINavigationInteractiveTransition")]) {
        return;
    }

    UINavigationController *navigationController = (UINavigationController *)[self __parent];
    UIViewController *adjustViewController = isCancel ? navigationController.interactivePopedViewController : navigationController.visibleViewController;
    navigationController.navigationBarBackgroundAlpha = adjustViewController.navigationBarBackgroundHidden ? 0 : (1-navigationController._navigationBarBackgroundReverseAlpha);
    navigationController.interactivePopedViewController = nil;
    !navigationController._interactivePopFinished ?: navigationController._interactivePopFinished(!isCancel);
}

- (void)_updateInteractiveTransition:(CGFloat)percentComplete {
    [self _updateInteractiveTransition:percentComplete];
    if (![self isMemberOfClass:NSClassFromString(@"_UINavigationInteractiveTransition")]) {
        return;
    }

    UINavigationController *navigationController = (UINavigationController *)[self __parent];

    BOOL popedViewControllerNaviBarBgHidden = navigationController.interactivePopedViewController.navigationBarBackgroundHidden;
    if (popedViewControllerNaviBarBgHidden == navigationController.visibleViewController.navigationBarBackgroundHidden) return;
    else {
        CGFloat _percentComplete = popedViewControllerNaviBarBgHidden ? percentComplete : 1- percentComplete;
        [[navigationController.navigationBar __backgroundView] setAlpha:(1-navigationController._navigationBarBackgroundReverseAlpha) * _percentComplete];
    }
}

- (void)_cancelInteractiveTransition {
    [self _cancelInteractiveTransition];
    [self _handleInteractiveTransition:YES];
}

- (void)_finishInteractiveTransition {
    [self _finishInteractiveTransition];
    [self _handleInteractiveTransition:NO];
}

- (id)__parent {
    return objc_getProperty(self, @"_parent");
}

@end
