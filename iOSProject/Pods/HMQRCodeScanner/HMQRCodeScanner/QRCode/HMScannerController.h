//
//  HMScannerController.h
//  HMQRCodeScanner
//
//  Created by 刘凡 on 16/1/2.
//  Copyright © 2016年 itheima. All rights reserved.
//

#import <UIKit/UIKit.h>

/*!
 扫描控制器
 
 作用：
 
 * 提供一个导航控制器，扫描 `二维码 / 条形码`
 * 能够生成指定 `字符串` + `avatar(可选)` 的二维码名片
 * 能够识别相册图片中的二维码(iOS 64 位设备)
 
 使用：
 
 @code
 NSString *cardName = @"天涯刀哥 - 傅红雪";
 UIImage *avatar = [UIImage imageNamed:@"avatar"];
 
 // 实例化控制器，并指定完成回调
 HMScannerController *scanner = [HMScannerController scannerWithCardName:cardName avatar:avatar completion:^(NSString *stringValue) {
 
 self.scanResultLabel.text = stringValue;
 }];
 
 // 设置导航标题样式
 [scanner setTitleColor:[UIColor whiteColor] tintColor:[UIColor greenColor]];
 
 // 展现扫描控制器
 [self showDetailViewController:scanner sender:nil];
 
 @endcode
 */
@interface HMScannerController : UINavigationController

/// 使用 `名片字符串` 实例化扫描导航控制器
///
/// @param cardName   名片字符串
/// @param avatar     头像图像
/// @param completion 完成回调
///
/// @return 扫描导航控制器
+ (instancetype)scannerWithCardName:(NSString *)cardName avatar:(UIImage *)avatar completion:(void (^)(NSString *stringValue))completion;

/// 使用 名片字符串 / 头像 异步生成二维码图像，并且指定头像占二维码图像的比例
///
/// @param string     名片字符串
/// @param avatar     头像图像
/// @param scale      头像占二维码图像的比例
/// @param completion 完成回调
+ (void)cardImageWithCardName:(NSString *)cardName avatar:(UIImage *)avatar scale:(CGFloat)scale completion:(void (^)(UIImage *image))completion;

/// 设置导航栏标题颜色和 tintColor
///
/// @param titleColor 标题颜色
/// @param tintColor  tintColor
- (void)setTitleColor:(UIColor *)titleColor tintColor:(UIColor *)tintColor;

@end
