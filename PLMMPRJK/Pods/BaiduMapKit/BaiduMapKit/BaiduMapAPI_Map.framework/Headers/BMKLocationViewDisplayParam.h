/*
 *  BMKLocationViewDisplayParam.h
 *  BMapKit
 *
 *  Copyright 2013 Baidu Inc. All rights reserved.
 *
 */
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>


///此类表示定位图层自定义样式参数
@interface BMKLocationViewDisplayParam : NSObject

///定位图标X轴偏移量(屏幕坐标)
@property (nonatomic, assign) CGFloat locationViewOffsetX;
///定位图标Y轴偏移量(屏幕坐标)
@property (nonatomic, assign) CGFloat locationViewOffsetY;
///精度圈是否显示，默认YES
@property (nonatomic, assign) BOOL isAccuracyCircleShow;
///精度圈 填充颜色
@property (nonatomic, strong) UIColor *accuracyCircleFillColor;
///精度圈 边框颜色
@property (nonatomic, strong) UIColor *accuracyCircleStrokeColor;
///跟随态旋转角度是否生效，默认YES
@property (nonatomic, assign) BOOL isRotateAngleValid;
///定位图标名称，需要将该图片放到 mapapi.bundle/images 目录下
@property (nonatomic, strong) NSString* locationViewImgName;

@end



