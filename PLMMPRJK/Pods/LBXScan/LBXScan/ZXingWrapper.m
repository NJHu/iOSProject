//
//  ZXingWrapper.m
//
//
//  Created by lbxia on 15/1/6.
//  Copyright (c) 2015年 lbxia. All rights reserved.
//

#import "ZXingWrapper.h"
#import "ZXingObjC.h"
#import "LBXZXCaptureDelegate.h"
#import "LBXZXCapture.h"


typedef void(^blockScan)(ZXBarcodeFormat barcodeFormat,NSString *str,UIImage *scanImg);

@interface ZXingWrapper() <LBXZXCaptureDelegate>
@property (nonatomic, strong) LBXZXCapture *capture;

@property (nonatomic,copy)blockScan block;

@property (nonatomic, assign) BOOL bNeedScanResult;

@end

@implementation ZXingWrapper


- (id)init
{
    if ( self = [super init] )
    {
        self.capture = [[LBXZXCapture alloc] init];
        self.capture.camera = self.capture.back;
        self.capture.focusMode = AVCaptureFocusModeContinuousAutoFocus;
        self.capture.rotation = 90.0f;
        
        self.capture.delegate = self;
    }
    return self;
}

- (id)initWithPreView:(UIView*)preView block:(void(^)(ZXBarcodeFormat barcodeFormat,NSString *str,UIImage *scanImg))block
{
    if (self = [super init]) {
        
        self.capture = [[LBXZXCapture alloc] init];
        self.capture.camera = self.capture.back;
        self.capture.focusMode = AVCaptureFocusModeContinuousAutoFocus;
        self.capture.rotation = 90.0f;
        
        self.capture.delegate = self;
        
        self.block = block;
        
        CGRect rect = preView.frame;
        rect.origin = CGPointZero;
        
        self.capture.layer.frame = rect;
        //[preView.layer addSublayer:self.capture.layer];
        
        [preView.layer insertSublayer:self.capture.layer atIndex:0];
        
        
    }
    return self;
}

- (void)setScanRect:(CGRect)scanRect
{
    self.capture.scanRect = scanRect;
}

- (void)start
{
    [self.capture start];
    self.bNeedScanResult = YES;
}

- (void)stop
{
    self.bNeedScanResult = NO;
    [self.capture stop];
    
}

- (void)openTorch:(BOOL)on_off
{
    [self.capture setTorch:on_off];
}
- (void)openOrCloseTorch
{
    [self.capture changeTorch];
}


#pragma mark - ZXCaptureDelegate Methods

- (void)captureResult:(ZXCapture *)capture result:(ZXResult *)result scanImage:(UIImage *)img {
    if (!result) return;
    
    if (!_bNeedScanResult) {
        
        return;
    }
    
    if ( _block )
    {
        [self stop];
        
        _block(result.barcodeFormat,result.text,img);
    }    
}


+ (UIImage*)createCodeWithString:(NSString*)str size:(CGSize)size CodeFomart:(ZXBarcodeFormat)format
{
    ZXMultiFormatWriter *writer = [[ZXMultiFormatWriter alloc] init];
    ZXBitMatrix *result = [writer encode:str
                                  format:format
                                   width:size.width
                                  height:size.width
                                   error:nil];
    
    if (result) {
        ZXImage *image = [ZXImage imageWithMatrix:result];
        return [UIImage imageWithCGImage:image.cgimage];
    } else {
        return nil;
    }
}


+ (void)recognizeImage:(UIImage*)image block:(void(^)(ZXBarcodeFormat barcodeFormat,NSString *str))block;
{
    ZXCGImageLuminanceSource *source = [[ZXCGImageLuminanceSource alloc] initWithCGImage:image.CGImage];
    
    ZXHybridBinarizer *binarizer = [[ZXHybridBinarizer alloc] initWithSource: source];
    
    ZXBinaryBitmap *bitmap = [[ZXBinaryBitmap alloc] initWithBinarizer:binarizer];
    
    NSError *error;
    
    id<ZXReader> reader;
    
    if (NSClassFromString(@"ZXMultiFormatReader")) {
        reader = [NSClassFromString(@"ZXMultiFormatReader") performSelector:@selector(reader)];
    }
    
    ZXDecodeHints *_hints = [ZXDecodeHints hints];
    ZXResult *result = [reader decode:bitmap hints:_hints error:&error];
    
    if (result == nil) {
        
        block(kBarcodeFormatQRCode,nil);
        return;
    }
    
    block(result.barcodeFormat,result.text);
}




@end
