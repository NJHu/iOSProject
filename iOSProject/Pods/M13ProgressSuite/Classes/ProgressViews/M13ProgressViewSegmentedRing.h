//
//  M13ProgressVewSegmentedRing.h
//  M13ProgressView
//
/*Copyright (c) 2013 Brandon McQuilkin
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

typedef enum {
    M13ProgressViewSegmentedRingSegmentBoundaryTypeWedge,
    M13ProgressViewSegmentedRingSegmentBoundaryTypeRectangle
} M13ProgressViewSegmentedRingSegmentBoundaryType;

#import "M13ProgressView.h"

/**Progress is shown by a ring split up into segments.*/
@interface M13ProgressViewSegmentedRing : M13ProgressView

/**@name Appearance*/
/**The width of the progress ring in points.*/
@property (nonatomic, assign) CGFloat progressRingWidth;
/**The number of segments to display in the progress view.*/
@property (nonatomic, assign) NSInteger numberOfSegments;
/**The angle of the separation between the segments in radians.*/
@property (nonatomic, assign) CGFloat segmentSeparationAngle;
/**The type of boundary between segments.*/
@property (nonatomic, assign) M13ProgressViewSegmentedRingSegmentBoundaryType segmentBoundaryType;
/**@name Percentage*/
/**Wether or not to display a percentage inside the ring.*/
@property (nonatomic, assign) BOOL showPercentage;


@end
