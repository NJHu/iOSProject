//
//  UINavigationController+M13ProgressViewBar.h
//  M13ProgressView
//
/*Copyright (c) 2013 Brandon McQuilkin
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import <UIKit/UIKit.h>

/**A UINavagationController category that adds a progress view to the UINavigationBar.*/
@interface UINavigationController (M13ProgressViewBar)

/**@name Actions*/

/**Show the progress bar.*/
- (void)showProgress;
/**Set the progress to display on the progress bar.
 @param progress The progress to display as a percentage from 0-1.
 @param animated Wether or not to animate the change.*/
- (void)setProgress:(CGFloat)progress animated:(BOOL)animated;
/**Set the string to replace the UINavigationBar's title with while showing progress. Send nil to reset the title.
 @param title The string to replace the UINavigationBar's title while showing progress.*/
- (void)setProgressTitle:(NSString *)title;
/**Set whether or not to show indeterminate.
 @param indeterminate wether or not the progress bar is indeterminate.*/
- (void)setIndeterminate:(BOOL)indeterminate;
/**Get whether or not to show indeterminate.*/
- (BOOL)getIndeterminate;
/**Fill the progress bar completely and remove it from display.*/
- (void)finishProgress;
/**Remove the progress bar from the display.*/
- (void)cancelProgress;
/**Wether or not the progress bar is showing.*/
- (BOOL)isShowingProgressBar;
/**
 The primary color of the progress bar if you do not want it to be the same as the UINavigationBar's tint color. If set to nil, the UINavigationBar's tint color will be used.
 
 @param primaryColor The color to set.
 */
- (void)setPrimaryColor:(UIColor *)primaryColor;
/**
 The secondary color of the progress bar, if nil, the secondary color will be the barTintColor.
 
 @param secondaryColor The color to set.
 */
- (void)setSecondaryColor:(UIColor *)secondaryColor;
/**
 The background color of the progress bar, if nil, the background color will be the clearColor.
 
 @param background The color to set.
 */
- (void)setBackgroundColor:(UIColor *)backgroundColor;

@end
