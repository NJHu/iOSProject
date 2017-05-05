//
//  M13ProgressViewImage.m
//  M13ProgressView
//
/*Copyright (c) 2013 Brandon McQuilkin
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import "M13ProgressViewImage.h"

@interface M13ProgressViewImage ()

/**The start progress for the progress animation.*/
@property (nonatomic, assign) CGFloat animationFromValue;
/**The end progress for the progress animation.*/
@property (nonatomic, assign) CGFloat animationToValue;
/**The start time interval for the animaiton.*/
@property (nonatomic, assign) CFTimeInterval animationStartTime;
/**Link to the display to keep animations in sync.*/
@property (nonatomic, strong) CADisplayLink *displayLink;
/**Allow us to write to the progress.*/
@property (nonatomic, readwrite) CGFloat progress;
/**The UIImageView that shows the progress image.*/
@property (nonatomic, retain) UIImageView *progressView;

@end

@implementation M13ProgressViewImage

@dynamic progress;

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
    _progressDirection = M13ProgressViewImageProgressDirectionLeftToRight;
    _drawGreyscaleBackground = YES;
    
    //Set the progress view
    _progressView = [[UIImageView alloc] init];
    _progressView.frame = self.bounds;
    _progressView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_progressView];
    
    //Layout
    [self layoutSubviews];
}

#pragma mark Appearance

- (void)setProgressDirection:(M13ProgressViewImageProgressDirection)progressDirection
{
    _progressDirection = progressDirection;
    [self setNeedsDisplay];
}

- (void)setDrawGreyscaleBackground:(BOOL)drawGreyscaleBackground
{
    _drawGreyscaleBackground = drawGreyscaleBackground;
    [self setNeedsDisplay];
}

- (void)setProgressImage:(UIImage *)progressImage
{
    _progressImage = progressImage;
    _progressView.image = _progressImage;
    [self setNeedsDisplay];
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
    [super drawRect:rect];
    
    [_progressView setImage:[self createImageForCurrentProgress]];
}

- (UIImage *)createImageForCurrentProgress
{
    const int ALPHA = 0;
    const int RED = 3;
    const int GREEN = 2;
    const int BLUE = 1;

    //Create image rectangle with current image width/height
    CGRect imageRect = CGRectMake(0, 0, _progressImage.size.width * _progressImage.scale, _progressImage.size.height * _progressImage.scale);
    
    int width = (int)imageRect.size.width;
    int height = (int)imageRect.size.height;
    
    //The pixels will be painted to this array
    uint32_t *pixels = (uint32_t *) malloc(width * height * sizeof(uint32_t));
    
    //Clear the pixels so any transparency is preserved
    memset(pixels, 0, width * height * sizeof(uint32_t));
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    //Create a context with RGBA pixels
    CGContextRef context = CGBitmapContextCreate(pixels, width, height, 8, width * sizeof(uint32_t), colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedLast);
    
    //Paint the bitmap to our context which will fill in the pixels array
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), _progressImage.CGImage);
    
    //Calculate the ranges to make greyscale or transparent.
    int xFrom = 0;
    int xTo = width;
    int yFrom = 0;
    int yTo = height;
    
    if (_progressDirection == M13ProgressViewImageProgressDirectionBottomToTop) {
        yTo = (int)(height * (1 - self.progress));
    } else if (_progressDirection == M13ProgressViewImageProgressDirectionTopToBottom) {
        yFrom = (int)(height * self.progress);
    } else if (_progressDirection == M13ProgressViewImageProgressDirectionLeftToRight) {
        xFrom = (int)(width * self.progress);
    } else if (_progressDirection == M13ProgressViewImageProgressDirectionRightToLeft) {
        xTo = (int)(width * (1 - self.progress));
    }
    
    for (int x = xFrom; x < xTo; x++) {
        for (int y = yFrom; y < yTo; y++) {
            //Get the pixel
            uint8_t *rgbaPixel = (uint8_t *) &pixels[y * width + x];
            //Convert
            if (_drawGreyscaleBackground) {
                //Convert to grayscale using luma coding: http://en.wikipedia.org/wiki/Grayscale#Converting_color_to_grayscale
                uint8_t gray = (uint8_t)(0.3 * rgbaPixel[RED] + 0.59 * rgbaPixel[GREEN] + 0.11 * rgbaPixel[BLUE]);
                // set the pixels to gray
                rgbaPixel[RED] = gray;
                rgbaPixel[GREEN] = gray;
                rgbaPixel[BLUE] = gray;
            } else {
                //Convert the pixels to transparant
                rgbaPixel[RED] = 0;
                rgbaPixel[GREEN] = 0;
                rgbaPixel[BLUE] = 0;
                rgbaPixel[ALPHA] = 0;
            }
        }
    }
    
    // create a new CGImageRef from our context with the modified pixels
    CGImageRef image = CGBitmapContextCreateImage(context);
    
    // we're done with the context, color space, and pixels
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    free(pixels);
    
    // make a new UIImage to return
    UIImage *resultUIImage = [UIImage imageWithCGImage:image scale:_progressImage.scale orientation:UIImageOrientationUp];
    
    // we're done with image now too
    CGImageRelease(image);
    
    return resultUIImage;
}

@end
