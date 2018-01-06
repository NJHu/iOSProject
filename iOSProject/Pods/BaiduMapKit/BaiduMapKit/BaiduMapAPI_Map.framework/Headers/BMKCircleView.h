/*
 *  BMKCircleView.h
 *  BMapKit
 *
 *  Copyright 2011 Baidu Inc. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>

#import "BMKCircle.h"
#import "BMKOverlayGLBasicView.h"

/// 该类用于定义圆对应的View
@interface BMKCircleView : BMKOverlayGLBasicView

/**
 *根据指定圆生成对应的View
 *@param circle 指定的圆
 *@return 生成的View
 */
- (id)initWithCircle:(BMKCircle *)circle;

/// 该View对应的圆
@property (nonatomic, readonly) BMKCircle *circle;

@end
