//
//  M13ProgressConsole.h
//  M13ProgressView
//
/*Copyright (c) 2013 Brandon McQuilkin
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import <UIKit/UIKit.h>
#import "M13ProgressView.h"

typedef enum {
    M13ProgressConsoleMaskTypeNone,
    M13ProgressConsoleMaskTypeSolidColor,
    M13ProgressConsoleMaskTypeIOS7Blur
} M13ProgressConsoleMaskType;

typedef enum {
    M13ProgressConsoleProgressTypePercentage,
    M13ProgressConsoleProgressTypeDots,
    M13ProgressConsoleProgressTypeBarOfDots
} M13ProgressConsoleProgressType;

/**A progress view that shows progress in the style of terminal.*/
@interface M13ProgressConsole : UITextView;

/**@name Progress*/
/**The progress displayed to the user.*/
@property (nonatomic, readonly) CGFloat progress;
/**Wether or not the progress view is indeterminate.*/
@property (nonatomic, assign) BOOL indeterminate;
/**Show progress at the end of each line.*/
@property (nonatomic, assign) M13ProgressConsoleProgressType progressType;

/**@name Appearance*/
/**The background type of the console.*/
@property (nonatomic, assign) M13ProgressConsoleMaskType maskType;
/**The color of the mask if set to solid color.*/
@property (nonatomic, retain) UIColor *maskColor;
/**Wether or not to show the cursor.*/
@property (nonatomic, assign) BOOL showCursor;
/**The prefix string for each line.*/
@property (nonatomic, retain) NSString *prefix;
/**The array containing all the lines displyed.*/
@property (nonatomic, retain) NSArray *lines;

/**@name Properties*/
/**The durations of animations in seconds.*/
@property (nonatomic, assign) CGFloat animationDuration;

/**@name Actions*/
/**Set the progress of the `M13ProgressView`.
 @param progress The progress to show on the current line.*/
- (void)setProgress:(CGFloat)progress;
/**Set the text of the current line.
 @param currentLine The string to replace the current line with.*/
- (void)setCurrentLine:(NSString *)currentLine;
/**Add a new line with the given text.
 @param newLine The text to start a new line with.*/
- (void)addNewLineWithString:(NSString *)newLine;
/**Clears the console.*/
- (void)clear;

@end
