//
//  JDStatusBarNotification.h
//
//  Based on KGStatusBar by Kevin Gibbon
//
//  Created by Markus Emrich on 10/28/13.
//  Copyright 2013 Markus Emrich. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JDStatusBarStyle.h"
#import "JDStatusBarView.h"

/**
 *  A block that is used to define the appearance of a notification.
 *  A JDStatusBarStyle instance defines the notification appeareance.
 *
 *  @param style The current default JDStatusBarStyle instance.
 *
 *  @return The modified JDStatusBarStyle instance.
 */
typedef JDStatusBarStyle*(^JDPrepareStyleBlock)(JDStatusBarStyle *style);

/**
 *  This class is a singletion which is used to present notifications
 *  on top of the status bar. To present a notification, use one of the
 *  given class methods.
 */
@interface JDStatusBarNotification : NSObject

#pragma mark Presentation

/**
 *  Show a notification. It won't hide automatically,
 *  you have to dimiss it on your own.
 *
 *  @param status The message to display
 *
 *  @return The presented notification view for further customization
 */
+ (JDStatusBarView*)showWithStatus:(NSString *)status;

/**
 *  Show a notification with a specific style. It won't
 *  hide automatically, you have to dimiss it on your own.
 *
 *  @param status The message to display
 *  @param styleName The name of the style. You can use any JDStatusBarStyle constant
 *  (JDStatusBarStyleDefault, etc.), or a custom style identifier, after you added a
 *  custom style. If this is nil, the default style will be used.
 *
 *  @return The presented notification view for further customization
 */
+ (JDStatusBarView*)showWithStatus:(NSString *)status
                         styleName:(NSString*)styleName;

/**
 *  Same as showWithStatus:, but the notification will
 *  automatically dismiss after the given timeInterval.
 *
 *  @param status       The message to display
 *  @param timeInterval The duration, how long the notification
 *  is displayed. (Including the animation duration)
 *
 *  @return The presented notification view for further customization
 */
+ (JDStatusBarView*)showWithStatus:(NSString *)status
                      dismissAfter:(NSTimeInterval)timeInterval;

/**
 *  Same as showWithStatus:styleName:, but the notification
 *  will automatically dismiss after the given timeInterval.
 *
 *  @param status       The message to display
 *  @param timeInterval The duration, how long the notification
 *  is displayed. (Including the animation duration)
 *  @param styleName The name of the style. You can use any JDStatusBarStyle constant
 *  (JDStatusBarStyleDefault, etc.), or a custom style identifier, after you added a
 *  custom style. If this is nil, the default style will be used.
 *
 *  @return The presented notification view for further customization
 */
+ (JDStatusBarView*)showWithStatus:(NSString *)status
                      dismissAfter:(NSTimeInterval)timeInterval
                         styleName:(NSString*)styleName;

#pragma mark Dismissal

/**
 *  Calls dismissAnimated: with animated set to YES
 */
+ (void)dismiss;

/**
 *  Dismisses any currently displayed notification immediately
 *
 *  @param animated If this is YES, the animation style used
 *  for presentation will also be used for the dismissal.
 */
+ (void)dismissAnimated:(BOOL)animated;

/**
 *  Same as dismissAnimated:, but you can specify a delay,
 *  so the notification wont be dismissed immediately
 *
 *  @param delay The delay, how long the notification should stay visible
 */
+ (void)dismissAfter:(NSTimeInterval)delay;

#pragma mark Styles

/**
 *  This changes the default style, which is always used
 *  when a method without styleName is used for presentation, or
 *  styleName is nil, or no style is found with this name.
 *
 *  @param prepareBlock A block, which has a JDStatusBarStyle instance as
 *  parameter. This instance can be modified to suit your needs. You need
 *  to return the modified style again.
 */
+ (void)setDefaultStyle:(JDPrepareStyleBlock)prepareBlock;

/**
 *  Adds a custom style, which than can be used
 *  in the presentation methods.
 *
 *  @param identifier   The identifier, which will
 *  later be used to reference the configured style.
 *  @param prepareBlock A block, which has a JDStatusBarStyle instance as
 *  parameter. This instance can be modified to suit your needs. You need
 *  to return the modified style again.
 *
 *  @return Returns the given identifier, so it can
 *  be directly used as styleName parameter.
 */
+ (NSString*)addStyleNamed:(NSString*)identifier
                   prepare:(JDPrepareStyleBlock)prepareBlock;

#pragma mark progress & activity

/**
 *  Show the progress below the label.
 *
 *  @param progress Relative progress from 0.0 to 1.0
 */
+ (void)showProgress:(CGFloat)progress;

/**
 *  Shows an activity indicator in front of the notification text
 *
 *  @param show  Use this flag to show or hide the activity indicator
 *  @param style Sets the style of the activity indicator
 */
+ (void)showActivityIndicator:(BOOL)show
               indicatorStyle:(UIActivityIndicatorViewStyle)style;

#pragma mark state

/**
 *  This method tests, if a notification is currently displayed.
 *
 *  @return YES, if a notification is currently displayed. Otherwise NO.
 */
+ (BOOL)isVisible;

@end


