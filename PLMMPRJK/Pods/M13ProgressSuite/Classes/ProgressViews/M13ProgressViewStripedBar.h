//
//  M13ProgressViewStripedBar.h
//  M13ProgressView
//
/*Copyright (c) 2013 Brandon McQuilkin
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import "M13ProgressView.h"

typedef enum {
    M13ProgressViewStripedBarCornerTypeSquare,
    M13ProgressViewStripedBarCornerTypeRounded,
    M13ProgressViewStripedBarCornerTypeCircle
} M13ProgressViewStripedBarCornerType;

/**A progress bar that is striped, and can animate the stripes if desired.*/
@interface M13ProgressViewStripedBar : M13ProgressView

/**@name Appearance*/
/**The type of corner to display on the bar.*/
@property (nonatomic, assign) M13ProgressViewStripedBarCornerType cornerType;
/**The radius of the corner if the corner type is set to rounded rect.*/
@property (nonatomic, assign) CGFloat cornerRadius;
/**The width of the stripes if shown.*/
@property (nonatomic, assign) CGFloat stripeWidth;
/**Wether or not the stripes are animated.*/
@property (nonatomic, assign) BOOL animateStripes;
/**Wether or not to show the stripes.*/
@property (nonatomic, assign) BOOL showStripes;
/**The color of the stripes.*/
@property (nonatomic, retain) UIColor *stripeColor;
/**The width of the border.*/
@property (nonatomic, assign) CGFloat borderWidth;

@end
