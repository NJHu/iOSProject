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
//"UINavigationController+JZExtension"分类为UINavigationController集成了许多方便的功能点，同时为它打开了一些隐藏功能。
#import <UIKit/UIKit.h>

/// The "UINavigationController+JZExtension" category integrates some convenient functions and open some hide property
/// for UINavigationController, such as gives your UINavigationController a fullscreen interactivePopGestureRecognizer,
/// all you need is enable/disable "fullScreenInteractivePopGestureRecognizer" property for each ViewController.
/// If you have some ViewController which doesn't wants a navigation bar, you can set the "wantsNavigationBarVisible"
/// property to NO.
/// You can also adjust your navigationBar or toolbar's background alpha.
@interface UINavigationController (JZExtension)

@property (nonatomic, assign) BOOL fullScreenInteractivePopGestureRecognizer NS_AVAILABLE_IOS(7_0); // If YES, then you can have a fullscreen
/// gesture recognizer responsible for popping the top view controller off the navigation stack, and the property is still
/// "interactivePopGestureRecognizer", see more for "UINavigationController.h", Default is NO.
@property (nonatomic, assign) CGFloat navigationBarBackgroundAlpha NS_AVAILABLE_IOS(7_0); // navigationBar's background alpha, when 0 your
/// navigationBar will be invisable, default is 1. Animatable
@property (nonatomic, assign) CGFloat toolbarBackgroundAlpha NS_AVAILABLE_IOS(7_0); // Current navigationController's toolbar background alpha,
/// make sure the toolbarHidden property is NO, default is 1. Animatable
@property (nonatomic, readonly, strong) UIViewController *interactivePopedViewController NS_AVAILABLE_IOS(7_0); // The view controller that is being popped
/// when the interactive pop gesture recognizer's UIGestureRecognizerState is UIGestureRecognizerStateChanged.
/// This category helps to change navigationBar or toolBar to any size, if you want default value, then set to 0.f.
@property (nonatomic, assign, readwrite) CGSize navigationBarSize;
@property (nonatomic, assign, readwrite) CGSize toolbarSize;

- (UIViewController *)previousViewControllerForViewController:(UIViewController *)viewController; // Return the gives
/// view controller's previous view controller in the navigation stack.

/// Called at end of animation of push/pop or immediately if not animated.
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^)(BOOL finished))completion;
- (UIViewController *)popViewControllerAnimated:(BOOL)animated completion:(void (^)(BOOL finished))completion;
- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated completion:(void (^)(BOOL finished))completion;
- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^)(BOOL finished))completion;
- (void)setInteractivePopGestureRecognizerCompletion:(void (^)(BOOL finished))completion;
@end

@interface UIViewController (JZExtension)
// Worked on each view controller's push or pop, If NO, then when this view controller wants push/pop into a controller hierarchy, the specify bar will slide out.
@property (nonatomic, assign) IBInspectable BOOL wantsNavigationBarVisible; //  Default is YES.

@property (nonatomic, assign, getter=isNavigationBarBackgroundHidden) IBInspectable BOOL navigationBarBackgroundHidden;
- (void)setNavigationBarBackgroundHidden:(BOOL)navigationBarBackgroundHidden animated:(BOOL)animated NS_AVAILABLE_IOS(8_0); // Hide or show the navigation bar background. If animated, it will transition vertically using UINavigationControllerHideShowBarDuration.
- (UIViewController *)previousViewController; //Return the gives
/// view controller's previous view controller in the navigation stack.
@end