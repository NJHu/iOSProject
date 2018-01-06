//
//  M13ProgressViewSegmentedBar.h
//  M13ProgressView
//
/*Copyright (c) 2013 Brandon McQuilkin
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import "M13ProgressView.h"

typedef enum {
    M13ProgressViewSegmentedBarProgressDirectionLeftToRight,
    M13ProgressViewSegmentedBarProgressDirectionBottomToTop,
    M13ProgressViewSegmentedBarProgressDirectionRightToLeft,
    M13ProgressViewSegmentedBarProgressDirectionTopToBottom
} M13ProgressViewSegmentedBarProgressDirection;

typedef enum {
    M13ProgressViewSegmentedBarSegmentShapeRectangle,
    M13ProgressViewSegmentedBarSegmentShapeRoundedRect,
    M13ProgressViewSegmentedBarSegmentShapeCircle
} M13ProgressViewSegmentedBarSegmentShape;

/**A progress bar that shows progress with discrete values.*/
@interface M13ProgressViewSegmentedBar : M13ProgressView

/**@name Appearance*/
/**The direction of progress. (What direction the fill proceeds in.)*/
@property (nonatomic, assign) M13ProgressViewSegmentedBarProgressDirection progressDirection;
/**The shape of the segments.*/
@property (nonatomic, assign) M13ProgressViewSegmentedBarSegmentShape segmentShape;
/**The corner radius of the segment shape if the shape is set to M13ProgressViewSegmentedBarSegmentShapeRoundedRect.*/
@property (nonatomic, assign) CGFloat cornerRadius;
/**The number of segments to display in the progress view.*/
@property (nonatomic, assign) NSInteger numberOfSegments;
/**The separation between segments in points. Must be less than self.width / numberOfSegments.*/
@property (nonatomic, assign) CGFloat segmentSeparation;
/**@name Actions*/
/**The color the bar changes to for the success action.*/
@property (nonatomic, retain) UIColor *successColor;
/**The color the bar changes to for the failure action.*/
@property (nonatomic, retain) UIColor *failureColor;
/**The array of UIColors that the segments will be colored with. 
 @note Each index in the array coresponds to a single segment. If there are more indicies then segments, not all colors will be used. If there are less indicies than segments, the colors will be looped. If nil, then a solid fill will be used.*/
@property (nonatomic, retain) NSArray *primaryColors;
/**The array of UIColors that the segment's backgrounds will be colored with.
 @note Each index in the array coresponds to a single segment. If there are more indicies then segments, not all colors will be used. If there are less indicies than segments, the colors will be looped. If nil, then a solid fill will be used.*/
@property (nonatomic, retain) NSArray *secondaryColors;


@end
