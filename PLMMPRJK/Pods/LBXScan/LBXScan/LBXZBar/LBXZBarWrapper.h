//
//  LBXZBarWrapper.h
//  LBXScanDemo
//
//  Created by lbxia on 2017/1/5.
//  Copyright © 2017年 lbx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZBarSDK.h"



// enum zbar_symbol_type_t;

/**
 扫码结果
 */
@interface LBXZbarResult : NSObject

/**
 @brief  条码字符串
 */
@property (nonatomic, copy) NSString* strScanned;
/**
 @brief  扫码图像
 */
@property (nonatomic, strong) UIImage* imgScanned;
/**
 @brief  扫码码的类型，码制
 */
@property (nonatomic, assign) zbar_symbol_type_t format;

@end


/*
 待完成，
 1、设置扫码区域
 2、识别图片
 3、码制设置不是很明白
 4、生成条码
 */


/**
 ZBar封装,使用的ZBar库不支持bitcode,
 另外需要添加libiconv库
 */
@interface LBXZBarWrapper : NSObject




/**
 初始化ZBar封装对象

 @param preView 视频预览视图
 @param barCodeType 条码类型
 @param block 扫码结果返回
 @return ZBar封装对象
 */
- (instancetype)initWithPreView:(UIView*)preView barCodeType:(zbar_symbol_type_t)barCodeType block:(void(^)(NSArray<LBXZbarResult*> *result))block;


/**
 切换扫码类型

 @param zbarFormat 码制
 */
- (void)changeBarCode:(zbar_symbol_type_t)zbarFormat;


/**
 启动扫码
 */
- (void)start;


/**
 关闭扫码
 */
- (void)stop;


/**
 根据闪光灯状态，切换成相反状态
 */
- (void)openOrCloseFlash;



/**
 识别图片

 @param image 图片
 @param block 返回失败结果
 */
+ (void)recognizeImage:(UIImage*)image block:(void(^)(NSArray<LBXZbarResult*> *result))block;

/**
 将码的类型转换字符串表示

 @param format 码的类型
 @return 返回码的字符串
 */
+ (NSString*)convertFormat2String:(zbar_symbol_type_t)format;

@end
