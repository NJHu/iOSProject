//------------------------------------------------------------------------
//  Copyright 2009-2010 (c) Jeff Brown <spadix@users.sourceforge.net>
//
//  This file is part of the ZBar Bar Code Reader.
//
//  The ZBar Bar Code Reader is free software; you can redistribute it
//  and/or modify it under the terms of the GNU Lesser Public License as
//  published by the Free Software Foundation; either version 2.1 of
//  the License, or (at your option) any later version.
//
//  The ZBar Bar Code Reader is distributed in the hope that it will be
//  useful, but WITHOUT ANY WARRANTY; without even the implied warranty
//  of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU Lesser Public License for more details.
//
//  You should have received a copy of the GNU Lesser Public License
//  along with the ZBar Bar Code Reader; if not, write to the Free
//  Software Foundation, Inc., 51 Franklin St, Fifth Floor,
//  Boston, MA  02110-1301  USA
//
//  http://sourceforge.net/projects/zbar
//------------------------------------------------------------------------

#import <UIKit/UIKit.h>
#import "ZBarImageScanner.h"

#ifdef __cplusplus
using namespace zbar;
#endif

typedef enum {
    // default interface provided by UIImagePickerController - user manually
    // captures an image by pressing a button
    ZBarReaderControllerCameraModeDefault = 0,

    // automatically scan by taking screenshots with UIGetScreenImage().
    // resolution is limited by the screen, so this is inappropriate for
    // longer codes
    ZBarReaderControllerCameraModeSampling,

    // automatically scan by rapidly taking pictures with takePicture.
    // tradeoff resolution with frame rate by adjusting the crop, and size
    // properties of the reader along with the density configs of the image
    // scanner
    ZBarReaderControllerCameraModeSequence,

} ZBarReaderControllerCameraMode;


@class ZBarReaderController, ZBarHelpController;

@protocol ZBarReaderDelegate <UIImagePickerControllerDelegate>
@optional

// called when no barcode is found in an image selected by the user.
// if retry is NO, the delegate *must* dismiss the controller
- (void) readerControllerDidFailToRead: (ZBarReaderController*) reader
                             withRetry: (BOOL) retry;

@end


@interface ZBarReaderController
    : UIImagePickerController
    < UINavigationControllerDelegate,
      UIImagePickerControllerDelegate >
{
    ZBarImageScanner *scanner;
    ZBarHelpController *help;
    UIView *overlay, *boxView;
    CALayer *boxLayer;

    UIToolbar *toolbar;
    UIBarButtonItem *cancelBtn, *scanBtn, *space[3];
    UIButton *infoBtn;

    id <ZBarReaderDelegate> readerDelegate;
    BOOL showsZBarControls, showsHelpOnFail, takesPicture, enableCache;
    ZBarReaderControllerCameraMode cameraMode;
    CGRect scanCrop;
    NSInteger maxScanDimension;

    BOOL hasOverlay, sampling;
    uint64_t t_frame;
    double dt_frame;

    ZBarSymbol *symbol;
}

// access to configure image scanner
@property (readonly, nonatomic) ZBarImageScanner *scanner;

// barcode result recipient (NB don't use delegate)
@property (nonatomic, assign) id <ZBarReaderDelegate> readerDelegate;

// whether to use alternate control set
@property (nonatomic) BOOL showsZBarControls;

// whether to display helpful information when decoding fails
@property (nonatomic) BOOL showsHelpOnFail;

// how to use the camera (when sourceType == Camera)
@property (nonatomic) ZBarReaderControllerCameraMode cameraMode;

// whether to outline symbols with the green tracking box.
@property (nonatomic) BOOL tracksSymbols;

// whether to automatically take a full picture when a barcode is detected
// (when cameraMode == Sampling)
@property (nonatomic) BOOL takesPicture;

// whether to use the "cache" for realtime modes (default YES).  this can be
// used to safely disable the inter-frame consistency and duplicate checks,
// speeding up recognition, iff:
//     1. the controller is dismissed when a barcode is read and
//     2. unreliable symbologies are disabled (all EAN/UPC variants and I2/5)
@property (nonatomic) BOOL enableCache;

// crop images for scanning.  the original image will be cropped to this
// rectangle before scanning.  the rectangle is normalized to the image size
// and aspect ratio; useful values will place the rectangle between 0 and 1
// on each axis, where the x-axis corresponds to the image major axis.
// defaults to the full image (0, 0, 1, 1).
@property (nonatomic) CGRect scanCrop;

// scale image to scan.  after cropping, the image will be scaled if
// necessary, such that neither of its dimensions exceed this value.
// defaults to 640.
@property (nonatomic) NSInteger maxScanDimension;

// display the built-in help browser.  for use with custom overlays if
// you don't also want to create your own help view.  only send this
// message when the reader is displayed.  the argument will be passed
// to the onZBarHelp() javascript function.
- (void) showHelpWithReason: (NSString*) reason;

// direct scanner interface - scan UIImage and return something enumerable
- (id <NSFastEnumeration>) scanImage: (CGImageRef) image;

@end

extern NSString* const ZBarReaderControllerResults;
