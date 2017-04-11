//
//  JDStatusBarStyle.h
//  JDStatusBarNotificationExample
//
//  Created by Markus on 04.12.13.
//  Copyright (c) 2013 Markus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

extern NSString *const JDStatusBarStyleError;   /// This style has a red background with a white Helvetica label.
extern NSString *const JDStatusBarStyleWarning; /// This style has a yellow background with a gray Helvetica label.
extern NSString *const JDStatusBarStyleSuccess; /// This style has a green background with a white Helvetica label.
extern NSString *const JDStatusBarStyleMatrix;  /// This style has a black background with a green bold Courier label.
extern NSString *const JDStatusBarStyleDefault; /// This style has a white background with a gray Helvetica label.
extern NSString *const JDStatusBarStyleDark;    /// This style has a nearly black background with a nearly white Helvetica label.

typedef NS_ENUM(NSInteger, JDStatusBarAnimationType) {
    JDStatusBarAnimationTypeNone,   /// Notification won't animate
    JDStatusBarAnimationTypeMove,   /// Notification will move in from the top, and move out again to the top
    JDStatusBarAnimationTypeBounce, /// Notification will fall down from the top and bounce a little bit
    JDStatusBarAnimationTypeFade    /// Notification will fade in and fade out
};

typedef NS_ENUM(NSInteger, JDStatusBarProgressBarPosition) {
    JDStatusBarProgressBarPositionBottom, /// progress bar will be at the bottom of the status bar
    JDStatusBarProgressBarPositionCenter, /// progress bar will be at the center of the status bar
    JDStatusBarProgressBarPositionTop,    /// progress bar will be at the top of the status bar
    JDStatusBarProgressBarPositionBelow,  /// progress bar will be below the status bar (the prograss bar won't move with the statusbar in this case)
    JDStatusBarProgressBarPositionNavBar, /// progress bar will be below the navigation bar (the prograss bar won't move with the statusbar in this case)
};

/**
 *  A Style defines the appeareance of a notification.
 */
@interface JDStatusBarStyle : NSObject <NSCopying>

/// The background color of the notification bar
@property (nonatomic, strong) UIColor *barColor;

/// The text color of the notification label
@property (nonatomic, strong) UIColor *textColor;

/// The text shadow of the notification label
@property (nonatomic, strong) NSShadow *textShadow;

/// The font of the notification label
@property (nonatomic, strong) UIFont *font;

/// A correction of the vertical label position in points. Default is 0.0
@property (nonatomic, assign) CGFloat textVerticalPositionAdjustment;

#pragma mark Animation

/// The animation, that is used to present the notification
@property (nonatomic, assign) JDStatusBarAnimationType animationType;

#pragma mark Progress Bar

/// The background color of the progress bar (on top of the notification bar)
@property (nonatomic, strong) UIColor *progressBarColor;

/// The height of the progress bar. Default is 1.0
@property (nonatomic, assign) CGFloat progressBarHeight;

/// The position of the progress bar. Default is JDStatusBarProgressBarPositionBottom
@property (nonatomic, assign) JDStatusBarProgressBarPosition progressBarPosition;

@end

