//
//  M13ProgressViewImage.h
//  M13ProgressView
//
/*Copyright (c) 2013 Brandon McQuilkin
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import "M13ProgressView.h"

typedef enum {
    M13ProgressViewImageProgressDirectionLeftToRight,
    M13ProgressViewImageProgressDirectionBottomToTop,
    M13ProgressViewImageProgressDirectionRightToLeft,
    M13ProgressViewImageProgressDirectionTopToBottom
} M13ProgressViewImageProgressDirection;

/**A progress bar where progress is shown by cutting an image.
 @note This progress bar does not have in indeterminate mode and does not respond to actions.*/
@interface M13ProgressViewImage : M13ProgressView

/**@name Appearance*/
/**The image to use when showing progress.*/
@property (nonatomic, retain) UIImage *progressImage;
/**The direction of progress. (What direction the fill proceeds in.)*/
@property (nonatomic, assign) M13ProgressViewImageProgressDirection progressDirection;
/**Wether or not to draw the greyscale background.*/
@property (nonatomic, assign) BOOL drawGreyscaleBackground;

@end
