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

#define MODULE ZBarReaderView
#import "debug.h"

// silence warning
@interface ZBarReaderViewImpl : NSObject
@end

@implementation ZBarReaderView

@synthesize readerDelegate, tracksSymbols, trackingColor, torchMode, showsFPS,
    zoom, maxZoom, scanCrop, previewTransform, captureReader;
@dynamic scanner, allowsPinchZoom, enableCache, device, session;

+ (id) alloc
{
    if(self == [ZBarReaderView class]) {
        // this is an abstract wrapper for implementation selected
        // at compile time.  replace with concrete subclass.
        return((id)[ZBarReaderViewImpl alloc]);
    }
    return([super alloc]);
}

- (void) initSubviews
{
    assert(preview);

    overlay = [CALayer new];
    overlay.backgroundColor = [UIColor clearColor].CGColor;
    [preview addSublayer: overlay];

#ifndef NDEBUG
    overlay.borderWidth = 2;
    overlay.borderColor = [UIColor colorWithRed: 1
                                   green: 0
                                   blue: 0
                                   alpha: .5].CGColor;
    cropLayer = [CALayer new];
    cropLayer.backgroundColor = [UIColor clearColor].CGColor;
    cropLayer.borderWidth = 2;
    cropLayer.borderColor = [UIColor colorWithRed: 0
                                     green: 0
                                     blue: 1
                                     alpha: .5].CGColor;
    [overlay addSublayer: cropLayer];
#endif

    tracking = [CALayer new];
    tracking.opacity = 0;
    tracking.borderWidth = 1;
    tracking.backgroundColor = [UIColor clearColor].CGColor;
    [overlay addSublayer: tracking];

    trackingColor = [[UIColor greenColor]
                        retain];
    tracking.borderColor = trackingColor.CGColor;

    fpsView = [UIView new];
    fpsView.backgroundColor = [UIColor colorWithWhite: 0
                                       alpha: .333];
    fpsView.layer.cornerRadius = 12;
    fpsView.hidden = YES;
    [self addSubview: fpsView];

    fpsLabel = [[UILabel alloc]
                   initWithFrame: CGRectMake(0, 0, 80, 32)];
    fpsLabel.backgroundColor = [UIColor clearColor];
    fpsLabel.textColor = [UIColor colorWithRed: .333
                                  green: .666
                                  blue: 1
                                  alpha: 1];
    fpsLabel.font = [UIFont systemFontOfSize: 18];
    fpsLabel.textAlignment = UITextAlignmentRight;
    [fpsView addSubview: fpsLabel];

    self.zoom = 1.25;
}

- (void) _initWithImageScanner: (ZBarImageScanner*) scanner
{
    assert(scanner);

    tracksSymbols = YES;
    interfaceOrientation = UIInterfaceOrientationPortrait;
    torchMode = 2; // AVCaptureTorchModeAuto
    scanCrop = effectiveCrop = CGRectMake(0, 0, 1, 1);
    imageScale = 1;
    previewTransform = CGAffineTransformIdentity;
    maxZoom = 2;

    pinch = [[UIPinchGestureRecognizer alloc]
                initWithTarget: self
                action: @selector(handlePinch)];
    [self addGestureRecognizer: pinch];
}

- (id) initWithImageScanner: (ZBarImageScanner*) scanner
{
    self = [super initWithFrame: CGRectMake(0, 0, 320, 426)];
    if(!self)
        return(nil);

    self.backgroundColor = [UIColor blackColor];
    self.contentMode = UIViewContentModeScaleAspectFill;
    self.clipsToBounds = YES;
    self.autoresizingMask =
        UIViewAutoresizingFlexibleWidth |
        UIViewAutoresizingFlexibleHeight;

    [self _initWithImageScanner: scanner];
    return(self);
}

- (id) init
{
    ZBarImageScanner *scanner =
        [[ZBarImageScanner new]
            autorelease];
    self = [self initWithImageScanner: scanner];
    if(!self)
        return(nil);

    [scanner setSymbology: 0
             config: ZBAR_CFG_X_DENSITY
             to: 3];
    [scanner setSymbology: 0
             config: ZBAR_CFG_Y_DENSITY
             to: 3];
    return(self);
}

- (id) initWithCoder: (NSCoder*) decoder
{
    self = [super initWithCoder: decoder];
    if(!self)
        return(nil);
    ZBarImageScanner *scanner =
        [[ZBarImageScanner new]
            autorelease];
    [self _initWithImageScanner: scanner];

    [scanner setSymbology: 0
             config: ZBAR_CFG_X_DENSITY
             to: 3];
    [scanner setSymbology: 0
             config: ZBAR_CFG_Y_DENSITY
             to: 3];
    return(self);
}

- (void) dealloc
{
    [preview removeFromSuperlayer];
    [preview release];
    preview = nil;
    [overlay release];
    overlay = nil;
    [cropLayer release];
    cropLayer = nil;
    [tracking release];
    tracking = nil;
    [trackingColor release];
    trackingColor = nil;
    [fpsLabel release];
    fpsLabel = nil;
    [fpsView release];
    fpsView = nil;
    [pinch release];
    pinch = nil;
    [super dealloc];
}

- (void) resetTracking
{
    [tracking removeAllAnimations];
    [CATransaction begin];
    [CATransaction setDisableActions: YES];
    CGSize size = overlay.bounds.size;
    CGRect crop = effectiveCrop;
    tracking.frame = CGRectMake(crop.origin.x * size.width,
                                crop.origin.y * size.height,
                                crop.size.width * size.width,
                                crop.size.height * size.height);
    tracking.opacity = 0;
    [CATransaction commit];
}

- (void) updateCrop
{
}

static inline CGFloat rotationForInterfaceOrientation (int orient)
{
    // resolve camera/device image orientation to view/interface orientation
    switch(orient)
    {
    case UIInterfaceOrientationLandscapeLeft:
        return(M_PI_2);
    case UIInterfaceOrientationPortraitUpsideDown:
        return(M_PI);
    case UIInterfaceOrientationLandscapeRight:
        return(3 * M_PI_2);
    case UIInterfaceOrientationPortrait:
        return(2 * M_PI);
    }
    return(0);
}

- (void) layoutSubviews
{
    CGRect bounds = self.bounds;
    if(!bounds.size.width || !bounds.size.height)
        return;

    [CATransaction begin];
    if(animationDuration) {
        [CATransaction setAnimationDuration: animationDuration];
        [CATransaction setAnimationTimingFunction:
            [CAMediaTimingFunction functionWithName:
                kCAMediaTimingFunctionEaseInEaseOut]];
    }
    else
        [CATransaction setDisableActions: YES];

    [super layoutSubviews];
    fpsView.frame = CGRectMake(bounds.size.width - 80, bounds.size.height - 32,
                               80 + 12, 32 + 12);

    // orient view bounds to match camera image
    CGSize psize;
    if(UIInterfaceOrientationIsPortrait(interfaceOrientation))
        psize = CGSizeMake(bounds.size.height, bounds.size.width);
    else
        psize = bounds.size;

    // calculate scale from view coordinates to image coordinates
    // FIXME assumes AVLayerVideoGravityResizeAspectFill
    CGFloat scalex = imageSize.width / psize.width;
    CGFloat scaley = imageSize.height / psize.height;
    imageScale = (scalex < scaley) ? scalex : scaley;
    if(!imageScale)
        imageScale = 1;
    // apply zoom
    imageScale /= zoom;

    // scale crop by zoom factor
    CGFloat z = 1 / zoom;
    CGFloat t = (1 - z) / 2;
    CGRect zoomCrop =
        CGRectMake(scanCrop.origin.x * z + t,
                   scanCrop.origin.y * z + t,
                   scanCrop.size.width * z,
                   scanCrop.size.height * z);

    // convert effective preview area to normalized image coordinates
    CGRect previewCrop;
    if(scalex < scaley && imageSize.height)
        previewCrop.size =
            CGSizeMake(z, psize.height * imageScale / imageSize.height);
    else if(imageSize.width)
        previewCrop.size =
            CGSizeMake(psize.width * imageScale / imageSize.width, z);
    else
        previewCrop.size = CGSizeMake(1, 1);
    previewCrop.origin = CGPointMake((1 - previewCrop.size.width) / 2,
                                     (1 - previewCrop.size.height) / 2);

    // clip crop to visible preview area
    effectiveCrop = CGRectIntersection(zoomCrop, previewCrop);
    if(CGRectIsNull(effectiveCrop))
        effectiveCrop = zoomCrop;

    // size preview to match image in view coordinates
    CGFloat viewScale = 1 / imageScale;
    if(imageSize.width && imageSize.height)
        psize = CGSizeMake(imageSize.width * viewScale,
                           imageSize.height * viewScale);

    preview.bounds = CGRectMake(0, 0, psize.height, psize.width);
    // center preview in view
    preview.position = CGPointMake(bounds.size.width / 2,
                                   bounds.size.height / 2);

    CGFloat angle = rotationForInterfaceOrientation(interfaceOrientation);
    CATransform3D xform =
        CATransform3DMakeAffineTransform(previewTransform);
    preview.transform = CATransform3DRotate(xform, angle, 0, 0, 1);

    // scale overlay to match actual image
    if(imageSize.width && imageSize.height)
        overlay.bounds = CGRectMake(0, 0, imageSize.width, imageSize.height);
    else
        overlay.bounds = CGRectMake(0, 0, psize.width, psize.height);
    // center overlay in preview
    overlay.position = CGPointMake(psize.height / 2, psize.width / 2);

    // image coordinates rotated from preview
    xform = CATransform3DMakeRotation(M_PI_2, 0, 0, 1);
    overlay.transform = CATransform3DScale(xform, viewScale, viewScale, 1);
    tracking.borderWidth = imageScale;

#ifndef NDEBUG
    preview.backgroundColor = [UIColor yellowColor].CGColor;
    overlay.borderWidth = 2 * imageScale;
    cropLayer.borderWidth = 2 * imageScale;
    cropLayer.frame = CGRectMake(effectiveCrop.origin.x * imageSize.width,
                                 effectiveCrop.origin.y * imageSize.height,
                                 effectiveCrop.size.width * imageSize.width,
                                 effectiveCrop.size.height * imageSize.height);
    zlog(@"layoutSubviews: bounds=%@ orient=%d image=%@ crop=%@ zoom=%g\n"
         @"=> preview=%@ crop=(z%@ p%@ %@ i%@) scale=%g %c %g = 1/%g",
         NSStringFromCGSize(bounds.size), interfaceOrientation,
         NSStringFromCGSize(imageSize), NSStringFromCGRect(scanCrop), zoom,
         NSStringFromCGSize(psize), NSStringFromCGRect(zoomCrop),
         NSStringFromCGRect(previewCrop), NSStringFromCGRect(effectiveCrop),
         NSStringFromCGRect(cropLayer.frame),
         scalex, (scalex > scaley) ? '>' : '<', scaley, viewScale);
#endif

    [self resetTracking];
    [self updateCrop];

    [CATransaction commit];
    animationDuration = 0;
}

- (void) setImageSize: (CGSize) size
{
    zlog(@"imageSize=%@", NSStringFromCGSize(size));
    imageSize = size;

    // FIXME bug in AVCaptureVideoPreviewLayer fails to update preview location
    preview.bounds = CGRectMake(0, 0, size.width, size.height);

    [self setNeedsLayout];
}

- (void) willRotateToInterfaceOrientation: (UIInterfaceOrientation) orient
                                 duration: (NSTimeInterval) duration
{
    if(interfaceOrientation != orient) {
        zlog(@"orient=%d #%g", orient, duration);
        interfaceOrientation = orient;
        animationDuration = duration;
    }
}

- (void) setScanCrop: (CGRect) r
{
    if(CGRectEqualToRect(scanCrop, r))
        return;
    scanCrop = r;
    [self setNeedsLayout];
}

- (void) setTracksSymbols: (BOOL) track
{
    if(track == tracksSymbols)
        return;
    tracksSymbols = track;
    [self resetTracking];
}

- (BOOL) allowsPinchZoom
{
    return(pinch.enabled);
}

- (void) setAllowsPinchZoom: (BOOL) enabled
{
    pinch.enabled = enabled;
}

- (void) setTrackingColor: (UIColor*) color
{
    if(!color)
        return;
    [color retain];
    [trackingColor release];
    trackingColor = color;
    tracking.borderColor = color.CGColor;
}

- (void) setShowsFPS: (BOOL) show
{
    if(show == showsFPS)
        return;
    fpsView.hidden = !show;
}

- (void) setZoom: (CGFloat) z
{
    if(z < 1.0)
        z = 1.0;
    if(z > maxZoom)
        z = maxZoom;
    if(z == zoom)
        return;
    zoom = z;

    [self setNeedsLayout];
}

- (void) setZoom: (CGFloat) z
        animated: (BOOL) animated
{
    [CATransaction begin];
    if(animated) {
        [CATransaction setAnimationDuration: .1];
        [CATransaction setAnimationTimingFunction:
            [CAMediaTimingFunction functionWithName:
                kCAMediaTimingFunctionLinear]];
    }
    else
        [CATransaction setDisableActions: YES];
    // FIXME animate from current value
    self.zoom = z;
    [self layoutIfNeeded];
    [CATransaction commit];
}

- (void) setPreviewTransform: (CGAffineTransform) xfrm
{
    previewTransform = xfrm;
    [self setNeedsLayout];
}

- (void) start
{
    if(started)
        return;
    started = YES;

    [self resetTracking];
    fpsLabel.text = @"--- fps ";

    [[UIDevice currentDevice]
        beginGeneratingDeviceOrientationNotifications];
}

- (void) stop
{
    if(!started)
        return;
    started = NO;

    [[UIDevice currentDevice]
        endGeneratingDeviceOrientationNotifications];
}

- (void) flushCache
{
}

// UIGestureRecognizer callback

- (void) handlePinch
{
    if(pinch.state == UIGestureRecognizerStateBegan)
        zoom0 = zoom;
    CGFloat z = zoom0 * pinch.scale;
    [self setZoom: z
          animated: YES];

    if((zoom < 1.5) != (z < 1.5)) {
        int d = (z < 1.5) ? 3 : 2;
        ZBarImageScanner *scanner = self.scanner;
        @synchronized(scanner) {
            [scanner setSymbology: 0
                     config: ZBAR_CFG_X_DENSITY
                     to: d];
            [scanner setSymbology: 0
                     config: ZBAR_CFG_Y_DENSITY
                     to: d];
        }
    }
}

- (void) updateTracking: (CALayer*) trk
             withSymbol: (ZBarSymbol*) sym
{
    if(!sym)
        return;

    CGRect r = sym.bounds;
    if(r.size.width <= 32 && r.size.height <= 32)
        return;
    r = CGRectInset(r, -24, -24);

    CALayer *current = trk.presentationLayer;
    CGPoint cp = current.position;
    CGPoint p = CGPointMake(CGRectGetMidX(r), CGRectGetMidY(r));
    p = CGPointMake((p.x * 3 + cp.x) / 4, (p.y * 3 + cp.y) / 4);

    CGRect cr = current.bounds;
    r.origin = cr.origin;
    r.size.width = (r.size.width * 3 + cr.size.width) / 4;
    r.size.height = (r.size.height * 3 + cr.size.height) / 4;

    CAMediaTimingFunction *linear =
        [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionLinear];

    CABasicAnimation *resize =
        [CABasicAnimation animationWithKeyPath: @"bounds"];
    resize.fromValue = [NSValue valueWithCGRect: cr];
    resize.toValue = [NSValue valueWithCGRect: r];
    resize.duration = .2;
    resize.timingFunction = linear;
    resize.fillMode = kCAFillModeForwards;
    resize.removedOnCompletion = NO;

    CABasicAnimation *move =
        [CABasicAnimation animationWithKeyPath: @"position"];
    move.fromValue = [NSValue valueWithCGPoint: cp];
    move.toValue = [NSValue valueWithCGPoint: p];
    move.duration = .2;
    move.timingFunction = linear;
    move.fillMode = kCAFillModeForwards;
    move.removedOnCompletion = NO;

    CABasicAnimation *on =
        [CABasicAnimation animationWithKeyPath: @"opacity"];
    on.fromValue = [NSNumber numberWithDouble: current.opacity];
    on.toValue = [NSNumber numberWithDouble: 1];
    on.duration = .2;
    on.timingFunction = linear;
    on.fillMode = kCAFillModeForwards;
    on.removedOnCompletion = NO;

    CABasicAnimation *off = nil;
    if(!TARGET_IPHONE_SIMULATOR) {
        off = [CABasicAnimation animationWithKeyPath: @"opacity"];
        off.fromValue = [NSNumber numberWithDouble: 1];
        off.toValue = [NSNumber numberWithDouble: 0];
        off.beginTime = .5;
        off.duration = .5;
        off.timingFunction = linear;
    }

    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = [NSArray arrayWithObjects: resize, move, on, off, nil];
    group.duration = 1;
    group.fillMode = kCAFillModeForwards;
    group.removedOnCompletion = !TARGET_IPHONE_SIMULATOR;
    [trk addAnimation: group
         forKey: @"tracking"];
}

- (void) didTrackSymbols: (ZBarSymbolSet*) syms
{
    if(!tracksSymbols)
        return;

    int n = syms.count;
    assert(n);
    if(!n)
        return;

    ZBarSymbol *sym = nil;
    for(ZBarSymbol *s in syms)
        if(!sym || s.type == ZBAR_QRCODE || s.quality > sym.quality)
            sym = s;
    assert(sym);
    if(!sym)
        return;

    [self updateTracking: tracking
          withSymbol: sym];
}

@end
