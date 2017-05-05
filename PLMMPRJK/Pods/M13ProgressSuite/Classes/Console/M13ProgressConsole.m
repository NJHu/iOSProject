//
//  M13ProgressConsole.m
//  M13ProgressView
//
/*Copyright (c) 2013 Brandon McQuilkin
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */
#import "M13ProgressConsole.h"
#import "UIImage+ImageEffects.h"

@interface M13ProgressConsole ()

@property (nonatomic, readwrite) CGFloat progress;

@end

@implementation M13ProgressConsole
{
    NSMutableArray *_mutableLines;
    NSMutableArray *_lineSuffixes;
    NSMutableArray *_linePrefixes;
    NSMutableString *_allPreviousLines;
    NSTimer *updateTimer;
    int indeterminateOffset;
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
        // Initialization code
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
    //Set defaults
    _progressType = M13ProgressConsoleProgressTypePercentage;
    _maskType = M13ProgressConsoleMaskTypeSolidColor;
    _maskColor = [UIColor colorWithWhite:0.0 alpha:0.75];
    self.font = [UIFont systemFontOfSize:14.0];
    self.textColor = [UIColor whiteColor];
    self.backgroundColor = [UIColor blackColor];
    _showCursor = YES;
    _mutableLines = [NSMutableArray array];
    _lineSuffixes = [NSMutableArray array];
    _linePrefixes = [NSMutableArray array];
    _allPreviousLines = [NSMutableString string];
    _animationDuration = .1;
    self.userInteractionEnabled = NO;
}

#pragma marks Properties

- (void)setProgressType:(M13ProgressConsoleProgressType)progressType
{
    _progressType = progressType;
    //Clear the suffix for the current line
    [_lineSuffixes removeLastObject];
}

- (void)setMaskType:(M13ProgressConsoleMaskType)maskType
{
    _maskType = maskType;
    
    if (_maskType == M13ProgressConsoleMaskTypeNone) {
        self.backgroundColor = [UIColor clearColor];
    } else if (_maskType == M13ProgressConsoleMaskTypeSolidColor) {
        self.backgroundColor = _maskColor;
    } else if (_maskType == M13ProgressConsoleMaskTypeIOS7Blur) {
        //Get the snapshot of the mask
        __block UIImage *image = [self snapshotForBlurredBackgroundInView:self];
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
                    [self.layer addAnimation:transition forKey:nil];
                    self.backgroundColor = [UIColor colorWithPatternImage:image];
                });
            });
        }
    }
}

- (void)setMaskColor:(UIColor *)maskColor
{
    _maskColor = maskColor;
    if (_maskType == M13ProgressConsoleMaskTypeSolidColor) {
        self.backgroundColor = _maskColor;
    }
}

- (void)setShowCursor:(BOOL)showCursor
{
    _showCursor = showCursor;
}

- (void)setPrefix:(NSString *)prefix
{
    _prefix = prefix;
    if (_prefix == nil) {
        _prefix = @"";
    }
}

- (NSArray *)lines
{
    return [_mutableLines copy];
}

- (void)setLines:(NSArray *)lines
{
    _mutableLines = [lines mutableCopy];
}

#pragma mark Actions

- (void)setIndeterminate:(BOOL)indeterminate
{
    _indeterminate = indeterminate;
    if (_indeterminate && !updateTimer) {
        updateTimer = [NSTimer timerWithTimeInterval:_animationDuration target:self selector:@selector(updateCurrentLine) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:updateTimer forMode:NSRunLoopCommonModes];
    } else if (!_indeterminate && updateTimer) {
        [updateTimer invalidate];
        updateTimer = nil;
        indeterminateOffset = 0;
    }
}

- (void)setProgress:(CGFloat)progress
{
    if (progress > 1) {
        progress = 1;
    }
    _progress = progress;
    [self updateCurrentLine];
}

- (void)setCurrentLine:(NSString *)currentLine
{
    [_mutableLines replaceObjectAtIndex:(_mutableLines.count - 1) withObject:currentLine];
    [self updateCurrentLine];
}

- (void)addNewLineWithString:(NSString *)newLine
{
    //Add the current line to the all previous lines string
    if (_mutableLines.count != 0) {
        [_allPreviousLines appendFormat:@"%@%@%@\n", _linePrefixes.lastObject, _mutableLines.lastObject, _lineSuffixes.lastObject];
    }
    //Create the new line
    [_mutableLines addObject:newLine];
    [_linePrefixes addObject:[_prefix copy]];
    [_lineSuffixes addObject:@""];
    _progress = 0.0;
    [self updateCurrentLine];
}

- (void)clear
{
    self.text = nil;
    self.indeterminate = NO;
    _allPreviousLines = [[NSMutableString alloc] init];
    _linePrefixes = [[NSMutableArray alloc] init];
    _lineSuffixes = [[NSMutableArray alloc] init];
    _mutableLines = [[NSMutableArray alloc] init];
}

#pragma mark Drawing

- (void)update
{
    NSMutableString *newString = [[NSMutableString alloc] init];
    _allPreviousLines = [NSMutableString string];
    for (int i = 0; i < _mutableLines.count; i++) {
        NSMutableString *newLine = [NSMutableString string];
        [newLine appendString:_linePrefixes[i]];
        [newLine appendString:_mutableLines[i]];
        [newLine appendString:_lineSuffixes[i]];
        [newLine appendString:@"\n"];
        [newString appendString:newLine];
        if (i != _mutableLines.count - 1) {
            [_allPreviousLines appendString:newLine];
        }
    }
    self.text = newString;
    [self scrollRectToVisible:CGRectMake(0, self.frame.size.height, 0, 0) animated:NO];
}

- (void)updateCurrentLine
{
    NSMutableString *currentText = [[NSMutableString alloc] initWithString:_allPreviousLines];
    [currentText appendString:_linePrefixes.lastObject];
    [currentText appendString:_mutableLines.lastObject];
    //Calculate suffix
    if (_progressType == M13ProgressConsoleProgressTypeDots && (_progress != 0 || _indeterminate)) {
        NSString *suffix = [self dotsProgressString];
        [_lineSuffixes replaceObjectAtIndex:(_lineSuffixes.count - 1) withObject:suffix];
        [currentText appendString:suffix];
    } else if (_progressType == M13ProgressConsoleProgressTypePercentage && (_progress != 0 || _indeterminate)) {
        NSString *suffix = [self percentageProgressString];
        [_lineSuffixes replaceObjectAtIndex:(_lineSuffixes.count - 1) withObject:suffix];
        [currentText appendString:suffix];
    } else if (_progressType == M13ProgressConsoleProgressTypeBarOfDots && (_progress != 0 || _indeterminate)) {
        NSString *suffix = [self barOfDotsProgressString];
        [_lineSuffixes replaceObjectAtIndex:(_lineSuffixes.count - 1) withObject:suffix];
        [currentText appendString:suffix];
    }
    self.text = currentText;
    [self scrollRectToVisible:CGRectMake(0, self.frame.size.height, 0, 0) animated:NO];
}

- (NSString *)dotsProgressString
{
    NSMutableString *string = [[NSMutableString alloc] initWithString:@"\n"];
    if (!_indeterminate) {
        for (float f = 0; f <= 1; f += .05) {
            if (f <= _progress) {
                [string appendString:@"."];
            } else {
                continue;
            }
        }
    } else {
        if (indeterminateOffset > 24) {
            indeterminateOffset = 0;
        }
        for (int i = 0; i < 20; i++) {
            if (i <= indeterminateOffset && i > indeterminateOffset - 5) {
                [string appendString:@"."];
            } else {
                [string appendString:@" "];
            }
        }
        indeterminateOffset += 1;
    }
    return string;
}

- (NSString *)percentageProgressString
{
    if (!_indeterminate) {
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        formatter.numberStyle = NSNumberFormatterPercentStyle;
        return [NSString stringWithFormat:@"\n%@",[formatter stringFromNumber:[NSNumber numberWithFloat:(float)_progress]]];
    } else {
        return @"\n??%";
    }
    
}

- (NSString *)barOfDotsProgressString
{
    NSMutableString *string = [[NSMutableString alloc] initWithString:@"\n"];
    if (!_indeterminate) {
        for (float f = 0; f <= 1; f += .05) {
            if (f <= _progress) {
                [string appendString:@"∙"];
            } else {
                [string appendString:@"."];
            }
        }
    } else {
        if (indeterminateOffset > 24) {
            indeterminateOffset = 0;
        }
        for (int i = 0; i < 20; i++) {
            if (i <= indeterminateOffset && i > indeterminateOffset - 5) {
                [string appendString:@"∙"];
            } else {
                [string appendString:@"."];
            }
        }
        indeterminateOffset += 1;
    }
    
    return string;
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

@end
