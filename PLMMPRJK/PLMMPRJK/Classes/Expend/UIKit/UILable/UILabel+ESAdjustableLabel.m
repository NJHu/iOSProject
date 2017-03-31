//
//  UILabel+ESAdjustableLabel.h
//  ===========================
//  This category adds a few helper methods to adjust
//  a UIlabel to fit its text. 
//  
//  You can specify the minimum and maximum label size,
//  minimum font size, or none at all.
//                      ----
//
//  Created by Edgar Schmidt (@edgarschmidt) on 4/14/12.
//  Copyright (c) 2012 Edgar Schmidt. All rights reserved.
//
//  This code is provided without any warranties.
//  Hack around and enjoy ;)
//

#import "UILabel+ESAdjustableLabel.h"

@implementation UILabel (ESAdjustableLabel)

// General method. If minSize is set to CGSizeZero then
// it is ignored.
// =====================================================
- (void)adjustLabelToMaximumSize:(CGSize)maxSize 
                     minimumSize:(CGSize)minSize 
                 minimumFontSize:(int)minFontSize
{
  //// 1) Calculate new label size
  //// ---------------------------
  // First, reset some basic parameters  
  [self setNumberOfLines:0];
  [self setLineBreakMode:UILineBreakModeWordWrap];
  
  // If maxSize is set to CGSizeZero, then assume the max width
  // is the size of the device screen minus the default
  // recommended edge distances (2 * 20)
  if (maxSize.height == CGSizeZero.height) {
    maxSize.width = [[UIScreen mainScreen] bounds].size.width - 40.0;
    maxSize.height = MAXFLOAT; // infinite height
    
  }
  
  // Now, calculate the size of the label constrained to maxSize
  CGSize tempSize = [[self text] sizeWithFont:[self font] 
                            constrainedToSize:maxSize 
                                lineBreakMode:[self lineBreakMode]];
  
  // If minSize is specified (not CGSizeZero) then 
  // check if the new calculated size is smaller than
  // the minimum size
  if (minSize.height != CGSizeZero.height) {
    if (tempSize.width <= minSize.width) tempSize.width = minSize.width;
    if (tempSize.height <= minSize.height) tempSize.height = minSize.height;
  }
  
  // Create rect
  CGRect newFrameSize = CGRectMake(  [self frame].origin.x
                                   , [self frame].origin.y
                                   , tempSize.width
                                   , tempSize.height);
  
  //// 2) Change the font size if necessary
  //// ------------------------------------
  UIFont *labelFont = [self font]; // temporary label object
  CGFloat fSize = [labelFont pointSize]; // temporary font size value
  CGSize calculatedSizeWithCurrentFontSize; // temporary frame size
  
  // Calculate label size as if there was no constrain
  CGSize unconstrainedSize = CGSizeMake(tempSize.width, MAXFLOAT);
  
  // Keep reducing the font size until the calculated frame size
  // is smaller than the maxSize parameter  
  do {
    // Create a temporary font object
    labelFont = [UIFont fontWithName:[labelFont fontName]
                                size:fSize];
    // Calculate the frame size
    calculatedSizeWithCurrentFontSize = 
    [[self text] sizeWithFont:labelFont 
            constrainedToSize:unconstrainedSize 
                lineBreakMode:UILineBreakModeWordWrap];
    // Reduce the temporary font size value
    fSize--;
  } while (calculatedSizeWithCurrentFontSize.height > maxSize.height);
  
  // Reset the font size to the last calculated value
  [self setFont:labelFont];
  
  // Reset the frame size
  [self setFrame:newFrameSize];
  
}

// Adjust label using only the maximum size and the 
// font size as constraints
// =====================================================
- (void)adjustLabelToMaximumSize:(CGSize)maxSize 
                 minimumFontSize:(int)minFontSize
{
  [self adjustLabelToMaximumSize:maxSize 
                     minimumSize:CGSizeZero 
                 minimumFontSize:minFontSize];
}

// Adjust the size of the label using only the font
// size as a constraint (the maximum size will be
// calculated automatically based on the screen size)
// =====================================================
- (void)adjustLabelSizeWithMinimumFontSize:(int)minFontSize
{
  [self adjustLabelToMaximumSize:CGSizeZero 
                     minimumSize:CGSizeZero 
                 minimumFontSize:minFontSize];
}

// Adjust label without any constraints (the maximum 
// size will be calculated automatically based on the
// screen size)
// =====================================================
- (void)adjustLabel
{
  [self adjustLabelToMaximumSize:CGSizeZero 
                     minimumSize:CGSizeZero 
                 minimumFontSize:[self minimumFontSize]];
}

@end
