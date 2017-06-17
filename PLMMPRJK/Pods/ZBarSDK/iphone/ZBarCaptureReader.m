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

#import <libkern/OSAtomic.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
#import <CoreVideo/CoreVideo.h>
#import <ZBarSDK/ZBarCaptureReader.h>
#import <ZBarSDK/ZBarImageScanner.h>
#import "ZBarCVImage.h"

#define MODULE ZBarCaptureReader
#import "debug.h"

enum {
    STOPPED = 0,
    RUNNING = 1,
    PAUSED = 2,
    CAPTURE = 4,
};

@implementation ZBarCaptureReader

@synthesize captureOutput, captureDelegate, scanner, scanCrop, size,
    framesPerSecond, enableCache;
@dynamic enableReader;

- (void) initResult
{
    [result release];
    result = [ZBarCVImage new];
    result.format = [ZBarImage fourcc: @"CV2P"];
}

- (id) initWithImageScanner: (ZBarImageScanner*) _scanner
{
    self = [super init];
    if(!self)
        return(nil);

    t_fps = t_frame = timer_now();
    enableCache = YES;

    scanner = [_scanner retain];
    scanCrop = CGRectMake(0, 0, 1, 1);
    image = [ZBarImage new];
    image.format = [ZBarImage fourcc: @"Y800"];
    [self initResult];

    captureOutput = [AVCaptureVideoDataOutput new];
    captureOutput.alwaysDiscardsLateVideoFrames = YES;

#ifdef FIXED_8697526
    /* iOS 4.2 introduced a bug that causes [session startRunning] to
     * hang if the session has a preview layer and this property is
     * specified at the output.  As this happens to be the default
     * setting for the currently supported devices, it can be omitted
     * without causing a functional problem (for now...).  Of course,
     * we still have no idea what the real problem is, or how robust
     * this is as a workaround...
     */
    captureOutput.videoSettings = 
        [NSDictionary
            dictionaryWithObject:
                [NSNumber numberWithInt:
                    kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange]
            forKey: (NSString*)kCVPixelBufferPixelFormatTypeKey];
#endif

    queue = dispatch_queue_create("ZBarCaptureReader", NULL);
    [captureOutput setSampleBufferDelegate:
                       (id<AVCaptureVideoDataOutputSampleBufferDelegate>)self
                   queue: queue];

    return(self);
}

- (id) init
{
    self = [self initWithImageScanner:
               [[ZBarImageScanner new]
                   autorelease]];
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

- (void) dealloc
{
    captureDelegate = nil;

    // queue continues to run after stopping (NB even after DidStopRunning!);
    // ensure released delegate is not called. (also NB that the queue
    // may not be null, even in this case...)
    [captureOutput setSampleBufferDelegate: nil
                   queue: queue];
    [captureOutput release];
    captureOutput = nil;
    dispatch_release(queue);

    [image release];
    image = nil;
    [result release];
    result = nil;
    [scanner release];
    scanner = nil;
    [super dealloc];
}

- (BOOL) enableReader
{
    return(OSAtomicOr32Barrier(0, &state) & RUNNING);
}

- (void) setEnableReader: (BOOL) enable
{
    if(!enable)
        OSAtomicAnd32Barrier(STOPPED, &state);
    else if(!(OSAtomicOr32OrigBarrier(RUNNING, &state) & RUNNING)) {
        OSAtomicAnd32Barrier(~PAUSED, &state);
        @synchronized(scanner) {
            scanner.enableCache = enableCache;
        }
    }
}

- (void) willStartRunning
{
    self.enableReader = YES;
}

- (void) willStopRunning
{
    self.enableReader = NO;
}

- (void) flushCache
{
    @synchronized(scanner) {
        scanner.enableCache = enableCache;
    }
}

- (void) captureFrame
{
    OSAtomicOr32(CAPTURE, &state);
}

- (void) setCaptureDelegate: (id<ZBarCaptureDelegate>) delegate
{
    @synchronized(scanner) {
        captureDelegate = delegate;
    }
}

- (void) cropUpdate
{
    @synchronized(scanner) {
        image.crop = CGRectMake(scanCrop.origin.x * width,
                                scanCrop.origin.y * height,
                                scanCrop.size.width * width,
                                scanCrop.size.height * height);
    }
}

- (void) setScanCrop: (CGRect) crop
{
    if(CGRectEqualToRect(scanCrop, crop))
        return;
    scanCrop = crop;
    [self cropUpdate];
}

- (void) didTrackSymbols: (ZBarSymbolSet*) syms
{
    [captureDelegate
        captureReader: self
        didTrackSymbols: syms];
}

- (void) didReadNewSymbolsFromImage: (ZBarImage*) img
{
    timer_start;
    [captureDelegate
        captureReader: self
        didReadNewSymbolsFromImage: img];
    OSAtomicAnd32Barrier(~PAUSED, &state);
    zlog(@"latency: delegate=%gs total=%gs",
         timer_elapsed(t_start, timer_now()),
         timer_elapsed(t_scan, timer_now()));
}

- (void) setFramesPerSecond: (CGFloat) fps
{
    framesPerSecond = fps;
}

- (void) updateFPS: (NSNumber*) val
{
    [self setFramesPerSecond: val.doubleValue];
}

- (void) setSize: (CGSize) _size
{
    size = _size;
}

- (void) updateSize: (CFDictionaryRef) val
{
    CGSize _size;
    if(CGSizeMakeWithDictionaryRepresentation(val, &_size))
        [self setSize: _size];
}

- (void)  captureOutput: (AVCaptureOutput*) output
  didOutputSampleBuffer: (CMSampleBufferRef) samp
         fromConnection: (AVCaptureConnection*) conn
{
    // queue is apparently not flushed when stopping;
    // only process when running
    uint32_t _state = OSAtomicOr32Barrier(0, &state);
    if((_state & (PAUSED | RUNNING)) != RUNNING)
        return;

    NSAutoreleasePool *pool = [NSAutoreleasePool new];
    image.sequence = framecnt++;

    uint64_t now = timer_now();
    double dt = timer_elapsed(t_frame, now);
    t_frame = now;
    if(dt > 2) {
        t_fps = now;
        dt_frame = 0;
    }
    else if(!dt_frame)
        dt_frame = dt;
    dt_frame = (dt_frame + dt) / 2;
    if(timer_elapsed(t_fps, now) >= 1) {
        [self performSelectorOnMainThread: @selector(updateFPS:)
              withObject: [NSNumber numberWithDouble: 1 / dt_frame]
              waitUntilDone: NO];
        t_fps = now;
    }

    CVImageBufferRef buf = CMSampleBufferGetImageBuffer(samp);
    if(CMSampleBufferGetNumSamples(samp) != 1 ||
       !CMSampleBufferIsValid(samp) ||
       !CMSampleBufferDataIsReady(samp) ||
       !buf) {
        zlog(@"ERROR: invalid sample");
        goto error;
    }

    OSType format = CVPixelBufferGetPixelFormatType(buf);
    int planes = CVPixelBufferGetPlaneCount(buf);

    if(format != kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange ||
       !planes) {
        zlog(@"ERROR: invalid buffer format");
        goto error;
    }

    int w = CVPixelBufferGetBytesPerRowOfPlane(buf, 0);
    int h = CVPixelBufferGetHeightOfPlane(buf, 0);
    CVReturn rc =
        CVPixelBufferLockBaseAddress(buf, kCVPixelBufferLock_ReadOnly);
    if(!w || !h || rc) {
        zlog(@"ERROR: invalid buffer data");
        goto error;
    }

    void *data = CVPixelBufferGetBaseAddressOfPlane(buf, 0);
    if(data) {
        [image setData: data
               withLength: w * h];

        BOOL doTrack = NO;
        int ngood = 0;
        ZBarSymbolSet *syms = nil;
        @synchronized(scanner) {
            if(width != w || height != h) {
                width = w;
                height = h;
                CGSize _size = CGSizeMake(w, h);
                CFDictionaryRef sized =
                    CGSizeCreateDictionaryRepresentation(_size);
                if(sized) {
                    [self performSelectorOnMainThread: @selector(updateSize:)
                          withObject: (id)sized
                          waitUntilDone: NO];
                    CFRelease(sized);
                }
                image.size = _size;
                [self cropUpdate];
            }

            ngood = [scanner scanImage: image];
            syms = scanner.results;
            doTrack = [captureDelegate respondsToSelector:
                          @selector(captureReader:didTrackSymbols:)];
        }
        now = timer_now();

        if(ngood >= 0) {
            // return unfiltered results for tracking feedback
            syms.filterSymbols = NO;
            int nraw = syms.count;
            if(nraw > 0 || (_state & CAPTURE))
                zlog(@"scan image: %dx%d crop=%@ ngood=%d nraw=%d st=%d",
                     w, h, NSStringFromCGRect(image.crop), ngood, nraw, _state);

            if(ngood || (_state & CAPTURE)) {
                // copy image data so we can release the buffer
                result.size = CGSizeMake(w, h);
                result.pixelBuffer = buf;
                result.symbols = syms;
                t_scan = now;
                OSAtomicXor32Barrier((_state & CAPTURE) | PAUSED, &state);
                [self performSelectorOnMainThread:
                          @selector(didReadNewSymbolsFromImage:)
                      withObject: result
                      waitUntilDone: NO];
                [self initResult];
            }

            if(nraw && doTrack)
                [self performSelectorOnMainThread:
                          @selector(didTrackSymbols:)
                      withObject: syms
                      waitUntilDone: NO];
        }
        [image setData: NULL
               withLength: 0];
    }
    else
        zlog(@"ERROR: invalid data");
    CVPixelBufferUnlockBaseAddress(buf, kCVPixelBufferLock_ReadOnly);

 error:
    [pool release];
}

@end
