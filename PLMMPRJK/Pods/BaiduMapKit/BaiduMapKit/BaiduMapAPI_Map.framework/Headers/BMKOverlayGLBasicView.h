/*
*  BMKOverlayGLBasicView.h
*  BMapKit
*
*  Copyright 2011 Baidu Inc. All rights reserved.
*
*/

#import <UIKit/UIKit.h>
#import "BMKOverlayView.h"

/// 该类定义了一个用opengl绘制的OverlayView的基类，如果需要用gdi进行绘制请继承于BMKOverlayPathView类
@interface BMKOverlayGLBasicView : BMKOverlayView {

}

/// 填充颜色
/// 注：请使用 - (UIColor *)initWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha; 初始化UIColor，使用[UIColor ***Color]初始化时，个别case转换成RGB后会有问题
@property (strong, nonatomic) UIColor *fillColor;
/// 画笔颜色
/// 注：请使用 - (UIColor *)initWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha; 初始化UIColor，使用[UIColor ***Color]初始化时，个别case转换成RGB后会有问题
@property (strong, nonatomic) UIColor *strokeColor;
/// 画笔宽度，默认为0
@property  (nonatomic) CGFloat lineWidth;
/// path对象
@property CGPathRef path;
/// 是否为虚线样式，默认NO
@property (nonatomic) BOOL lineDash;
/// 是否纹理图片平铺绘制，默认NO
@property (assign, nonatomic) BOOL tileTexture;
/// 纹理图片是否缩放（tileTexture为YES时生效），默认NO
@property (assign, nonatomic) BOOL keepScale;

@end
