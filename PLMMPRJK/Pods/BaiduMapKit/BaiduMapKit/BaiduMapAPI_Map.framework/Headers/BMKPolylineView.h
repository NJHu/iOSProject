/*
 *  BMKPolylineView.h
 *  BMapKit
 *
 *  Copyright 2011 Baidu Inc. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>

#import "BMKPolyline.h"
#import "BMKOverlayGLBasicView.h"

/// 此类用于定义一个折线View
@interface BMKPolylineView : BMKOverlayGLBasicView

/**
 *根据指定的折线生成一个折线View
 *@param polyline 指定的折线数据对象
 *@return 新生成的折线View
 */
- (id)initWithPolyline:(BMKPolyline *)polyline;

/// 该View对应的折线数据对象
@property (nonatomic, readonly) BMKPolyline *polyline;


#pragma mark - 以下方法和属性只适用于分段纹理绘制/分段颜色绘制

/// 是否分段纹理/分段颜色绘制（突出显示），默认YES，YES:使用分段纹理绘制 NO:使用默认的灰色纹理绘制
@property (nonatomic, assign) BOOL isFocus;

@end
