//
//  M13ProgressViewHUD.m
//  M13ProgressView
//
/*Copyright (c) 2013 Brandon McQuilkin
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import "M13ProgressHUD.h"
#import "UIImage+ImageEffects.h"

@interface M13ProgressHUD ()

@property (nonatomic, readwrite) CGFloat progress;

@end

@implementation M13ProgressHUD
{
    UIView *backgroundView;
    UIView *maskView;
    UILabel *statusLabel;
    NSString *optimalStatusString;
    BOOL onScreen;
}

#pragma mark Initalization and Setup

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

- (id)initWithProgressView:(M13ProgressView *)progressView
{
    self = [self init];
    if (self) {
        _progressView = progressView;
        [self setup];
    }
    return self;
}

- (id)initAndShowWithProgressView:(M13ProgressView *)progressView progress:(CGFloat)progress indeterminate:(BOOL)indeterminate status:(NSString *)status mask:(M13ProgressHUDMaskType)maskType inView:(UIView *)view
{
    self = [super init];
    if (self) {
        _progressView = progressView;
        [self setup];
        self.progress = progress;
        self.indeterminate = indeterminate;
        self.status = status;
        self.maskType = maskType;
        [view addSubview:self];
        [self show:YES];
    }
    return self;
}

- (void)setup
{
    //Set the defaults for the progress view
    self.backgroundColor = [UIColor clearColor];
    self.layer.opacity = 0;
    _primaryColor = [UIColor colorWithRed:0 green:122/255.0 blue:1.0 alpha:1.0];
    _secondaryColor = [UIColor colorWithRed:181/255.0 green:182/255.0 blue:183/255.0 alpha:1.0];
    _progress = 0;
    _indeterminate = NO;
    _shouldAutorotate = YES;
    if (self.frame.size.height != 0 && self.frame.size.width != 0) {
        _progressViewSize = CGSizeMake(150 / 4, 150 / 4);
    }
    _animationDuration = .3;
    //Set the other defaults
    _applyBlurToBackground = NO;
    _statusPosition = M13ProgressHUDStatusPositionBelowProgress;
    _contentMargin = 20.0;
    _cornerRadius = 20.0;
    _maskType = M13ProgressHUDMaskTypeNone;
    _maskColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.5];
    _statusColor = [UIColor whiteColor];
    _statusFont = [UIFont systemFontOfSize:20.0];
    _minimumSize = CGSizeMake(150, 150);
    _dismissAfterAction = NO;
    _hudBackgroundColor = [UIColor colorWithWhite:0 alpha:.8];
    //Add the proper views
    maskView = [[UIView alloc] init];
    [self addSubview:maskView];
    backgroundView = [[UIView alloc] init];
    backgroundView.backgroundColor = _hudBackgroundColor;
    backgroundView.layer.cornerRadius = _cornerRadius;
    backgroundView.clipsToBounds = YES;
    [self addSubview:backgroundView];
    statusLabel = [[UILabel alloc] init];
    statusLabel.font = _statusFont;
    statusLabel.textColor = _statusColor;
    statusLabel.textAlignment = NSTextAlignmentCenter;
    statusLabel.contentMode = UIViewContentModeTop;
    statusLabel.lineBreakMode = NSLineBreakByWordWrapping;
    statusLabel.numberOfLines = 0;
    [backgroundView addSubview:statusLabel];
    if (_progressView != nil) {
        [backgroundView addSubview:_progressView];
    }
}

#pragma marks Properties

- (void)setProgressView:(M13ProgressView *)progressView
{
    if (_progressView) {
        [_progressView removeFromSuperview];
    }
    [backgroundView addSubview:progressView];
    [self setNeedsLayout];
}

- (void)setPrimaryColor:(UIColor *)primaryColor
{
    _primaryColor = primaryColor;
    _progressView.primaryColor = _primaryColor;
}

- (void)setSecondaryColor:(UIColor *)secondaryColor
{
    _secondaryColor = secondaryColor;
    _progressView.secondaryColor = _secondaryColor;
}

- (void)setApplyBlurToBackground:(BOOL)applyBlurToBackground
{
    _applyBlurToBackground = applyBlurToBackground;
    //Only needs to be redrawn if visible
    if ([self isVisible]) {
        [self drawBackground];
    }
}

- (void)setStatusPosition:(M13ProgressHUDStatusPosition)statusPosition
{
    _statusPosition = statusPosition;
    [self setNeedsLayout];
}

- (void)setOffsetFromCenter:(UIOffset)offsetFromCenter
{
    _offsetFromCenter = offsetFromCenter;
    [self setNeedsLayout];
}

- (void)setContentMargin:(CGFloat)contentMargin
{
    _contentMargin = contentMargin;
    [self setNeedsLayout];
}

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    _cornerRadius = cornerRadius;
    backgroundView.layer.cornerRadius = cornerRadius;
}

- (void)setMaskType:(M13ProgressHUDMaskType)maskType
{
    _maskType = maskType;
    [self drawMask];
}

- (void)setMaskColor:(UIColor *)maskColor
{
    _maskColor = maskColor;
    [self drawMask];
}

- (void)setStatusColor:(UIColor *)statusColor
{
    _statusColor = statusColor;
    statusLabel.textColor = _statusColor;
}

- (void)setStatusFont:(UIFont *)statusFont
{
    _statusFont = statusFont;
    statusLabel.font = _statusFont;
    [self layoutSubviews];
}

- (void)setAnimationDuration:(CGFloat)animationDuration
{
    _animationDuration = animationDuration;
    _progressView.animationDuration = _animationDuration;
}

- (void)setStatus:(NSString *)status
{
    _status = status;
    if (_status.length == 0 || _status == nil) {
        //Clear the optimal string
        optimalStatusString = nil;
    } else {
        [self recalculateOptimalStatusStringStructure];
    }
    [self layoutHUD];
}

- (void)setMinimumSize:(CGSize)minimumSize
{
    _minimumSize = minimumSize;
    [self recalculateOptimalStatusStringStructure];
    [self setNeedsLayout];
}

- (void)setDismissAfterAction:(BOOL)dismissAfterAction
{
    _dismissAfterAction = dismissAfterAction;
}

- (void)setHudBackgroundColor:(UIColor *)hudBackgroundColor
{
    _hudBackgroundColor = hudBackgroundColor;
    if ([self isVisible]) {
        [self drawBackground];
    }
}

- (BOOL)isVisible
{
    if (self.alpha == 1) {
        return YES;
    } else {
        return NO;
    }
}

- (void)didMoveToSuperview
{
    if (_maskType == M13ProgressHUDMaskTypeIOS7Blur || _applyBlurToBackground) {\
        [self setNeedsLayout];
        [self redrawBlurs];
    }
}

- (void)didMoveToWindow
{
    if (_maskType == M13ProgressHUDMaskTypeIOS7Blur || _applyBlurToBackground) {
        [self setNeedsLayout];
        [self redrawBlurs];
    }
}

#pragma mark Actions

- (void)setIndeterminate:(BOOL)indeterminate
{
    _indeterminate = indeterminate;
    _progressView.indeterminate = _indeterminate;
}

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated
{
    [_progressView setProgress:progress animated:animated];
	self.progress = progress;
}

- (void)performAction:(M13ProgressViewAction)action animated:(BOOL)animated
{
    [_progressView performAction:action animated:animated];
}

- (void)show:(BOOL)animated
{
    //reset the blurs to the curent screen if need be
    [self registerForNotificationCenter];
    [self setNeedsLayout];
    [self setNeedsDisplay];
    
    onScreen = YES;
    
    //Animate the HUD on screen
    CABasicAnimation *fadeAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeAnimation.duration = _animationDuration;
    fadeAnimation.fromValue = [NSNumber numberWithFloat:0.0];
    fadeAnimation.toValue = [NSNumber numberWithFloat:1.0];
    fadeAnimation.removedOnCompletion = YES;
    
    [self.layer addAnimation:fadeAnimation forKey:@"fadeAnimation"];
    self.layer.opacity = 1.0;
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.duration = _animationDuration;
    scaleAnimation.fromValue = [NSNumber numberWithFloat:0.0];
    scaleAnimation.toValue = [NSNumber numberWithFloat:1.0];
    scaleAnimation.removedOnCompletion = YES;
    
    CABasicAnimation *positionAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    positionAnimation.duration = _animationDuration;
    
    if (_animationCentered)
    {
        positionAnimation.fromValue = [NSValue valueWithCGPoint:backgroundView.layer.position];
    }
    else
    {
        positionAnimation.fromValue = [NSValue valueWithCGPoint:_animationPoint];
    }
    
    positionAnimation.toValue = [NSValue valueWithCGPoint:backgroundView.layer.position];
    positionAnimation.removedOnCompletion = YES;
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = @[scaleAnimation, positionAnimation];
    animationGroup.duration = _animationDuration;
    animationGroup.removedOnCompletion = YES;
    [backgroundView.layer addAnimation:animationGroup forKey:nil];
}

- (void)hide:(BOOL)animated
{
    [self unregisterFromNotificationCenter];
    
    onScreen = NO;
    
    CABasicAnimation *fadeAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    fadeAnimation.toValue = [NSNumber numberWithFloat:0.0];
    fadeAnimation.removedOnCompletion = YES;
    
    [self.layer addAnimation:fadeAnimation forKey:@"fadeAnimation"];
    self.layer.opacity = 0.0;
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    scaleAnimation.toValue = [NSNumber numberWithFloat:0.0];
    scaleAnimation.removedOnCompletion = YES;
    
    CABasicAnimation *frameAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    
    if (_animationCentered)
    {
        frameAnimation.toValue = [NSValue valueWithCGPoint:backgroundView.layer.position];
    }
    else
    {
        frameAnimation.toValue = [NSValue valueWithCGPoint:_animationPoint];
    }
    
    frameAnimation.removedOnCompletion = YES;
    
    if (!_animationCentered)
    {
        backgroundView.layer.position = _animationPoint;
    }
    backgroundView.layer.position = _animationPoint;
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = @[scaleAnimation, frameAnimation];
    animationGroup.duration = _animationDuration;
    animationGroup.removedOnCompletion = YES;
    [backgroundView.layer addAnimation:animationGroup forKey:nil];
}

- (void)dismiss:(BOOL)animated
{
    [self hide:animated];
    
    //Removes the HUD from the superview, dismissing it.
    [self performSelector:@selector(removeFromSuperview) withObject:Nil afterDelay:_animationDuration];
}

#pragma mark - Notifications

- (void)registerForNotificationCenter {
    NSNotificationCenter *center = NSNotificationCenter.defaultCenter;
    [center addObserver:self selector:@selector(deviceOrientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)unregisterFromNotificationCenter {
    NSNotificationCenter *center = NSNotificationCenter.defaultCenter;
    [center removeObserver:self];
}

- (void)deviceOrientationDidChange:(NSNotification *)notification {
    UIDeviceOrientation deviceOrientation = [notification.object orientation];
    
    if (_shouldAutorotate && UIDeviceOrientationIsValidInterfaceOrientation(deviceOrientation)) {
        if (UIDeviceOrientationIsPortrait(deviceOrientation)) {
            if (deviceOrientation == UIDeviceOrientationPortraitUpsideDown) {
                _orientation = UIInterfaceOrientationPortraitUpsideDown;
            } else {
                _orientation = UIInterfaceOrientationPortrait;
            }
        } else {
            if (deviceOrientation == UIDeviceOrientationLandscapeLeft) {
                _orientation = UIInterfaceOrientationLandscapeLeft;
            } else {
                _orientation = UIInterfaceOrientationLandscapeRight;
            }
        }
        [self layoutHUD];
    }
}

#pragma mark Layout

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    self.frame = CGRectMake(0, 0, newSuperview.frame.size.width, newSuperview.frame.size.height);
    [self layoutSubviews];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self layoutHUD];
}

- (void)layoutHUD
{
    //Setup the background rect
    CGRect backgroundRect = CGRectZero;
    //Setup the label rect
    CGRect statusRect = [optimalStatusString boundingRectWithSize:[UIScreen mainScreen].bounds.size options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName : statusLabel.font} context:nil];
    //Setup the progress rect
    CGRect progressRect = CGRectMake(0, 0, _progressViewSize.width, _progressViewSize.height);
    
    //Calculate the rects as per positioning
    if (optimalStatusString.length != 0 && optimalStatusString != nil) {
        if (_statusPosition == M13ProgressHUDStatusPositionBelowProgress) {
            //Calculate background height
            CGFloat backgroundRectBaseHeight = _progressViewSize.height + _contentMargin * 3;
            backgroundRect.size.height = backgroundRectBaseHeight + statusRect.size.height;
            if (backgroundRect.size.height < _minimumSize.height) {
                backgroundRect.size.height = _minimumSize.height;
            }
            //Calculate background width
            backgroundRect.size.width = (statusRect.size.width > _progressViewSize.width) ? statusRect.size.width : _progressViewSize.width;
            backgroundRect.size.width += 2 * _contentMargin;
            if (backgroundRect.size.width < _minimumSize.width) {
                backgroundRect.size.width = _minimumSize.width;
            }
            //Calculate background origin (Calculated to keep the progress bar in the same position on the screen during frame changes.)
            backgroundRect.origin.x = (self.bounds.size.width / 2.0) - (backgroundRect.size.width / 2.0);
            backgroundRect.origin.y = (self.bounds.size.height / 2.0) - (backgroundRectBaseHeight / 2.0);
            //Calculate the progress view rect
            progressRect.origin.x = (backgroundRect.size.width / 2.0) - (progressRect.size.width / 2.0);
            progressRect.origin.y = _contentMargin;
            //Calculate the label rect
            statusRect.origin.x = (backgroundRect.size.width / 2.0) - (statusRect.size.width / 2.0);
            statusRect.origin.y = progressRect.origin.y + progressRect.size.height + _contentMargin;
            
        } else if (_statusPosition == M13ProgressHUDStatusPositionAboveProgress) {
            //Calculate background height
            backgroundRect.size.height = _contentMargin + _progressViewSize.height + _contentMargin + statusRect.size.height + _contentMargin;
            if (backgroundRect.size.height < _minimumSize.height) {
                backgroundRect.size.height = _minimumSize.height;
            }
            //Calculate background width
            backgroundRect.size.width = (statusRect.size.width > _progressViewSize.width) ? statusRect.size.width : _progressViewSize.width;
            backgroundRect.size.width += 2 * _contentMargin;
            if (backgroundRect.size.width < _minimumSize.width) {
                backgroundRect.size.width = _minimumSize.width;
            }
            //Calculate background origin (Calculated to keep the progress bar in the same position on the screen during frame changes.)
            backgroundRect.origin.x = (self.bounds.size.width / 2.0) - (backgroundRect.size.width / 2.0);
            backgroundRect.origin.y = (self.bounds.size.height / 2.0) - (_minimumSize.height / 2.0);
            //Calculate the label rect
            statusRect.origin.x = (backgroundRect.size.width / 2.0) - (statusRect.size.width / 2.0);
            statusRect.origin.y = _contentMargin;
            //Calculate the progress view rect
            progressRect.origin.x = (backgroundRect.size.width / 2.0) - (progressRect.size.width / 2.0);
            progressRect.origin.y = statusRect.origin.y + statusRect.size.height + _contentMargin;
            
        } else if (_statusPosition == M13ProgressHUDStatusPositionLeftOfProgress) {
            //Calculate background height
            backgroundRect.size.height = (statusRect.size.height > progressRect.size.height) ? statusRect.size.height : progressRect.size.height;
            backgroundRect.size.height += 2 * _contentMargin;
            if (backgroundRect.size.height < _minimumSize.height) {
                backgroundRect.size.height = _minimumSize.height;
            }
            //Calculate background width
            backgroundRect.size.width = _contentMargin + statusRect.size.width + _contentMargin + progressRect.size.width + _contentMargin;
            if (backgroundRect.size.width < _minimumSize.width) {
                backgroundRect.size.width = _minimumSize.width;
            }
            //Calculate background origin (Calculated to keep the progress bar in the same position on the screen during frame changes.)
            backgroundRect.origin.x = (self.bounds.size.width / 2.0) - (backgroundRect.size.width / 2.0);
            backgroundRect.origin.y = (self.bounds.size.height / 2.0) - (_minimumSize.height / 2.0);
            //Calculate the label rect
            statusRect.origin.x = _contentMargin;
            statusRect.origin.y = (backgroundRect.size.height / 2.0) - (statusRect.size.height / 2.0);
            //Calculate the progress view rect
            progressRect.origin.x = statusRect.origin.x + statusRect.size.width + _contentMargin;
            progressRect.origin.y = (backgroundRect.size.height / 2.0) - (progressRect.size.height / 2.0);
            
        } else if (_statusPosition == M13ProgressHUDStatusPositionRightOfProgress) {
            //Calculate background height
            backgroundRect.size.height = (statusRect.size.height > progressRect.size.height) ? statusRect.size.height : progressRect.size.height;
            backgroundRect.size.height += 2 * _contentMargin;
            if (backgroundRect.size.height < _minimumSize.height) {
                backgroundRect.size.height = _minimumSize.height;
            }
            //Calculate background width
            backgroundRect.size.width = _contentMargin + statusRect.size.width + _contentMargin + progressRect.size.width + _contentMargin;
            if (backgroundRect.size.width < _minimumSize.width) {
                backgroundRect.size.width = _minimumSize.width;
            }
            //Calculate background origin (Calculated to keep the progress bar in the same position on the screen during frame changes.)
            backgroundRect.origin.x = (self.bounds.size.width / 2.0) - (backgroundRect.size.width / 2.0);
            backgroundRect.origin.y = (self.bounds.size.height / 2.0) - (_minimumSize.height / 2.0);
            //Calculate the progress view rect
            progressRect.origin.x = _contentMargin;
            progressRect.origin.y = (backgroundRect.size.height / 2.0) - (progressRect.size.height / 2.0);
            //Calculate the label rect
            statusRect.origin.x = progressRect.origin.x + progressRect.size.width + _contentMargin;
            statusRect.origin.y = (backgroundRect.size.height / 2.0) - (statusRect.size.height / 2.0);
        }
    } else {
        //Calculate background height
        backgroundRect.size.height = (statusRect.size.height > progressRect.size.height) ? statusRect.size.height : progressRect.size.height;
        backgroundRect.size.height += 2 * _contentMargin;
        if (backgroundRect.size.height < _minimumSize.height) {
            backgroundRect.size.height = _minimumSize.height;
        }
        
        //Calculate background width
        backgroundRect.size.width = (statusRect.size.width > _progressViewSize.width) ? statusRect.size.width : _progressViewSize.width;
        backgroundRect.size.width += 2 * _contentMargin;
        if (backgroundRect.size.width < _minimumSize.width) {
            backgroundRect.size.width = _minimumSize.width;
        }
        
        backgroundRect.origin.x = (self.bounds.size.width / 2.0) - (backgroundRect.size.width / 2.0);
        backgroundRect.origin.y = (self.bounds.size.height / 2.0) - (_minimumSize.height / 2.0);
        
        //There is no status label text, center the progress view
        progressRect.origin.x = (backgroundRect.size.width / 2.0) - (progressRect.size.width / 2.0);
        progressRect.origin.y = (backgroundRect.size.height / 2.0) - (progressRect.size.height / 2.0);
        statusRect.size.width = 0.0;
        statusRect.size.height = 0.0;
    }
    
    //Swap height and with on rotation
    if (_orientation == UIInterfaceOrientationLandscapeLeft || _orientation == UIInterfaceOrientationLandscapeRight) {
        //Flip the width and height.
        CGFloat temp = backgroundRect.size.width;
        backgroundRect.size.width = backgroundRect.size.height;
        backgroundRect.size.height = temp;
    }
    
    if (onScreen) {
        //Set the frame of the background and its subviews
        [UIView animateWithDuration:_animationDuration animations:^{
            self->backgroundView.frame = CGRectIntegral(backgroundRect);
            self.progressView.frame = CGRectIntegral(progressRect);
            self->backgroundView.transform = CGAffineTransformMakeRotation([self angleForDeviceOrientation]);
            //Fade the label
            self->statusLabel.alpha = 0.0;
        } completion:^(BOOL finished) {
            if (finished) {
                //Set the label frame
                self->statusLabel.frame = CGRectIntegral(statusRect);
                self->statusLabel.text = self->optimalStatusString;
                [UIView animateWithDuration:self.animationDuration animations:^{
                    //Show the label
                    self->statusLabel.alpha = 1.0;
                }];
            }
        }];
    } else {
        backgroundView.frame = CGRectIntegral(backgroundRect);
        _progressView.frame = CGRectIntegral(progressRect);
        backgroundView.transform = CGAffineTransformMakeRotation([self angleForDeviceOrientation]);
        //Fade the label
        statusLabel.alpha = 0.0;
    }
    
    
}

- (void)recalculateOptimalStatusStringStructure
{
    if ([_status rangeOfString:@" "].location == NSNotFound || [_status rangeOfString:@"\n"].location != NSNotFound) {
        //One word, just pass the string as is.
        //Or has line breaks, so follow them.
        optimalStatusString = [_status copy];
    } else if ([_status rangeOfString:@" "].location != NSNotFound && [_status rangeOfString:@"\n"].location == NSNotFound) {
        //There are spaces, but no line breaks. Insert line breaks as needed.
        //Break the status into indivual words
        NSArray *wordsArray = [_status componentsSeparatedByString:@" "];
        //Calculate the mean width and standard deviation to use as parameters for where line breaks should go.
        float meanWidth = 0.0;
        float standardDeviation = 0.0;
        NSMutableArray *sizesArray = [NSMutableArray array];
        //Calculate size of each word
        for (NSString *word in wordsArray) {
            CGRect wordRect = [word boundingRectWithSize:[UIScreen mainScreen].bounds.size options:(NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName : statusLabel.font} context:nil];
            [sizesArray addObject:NSStringFromCGRect(wordRect)];
            //Sum the widths to calculate the mean width
            meanWidth += wordRect.size.width;
        }
        //Finish the mean size and standard deviation calculations
        meanWidth = roundf(meanWidth / wordsArray.count);
        //Calculate the standard deviation
        for (NSString *rect in sizesArray) {
            CGRect theRect = CGRectFromString(rect);
            //Sum the widths to calculate the mean width
            standardDeviation += exp2f((float)theRect.size.width - meanWidth);
        }
        standardDeviation = sqrtf(standardDeviation / wordsArray.count);
        //Correct the mean width if it is below the minimum size
        if (meanWidth < self.minimumSize.width) {
            meanWidth = (float)self.minimumSize.width;
        }
        
        //Now calculate where to put line breaks. Lines can exceed the minimum width, but cannot exceed the minimum width plus the standard deviation. Single words can excced these limits.
        NSMutableString *correctedString = [[NSMutableString alloc] initWithString:wordsArray[0]];
        float lineSize = (float)CGRectFromString(sizesArray[0]).size.width;
        for (int i = 1; i < wordsArray.count; i++) {
            NSString *word = wordsArray[i];
            CGRect wordRect = CGRectFromString(sizesArray[i]);
            if (lineSize + wordRect.size.width > meanWidth + standardDeviation) {
                //If the max width is exceeded, add a new line
                [correctedString appendFormat:@"\n"];
            } else {
                //append a space before the new word
                [correctedString appendFormat:@" "];
            }
            //Append the string
            [correctedString appendString:word];
        }
        //Set the optimal string
        optimalStatusString = correctedString;
    }
}

#pragma mark Drawing

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    [self drawMask];
    [self drawBackground];
}

- (void)drawBackground
{
    //Set the proper color
    if (_applyBlurToBackground == NO) {
        backgroundView.backgroundColor = _hudBackgroundColor;
    } else {
        //Redraw the hud blur
        [self redrawBlurs];
    }
}

- (void)drawMask
{
    maskView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    if (_maskType == M13ProgressHUDMaskTypeNone) {
        maskView.backgroundColor = [UIColor clearColor];
    } else if (_maskType == M13ProgressHUDMaskTypeSolidColor) {
        maskView.backgroundColor = _maskColor;
    } else if (_maskType == M13ProgressHUDMaskTypeGradient) {
        //Get the components of color of the maskColor
        CGFloat red;
        CGFloat green;
        CGFloat blue;
        CGFloat alpha;
        [_maskColor getRed:&red green:&green blue:&blue alpha:&alpha];
        //Create the gradient as an image, and then set it as the color of the mask view.
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [UIScreen mainScreen].scale);
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        if (!context) {
            return;
        }
        
        //Create the gradient
        size_t locationsCount = 2;
        CGFloat locations[2] = {0.0f, 1.0f};
        CGFloat colors[8] = {0.0f, 0.0f, 0.0f, 0.0f, red, green, blue, alpha};
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, colors, locations, locationsCount);
        CGColorSpaceRelease(colorSpace);
        //Draw the gradient
        CGPoint center = CGPointMake(self.bounds.size.width / 2.0, self.bounds.size.height / 2.0);
        float radius = (float)MIN(self.bounds.size.width , self.bounds.size.height) ;
        CGContextDrawRadialGradient (context, gradient, center, 0, center, radius, kCGGradientDrawsAfterEndLocation);
        CGGradientRelease(gradient);
        //Get the gradient image
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        //Set the background
        maskView.backgroundColor = [UIColor colorWithPatternImage:image];
        
    } else if (_maskType == M13ProgressHUDMaskTypeIOS7Blur) {
        // do nothing; we don't want to take a snapshot of the background for blurring now, no idea what the background is
    }
}

- (void)redrawBlurs
{
    if (_maskType == M13ProgressHUDMaskTypeIOS7Blur) {
        //Get the snapshot of the mask
        __block UIImage *image = [self snapshotForBlurredBackgroundInView:maskView];
        if (image != nil) {
            //Apply the filters to blur the image
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                image = [image applyLightEffect];
                dispatch_async(dispatch_get_main_queue(), ^{
                    // Fade on content's change, if there was already an image.
                    CATransition *transition = [CATransition new];
                    transition.duration = 0.3;
                    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                    transition.type = kCATransitionFade;
                    [self->maskView.layer addAnimation:transition forKey:nil];
                    self->maskView.backgroundColor = [UIColor colorWithPatternImage:image];
                });
            });
        }
    }
    if (_applyBlurToBackground) {
        //Get the snapshot of the mask
        __block UIImage *image = [self snapshotForBlurredBackgroundInView:backgroundView];
        if (image != nil) {
            //Apply the filters to blur the image
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                //image = [image applyLightEffect];
                image = [image applyLightEffect];
                dispatch_async(dispatch_get_main_queue(), ^{
                    // Fade on content's change, if there was already an image.
                    CATransition *transition = [CATransition new];
                    transition.duration = 0.3;
                    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                    transition.type = kCATransitionFade;
                    [self->backgroundView.layer addAnimation:transition forKey:nil];
                    self->backgroundView.backgroundColor = [UIColor colorWithPatternImage:image];
                });
            });
        }
    }
}

- (UIImage *)snapshotForBlurredBackgroundInView:(UIView *)view
{
    //Translate the view's rect to the superview's rect
    CGRect viewRect = view.bounds;
    viewRect = [view convertRect:viewRect toView:self.superview];
    
    //Hide self if visible
    BOOL previousViewState = self.hidden;
    self.hidden = YES;
    
    //Create a snapshot of the superview
    UIView *snapshotView = [self.superview resizableSnapshotViewFromRect:viewRect afterScreenUpdates:YES withCapInsets:UIEdgeInsetsZero];
    //Draw the snapshot view into a UIImage
    UIGraphicsBeginImageContextWithOptions(snapshotView.bounds.size, YES, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (!context) {
        return nil;
    }
    CGContextTranslateCTM(context, viewRect.origin.x, viewRect.origin.y);
    BOOL result = [self.superview drawViewHierarchyInRect:viewRect afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //Return self to the previous state
    self.hidden = previousViewState;
    
    if (result) {
        return image;
    } else {
        return nil;
    }
}

- (CGFloat)angleForDeviceOrientation
{
    if (_orientation == UIInterfaceOrientationLandscapeLeft) {
        return M_PI_2;
    } else if (_orientation == UIInterfaceOrientationLandscapeRight) {
        return -M_PI_2;
    } else if (_orientation == UIInterfaceOrientationPortraitUpsideDown) {
        return M_PI;
    }
    return 0;
}

@end

@implementation UIView (M13ProgressHUD)

- (M13ProgressHUD *)progressHUD
{
    for (id view in self.subviews) {
        //If the subview is a progress HUD return it.
        if ([[view class] isSubclassOfClass:[M13ProgressHUD class]]) {
            return view;
        }
    }
    return nil;
}

@end
