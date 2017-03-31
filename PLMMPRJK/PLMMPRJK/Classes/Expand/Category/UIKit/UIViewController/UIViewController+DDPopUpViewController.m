//
//  UIViewController+DDPopUpViewController.m
//  appStroreDDReaderHD
//
//  Created by Sun chongyang on 14-1-17.
//  Copyright (c) 2014年 dangdang.com. All rights reserved.
//

#import "UIViewController+DDPopUpViewController.h"
#import <objc/runtime.h>

#define kDDBackgroundViewTag 12345
#define kDDContentViewTag 12346

static char* popUpViewControllerKey ="popUpViewControllerKey";
static char* popUpParentViewViewControllerKey ="popUpParentViewViewControllerKey";
static char* popUpOffsetKey = "popUpOffsetKey";
static char* popUpPositionKey = "popUpPositionKey";
static char* popUpSizeKey = "popUpSizeKey";
static char* animationTypeKey = "animationTypeKey";
static char* dismissWhenTouchBackgroundKey = "dismissWhenTouchBackgroundKey";
static char* popUpWindowKey = "popUpWindowKey";
static char* previosKeyWindowKey = "previosKeyWindowKey";
static char* dissmissCallbackKey = "dissmissCallbackKey";

NSTimeInterval const kPopupModalAnimationDuration = 0.30f;

static NSMutableArray *__popUpViewControllers = nil;

@interface UIViewController (DDPopUpViewControllerPrivate)

@property (nonatomic,assign) UIViewController *popUpParentViewController;
@property (nonatomic,assign) DDPopUpAnimationType animationType;
@property (nonatomic,assign) UIWindow *previosKeyWindow;
@property (nonatomic,retain) UIWindow *popUpWindow;

- (CGRect)frameForViewSize:(CGSize)viewSize;
- (void)updatePopupViewSize:(CGSize)newSize;
- (void)showPopUpView:(UIView *)popupContentView backgroundView:(UIView *)backgroundView animationType:(DDPopUpAnimationType)animationType;
- (void)dismissPopUpView;

@end

@interface UINavigationController (DDPopUpViewControllerPrivate)

@end

@implementation UINavigationController (DDPopUpViewControllerPrivate)

- (CGSize)popUpViewSize
{
    NSValue *value = objc_getAssociatedObject(self, popUpSizeKey);
    CGSize popUpViewSize = [value CGSizeValue];
    if (CGSizeEqualToSize(popUpViewSize, CGSizeZero)) {
        popUpViewSize = self.topViewController.popUpViewSize;
    }
    
    return popUpViewSize;
}

@end

@implementation UIViewController (DDPopUpViewController)

#pragma mark - setters & getters
- (void)setPopUpViewController:(UIViewController *)popUpViewController
{
    objc_setAssociatedObject(self, popUpViewControllerKey, popUpViewController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIViewController *)popUpViewController
{
    return objc_getAssociatedObject(self, popUpViewControllerKey);
}

- (void)setPopUpParentViewController:(UIViewController *)popUpParentViewController
{
    objc_setAssociatedObject(self, popUpParentViewViewControllerKey, popUpParentViewController, OBJC_ASSOCIATION_ASSIGN);
}

- (UIViewController *)popUpParentViewController
{
    return objc_getAssociatedObject(self, popUpParentViewViewControllerKey);
}

- (void)setPopUpOffset:(CGPoint)popUpOffset
{
    objc_setAssociatedObject(self, popUpOffsetKey, [NSValue valueWithCGPoint:popUpOffset], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self.popUpParentViewController updatePopupViewSize:self.popUpViewSize animated:YES];
}

- (CGPoint)popUpOffset
{
    NSValue *value = objc_getAssociatedObject(self, popUpOffsetKey);
    return [value CGPointValue];
}

- (void)setPopUpPosition:(DDPopUpPosition)popUpPosition
{
    objc_setAssociatedObject(self, popUpPositionKey, [NSNumber numberWithInteger:popUpPosition], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (DDPopUpPosition)popUpPosition
{
    NSNumber *number = objc_getAssociatedObject(self, popUpPositionKey);
    return [number integerValue];
}

- (void)setPopUpViewSize:(CGSize)popUpViewSize
{
    objc_setAssociatedObject(self, popUpSizeKey, [NSValue valueWithCGSize:popUpViewSize], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self.popUpParentViewController updatePopupViewSize:self.popUpViewSize animated:YES];
}

- (CGSize)popUpViewSize
{
    NSValue *value = objc_getAssociatedObject(self, popUpSizeKey);
    return [value CGSizeValue];
}

- (void)setAnimationType:(DDPopUpAnimationType)animationType
{
    objc_setAssociatedObject(self, animationTypeKey,@(animationType), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (DDPopUpAnimationType)animationType
{
    NSNumber *value = objc_getAssociatedObject(self, animationTypeKey);
    return [value integerValue];
}

- (void)setDismissWhenTouchBackground:(BOOL)dismissWhenTouchBackground
{
    objc_setAssociatedObject(self, dismissWhenTouchBackgroundKey,@(dismissWhenTouchBackground), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)dismissWhenTouchBackground
{
    NSNumber *value = objc_getAssociatedObject(self, dismissWhenTouchBackgroundKey);
    return [value boolValue];
}

- (void)setPopUpWindow:(UIWindow *)popUpWindow
{
    objc_setAssociatedObject(self, popUpWindowKey,popUpWindow, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIWindow *)popUpWindow
{
    return objc_getAssociatedObject(self, popUpWindowKey);
}

- (void)setPreviosKeyWindow:(UIWindow *)previosKeyWindow
{
    objc_setAssociatedObject(self, previosKeyWindowKey,previosKeyWindow, OBJC_ASSOCIATION_ASSIGN);
}

- (UIWindow *)previosKeyWindow
{
    return objc_getAssociatedObject(self, previosKeyWindowKey);
}

- (void)setDismissCallback:(DismissCallback)dismissCallback
{
    objc_setAssociatedObject(self, dissmissCallbackKey,dismissCallback, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (DismissCallback)dismissCallback
{
    return objc_getAssociatedObject(self, dissmissCallbackKey);
}

#pragma mark - private methods

+ (void)load
{
    __popUpViewControllers = [[NSMutableArray alloc] init];
    Method original = class_getInstanceMethod([UIViewController class], NSSelectorFromString(@"dealloc"));
    Method swizzle = class_getInstanceMethod([UIViewController class], @selector(sizzled_dealloc));
    method_exchangeImplementations(original, swizzle);
}

- (void)sizzled_dealloc
{
    if (self.popUpViewController) {
        [self dismissPopUpViewController:DDPopUpAnimationTypeNone];
    }
    
    [self sizzled_dealloc];
}

- (UIView *)topView
{
    UIWindow *w = [[UIApplication sharedApplication].delegate window];
    if (!w) {
        w = [[UIApplication sharedApplication].windows lastObject];
    }
    UIViewController *topVC = [w rootViewController];
    while ([topVC presentedViewController]) {
        topVC = [topVC presentedViewController];
    }
    return [topVC view];
}

- (CGRect)frameForViewSize:(CGSize)viewSize
{
    UIViewController *containerVC = self.popUpWindow.rootViewController;
    DDPopUpPosition position = self.popUpViewController.popUpPosition;
    CGPoint popupoffset = self.popUpViewController.popUpOffset;
    
    CGRect frame = containerVC.view.bounds;
    if (position == DDPopUpPositionCenter) {
        frame = CGRectMake((CGRectGetWidth(containerVC.view.bounds) - viewSize.width)/2.0f, (CGRectGetHeight(containerVC.view.bounds) - viewSize.height)/2.0f, viewSize.width, viewSize.height);
    }
    else if(position == DDPopUpPositionTop){
        frame = CGRectMake((CGRectGetWidth(containerVC.view.bounds) - viewSize.width)/2.0f, 0, viewSize.width, viewSize.height);
    }
    else if(position == DDPopUpPositionLeft){
        frame = CGRectMake(0, (CGRectGetHeight(containerVC.view.bounds) - viewSize.height)/2.0f, viewSize.width, viewSize.height);
    }
    else if(position == DDPopUpPositionRight){
        frame = CGRectMake((CGRectGetWidth(containerVC.view.bounds) - viewSize.width), (CGRectGetHeight(containerVC.view.bounds) - viewSize.height)/2.0f, viewSize.width, viewSize.height);
    }
    
    return CGRectOffset(frame, popupoffset.x, popupoffset.y);
}

- (UIViewAutoresizing)autoresizingMaskForPosition:(DDPopUpPosition)popUpPosition frame:(CGRect)popupFrame
{
    UIViewAutoresizing autoresizingMask = UIViewAutoresizingNone;
    if (popUpPosition == DDPopUpPositionTop){
        if (CGRectGetWidth(popupFrame) == CGRectGetWidth(self.view.bounds)) {
            autoresizingMask = UIViewAutoresizingFlexibleWidth;
        }
        else{
            autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
        }
    }
    else if (popUpPosition == DDPopUpPositionFullScreen){
        autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    }
    else if (popUpPosition == DDPopUpPositionLeft){
        if (CGRectGetHeight(popupFrame) == CGRectGetHeight(self.view.bounds)) {
            autoresizingMask = UIViewAutoresizingFlexibleHeight;
        }
        else{
            autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
        }
    }
    else if (popUpPosition == DDPopUpPositionRight){
        if (CGRectGetHeight(popupFrame) == CGRectGetHeight(self.view.bounds)) {
            autoresizingMask = UIViewAutoresizingFlexibleHeight;
        }
        else{
            autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
        }
        autoresizingMask = autoresizingMask|UIViewAutoresizingFlexibleLeftMargin;
    }
    else {
        //default DDPopUpPositionCenter
        autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleRightMargin;
    }

    return autoresizingMask;
}

- (void)updatePopupViewSize:(CGSize)newSize animated:(BOOL)animated
{
    __block UIView *contentView = self.popUpViewController.view;
    CGRect frame = [self frameForViewSize:newSize];
    CGFloat animationDuration = animated ? kPopupModalAnimationDuration : 0;
    __block typeof(self) weakSelf = self;
    [UIView animateWithDuration:animationDuration animations:^(){
        contentView.frame = frame;
    }completion:^(BOOL finished){
        [weakSelf.popUpViewController.view setNeedsLayout];
        if ([weakSelf.popUpViewController isKindOfClass:[UINavigationController class]]) {
            [[(UINavigationController *)weakSelf.popUpViewController topViewController].view setNeedsLayout];
        }
    }];
}

- (void)showPopUpView:(UIView *)popupContentView backgroundView:(UIView *)backgroundView animationType:(DDPopUpAnimationType)animationType
{
    UIViewController *containerVC = self.popUpWindow.rootViewController;
    __block UIView *contentView = popupContentView;
    CGRect destinationFrame = popupContentView.frame;
    CGRect startFrame = destinationFrame;
    
    CGFloat destinationAlpha = 1.0;
    CGFloat startAlpha = 1.0;
    
    CGFloat animationDuration = kPopupModalAnimationDuration;
    
    if (animationType == DDPopUpAnimationTypeFade) {
        startAlpha = 0.0;
    }
    else if (animationType == DDPopUpAnimationTypeSlideVertical){
        startFrame = CGRectOffset(destinationFrame, 0, CGRectGetHeight(containerVC.view.bounds) - CGRectGetMinY(destinationFrame));
    }
    else if (animationType == DDPopUpAnimationTypeSlideLTR){
        startFrame = CGRectOffset(destinationFrame, -1*CGRectGetMaxX(destinationFrame), 0);
    }
    else if (animationType == DDPopUpAnimationTypeSlideRTL){
        startFrame = CGRectOffset(destinationFrame, CGRectGetWidth(containerVC.view.bounds) -  CGRectGetMinX(destinationFrame), 0);
    }
    else{
        animationDuration = 0.01;
    }
    
    __block typeof(self) weakSelf = self;
    [popupContentView setFrame:startFrame];
    popupContentView.alpha = startAlpha;
    self.popUpWindow.backgroundColor = [UIColor clearColor];
    
    [self.popUpViewController beginAppearanceTransition:YES animated:YES];
    [backgroundView addSubview:popupContentView];
    
    [UIView animateWithDuration:animationDuration animations:^(){
        [weakSelf.popUpWindow setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.5]];
        [contentView setFrame:destinationFrame];
        contentView.alpha = destinationAlpha;
    }completion:^(BOOL finished){
        [weakSelf.popUpViewController endAppearanceTransition];
    }];
}

- (void)dismissPopUpViewWithoutAnimation
{
    [self dismissPopUpViewController:DDPopUpAnimationTypeNone];
}

- (void)dismissPopUpView:(DDPopUpAnimationType)animationType  completion:(void (^)(void))completion
{
    __block DDPopUpContainerViewController *containerVC = (DDPopUpContainerViewController *)self.popUpWindow.rootViewController;
    __block UIView *popupContentView = self.popUpViewController.view;
    
    CGRect destinationFrame = popupContentView.frame;
    CGFloat destinationAlpha = 1.0;
    
    CGFloat animationDuration = kPopupModalAnimationDuration;
    
    if (animationType == DDPopUpAnimationTypeFade) {
        destinationAlpha = 0.0;
    }
    else if (animationType == DDPopUpAnimationTypeSlideVertical){
        destinationFrame = CGRectOffset(destinationFrame, 0,CGRectGetHeight(containerVC.view.bounds) - CGRectGetMinY(popupContentView.frame));
    }
    else if (animationType == DDPopUpAnimationTypeSlideLTR){
        destinationFrame = CGRectOffset(destinationFrame, -1*CGRectGetMaxX(popupContentView.frame), 0);
    }
    else if (animationType == DDPopUpAnimationTypeSlideRTL){
        destinationFrame = CGRectOffset(destinationFrame, CGRectGetWidth(containerVC.view.bounds) - CGRectGetMinX(popupContentView.frame), 0);
    }
    else if (animationType == DDPopUpAnimationTypeNone){
        animationDuration = 0.01;
    }
    
    if (self.popUpViewController.dismissCallback) {
        self.popUpViewController.dismissCallback();
    }
    
    __block typeof(self) weakSelf = self;
    [weakSelf.popUpViewController beginAppearanceTransition:NO animated:YES];
    [UIView animateWithDuration:animationDuration animations:^(){
        [popupContentView setFrame:destinationFrame];
        popupContentView.alpha = destinationAlpha;
        [weakSelf.popUpWindow setBackgroundColor:[UIColor clearColor]];
    }completion:^(BOOL finished){
        [weakSelf.popUpWindow setHidden:YES];
        containerVC.presentingPopupController = nil;
        [weakSelf.popUpViewController.view removeFromSuperview];
        [weakSelf.popUpViewController endAppearanceTransition];
        [weakSelf.popUpViewController removeFromParentViewController];
        weakSelf.popUpWindow.rootViewController = nil;
        weakSelf.popUpWindow = nil;
        weakSelf.popUpViewController.popUpParentViewController = nil;
        weakSelf.popUpViewController = nil;
        UIWindow *curKeyWindow = [[UIApplication sharedApplication] keyWindow];
        if (curKeyWindow == weakSelf.previosKeyWindow) {
            [weakSelf.previosKeyWindow makeKeyWindow];
        }
        
        if (completion) {
            completion();
        }
    }];
}

#pragma mark - public methods

+ (void)dismissCurrentShowingPopUpViewControllers
{
    while ([__popUpViewControllers count]) {
        UIViewController *vc = [__popUpViewControllers lastObject];
        [vc.popUpParentViewController dismissPopUpViewController:DDPopUpAnimationTypeNone];
    }
}

- (void)showPopUpViewController:(UIViewController *)popUpViewController
{
    [self showPopUpViewController:popUpViewController animationType:DDPopUpAnimationTypeFade dismissWhenTouchBackground:YES];
}

- (void)showPopUpViewController:(UIViewController *)popUpViewController  animationType:(DDPopUpAnimationType)animationType
{
    [self showPopUpViewController:popUpViewController animationType:animationType dismissWhenTouchBackground:YES];
}

- (void)showPopUpViewController:(UIViewController *)popUpViewController  animationType:(DDPopUpAnimationType)animationType dismissWhenTouchBackground:(BOOL)dismissWhenTouchBackground
{
    if (self.popUpWindow) {
        return;
    }
    
    self.popUpViewController = popUpViewController;
    [__popUpViewControllers addObject:popUpViewController];
    popUpViewController.animationType = animationType;
    popUpViewController.dismissWhenTouchBackground = dismissWhenTouchBackground;
    popUpViewController.popUpParentViewController = self;
    /*
     if ([popUpViewController isKindOfClass:[UINavigationController class]]) {
     ((UINavigationController *)popUpViewController).delegate = self;
     }
     */
    DDPopUpContainerViewController *containerVC = [[DDPopUpContainerViewController alloc] initWithNibName:nil bundle:nil];
    __block UIButton *backgroundView = [containerVC backgroundButton];
    [backgroundView addTarget:self action:@selector(backgroundViewTouched:) forControlEvents:UIControlEventTouchUpInside];
    containerVC.presentingPopupController = self;
    [containerVC addChildViewController:popUpViewController];
    [popUpViewController view];
    self.previosKeyWindow = [UIApplication sharedApplication].keyWindow;
    UIWindow *win = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    win.backgroundColor = [UIColor clearColor];
    UIWindowLevel windowLevel = UIWindowLevelNormal;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        windowLevel = UIWindowLevelStatusBar/2.0f;        
    }
    win.windowLevel = windowLevel + [__popUpViewControllers count];
    win.rootViewController = containerVC;
    DDRelease(containerVC);
    [win makeKeyAndVisible];
    self.popUpWindow = win;
    DDRelease(win);
    
    CGSize popupViewSize = popUpViewController.popUpViewSize;
    CGRect frame = [self frameForViewSize:popupViewSize];
    popUpViewController.view.frame = frame;
    popUpViewController.view.autoresizingMask = [self autoresizingMaskForPosition:popUpViewController.popUpPosition frame:frame];
    
    [self showPopUpView:popUpViewController.view backgroundView:backgroundView animationType:animationType];
}

- (void)backgroundViewTouched:(UIButton *)sender
{
    if (self.popUpViewController.dismissWhenTouchBackground) {
        [self dismissPopUpViewController:self.popUpViewController.animationType];
    }
}

- (void)dismissPopUpViewController
{
    [self dismissPopUpViewController:self.popUpViewController.animationType];
}

- (void)dismissPopUpViewController:(DDPopUpAnimationType)animationType;
{
    [self dismissPopUpViewController:animationType completion:NULL];
}

- (void)dismissPopUpViewController:(DDPopUpAnimationType)animationType completion:(void (^)(void))completion
{
    UIViewController *vc = nil;
    if (self.popUpViewController) {
        vc = self;
    }
    else if (self.popUpParentViewController){
        vc = self.popUpParentViewController;
    }
    
    if (vc) {
        [__popUpViewControllers removeObject:vc.popUpViewController];
        [vc dismissPopUpView:animationType completion:completion];
    }
    else if (self.parentViewController) {
        [self.parentViewController dismissPopUpViewController:animationType];
    }
}
/*
#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    CGFloat offset = 0;
    if (!navigationController.navigationBarHidden) {
        offset += CGRectGetHeight(navigationController.navigationBar.bounds);
    }
    
    CGSize popupViewSize = viewController.popUpViewSize;
    if (CGSizeEqualToSize(popupViewSize, CGSizeZero)) {
        popupViewSize = viewController.view.bounds.size;
    }
    
    popupViewSize.height += offset;
    
    __block typeof(self) weakSelf = self;
    double delayInSeconds = 0.25;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [weakSelf updatePopupViewSize:popupViewSize animated:YES];
    });
}
*/

@end

#pragma mark - DDPopUpContainerViewController

@implementation DDPopUpContainerViewController

- (void)dealloc
{
    self.backgroundButton = nil;
    self.presentingPopupController = nil;
    
    #if !__has_feature(objc_arc)
        [super dealloc];
    #endif
}

- (UIButton *)backgroundButton
{
    if (nil == _backgroundButton) {
        _backgroundButton = DDRetain([UIButton buttonWithType:UIButtonTypeCustom]);;
        _backgroundButton.frame = self.view.bounds;
        _backgroundButton.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        [self.view addSubview:_backgroundButton];
    }
    
    return _backgroundButton;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return [self.presentingPopupController preferredStatusBarStyle];
}

- (BOOL)prefersStatusBarHidden
{
    return [self.presentingPopupController prefersStatusBarHidden];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return [self.presentingPopupController supportedInterfaceOrientations];
}

- (BOOL)shouldAutorotate
{
    return [self.presentingPopupController shouldAutorotate];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return [self.presentingPopupController shouldAutorotateToInterfaceOrientation:toInterfaceOrientation];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self.presentingPopupController.popUpViewController willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    [self.presentingPopupController.popUpViewController didRotateFromInterfaceOrientation:fromInterfaceOrientation];
}

@end

