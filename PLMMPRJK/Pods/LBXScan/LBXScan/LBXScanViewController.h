//
//  QQStyleQRScanViewController.h
//  LBXScanDemo
//  github:https://github.com/MxABC/LBXScan
//  Created by lbxia on 15/10/21.
//  Copyright © 2015年 lbxia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "LBXScanView.h"
#import "LBXScanWrapper.h"




@interface LBXScanViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate>


/**
 @brief  扫码功能封装对象
 */
@property (nonatomic,strong) LBXScanWrapper* scanObj;

#pragma mark - 扫码界面效果及提示等
/**
 @brief  扫码区域视图,二维码一般都是框
 */
@property (nonatomic,strong) LBXScanView* qRScanView;




/**
 *  界面效果参数
 */
@property (nonatomic, strong) LBXScanViewStyle *style;


#pragma mark - 扫码界面效果及提示等


/**
 @brief  扫码当前图片
 */
@property(nonatomic,strong)UIImage* scanImage;


/**
 @brief  启动区域识别功能
 */
@property(nonatomic,assign)BOOL isOpenInterestRect;


/**
 @brief  闪关灯开启状态
 */
@property(nonatomic,assign)BOOL isOpenFlash;


//打开相册
- (void)openLocalPhoto;
//开关闪光灯
- (void)openOrCloseFlash;


//子类继承必须实现的提示
/**
 *  继承者实现的alert提示功能：如没有权限时会调用
 *
 *  @param str 提示语
 */
- (void)showError:(NSString*)str;


- (void)reStartDevice;


@end
