//
//  M13ProgressViewFilteredImage.h
//  M13ProgressView
//
/*Copyright (c) 2013 Brandon McQuilkin
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import "M13ProgressView.h"
#import <CoreImage/CoreImage.h>

#define kM13ProgressViewFilteredImageCIFilterStartValuesKey @"StartValues"
#define kM13ProgressViewFilteredImageCIFilterEndValuesKey @"EndValues"

/**A progress view where progress is shown by changes in CIFilters.
 @note This progress bar does not have in indeterminate mode and does not respond to actions.*/
@interface M13ProgressViewFilteredImage : M13ProgressView

/**@name Appearance*/
/**The image to use when showing progress.*/
@property (nonatomic, retain) UIImage *progressImage;
/**The UIImageView that shows the progress image.*/
@property (nonatomic, retain) UIImageView *progressView;
/**The array of CIFilters to apply to the image.
 @note The filters need to be encased in a M13ProgressViewCIFilterWrapper*/
@property (nonatomic, retain) NSArray *filters;
/**The dictionaries of dictionaries that coresspond to filter properties to be changed.
    NSArray
        |------ NSDictionary (Index matches the coresponding CIFilter in filters)
        |               |---- "Parameter Key" -> NSDictionary
        |               |                               |------ "Start Value" -> NSNumber
        |               |                               |------ "End Value" -> NSNumber
        |               |---- "Parameter Key" -> NSDictionary
        |                                               |------ "Start Value" -> NSNumber
        |                                               |------ "End Value" -> NSNumber
        |------ NSDictionary ... */
@property (nonatomic, retain) NSArray *filterParameters;

@end
