//
//  M13ProgressViewFilteredImage.m
//  M13ProgressView
//
/*Copyright (c) 2013 Brandon McQuilkin
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import "M13ProgressViewFilteredImage.h"

@interface M13ProgressViewFilteredImage ()

/**The start progress for the progress animation.*/
@property (nonatomic, assign) CGFloat animationFromValue;
/**The end progress for the progress animation.*/
@property (nonatomic, assign) CGFloat animationToValue;
/**The start time interval for the animaiton.*/
@property (nonatomic, assign) CFTimeInterval animationStartTime;
/**Link to the display to keep animations in sync.*/
@property (nonatomic, strong) CADisplayLink *displayLink;

@end

@implementation M13ProgressViewFilteredImage

#pragma mark Initalization and setup

- (id)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    //Set own background color
    self.backgroundColor = [UIColor clearColor];
    
    //Set defauts
    self.animationDuration = .3;
    
    //Set up the progress view
    _progressView = [[UIImageView alloc] init];
    _progressView.contentMode = UIViewContentModeScaleAspectFit;
    _progressView.frame = self.bounds;
    [self addSubview:_progressView];
    
    //Layout
    [self layoutSubviews];
}

#pragma mark Appearance

- (void)setProgressImage:(UIImage *)progressImage
{
    _progressImage = progressImage;
    [_progressView setImage:_progressImage];
    [self setNeedsDisplay];
}

- (void)setFilters:(NSArray *)filters
{
    _filters = filters;
    [self setNeedsDisplay];
}

- (void)setFilterParameters:(NSArray *)filterParameters
{
    _filterParameters = filterParameters;
}

#pragma mark Actions

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated
{
    if (animated == NO) {
        if (_displayLink) {
            //Kill running animations
            [_displayLink invalidate];
            _displayLink = nil;
        }
        [super setProgress:progress animated:NO];
        [self setNeedsDisplay];
    } else {
        _animationStartTime = CACurrentMediaTime();
        _animationFromValue = self.progress;
        _animationToValue = progress;
        if (!_displayLink) {
            //Create and setup the display link
            [self.displayLink invalidate];
            self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(animateProgress:)];
            [self.displayLink addToRunLoop:NSRunLoop.mainRunLoop forMode:NSRunLoopCommonModes];
        } /*else {
           //Reuse the current display link
           }*/
    }
}

- (void)animateProgress:(CADisplayLink *)displayLink
{
    dispatch_async(dispatch_get_main_queue(), ^{
        CGFloat dt = (displayLink.timestamp - self.animationStartTime) / self.animationDuration;
        if (dt >= 1.0) {
            //Order is important! Otherwise concurrency will cause errors, because setProgress: will detect an animation in progress and try to stop it by itself. Once over one, set to actual progress amount. Animation is over.
            [self.displayLink invalidate];
            self.displayLink = nil;
            [super setProgress:self.animationToValue animated:NO];
            [self setNeedsDisplay];
            return;
        }
        
        //Set progress
        [super setProgress:self.animationFromValue + dt * (self.animationToValue - self.animationFromValue) animated:YES];
        [self setNeedsDisplay];
        
    });
}

- (void)performAction:(M13ProgressViewAction)action animated:(BOOL)animated
{
    //Do Nothing
}

- (void)setIndeterminate:(BOOL)indeterminate
{
    [super setIndeterminate:indeterminate];
    //Do Nothing
}

#pragma mark Layout

- (void)layoutSubviews
{
    [super layoutSubviews];
    _progressView.frame = self.bounds;
}

- (CGSize)intrinsicContentSize
{
    return CGSizeMake(UIViewNoIntrinsicMetric, UIViewNoIntrinsicMetric);
}

#pragma mark Drawing

- (void)drawRect:(CGRect)rect
{
    //Create the base CIImage
    CIImage *image = [CIImage imageWithCGImage:_progressImage.CGImage];
    //Change the values of the CIFilters before drawing
    for (int i = 0; i < _filters.count; i++) {
        CIFilter *filter = _filters[i];
        //For each filter
        NSDictionary *parameters = _filterParameters[i];
        //For each parameter
        for (NSString *parameterKey in parameters.allKeys) {
            //Retreive the values
            NSDictionary *parameterDict = parameters[parameterKey];
            CGFloat startValue = [parameterDict[kM13ProgressViewFilteredImageCIFilterStartValuesKey] floatValue];
            CGFloat endValue = [parameterDict[kM13ProgressViewFilteredImageCIFilterEndValuesKey] floatValue];
            //Calculate the current value
            CGFloat value = startValue + ((endValue - startValue) * self.progress);
            //Set the value
            [filter setValue:[NSNumber numberWithFloat:(float)value] forKey:parameterKey];
        }
        //Set the input image
        [filter setValue:image forKey:kCIInputImageKey];
        image = filter.outputImage;
    }
    //Set the image of the image view.
    [_progressView setImage:[UIImage imageWithCIImage:image]];
    
    [super drawRect:rect];
}

@end
