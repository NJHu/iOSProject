


#import "LBXScanNative.h"


@interface LBXScanNative()<AVCaptureMetadataOutputObjectsDelegate>
{
    BOOL bNeedScanResult;
}

@property (assign,nonatomic)AVCaptureDevice * device;
@property (strong,nonatomic)AVCaptureDeviceInput * input;
@property (strong,nonatomic)AVCaptureMetadataOutput * output;
@property (strong,nonatomic)AVCaptureSession * session;
@property (strong,nonatomic)AVCaptureVideoPreviewLayer * preview;

@property(nonatomic,strong)  AVCaptureStillImageOutput *stillImageOutput;//拍照

@property(nonatomic,assign)BOOL isNeedCaputureImage;

//扫码结果
@property (nonatomic, strong) NSMutableArray<LBXScanResult*> *arrayResult;

//扫码类型
@property (nonatomic, strong) NSArray* arrayBarCodeType;

/**
 @brief  视频预览显示视图
 */
@property (nonatomic,weak)UIView *videoPreView;


/*!
 *  扫码结果返回
 */
@property(nonatomic,copy)void (^blockScanResult)(NSArray<LBXScanResult*> *array);



@end

@implementation LBXScanNative


- (void)setNeedCaptureImage:(BOOL)isNeedCaputureImg
{
    _isNeedCaputureImage = isNeedCaputureImg;
}

- (id)initWithPreView:(UIView*)preView ObjectType:(NSArray*)objType cropRect:(CGRect)cropRect success:(void(^)(NSArray<LBXScanResult*> *array))block
{
    if (self = [super init]) {
     
        [self initParaWithPreView:preView ObjectType:objType cropRect:cropRect success:block];
    }
    
    return self;
}


- (void)initParaWithPreView:(UIView*)videoPreView ObjectType:(NSArray*)objType cropRect:(CGRect)cropRect success:(void(^)(NSArray<LBXScanResult*> *array))block
{
    self.arrayBarCodeType = objType;
    self.blockScanResult = block;
    self.videoPreView = videoPreView;
    
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    if (!_device) {
        return;
    }
    
    // Input
    _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    if ( !_input  )
        return ;
    
    
    bNeedScanResult = YES;
    
    // Output
    _output = [[AVCaptureMetadataOutput alloc]init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    
    if ( !CGRectEqualToRect(cropRect,CGRectZero) )
    {
        _output.rectOfInterest = cropRect;
    }
    
    /*
    // Setup the still image file output
     */
    
    
    _stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:
                                    AVVideoCodecJPEG, AVVideoCodecKey,
                                    nil];
    [_stillImageOutput setOutputSettings:outputSettings];
    
    // Session
    _session = [[AVCaptureSession alloc]init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    
   // _session.
    
   // videoScaleAndCropFactor
    
    if ([_session canAddInput:_input])
    {
        [_session addInput:_input];
    }
    
    if ([_session canAddOutput:_output])
    {
        [_session addOutput:_output];
    }

    if ([_session canAddOutput:_stillImageOutput])
    {
        [_session addOutput:_stillImageOutput];
    }
    
 
 
    
    // 条码类型 AVMetadataObjectTypeQRCode
   // _output.metadataObjectTypes =@[AVMetadataObjectTypeQRCode];
    
    if (!objType) {
        objType = [self defaultMetaDataObjectTypes];
    }
    
    _output.metadataObjectTypes = objType;
    
    // Preview
    _preview =[AVCaptureVideoPreviewLayer layerWithSession:_session];
    _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
    //_preview.frame =CGRectMake(20,110,280,280);
    
    CGRect frame = videoPreView.frame;
    frame.origin = CGPointZero;
    _preview.frame = frame;
    
    [videoPreView.layer insertSublayer:self.preview atIndex:0];
    
 
    
//    AVCaptureConnection *videoConnection = [AVCamUtilities connectionWithMediaType:AVMediaTypeVideo fromConnections:[[self stillImageOutput] connections]];
//    CGFloat maxScale = videoConnection.videoMaxScaleAndCropFactor;
//    CGFloat zoom = maxScale / 50;
//    if (zoom < 1.0f || zoom > maxScale)
//    {
//        return;
//    }
//    videoConnection.videoScaleAndCropFactor += zoom;
//    CGAffineTransform transform = videoPreView.transform;
//    videoPreView.transform = CGAffineTransformScale(transform, zoom, zoom);

    
    
    //先进行判断是否支持控制对焦,不开启自动对焦功能，很难识别二维码。
    if (_device.isFocusPointOfInterestSupported &&[_device isFocusModeSupported:AVCaptureFocusModeAutoFocus])
    {
        [_input.device lockForConfiguration:nil];
        [_input.device setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
        [_input.device unlockForConfiguration];
    }
}


- (void)setScanRect:(CGRect)scanRect
{
    //识别区域设置
    if (_output) {
        _output.rectOfInterest = [self.preview metadataOutputRectOfInterestForRect:scanRect];
    }
    
}

- (void)changeScanType:(NSArray*)objType
{    
    _output.metadataObjectTypes = objType;
}

- (void)startScan
{
    if ( _input && !_session.isRunning )
    {
        [_session startRunning];
        bNeedScanResult = YES;
        
        [_videoPreView.layer insertSublayer:self.preview atIndex:0];
        
       // [_input.device addObserver:self forKeyPath:@"torchMode" options:0 context:nil];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ( object == _input.device ) {
        
        NSLog(@"flash change");
    }
}

- (void)stopScan
{
    if ( _input && _session.isRunning )
    {
        bNeedScanResult = NO;
        [_session stopRunning];
        
       // [self.preview removeFromSuperlayer];
    }
}

- (void)setTorch:(BOOL)torch {   
    
    [self.input.device lockForConfiguration:nil];
    self.input.device.torchMode = torch ? AVCaptureTorchModeOn : AVCaptureTorchModeOff;
    [self.input.device unlockForConfiguration];
}

- (void)changeTorch
{
    AVCaptureTorchMode torch = self.input.device.torchMode;
   
    switch (_input.device.torchMode) {
        case AVCaptureTorchModeAuto:
            break;
        case AVCaptureTorchModeOff:
            torch = AVCaptureTorchModeOn;
            break;
        case AVCaptureTorchModeOn:
            torch = AVCaptureTorchModeOff;
            break;
        default:
            break;
    }
    
    [_input.device lockForConfiguration:nil];
    _input.device.torchMode = torch;
    [_input.device unlockForConfiguration];
}


-(UIImage *)getImageFromLayer:(CALayer *)layer{
    
    //CGSize size = layer.frame.size;
    
    UIGraphicsBeginImageContext(layer.frame.size);
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (AVCaptureConnection *)connectionWithMediaType:(NSString *)mediaType fromConnections:(NSArray *)connections
{
    for ( AVCaptureConnection *connection in connections ) {
        for ( AVCaptureInputPort *port in [connection inputPorts] ) {
            if ( [[port mediaType] isEqual:mediaType] ) {
                return connection;
            }
        }
    }
    return nil;
}

- (void)captureImage
{
    AVCaptureConnection *stillImageConnection = [self connectionWithMediaType:AVMediaTypeVideo fromConnections:[[self stillImageOutput] connections]];
    
    
    [[self stillImageOutput] captureStillImageAsynchronouslyFromConnection:stillImageConnection
                                                         completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error)
     {
         [self stopScan];
         
         if (imageDataSampleBuffer)
         {
             NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
             
             UIImage *img = [UIImage imageWithData:imageData];
            
             if (_blockScanResult)
             {
                 for (LBXScanResult* result in _arrayResult) {
                     
                     result.imgScanned = img;
                 }
                 
                 _blockScanResult(_arrayResult);
             }
             
             
         }
         else
         {
             if (_blockScanResult)
             {
                 _blockScanResult(_arrayResult);
             }
         }
     }];
}


#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput2:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
   
    
    //识别扫码类型
    for(AVMetadataObject *current in metadataObjects)
    {
        if ([current isKindOfClass:[AVMetadataMachineReadableCodeObject class]] )
        {
            
            NSString *scannedResult = [(AVMetadataMachineReadableCodeObject *) current stringValue];
            NSLog(@"type:%@",current.type);
            NSLog(@"result:%@",scannedResult);
            
            
            
         
            
            //测试可以同时识别多个二维码
        }
    }
    
   
    
}
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if (!bNeedScanResult) {
        return;
    }
    
    if (!_arrayResult) {
        
        self.arrayResult = [NSMutableArray arrayWithCapacity:1];
    }
    else
    {
        [_arrayResult removeAllObjects];
    }
    
    //识别扫码类型
    for(AVMetadataObject *current in metadataObjects)
    {
        if ([current isKindOfClass:[AVMetadataMachineReadableCodeObject class]] )
        {
            bNeedScanResult = NO;
            
            NSLog(@"type:%@",current.type);
            NSString *scannedResult = [(AVMetadataMachineReadableCodeObject *) current stringValue];
            
            LBXScanResult *result = [LBXScanResult new];
            result.strScanned = scannedResult;
            result.strBarCodeType = current.type;
            
            [_arrayResult addObject:result];
            
            //测试可以同时识别多个二维码
        }
    }
    
    if (_isNeedCaputureImage)
    {
        [self captureImage];
    }
    else
    {
        [self stopScan];
        
        if (_blockScanResult) {
            _blockScanResult(_arrayResult);
        }
    }
    
}


/**
 @brief  默认支持码的类别
 @return 支持类别 数组
 */
- (NSArray *)defaultMetaDataObjectTypes
{
    NSMutableArray *types = [@[AVMetadataObjectTypeQRCode,
                               AVMetadataObjectTypeUPCECode,
                               AVMetadataObjectTypeCode39Code,
                               AVMetadataObjectTypeCode39Mod43Code,
                               AVMetadataObjectTypeEAN13Code,
                               AVMetadataObjectTypeEAN8Code,
                               AVMetadataObjectTypeCode93Code,
                               AVMetadataObjectTypeCode128Code,
                               AVMetadataObjectTypePDF417Code,
                               AVMetadataObjectTypeAztecCode] mutableCopy];
    
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_7_1)
    {
        [types addObjectsFromArray:@[
                                     AVMetadataObjectTypeInterleaved2of5Code,
                                     AVMetadataObjectTypeITF14Code,
                                     AVMetadataObjectTypeDataMatrixCode
                                     ]];
    }
    
    return types;
}



@end
