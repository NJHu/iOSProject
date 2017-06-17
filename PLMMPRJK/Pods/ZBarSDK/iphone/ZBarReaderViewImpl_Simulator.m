//------------------------------------------------------------------------
//  Copyright 2010 (c) Jeff Brown <spadix@users.sourceforge.net>
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

#import <ZBarSDK/ZBarReaderView.h>
#import <ZBarSDK/ZBarReaderViewController.h>

#define MODULE ZBarReaderView
#import "debug.h"

// hack around missing simulator support for AVCapture interfaces

// protected APIs
@interface ZBarReaderView()
- (void) _initWithImageScanner: (ZBarImageScanner*) _scanner;
- (void) initSubviews;
- (void) setImageSize: (CGSize) size;
- (void) didTrackSymbols: (ZBarSymbolSet*) syms;
@end

@interface ZBarReaderViewImpl
    : ZBarReaderView
{
    ZBarImageScanner *scanner;
    UILabel *simLabel;
    UIImage *scanImage;
    CALayer *previewImage;
    BOOL enableCache;
}
@end

@implementation ZBarReaderViewImpl

@synthesize scanner, enableCache;

- (void) _initWithImageScanner: (ZBarImageScanner*) _scanner
{
    [super _initWithImageScanner: _scanner];
    scanner = [_scanner retain];

    [self initSubviews];
}

- (void) initSubviews
{
    simLabel = [UILabel new];
    simLabel.backgroundColor = [UIColor clearColor];
    simLabel.textColor = [UIColor whiteColor];
    simLabel.font = [UIFont boldSystemFontOfSize: 20];
    simLabel.numberOfLines = 4;
    simLabel.textAlignment = UITextAlignmentCenter;
    simLabel.text = @"Camera Simulation\n\n"
        @"Tap and hold with two \"fingers\" to select image";
    simLabel.autoresizingMask =
        UIViewAutoresizingFlexibleWidth |
        UIViewAutoresizingFlexibleHeight;
    [self addSubview: simLabel];

    preview = [CALayer new];
    [self.layer addSublayer: preview];

    previewImage = [CALayer new];
    [preview addSublayer: previewImage];

    [super initSubviews];
}

- (void) dealloc
{
    [scanner release];
    scanner = nil;
    [simLabel release];
    simLabel = nil;
    [previewImage release];
    previewImage = nil;
    [super dealloc];
}

- (AVCaptureDevice*) device
{
    return(nil);
}

- (void) setDevice: (AVCaptureDevice*) device
{
    // simulated camera does nothing with this
}

- (AVCaptureSession*) session
{
    return(nil);
}

- (void) updateCrop
{
    previewImage.frame = preview.bounds;
    CGRect bounds = self.bounds;
    simLabel.frame = CGRectInset(bounds,
                                 bounds.size.width * .05,
                                 bounds.size.height * .05);
}

- (void) start
{
    if(started)
        return;
    [super start];
    running = YES;

    [self performSelector: @selector(onVideoStart)
          withObject: nil
          afterDelay: 0.5];
}

- (void) stop
{
    if(!started)
        return;
    [super stop];
    running = NO;

    [self performSelector: @selector(onVideoStop)
          withObject: nil
          afterDelay: 0.5];
}

- (void) scanImage: (UIImage*) image
{
    // strip EXIF info
    CGImageRef cgimage = image.CGImage;
    image = [[UIImage alloc]
                initWithCGImage: cgimage
                scale: 1.0
                orientation: UIImageOrientationUp];

    [self setImageSize: image.size];
    [self layoutIfNeeded];

    [CATransaction begin];
    [CATransaction setDisableActions: YES];
    previewImage.contentsGravity = kCAGravityResizeAspectFill;
    previewImage.transform = CATransform3DMakeRotation(M_PI_2, 0, 0, 1);
    previewImage.contents = (id)cgimage;
    [CATransaction commit];

    ZBarImage *zimg =
        [[ZBarImage alloc]
            initWithCGImage: cgimage];

    CGSize size = zimg.size;
    zimg.crop = CGRectMake(effectiveCrop.origin.x * size.width,
                           effectiveCrop.origin.y * size.height,
                           effectiveCrop.size.width * size.width,
                           effectiveCrop.size.height * size.height);

    int nsyms = [scanner scanImage: zimg];
    zlog(@"scan image: %@ crop=%@ nsyms=%d",
         NSStringFromCGSize(size), NSStringFromCGRect(zimg.crop), nsyms);
    [zimg release];

    if(nsyms > 0) {
        scanImage = [image retain];
        ZBarSymbolSet *syms = scanner.results;
        [self performSelector: @selector(didReadSymbols:)
              withObject: syms
              afterDelay: .4];
        [self performSelector: @selector(didTrackSymbols:)
              withObject: syms
              afterDelay: .001];
    }
    [image release];
}

- (void) didReadSymbols: (ZBarSymbolSet*) syms
{
    [readerDelegate
        readerView: self
        didReadSymbols: syms
        fromImage: scanImage];
    [scanImage release];
    scanImage = nil;
}

- (void) onVideoStart
{
    if(running &&
       [readerDelegate respondsToSelector: @selector(readerViewDidStart:)])
        [readerDelegate readerViewDidStart: self];
}

- (void) onVideoStop
{
    if(!running &&
       [readerDelegate respondsToSelector:
                           @selector(readerView:didStopWithError:)])
        [readerDelegate readerView: self
                        didStopWithError: nil];
}

@end
