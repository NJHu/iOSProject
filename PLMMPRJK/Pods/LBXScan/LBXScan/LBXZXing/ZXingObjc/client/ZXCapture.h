/*
 * Copyright 2012 ZXing authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import <AVFoundation/AVFoundation.h>

@protocol ZXCaptureDelegate, ZXReader;
@class ZXDecodeHints;

@interface ZXCapture : NSObject <AVCaptureVideoDataOutputSampleBufferDelegate, CAAction>

@property (nonatomic, assign) int camera;
@property (nonatomic, strong) AVCaptureDevice *captureDevice;
@property (nonatomic, copy) NSString *captureToFilename;
@property (nonatomic, weak) id<ZXCaptureDelegate> delegate;
@property (nonatomic, assign) AVCaptureFocusMode focusMode;
@property (nonatomic, strong) ZXDecodeHints *hints;
@property (nonatomic, assign) CGImageRef lastScannedImage;
@property (nonatomic, assign) BOOL invert;
@property (nonatomic, strong, readonly) CALayer *layer;
@property (nonatomic, assign) BOOL mirror;
@property (nonatomic, strong, readonly) AVCaptureVideoDataOutput *output;
@property (nonatomic, strong) id<ZXReader> reader;
@property (nonatomic, assign) CGFloat rotation;
@property (nonatomic, assign, readonly) BOOL running;
@property (nonatomic, assign) CGRect scanRect;
@property (nonatomic, copy) NSString *sessionPreset;
@property (nonatomic, assign) BOOL torch;
@property (nonatomic, assign) CGAffineTransform transform;

- (int)back;
- (int)front;
- (BOOL)hasBack;
- (BOOL)hasFront;
- (BOOL)hasTorch;

- (CALayer *)binary;
- (void)setBinary:(BOOL)on_off;

- (CALayer *)luminance;
- (void)setLuminance:(BOOL)on_off;

- (void)hard_stop;
- (void)order_skip;
- (void)start;
- (void)stop;

@end
