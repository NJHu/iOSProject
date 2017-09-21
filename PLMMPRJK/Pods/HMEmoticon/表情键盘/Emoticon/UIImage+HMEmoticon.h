//
//  UIImage+HMEmoticon.h
//  表情键盘
//
//  Created by 刘凡 on 16/3/3.
//  Copyright © 2016年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (HMEmoticon)

/// 使用图像名从 bundle 中加载图像
///
/// @param name 图像名字符串
///
/// @return UIImage
+ (UIImage *)hm_imageNamed:(NSString *)name;

/// 返回当前图像从中心点开始向四周的拉伸结果
///
/// @return UIImage
- (UIImage *)hm_resizableImage;

@end
