/*
 *  BMKArclineView.h
 *  BMapKit
 *
 *  Copyright 2011 Baidu Inc. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>

#import "BMKArcline.h"
#import "BMKOverlayGLBasicView.h"

/// 此类用于定义一个圆弧View
@interface BMKArclineView : BMKOverlayGLBasicView

/**
 *根据指定的弧线生成一个圆弧View
 *@param arcline 指定的弧线数据对象
 *@return 新生成的弧线View
 */
- (id)initWithArcline:(BMKArcline *)arcline;

/// 该View对应的圆弧数据对象
@property (nonatomic, readonly) BMKArcline *arcline;

@end
