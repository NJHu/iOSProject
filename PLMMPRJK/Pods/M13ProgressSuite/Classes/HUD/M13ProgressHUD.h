//
//  M13ProgressViewHUD.h
//  M13ProgressView
//
/*Copyright (c) 2013 Brandon McQuilkin
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import <UIKit/UIKit.h>
#import "M13ProgressView.h"

typedef enum {
    M13ProgressHUDStatusPositionBelowProgress,
    M13ProgressHUDStatusPositionAboveProgress,
    M13ProgressHUDStatusPositionLeftOfProgress,
    M13ProgressHUDStatusPositionRightOfProgress
} M13ProgressHUDStatusPosition;

typedef enum {
    M13ProgressHUDMaskTypeNone,
    M13ProgressHUDMaskTypeSolidColor,
    M13ProgressHUDMaskTypeGradient,
    M13ProgressHUDMaskTypeIOS7Blur
} M13ProgressHUDMaskType;

/**A progress HUD to display progress, and a description over a window or view.*/
@interface M13ProgressHUD : UIView

/**@name Initalization*/
/**Initalize the HUD with a customized progress view.
 @param progressView The progres view to display in the HUD.
 @note If you create the HUD with this method, you are responsible for creating the progress view and setting the frame size of the progress view.*/
- (id)initWithProgressView:(M13ProgressView *)progressView;
/**Initalize and show the hud with parameters.
 @param progressView The progress view to show in the HUD.
 @param indeterminate Wether or not the progress view is indeterminate.
 @param progress The progress to display in the progress view.
 @param status The status to display in the HUD.
 @param maskType The type of mask to use for the HUD.
 @param view The view to show the HUD in.
 @return A instance of M13PRogressHUD*/
- (id)initAndShowWithProgressView:(M13ProgressView *)progressView progress:(CGFloat)progress indeterminate:(BOOL)indeterminate status:(NSString *)status mask:(M13ProgressHUDMaskType)maskType inView:(UIView *)view;

/**@name Progress View Convienence Properties*/
/**The progress view displaied.*/
@property (nonatomic, retain) M13ProgressView *progressView;
/**The primary color of the `M13ProgressView`.*/
@property (nonatomic, retain) UIColor *primaryColor;
/**The secondary color of the `M13ProgressView`.*/
@property (nonatomic, retain) UIColor *secondaryColor;
/**The progress displayed to the user.*/
@property (nonatomic, readonly) CGFloat progress;
/**Wether or not the progress view is indeterminate.*/
@property (nonatomic, assign) BOOL indeterminate;

/**@name Appearance*/
/**Wether or not a iOS7 style blur is applied to the HUD.*/
@property (nonatomic, assign) BOOL applyBlurToBackground;
/**The color of the background.*/
@property (nonatomic, retain) UIColor *hudBackgroundColor;
/**The location of the status label in comparison to the progress view.*/
@property (nonatomic, assign) M13ProgressHUDStatusPosition statusPosition;
/**The offset distance of the HUD from the center of its superview.*/
@property (nonatomic, assign) UIOffset offsetFromCenter;
/**The margin between the edge of the HUD and it's progress view and status label.*/
@property (nonatomic, assign) CGFloat contentMargin;
/**The corner radius of the HUD view.*/
@property (nonatomic, assign) CGFloat cornerRadius;
/**The type of mask the HUD displays over the view's content.*/
@property (nonatomic, assign) M13ProgressHUDMaskType maskType;
/**The color of the HUD mask if set to Solid Color or Gradient.*/
@property (nonatomic, retain) UIColor *maskColor;
/**The color of the status text.*/
@property (nonatomic, retain) UIColor *statusColor;
/**The font to display the status label with.*/
@property (nonatomic, retain) UIFont *statusFont;
/**The size of the progress view.*/
@property (nonatomic, assign) CGSize progressViewSize;
/**The origin of the show/hide animation. show: will animate from this point, and hide: will animate to this point.*/
@property (nonatomic, assign) CGPoint animationPoint;
/**If true, animation doesn't come from animation point, but frame background view position
 */
@property (nonatomic, assign) BOOL animationCentered;

/**@name Properties*/
/**The durations of animations in seconds.*/
@property (nonatomic, assign) CGFloat animationDuration;
/**The text displayed in the HUD to provide more information to the user.*/
@property (nonatomic, retain) NSString *status;
/**Minimum size of the HUD. 
 @note If the content is smaller than the minimum size, the HUD will be the minimum size. If larger than the minimum size, the HUD will expand to fit it's content, with a maximum size of its super view.*/
@property (nonatomic, assign) CGSize minimumSize;
/**Wether or not to dismiss automatically after an action is performed.*/
@property (nonatomic, assign) BOOL dismissAfterAction;
/**Wether or not the HUD is currenty visible.*/
- (BOOL)isVisible;
/**Wether or not the HUD will auto rotate to the device orientation.
 @note If set to `YES`, The HUD will rotate automatically to the device orientation, regardless of the interface orientation. This setting is suggested if the displayed view controller rotates and the HUD is displayed in a UIWindow. If the HUD is contained in a UIViewController. This setting should be set to NO, and the rotation should be set manually via the rotation property.
 */
@property (nonatomic, assign) BOOL shouldAutorotate;
/**The orientation of the HUD.*/
@property (nonatomic, assign) UIInterfaceOrientation orientation;

/**@name Actions*/
/**Set the progress of the `M13ProgressView`.
 @param progress The progress to show on the progress view.
 @param animated Wether or not to animate the progress change.*/
- (void)setProgress:(CGFloat)progress animated:(BOOL)animated;
/**Perform the given action if defined. Usually showing success or failure.
 @param action The action to perform.
 @param animated Wether or not to animate the change*/
- (void)performAction:(M13ProgressViewAction)action animated:(BOOL)animated;
/**Show the progress HUD.
 @param animated Wether or not to animate the change*/
- (void)show:(BOOL)animated;
/**Hide the progress HUD.
 @note This method should be used when the HUD is going to be reused. When the HUD needs to be shown again, use `show:` do not initalize another instance. That will cause a memory leak. If the HUD is not going to be reused, use `dismiss:` instead. To retreive a hidden HUD, either hold onto it with a global variable, or use the `progressHUD` method for UIView.
 @param animated Wether or not to animate the change*/
- (void)hide:(BOOL)animated;
/**Dismiss the progress HUD and remove it from its superview.
 @param animated Wether or not to animate the change*/
- (void)dismiss:(BOOL)animated;

@end

@interface UIView (M13ProgressHUD)

/*Retreive the topmost progress hud in the receiver view stack.*/
- (M13ProgressHUD *)progressHUD;

@end
