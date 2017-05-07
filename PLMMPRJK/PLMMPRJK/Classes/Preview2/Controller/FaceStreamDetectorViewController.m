//
//  FaceStreamDetectorViewController.m
//  IFlyFaceDemo
//
//  Created by pro－cookie on 16/7/21.
//  Copyright (c) 2016年 pro－cookie. All rights reserved.
//

#import "FaceStreamDetectorViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <QuartzCore/QuartzCore.h>
#import "PermissionDetector.h"
#import "UIImage+Extensions.h"
#import "UIImage+compress.h"
#import "iflyMSC/IFlyFaceSDK.h"
//#import "DemoPreDefine.h"
#import "CaptureManager.h"
#import "CanvasView.h"
#import "CalculatorTools.h"
#import "UIImage+Extensions.h"
#import "IFlyFaceImage.h"
#import "IFlyFaceResultKeys.h"

@interface FaceStreamDetectorViewController ()<CaptureManagerDelegate,CaptureNowImageDelegate,IFlyFaceRequestDelegate>
{
    UILabel *alignLabel;
    int number;//
    int takePhotoNumber;
    NSTimer *timer;
    NSInteger timeCount;
    //拍照操作
    UIView *backView;//照片背景 拍好的照片展示在这个上面
    UIImageView *imageView;//照片展示 拍好的照片
    
    BOOL isCrossBorder;//判断是否越界
}
@property (nonatomic, retain ) UIView         *previewView;
@property (nonatomic, strong ) UILabel        *textLabel;

@property (nonatomic, retain ) AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic, retain ) CaptureManager             *captureManager;

@property (nonatomic, retain ) IFlyFaceDetector           *faceDetector;
@property (nonatomic, strong ) CanvasView                 *viewCanvas;
@property (nonatomic, strong ) UITapGestureRecognizer     *tapGesture;
#pragma mark --------检测需要的属性和
@property (copy, nonatomic) NSString *resultStings;
@property (nonatomic, strong) IFlyFaceRequest * iFlySpFaceRequest; // 人脸识别请求

#pragma mark ------------------------------------
@end

@implementation FaceStreamDetectorViewController
@synthesize captureManager;

+ (void)initialize
{
#pragma mark --- 配置文件
    //设置log等级，此处log为默认在app沙盒目录下的msc.log文件
    [IFlySetting setLogFile:LVL_ALL];
    
    //输出在console的log开关
    [IFlySetting showLogcat:YES];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [paths objectAtIndex:0];
    //设置msc.log的保存路径
    [IFlySetting setLogFilePath:cachePath];
    
    //创建语音配置,appid必须要传入，仅执行一次则可
    NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@,",USER_APPID];
    
    //所有服务启动前，需要确保执行createUtility
    [IFlySpeechUtility createUtility:initString];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.fd_interactivePopDisabled = YES;
    self.view.backgroundColor = [UIColor whiteColor];
#pragma mark--------------------------
    self.iFlySpFaceRequest=[IFlyFaceRequest sharedInstance]; // 单例初始化
    [self.iFlySpFaceRequest setDelegate:self]; // 设置代理
    self.resultStings=[[NSString alloc] init]; // 初始化容器
#pragma mark -------------------------
    //创建界面
    [self makeUI];
    //创建摄像页面
    [self makeCamera];
    //创建数据
    [self makeNumber];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //停止摄像
    [self.previewLayer.session stopRunning];
    [self.captureManager removeObserver];
}

-(void)makeNumber
{
    //数据
    number = 0;
    takePhotoNumber = 0;
}

#pragma mark --- 创建UI界面
-(void)makeUI
{
    self.previewView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight*2/3)]; // 上面摄像显示区域
    [self.view addSubview:self.previewView];
    
    self.textLabel = [[UILabel alloc]initWithFrame:CGRectMake((ScreenWidth-200)/2, CGRectGetMaxY(self.previewView.frame)+10, 200, 30)];
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    self.textLabel.layer.cornerRadius = 15;
    self.textLabel.text = @"请按提示做动作";
    self.textLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:self.textLabel]; // 下面的提示文字
    
    //背景View
    backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64)];
    backView.backgroundColor = [UIColor redColor];
    
    //图片放置View
    imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 10, ScreenWidth, ScreenWidth*4/3)];
    imageView.backgroundColor = [UIColor redColor];
    [backView addSubview:imageView];
    
}

#pragma mark --- 创建相机
-(void)makeCamera
{
    switch (self.isController) {
        case NSTypePaiZhao:
            self.title = @"人脸\"识别\"";
            break;
            
        case NSTypeYanZhen:
            self.title = @"人脸\"验证\"";
            break;
            
        default:
            break;
    }
    //adjust the UI for iOS 7 这个在face里面有记录，只是一些参数设置
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    if ( [[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending ){
        self.edgesForExtendedLayout = UIRectEdgeNone; //屏幕边界设置
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO; //拍照的时候状态栏
        self.navigationController.navigationBar.translucent = NO;
    }
#endif
    
    self.view.backgroundColor=[UIColor blackColor];
    self.previewView.backgroundColor=[UIColor clearColor];
    
    //设置初始化打开识别
    self.faceDetector=[IFlyFaceDetector sharedInstance];
    [self.faceDetector setParameter:@"1" forKey:@"detect"]; // 暂时没看到
    [self.faceDetector setParameter:@"1" forKey:@"align"]; // 1为把绿点点打开
    
    //初始化 CaptureSessionManager
    self.captureManager=[[CaptureManager alloc] init];
    self.captureManager.capturedelegate=self;
    
    self.previewLayer=self.captureManager.previewLayer;
    
    self.captureManager.previewLayer.frame= self.previewView.frame;
    self.captureManager.previewLayer.position=self.previewView.center;
    self.captureManager.previewLayer.videoGravity=AVLayerVideoGravityResizeAspectFill;
    [self.previewView.layer addSublayer:self.captureManager.previewLayer];
    
    self.viewCanvas = [[CanvasView alloc] initWithFrame:self.captureManager.previewLayer.frame] ;
    [self.previewView addSubview:self.viewCanvas] ;
    self.viewCanvas.center=self.captureManager.previewLayer.position;
    self.viewCanvas.backgroundColor = [UIColor clearColor];
    NSString *str = [NSString stringWithFormat:@"{{%f, %f}, {220, 240}}",(ScreenWidth-220)/2,(ScreenWidth-240)/2+15];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setObject:str forKey:@"RECT_KEY"];
    [dic setObject:@"1" forKey:@"RECT_ORI"];
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    [arr addObject:dic];
    self.viewCanvas.arrFixed = arr;
    self.viewCanvas.hidden = NO;
    
    //开始摄像
    [self.captureManager setup];
    [self.captureManager addObserver];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    [self.captureManager observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

#pragma mark - 开启识别
- (void) showFaceLandmarksAndFaceRectWithPersonsArray:(NSMutableArray *)arrPersons
{
    if (self.viewCanvas.hidden) {
        self.viewCanvas.hidden = NO;
    }
    self.viewCanvas.arrPersons = arrPersons;
    [self.viewCanvas setNeedsDisplay] ;
}

#pragma mark --- 关闭识别
- (void) hideFace
{
    if (!self.viewCanvas.hidden) {
        self.viewCanvas.hidden = YES ;
    }
}

#pragma mark --- 脸部框识别
-(NSString*)praseDetect:(NSDictionary* )positionDic OrignImage:(IFlyFaceImage*)faceImg
{
    if(!positionDic){
        return nil;
    }
    
    // 判断摄像头方向
    BOOL isFrontCamera=self.captureManager.videoDeviceInput.device.position==AVCaptureDevicePositionFront;
    
    // scale coordinates so they fit in the preview box, which may be scaled
    CGFloat widthScaleBy = self.previewLayer.frame.size.width / faceImg.height;
    CGFloat heightScaleBy = self.previewLayer.frame.size.height / faceImg.width;
    
    CGFloat bottom =[[positionDic objectForKey:KCIFlyFaceResultBottom] floatValue];
    CGFloat top=[[positionDic objectForKey:KCIFlyFaceResultTop] floatValue];
    CGFloat left=[[positionDic objectForKey:KCIFlyFaceResultLeft] floatValue];
    CGFloat right=[[positionDic objectForKey:KCIFlyFaceResultRight] floatValue];
    
    float cx = (left+right)/2;
    float cy = (top + bottom)/2;
    float w = right - left;
    float h = bottom - top;
    
    float ncx = cy ;
    float ncy = cx ;
    
    CGRect rectFace = CGRectMake(ncx-w/2 ,ncy-w/2 , w, h);
    
    if(!isFrontCamera){
        rectFace=rSwap(rectFace);
        rectFace=rRotate90(rectFace, faceImg.height, faceImg.width);
    }
    
    //判断位置
    BOOL isNotLocation = [self identifyYourFaceLeft:left right:right top:top bottom:bottom];
    
    if (isNotLocation==YES) {
        return nil;
    }
    isCrossBorder = NO;
    
    rectFace=rScale(rectFace, widthScaleBy, heightScaleBy);
    
    return NSStringFromCGRect(rectFace);
}
#pragma mark --- 脸部识别
-(void)praseTrackResult:(NSString*)result OrignImage:(IFlyFaceImage*)faceImg
{
    if(!result){
        return;
    }
    
    @try {
        NSError* error;
        NSData* resultData=[result dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary* faceDic=[NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:&error];
        resultData=nil;
        if(!faceDic){
            return;
        }
        
        NSString* faceRet=[faceDic objectForKey:KCIFlyFaceResultRet];
        NSArray* faceArray=[faceDic objectForKey:KCIFlyFaceResultFace];
        faceDic=nil;
        
        int ret=0;
        if(faceRet){
            ret=[faceRet intValue];
        }
        //没有检测到人脸或发生错误
        if (ret || !faceArray || [faceArray count]<1) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self hideFace];
            }) ;
            return;
        }
        
        //检测到人脸
        NSMutableArray *arrPersons = [NSMutableArray array] ;
        
        for(id faceInArr in faceArray){
            
            if(faceInArr && [faceInArr isKindOfClass:[NSDictionary class]]){
                
                NSDictionary* positionDic=[faceInArr objectForKey:KCIFlyFaceResultPosition];
                NSString* rectString=[self praseDetect:positionDic OrignImage: faceImg];
                positionDic=nil;
                
                NSDictionary* landmarkDic=[faceInArr objectForKey:KCIFlyFaceResultLandmark];
                
                landmarkDic=nil;
                
                
                NSMutableDictionary *dicPerson = [NSMutableDictionary dictionary] ;
                if(rectString){
                    [dicPerson setObject:rectString forKey:RECT_KEY];
                }
                
                [dicPerson setObject:@"0" forKey:RECT_ORI];
                [arrPersons addObject:dicPerson] ;
                
                dicPerson=nil;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self showFaceLandmarksAndFaceRectWithPersonsArray:arrPersons];
                });
            }
        }
        faceArray=nil;
    }
    @catch (NSException *exception) {
        NSLog(@"prase exception:%@",exception.name);
    }
    @finally {
    }
}

#pragma mark - CaptureManagerDelegate
-(void)onOutputFaceImage:(IFlyFaceImage*)faceImg
{
    NSString* strResult=[self.faceDetector trackFrame:faceImg.data withWidth:faceImg.width height:faceImg.height direction:(int)faceImg.direction];
    
#warning
    //此处清理图片数据，以防止因为不必要的图片数据的反复传递造成的内存卷积占用。
    faceImg.data=nil;
    
    NSMethodSignature *sig = [self methodSignatureForSelector:@selector(praseTrackResult:OrignImage:)];
    if (!sig) return;
    NSInvocation* invocation = [NSInvocation invocationWithMethodSignature:sig];
    [invocation setTarget:self];
    [invocation setSelector:@selector(praseTrackResult:OrignImage:)];
    [invocation setArgument:&strResult atIndex:2];
    [invocation setArgument:&faceImg atIndex:3];
    [invocation retainArguments];
    [invocation performSelectorOnMainThread:@selector(invoke) withObject:nil  waitUntilDone:NO];
    faceImg=nil;
}

#pragma mark --- 判断位置
-(BOOL)identifyYourFaceLeft:(CGFloat)left right:(CGFloat)right top:(CGFloat)top bottom:(CGFloat)bottom
{
    //判断位置
    if (right - left < 230 || bottom - top < 250) {
        self.textLabel.text = @"太远了...";
        [self delateNumber];//清数据
        isCrossBorder = YES;
        return YES;
    }else if (right - left > 320 || bottom - top > 320) {
        self.textLabel.text = @"太近了...";
        [self delateNumber];//清数据
        isCrossBorder = YES;
        return YES;
    }else{
        
        //#pragma mark --- 限定脸部位置为中间位置
        if (left < 100 || top < 100 || right > 460 || bottom > 400) {
            isCrossBorder = YES;
            self.textLabel.text = @"调整下位置先,居中诶";
            [self delateNumber];//清数据
            return YES;
        } else {
            self.captureManager.nowImageDelegate=self;
        }
        isCrossBorder = NO;
    }
    return NO;
}
#pragma mark --- 上传图片按钮点击事件
-(void)didClickUpPhoto
{
    //上传照片成功
    [self.faceDelegate sendFaceImage:imageView.image];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 点击『验证完成』AlertView
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (imageView.image) {
        //上传照片成功
        [self.faceDelegate sendFaceImage:imageView.image];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark --- 清掉对应的数
-(void)delateNumber
{
    number = 0;
    takePhotoNumber = 0;
}
-(void)returnNowShowImage:(UIImage *)image
{
    //停止摄像
    [self.previewLayer.session stopRunning];
    
    //延时操作
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        //取得的静态影像
        imageView.backgroundColor = [UIColor lightGrayColor];
        
        imageView.image = image;
        
        imageView.frame = CGRectMake(0, 10, ScreenWidth, ScreenWidth*imageView.image.size.height/imageView.image.size.width);
#warning 这边拍好照后按按钮上传
        if (_isController == NSTypePaiZhao) {
            [self btnRegClicked];
        } else if (_isController == NSTypeYanZhen) {
            [self btnVerifyClicked];
        }
        [self didClickUpPhoto];
        [self delateNumber];
        
        self.captureManager.nowImageDelegate=nil;
    });
    
}

#pragma mark --- 创建button公共方法
-(UIButton *)buttonWithTitle:(NSString *)title frame:(CGRect)frame action:(SEL)action AddView:(id)view
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = frame;
    button.backgroundColor = [UIColor lightGrayColor];
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchDown];
    [view addSubview:button];
    return button;
}

-(void)dealloc
{
    self.captureManager=nil;
    self.viewCanvas=nil;
    [self.previewView removeGestureRecognizer:self.tapGesture];
    self.tapGesture=nil;
}
#pragma mark -------------------上面已经把自动拍照搞定了，下面搞一波检测-----------------------
- (void)btnRegClicked {
    self.resultStings=nil;
    self.resultStings=[[NSString alloc] init];
    
    [self.iFlySpFaceRequest setParameter:[IFlySpeechConstant FACE_REG] forKey:[IFlySpeechConstant FACE_SST]];
    [self.iFlySpFaceRequest setParameter:USER_APPID forKey:[IFlySpeechConstant APPID]];
    [self.iFlySpFaceRequest setParameter:USER_APPID forKey:@"auth_id"];
    [self.iFlySpFaceRequest setParameter:@"del" forKey:@"property"];
    //  压缩图片大小
    UIGraphicsBeginImageContext(CGSizeMake(imageView.frame.size.width / 1.3, imageView.frame.size.height / 1.3));
    [imageView drawRect:CGRectMake(0, 0, imageView.frame.size.width / 1.3, imageView.frame.size.height / 1.3)];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData *date = UIImageJPEGRepresentation(newImage, 0.01);
    
    NSLog(@"========%lu", (unsigned long)[date length]);
    [self.iFlySpFaceRequest sendRequest:date];
}
// 验证
- (void)btnVerifyClicked {
    
    self.resultStings=nil;
    self.resultStings=[[NSString alloc] init];
    
    [self.iFlySpFaceRequest setParameter:[IFlySpeechConstant FACE_VERIFY] forKey:[IFlySpeechConstant FACE_SST]];
    [self.iFlySpFaceRequest setParameter:USER_APPID forKey:[IFlySpeechConstant APPID]];
    [self.iFlySpFaceRequest setParameter:USER_APPID forKey:@"auth_id"];
    NSUserDefaults* userDefaults=[NSUserDefaults standardUserDefaults];
    NSString* gid=[userDefaults objectForKey:KCIFlyFaceResultGID];
    if(!gid){
        [self showResultInfo:@"请先注册，或在设置中输入已注册的gid"];
        return;
    }
    [self.iFlySpFaceRequest setParameter:gid forKey:[IFlySpeechConstant FACE_GID]];
    [self.iFlySpFaceRequest setParameter:@"2000" forKey:@"wait_time"];
    //  压缩图片大小
    //    NSData* imgData=[_imgView.image compressedData];
    
    //  压缩图片大小
    UIGraphicsBeginImageContext(CGSizeMake(imageView.frame.size.width / 1.3, imageView.frame.size.height / 1.3));
    [imageView drawRect:CGRectMake(0, 0, imageView.frame.size.width / 1.3, imageView.frame.size.height / 1.3)];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData *date = UIImageJPEGRepresentation(newImage, 0.01);
    
    NSLog(@"verify image data length: %lu",(unsigned long)[date length]);
    [self.iFlySpFaceRequest sendRequest:date];
    
}

#pragma mark - IFlyFaceRequestDelegate


/**
 * 消息回调
 * @param eventType 消息类型
 * @param params 消息数据对象
 */
- (void) onEvent:(int) eventType WithBundle:(NSString*) params{
    NSLog(@"onEvent | params:%@",params);
}

/**
 * 数据回调，可能调用多次，也可能一次不调用
 * @param buffer 服务端返回的二进制数据
 */
- (void) onData:(NSData* )data{
    
    //    NSLog(@"onData | ");
    NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    //    NSLog(@"result:%@",result);
    
    if (result) {
        self.resultStings=[self.resultStings stringByAppendingString:result];
    }
    
}
/**
 * 结束回调，没有错误时，error为null
 * @param error 错误类型
 */
- (void) onCompleted:(IFlySpeechError*) error{
    
    
    NSLog(@"onCompleted | error:%@",[error errorDesc]);
    NSString* errorInfo=[NSString stringWithFormat:@"错误码：%d\n 错误描述：%@",[error errorCode],[error errorDesc]];
    
    if(0!=[error errorCode]){
        [self performSelectorOnMainThread:@selector(showResultInfo:) withObject:errorInfo waitUntilDone:NO];
    }
    else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateFaceImage:self.resultStings];
        });
    }
}
#pragma mark - Perform results On UI

-(void)updateFaceImage:(NSString*)result{
    
    NSError* error;
    NSData* resultData=[result dataUsingEncoding:NSUTF8StringEncoding];
    
    
    NSDictionary* dic=[NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:&error];
    
    if(dic){
        NSString* strSessionType=[dic objectForKey:KCIFlyFaceResultSST];
        
        //注册
        if([strSessionType isEqualToString:KCIFlyFaceResultReg]){
            [self praseRegResult:result];
        }
        
        //验证
        if([strSessionType isEqualToString:KCIFlyFaceResultVerify]){
            [self praseVerifyResult:result];
        }
//                //检测
//                if([strSessionType isEqualToString:KCIFlyFaceResultDetect]){
//                    [self praseVerifyResult:result];
//                }
//        
//                //关键点
//                if([strSessionType isEqualToString:KCIFlyFaceResultAlign]){
//                    [self praseVerifyResult:result];
//                }
        
    }
}
#pragma mark - Data Parser

-(void)praseRegResult:(NSString*)result{
    NSString *resultInfo = @"";
    NSString *resultInfoForLabel = @"";
    //    NSLog(@"--------------%@",result);
    @try {
        NSError* error;
        NSData* resultData=[result dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary* dic=[NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:&error];
        
        if(dic){
            NSString* strSessionType=[dic objectForKey:KCIFlyFaceResultSST];
            
            //            注册onCompleted
            if([strSessionType isEqualToString:KCIFlyFaceResultReg]){
                NSString* rst=[dic objectForKey:KCIFlyFaceResultRST];
                NSString* ret=[dic objectForKey:KCIFlyFaceResultRet];
                if([ret integerValue]!=0){
                    resultInfo=[resultInfo stringByAppendingFormat:@"注册错误\n错误码：%@",ret];
                }else{
                    if(rst && [rst isEqualToString:KCIFlyFaceResultSuccess]){
                        NSString* gid=[dic objectForKey:KCIFlyFaceResultGID];
                        resultInfo=[resultInfo stringByAppendingString:@"注册成功！\n 欢迎来到人脸识别打卡系统"];
                        NSLog(@"%@", resultInfo);
#warning 这里把值存到本地了
                        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
                        [defaults setObject:gid forKey:KCIFlyFaceResultGID];
                        resultInfoForLabel=[resultInfoForLabel stringByAppendingFormat:@"gid:%@",gid];
                    }else{
                        resultInfo=[resultInfo stringByAppendingString:@"注册失败！\n 请重新拍照"];
                    }
                }
            }
            self.navigationController.title = resultInfoForLabel;
            
            //            [self performSelectorOnMainThread:@selector(showResultInfo:) withObject:resultInfo waitUntilDone:NO];
            self.sendBlock(resultInfo);
        }
        
    }
    @catch (NSException *exception) {
        NSLog(@"prase exception:%@",exception.name);
    }
    @finally {
    }
    
    
}
-(void)praseVerifyResult:(NSString*)result{
    NSString *resultInfo = @"";
    NSString *resultInfoForLabel = @"";
    
    @try {
        NSError* error;
        NSData* resultData=[result dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary* dic=[NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:&error];
        
        if(dic){
            NSString* strSessionType=[dic objectForKey:KCIFlyFaceResultSST];
            
            if([strSessionType isEqualToString:KCIFlyFaceResultVerify]){
                NSString* rst=[dic objectForKey:KCIFlyFaceResultRST];
                NSString* ret=[dic objectForKey:KCIFlyFaceResultRet];
                //                NSString *score = [dic objectForKey:KCIFlyFaceResultScore];
                if([ret integerValue]!=0){
                    resultInfo=[resultInfo stringByAppendingFormat:@"验证错误\n错误码：%@",ret];
                    self.sendBlock(resultInfo);
                }else{
                    
                    if([rst isEqualToString:KCIFlyFaceResultSuccess]){
                        resultInfo=[resultInfo stringByAppendingString:@"检测到人脸\n"];
                        self.sendBlock(resultInfo);
                    }else{
                        resultInfo=[resultInfo stringByAppendingString:@"未检测到人脸\n"];
                        self.sendBlock(resultInfo);
                    }
                    NSString* verf=[dic objectForKey:KCIFlyFaceResultVerf];
                    NSString* score=[dic objectForKey:KCIFlyFaceResultScore];
                    if([verf boolValue]){
                        resultInfoForLabel=[resultInfoForLabel stringByAppendingFormat:@"score:%@\n",score];
                        resultInfo=[resultInfo stringByAppendingString:@"验证结果:验证成功!"];
                        self.sendBlock(resultInfo);
                    }else{
                        NSUserDefaults* defaults=[NSUserDefaults standardUserDefaults];
                        NSString* gid=[defaults objectForKey:KCIFlyFaceResultGID];
                        resultInfoForLabel=[resultInfoForLabel stringByAppendingFormat:@"last reg gid:%@\n",gid];
                        resultInfo=[resultInfo stringByAppendingString:@"验证结果:验证失败!"];
                        //                        NSLog(@"%@", resultInfo);
                        self.sendBlock(resultInfo);
                    }
                    NSString *zeroResult = [NSString stringWithFormat:@"匹配度%@ \n 验证结果 %@", score, resultInfo];
                    self.sendBlock(zeroResult);
                }
                
            }
            
            if([resultInfo length]<1){
                resultInfo=@"结果异常";
            }
            
        }
        
    }
    @catch (NSException *exception) {
        NSLog(@"prase exception:%@",exception.name);
    }
    @finally {
        
    }
    
    
}
-(void)showResultInfo:(NSString*)resultInfo{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"结果" message:resultInfo preferredStyle:(UIAlertControllerStyleAlert)];
    
    UIAlertAction *alert1 = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:alert1];
    [self.navigationController presentViewController:alert animated:YES completion:nil];
    
}


#pragma mark - LMJNavUIBaseViewControllerDataSource

- (UIColor *)lmjNavigationBackgroundColor:(LMJNavigationBar *)navigationBar
{
    return [UIColor clearColor];
}

- (BOOL)lmjNavigationIsHideBottomLine:(LMJNavigationBar *)navigationBar
{
    return YES;
}

/** 导航条左边的按钮 */
- (UIImage *)lmjNavigationBarLeftButtonImage:(UIButton *)leftButton navigationBar:(LMJNavigationBar *)navigationBar
{
    [leftButton setImage:[UIImage imageNamed:@"NavgationBar_white_back"] forState:UIControlStateHighlighted];
    
    return [UIImage imageNamed:@"NavgationBar_blue_back"];
}

#pragma mark - LMJNavUIBaseViewControllerDelegate
/** 左边的按钮的点击 */
-(void)leftButtonEvent:(UIButton *)sender navigationBar:(LMJNavigationBar *)navigationBar
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
