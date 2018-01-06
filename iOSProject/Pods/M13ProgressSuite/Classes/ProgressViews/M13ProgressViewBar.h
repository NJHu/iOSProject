//
//  M13ProgressViewBar.h
//  M13ProgressView
//
/*Copyright (c) 2013 Brandon McQuilkin
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import "M13ProgressView.h"

typedef enum {
    M13ProgressViewBarPercentagePositionLeft,
    M13ProgressViewBarPercentagePositionRight,
    M13ProgressViewBarPercentagePositionTop,
    M13ProgressViewBarPercentagePositionBottom,
} M13ProgressViewBarPercentagePosition;

typedef enum {
    M13ProgressViewBarProgressDirectionLeftToRight,
    M13ProgressViewBarProgressDirectionBottomToTop,
    M13ProgressViewBarProgressDirectionRightToLeft,
    M13ProgressViewBarProgressDirectionTopToBottom
} M13ProgressViewBarProgressDirection;

/**A replacement for UIProgressBar.*/
@interface M13ProgressViewBar : M13ProgressView

/**@name Appearance*/
/**The direction of progress. (What direction the fill proceeds in.)*/
@property (nonatomic, assign) M13ProgressViewBarProgressDirection progressDirection;
/**The thickness of the progress bar.*/
@property (nonatomic, assign) CGFloat progressBarThickness;
/**The corner radius of the progress bar.*/
@property (nonatomic, assign) CGFloat progressBarCornerRadius;
/**@name Actions*/
/**The color the bar changes to for the success action.*/
@property (nonatomic, retain) UIColor *successColor;
/**The color the bar changes to for the failure action.*/
@property (nonatomic, retain) UIColor *failureColor;
/**@name Percentage*/
/**Wether or not to show percentage text. If shown exterior to the progress bar, the progress bar is shifted to make room for the text.*/
@property (nonatomic, assign) BOOL showPercentage;
/**The location of the percentage in comparison to the progress bar.*/
@property (nonatomic, assign) M13ProgressViewBarPercentagePosition percentagePosition;

@end
