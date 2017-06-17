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

#import <ZBarSDK/ZBarReaderViewController.h>
#import <ZBarSDK/ZBarReaderView.h>
#import <ZBarSDK/ZBarCaptureReader.h>
#import <ZBarSDK/ZBarHelpController.h>
#import <ZBarSDK/ZBarCameraSimulator.h>

#define MODULE ZBarReaderViewController
#import "debug.h"

static inline AVCaptureDevicePosition
AVPositionForUICamera (UIImagePickerControllerCameraDevice camera)
{
    switch(camera) {
    case UIImagePickerControllerCameraDeviceRear:
        return(AVCaptureDevicePositionBack);
    case UIImagePickerControllerCameraDeviceFront:
        return(AVCaptureDevicePositionFront);
    }
    return(-1);
}

static inline UIImagePickerControllerCameraDevice
UICameraForAVPosition (AVCaptureDevicePosition position)
{
    switch(position)
    {
    case AVCaptureDevicePositionBack:
        return(UIImagePickerControllerCameraDeviceRear);
    case AVCaptureDevicePositionFront:
        return(UIImagePickerControllerCameraDeviceFront);
    }
    return(-1);
}

static inline AVCaptureDevice*
AVDeviceForUICamera (UIImagePickerControllerCameraDevice camera)
{
    AVCaptureDevicePosition position = AVPositionForUICamera(camera);
    if(position < 0)
        return(nil);

#if !TARGET_IPHONE_SIMULATOR
    NSArray *allDevices =
        [AVCaptureDevice devicesWithMediaType: AVMediaTypeVideo];
    for(AVCaptureDevice *device in allDevices)
        // FIXME how to quantify "best" of several (theoretical) possibilities
        if(device.position == position)
            return(device);
#endif
    return(nil);
}

static inline AVCaptureTorchMode
AVTorchModeForUIFlashMode (UIImagePickerControllerCameraFlashMode mode)
{
    switch(mode)
    {
    case UIImagePickerControllerCameraFlashModeAuto:
        return(AVCaptureTorchModeAuto);
    case UIImagePickerControllerCameraFlashModeOn:
        return(AVCaptureTorchModeOn);
    case UIImagePickerControllerCameraFlashModeOff:
        break;
    }
    return(AVCaptureTorchModeOff);
}

static inline NSString*
AVSessionPresetForUIVideoQuality (UIImagePickerControllerQualityType quality)
{
#if !TARGET_IPHONE_SIMULATOR
    switch(quality)
    {
    case UIImagePickerControllerQualityTypeHigh:
        return(AVCaptureSessionPresetHigh);
    case UIImagePickerControllerQualityType640x480:
        return(AVCaptureSessionPreset640x480);
    case UIImagePickerControllerQualityTypeMedium:
        return(AVCaptureSessionPresetMedium);
    case UIImagePickerControllerQualityTypeLow:
        return(AVCaptureSessionPresetLow);
    case UIImagePickerControllerQualityTypeIFrame1280x720:
        return(AVCaptureSessionPresetiFrame1280x720);
    case UIImagePickerControllerQualityTypeIFrame960x540:
        return(AVCaptureSessionPresetiFrame960x540);
    }
#endif
    return(nil);
}


@implementation ZBarReaderViewController

@synthesize scanner, readerDelegate, showsZBarControls,
    supportedOrientationsMask, tracksSymbols, enableCache, cameraOverlayView,
    cameraViewTransform, cameraDevice, cameraFlashMode, videoQuality,
    readerView, scanCrop;
@dynamic sourceType, allowsEditing, allowsImageEditing, showsCameraControls,
    showsHelpOnFail, cameraMode, takesPicture, maxScanDimension;

+ (BOOL) isSourceTypeAvailable: (UIImagePickerControllerSourceType) sourceType
{
    if(sourceType != UIImagePickerControllerSourceTypeCamera)
        return(NO);
    return(TARGET_IPHONE_SIMULATOR ||
           [UIImagePickerController isSourceTypeAvailable: sourceType]);
}

+ (BOOL) isCameraDeviceAvailable: (UIImagePickerControllerCameraDevice) camera
{
    return(TARGET_IPHONE_SIMULATOR ||
           [UIImagePickerController isCameraDeviceAvailable: camera]);
}

+ (BOOL) isFlashAvailableForCameraDevice: (UIImagePickerControllerCameraDevice) camera
{
    return(TARGET_IPHONE_SIMULATOR ||
           [UIImagePickerController isFlashAvailableForCameraDevice: camera]);
}

+ (NSArray*) availableCaptureModesForCameraDevice: (UIImagePickerControllerCameraDevice) camera
{
    if(![self isCameraDeviceAvailable: camera])
        return([NSArray array]);

    // current reader only supports automatic detection
    return([NSArray arrayWithObject:
               [NSNumber numberWithInteger:
                   UIImagePickerControllerCameraCaptureModeVideo]]);
}

- (void) _init
{
    supportedOrientationsMask =
        ZBarOrientationMask(UIInterfaceOrientationPortrait);
    showsZBarControls = tracksSymbols = enableCache = YES;
    scanCrop = CGRectMake(0, 0, 1, 1);
    cameraViewTransform = CGAffineTransformIdentity;

    cameraFlashMode = UIImagePickerControllerCameraFlashModeAuto;
    videoQuality = UIImagePickerControllerQualityType640x480;
    AVCaptureDevice *device = nil;
#if !TARGET_IPHONE_SIMULATOR
    device = [AVCaptureDevice defaultDeviceWithMediaType: AVMediaTypeVideo];
#endif
    if(device)
        cameraDevice = UICameraForAVPosition(device.position);
    else
        cameraDevice = UIImagePickerControllerCameraDeviceRear;

    // create our own scanner to store configuration,
    // independent of whether view is loaded
    scanner = [ZBarImageScanner new];
    [scanner setSymbology: 0
             config: ZBAR_CFG_X_DENSITY
             to: 3];
    [scanner setSymbology: 0
             config: ZBAR_CFG_Y_DENSITY
             to: 3];
}

- (id) init
{
    if(!TARGET_IPHONE_SIMULATOR &&
       !NSClassFromString(@"AVCaptureSession")) {
        // fallback to old interface
        zlog(@"Falling back to ZBarReaderController");
        [self release];
        return((id)[ZBarReaderController new]);
    }

    self = [super init];
    if(!self)
        return(nil);

    self.wantsFullScreenLayout = YES;
    [self _init];
    return(self);
}

- (id) initWithCoder: (NSCoder*) decoder
{
    self = [super initWithCoder: decoder];
    if(!self)
        return(nil);

    [self _init];
    return(self);
}

- (void) cleanup
{
    [cameraOverlayView removeFromSuperview];
    cameraSim.readerView = nil;
    [cameraSim release];
    cameraSim = nil;
    readerView.readerDelegate = nil;
    [readerView release];
    readerView = nil;
    [controls release];
    controls = nil;
    [shutter release];
    shutter = nil;
}

- (void) dealloc
{
    [self cleanup];
    [cameraOverlayView release];
    cameraOverlayView = nil;
    [scanner release];
    scanner = nil;
    [super dealloc];
}

- (void) initControls
{
    if(!showsZBarControls && controls) {
        [controls removeFromSuperview];
        [controls release];
        controls = nil;
    }
    if(!showsZBarControls)
        return;

    UIView *view = self.view;
    if(controls) {
        assert(controls.superview == view);
        [view bringSubviewToFront: controls];
        return;
    }

    CGRect r = view.bounds;
    r.origin.y = r.size.height - 54;
    r.size.height = 54;
    controls = [[UIView alloc]
                   initWithFrame: r];
    controls.autoresizingMask =
        UIViewAutoresizingFlexibleWidth |
        UIViewAutoresizingFlexibleHeight |
        UIViewAutoresizingFlexibleTopMargin;
    controls.backgroundColor = [UIColor blackColor];

    UIToolbar *toolbar =
        [UIToolbar new];
    r.origin.y = 0;
    toolbar.frame = r;
    toolbar.barStyle = UIBarStyleBlackOpaque;
    toolbar.autoresizingMask =
        UIViewAutoresizingFlexibleWidth |
        UIViewAutoresizingFlexibleHeight;

    UIButton *info =
        [UIButton buttonWithType: UIButtonTypeInfoLight];
    [info addTarget: self
          action: @selector(info)
          forControlEvents: UIControlEventTouchUpInside];

    toolbar.items =
        [NSArray arrayWithObjects:
            [[[UIBarButtonItem alloc]
                 initWithBarButtonSystemItem: UIBarButtonSystemItemCancel
                 target: self
                 action: @selector(cancel)]
                autorelease],
            [[[UIBarButtonItem alloc]
                 initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace
                 target: nil
                 action: nil]
                autorelease],
            [[[UIBarButtonItem alloc]
                 initWithCustomView: info]
                autorelease],
            nil];
    [controls addSubview: toolbar];
    [toolbar release];

    [view addSubview: controls];
}

- (void) initVideoQuality
{
    if(!readerView) {
        assert(0);
        return;
    }

    AVCaptureSession *session = readerView.session;
    NSString *preset = AVSessionPresetForUIVideoQuality(videoQuality);
    if(session && preset && [session canSetSessionPreset: preset]) {
        zlog(@"set session preset=%@", preset);
        session.sessionPreset = preset;
    }
    else
        zlog(@"unable to set session preset=%@", preset);
}

- (void) loadView
{
    self.view = [[UIView alloc]
                    initWithFrame: CGRectMake(0, 0, 320, 480)];
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    UIView *view = self.view;
    view.backgroundColor = [UIColor blackColor];
    view.autoresizingMask =
        UIViewAutoresizingFlexibleWidth |
        UIViewAutoresizingFlexibleHeight;

    readerView = [[ZBarReaderView alloc]
                     initWithImageScanner: scanner];
    CGRect bounds = view.bounds;
    CGRect r = bounds;
    NSUInteger autoresize =
        UIViewAutoresizingFlexibleWidth |
        UIViewAutoresizingFlexibleHeight;

    if(showsZBarControls ||
       self.parentViewController.modalViewController == self)
    {
        autoresize |= UIViewAutoresizingFlexibleBottomMargin;
        r.size.height -= 54;
    }
    readerView.frame = r;
    readerView.autoresizingMask = autoresize;
    AVCaptureDevice *device = AVDeviceForUICamera(cameraDevice);
    if(device && device != readerView.device)
        readerView.device = device;
    readerView.torchMode = AVTorchModeForUIFlashMode(cameraFlashMode);
    [self initVideoQuality];

    readerView.readerDelegate = (id<ZBarReaderViewDelegate>)self;
    readerView.scanCrop = scanCrop;
    readerView.previewTransform = cameraViewTransform;
    readerView.tracksSymbols = tracksSymbols;
    readerView.enableCache = enableCache;
    [view addSubview: readerView];

    shutter = [[UIView alloc]
                  initWithFrame: r];
    shutter.backgroundColor = [UIColor blackColor];
    shutter.opaque = NO;
    shutter.autoresizingMask =
        UIViewAutoresizingFlexibleWidth |
        UIViewAutoresizingFlexibleHeight;
    [view addSubview: shutter];

    if(cameraOverlayView) {
        assert(!cameraOverlayView.superview);
        [cameraOverlayView removeFromSuperview];
        [view addSubview: cameraOverlayView];
    }

    [self initControls];

    if(TARGET_IPHONE_SIMULATOR) {
        cameraSim = [[ZBarCameraSimulator alloc]
                        initWithViewController: self];
        cameraSim.readerView = readerView;
    }
}

- (void) viewDidUnload
{
    [cameraOverlayView removeFromSuperview];
    [self cleanup];
    [super viewDidUnload];
}

- (void) viewWillAppear: (BOOL) animated
{
    zlog(@"willAppear: anim=%d orient=%d",
         animated, self.interfaceOrientation);
    [self initControls];
    [super viewWillAppear: animated];

    [readerView willRotateToInterfaceOrientation: self.interfaceOrientation
                duration: 0];
    [readerView performSelector: @selector(start)
                withObject: nil
                afterDelay: .001];
    shutter.alpha = 1;
    shutter.hidden = NO;

    UIApplication *app = [UIApplication sharedApplication];
    BOOL willHideStatusBar =
        !didHideStatusBar && self.wantsFullScreenLayout && !app.statusBarHidden;
    if(willHideStatusBar)
        [app setStatusBarHidden: YES
             withAnimation: UIStatusBarAnimationFade];
    didHideStatusBar = didHideStatusBar || willHideStatusBar;
}

- (void) dismissModalViewControllerAnimated: (BOOL) animated
{
    if(didHideStatusBar) {
        [[UIApplication sharedApplication]
            setStatusBarHidden: NO
            withAnimation: UIStatusBarAnimationFade];
        didHideStatusBar = NO;
    }
    [super dismissModalViewControllerAnimated: animated];
}

- (void) viewWillDisappear: (BOOL) animated
{
    readerView.captureReader.enableReader = NO;

    if(didHideStatusBar) {
        [[UIApplication sharedApplication]
            setStatusBarHidden: NO
            withAnimation: UIStatusBarAnimationFade];
        didHideStatusBar = NO;
    }

    [super viewWillDisappear: animated];
}

- (void) viewDidDisappear: (BOOL) animated
{
    // stopRunning can take a really long time (>1s observed),
    // so defer until the view transitions are complete
    [readerView stop];
}

- (BOOL) shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation) orient
{
    return((supportedOrientationsMask >> orient) & 1);
}

- (void) willRotateToInterfaceOrientation: (UIInterfaceOrientation) orient
                                 duration: (NSTimeInterval) duration
{
    zlog(@"willRotate: orient=%d #%g", orient, duration);
    rotating = YES;
    if(readerView)
        [readerView willRotateToInterfaceOrientation: orient
                    duration: duration];
}

- (void) willAnimateRotationToInterfaceOrientation: (UIInterfaceOrientation) orient
                                          duration: (NSTimeInterval) duration
{
    zlog(@"willAnimateRotation: orient=%d #%g", orient, duration);
    if(helpController)
        [helpController willAnimateRotationToInterfaceOrientation: orient
                        duration: duration];
    if(readerView)
        [readerView setNeedsLayout];
}

- (void) didRotateFromInterfaceOrientation: (UIInterfaceOrientation) orient
{
    zlog(@"didRotate(%d): orient=%d", rotating, orient);
    if(!rotating && readerView) {
        // work around UITabBarController bug: willRotate is not called
        // for non-portrait initial interface orientation
        [readerView willRotateToInterfaceOrientation: self.interfaceOrientation
                    duration: 0];
        [readerView setNeedsLayout];
    }
    rotating = NO;
}

- (ZBarReaderView*) readerView
{
    // force view to load
    (void)self.view;
    assert(readerView);
    return(readerView);
}

- (void) setTracksSymbols: (BOOL) track
{
    tracksSymbols = track;
    if(readerView)
        readerView.tracksSymbols = track;
}

- (void) setEnableCache: (BOOL) enable
{
    enableCache = enable;
    if(readerView)
        readerView.enableCache = enable;
}

- (void) setScanCrop: (CGRect) r
{
    scanCrop = r;
    if(readerView)
        readerView.scanCrop = r;
}

- (void) setCameraOverlayView: (UIView*) newview
{
    UIView *oldview = cameraOverlayView;
    [oldview removeFromSuperview];

    cameraOverlayView = [newview retain];
    if([self isViewLoaded] && newview)
        [self.view addSubview: newview];

    [oldview release];
}

- (void) setCameraViewTransform: (CGAffineTransform) xfrm
{
    cameraViewTransform = xfrm;
    if(readerView)
        readerView.previewTransform = xfrm;
}

- (void) cancel
{
    if(!readerDelegate)
        return;
    SEL cb = @selector(imagePickerControllerDidCancel:);
    if([readerDelegate respondsToSelector: cb])
        [readerDelegate
            imagePickerControllerDidCancel: (UIImagePickerController*)self];
    else
        [self dismissModalViewControllerAnimated: YES];
}

- (void) info
{
    [self showHelpWithReason: @"INFO"];
}

- (void) showHelpWithReason: (NSString*) reason
{
    if(helpController)
        return;
    helpController = [[ZBarHelpController alloc]
                         initWithReason: reason];
    helpController.delegate = (id<ZBarHelpDelegate>)self;
    helpController.wantsFullScreenLayout = YES;
    UIView *helpView = helpController.view;
    helpView.alpha = 0;
    helpView.frame = self.view.bounds;
    [helpController viewWillAppear: YES];
    [self.view addSubview: helpView];
    [UIView beginAnimations: @"ZBarHelp"
            context: nil];
    helpController.view.alpha = 1;
    [UIView commitAnimations];
}

- (void) takePicture
{
    if(TARGET_IPHONE_SIMULATOR) {
        [cameraSim takePicture];
        // FIXME return selected image
    }
    else if(readerView)
        [readerView.captureReader captureFrame];
}

- (void) setCameraDevice: (UIImagePickerControllerCameraDevice) camera
{
    cameraDevice = camera;
    if(readerView) {
        AVCaptureDevice *device = AVDeviceForUICamera(camera);
        if(device)
            readerView.device = device;
    }
}

- (void) setCameraFlashMode: (UIImagePickerControllerCameraFlashMode) mode
{
    cameraFlashMode = mode;
    if(readerView)
        readerView.torchMode = AVTorchModeForUIFlashMode(mode);
}

- (UIImagePickerControllerCameraCaptureMode) cameraCaptureMode
{
    return(UIImagePickerControllerCameraCaptureModeVideo);
}

- (void) setCameraCaptureMode: (UIImagePickerControllerCameraCaptureMode) mode
{
    NSAssert2(mode == UIImagePickerControllerCameraCaptureModeVideo,
              @"attempt to set unsupported value (%d)"
              @" for %@ property", mode, @"cameraCaptureMode");
}

- (void) setVideoQuality: (UIImagePickerControllerQualityType) quality
{
    videoQuality = quality;
    if(readerView)
        [self initVideoQuality];
}


// ZBarHelpDelegate

- (void) helpControllerDidFinish: (ZBarHelpController*) help
{
    assert(help == helpController);
    [help viewWillDisappear: YES];
    [UIView beginAnimations: @"ZBarHelp"
            context: NULL];
    [UIView setAnimationDelegate: self];
    [UIView setAnimationDidStopSelector: @selector(removeHelp:done:context:)];
    help.view.alpha = 0;
    [UIView commitAnimations];
}

- (void) removeHelp: (NSString*) tag
               done: (NSNumber*) done
            context: (void*) ctx
{
    if([tag isEqualToString: @"ZBarHelp"] && helpController) {
        [helpController.view removeFromSuperview];
        [helpController release];
        helpController = nil;
    }
}


// ZBarReaderViewDelegate

- (void) readerView: (ZBarReaderView*) readerView
     didReadSymbols: (ZBarSymbolSet*) syms
          fromImage: (UIImage*) image
{
    [readerDelegate
        imagePickerController: (UIImagePickerController*)self
        didFinishPickingMediaWithInfo:
            [NSDictionary dictionaryWithObjectsAndKeys:
                image, UIImagePickerControllerOriginalImage,
                syms, ZBarReaderControllerResults,
                nil]];
}

- (void) readerViewDidStart: (ZBarReaderView*) readerView
{
    if(!shutter.hidden)
        [UIView animateWithDuration: .25
                animations: ^{
                    shutter.alpha = 0;
                }
                completion: ^(BOOL finished) {
                    shutter.hidden = YES;
                }];
}


// "deprecated" properties

#define DEPRECATED_PROPERTY(getter, setter, type, val, ignore) \
    - (type) getter                                    \
    {                                                  \
        return(val);                                   \
    }                                                  \
    - (void) setter: (type) v                          \
    {                                                  \
        NSAssert2(ignore || v == val,                  \
                  @"attempt to set unsupported value (%d)" \
                  @" for %@ property", val, @#getter); \
    }

DEPRECATED_PROPERTY(sourceType, setSourceType, UIImagePickerControllerSourceType, UIImagePickerControllerSourceTypeCamera, NO)
DEPRECATED_PROPERTY(allowsEditing, setAllowsEditing, BOOL, NO, NO)
DEPRECATED_PROPERTY(allowsImageEditing, setAllowsImageEditing, BOOL, NO, NO)
DEPRECATED_PROPERTY(showsCameraControls, setShowsCameraControls, BOOL, NO, NO)
DEPRECATED_PROPERTY(showsHelpOnFail, setShowsHelpOnFail, BOOL, NO, YES)
DEPRECATED_PROPERTY(cameraMode, setCameraMode, ZBarReaderControllerCameraMode, ZBarReaderControllerCameraModeSampling, NO)
DEPRECATED_PROPERTY(takesPicture, setTakesPicture, BOOL, NO, NO)
DEPRECATED_PROPERTY(maxScanDimension, setMaxScanDimension, NSInteger, 640, YES)

@end
