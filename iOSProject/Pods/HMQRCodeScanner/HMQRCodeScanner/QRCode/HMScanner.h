//
//  HMScanner.h
//  HMQRCodeScanner
//
//  Created by 刘凡 on 16/1/2.
//  Copyright © 2016年 itheima. All rights reserved.
//

#import <UIKit/UIKit.h>

/// 二维码/条码扫描器
@interface HMScanner : NSObject

/// 使用视图实例化扫描器，扫描预览窗口会添加到指定视图中
///
/// @param view       指定的视图
/// @param scanFrame  扫描范围
/// @param completion 完成回调
///
/// @return 扫描器
+ (instancetype)scanerWithView:(UIView *)view scanFrame:(CGRect)scanFrame completion:(void (^)(NSString *stringValue))completion;

/// 扫描图像
///
/// @param image 包含二维码的图像
/// @remark 目前只支持 64 位的 iOS 设备
+ (void)scaneImage:(UIImage *)image completion:(void (^)(NSArray *values))completion;

/// 使用 string / 头像 异步生成二维码图像
///
/// @param string     二维码图像的字符串
/// @param avatar     头像图像，默认比例 0.2
/// @param completion 完成回调
+ (void)qrImageWithString:(NSString *)string avatar:(UIImage *)avatar completion:(void (^)(UIImage *image))completion;

/// 使用 string / 头像 异步生成二维码图像，并且指定头像占二维码图像的比例
///
/// @param string     二维码图像的字符串
/// @param avatar     头像图像
/// @param scale      头像占二维码图像的比例
/// @param completion 完成回调
+ (void)qrImageWithString:(NSString *)string avatar:(UIImage *)avatar scale:(CGFloat)scale completion:(void (^)(UIImage *))completion;

/// 开始扫描
- (void)startScan;
/// 停止扫描
- (void)stopScan;

@end
