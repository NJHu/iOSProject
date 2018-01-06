//
//  M13ProgressView.h
//  M13ProgressView
//
/*Copyright (c) 2013 Brandon McQuilkin
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import <UIKit/UIKit.h>

typedef enum {
    /**Resets the action and returns the progress view to its normal state.*/
    M13ProgressViewActionNone,
    /**The progress view shows success.*/
    M13ProgressViewActionSuccess,
    /**The progress view shows failure.*/
    M13ProgressViewActionFailure
} M13ProgressViewAction;

/**A standardized base upon which to build progress views for applications. This allows one to use any subclass progress view in any component that use this standard.*/
@interface M13ProgressView : UIView

/**@name Appearance*/
/**The primary color of the `M13ProgressView`.*/
@property (nonatomic, retain) UIColor *primaryColor;
/**The secondary color of the `M13ProgressView`.*/
@property (nonatomic, retain) UIColor *secondaryColor;

/**@name Properties*/
/**Wether or not the progress view is indeterminate.*/
@property (nonatomic, assign) BOOL indeterminate;
/**The durations of animations in seconds.*/
@property (nonatomic, assign) CGFloat animationDuration;
/**The progress displayed to the user.*/
@property (nonatomic, readonly) CGFloat progress;

/**@name Actions*/
/**Set the progress of the `M13ProgressView`.
 @param progress The progress to show on the progress view.
 @param animated Wether or not to animate the progress change.*/
- (void)setProgress:(CGFloat)progress animated:(BOOL)animated;
/**Perform the given action if defined. Usually showing success or failure.
 @param action The action to perform.
 @param animated Wether or not to animate the change*/
- (void)performAction:(M13ProgressViewAction)action animated:(BOOL)animated;

@end
