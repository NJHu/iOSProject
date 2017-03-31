//
//  UIImageView+UIImageView_FaceAwareFill.h
//  faceAwarenessClipping
//
//  Created by Julio Andrés Carrettoni on 03/02/13.
//  Copyright (c) 2013 Julio Andrés Carrettoni. All rights reserved.
//
//  https://github.com/Julioacarrettoni/UIImageView_FaceAwareFill
// This category applies Aspect Fill content mode to an image and if faces are detected it centers them instead of centering the image just by its geometrical center.

#import <UIKit/UIKit.h>

@interface UIImageView (FaceAwareFill)

//Ask the image to perform an "Aspect Fill" but centering the image to the detected faces
//Not the simple center of the image
- (void) faceAwareFill;

@end
