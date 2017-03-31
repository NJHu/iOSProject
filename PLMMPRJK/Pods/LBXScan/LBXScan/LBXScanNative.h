//
//
//
//  github:https://github.com/MxABC/LBXScan
//  Created by lbxia on 15/3/4.
//  Copyright (c) 2015年 lbxia. All rights reserved.
//


@import UIKit;
@import Foundation;
@import AVFoundation;

#import "LBXScanResult.h"

/**
 @brief  ios系统自带扫码功能
 */
@interface LBXScanNative : NSObject


/**
 @brief  初始化采集相机
 @param preView 视频显示区域
 @param objType 识别码类型：如果为nil，默认支持很多类型。
 @param cropRect 识别区域，值CGRectZero 全屏识别
 @param block   识别结果
 @return LBXScanNative的实例
 */
- (instancetype)initWithPreView:(UIView*)preView ObjectType:(NSArray*)objType cropRect:(CGRect)cropRect
              success:(void(^)(NSArray<LBXScanResult*> *array))block;


/*!
 *  设置扫码成功后是否拍照
 *
 *  @param isNeedCaputureImg YES:拍照， NO:不拍照
 */
- (void)setNeedCaptureImage:(BOOL)isNeedCaputureImg;


/*!
 *  开始扫码
 */
- (void)startScan;

/*!
 *  停止扫码
 */
- (void)stopScan;

/*!
 *  开启关闭闪光灯
 *
 *  @param torch ...
 */
- (void)setTorch:(BOOL)torch;

/*!
 *  开启关闭闪光灯
 */
- (void)changeTorch;

/*!
 *  修改扫码类型：二维码、条形码
 *
 *  @param objType 
 */
- (void)changeScanType:(NSArray*)objType;

@end

