/*
 *  BMKOverlay.h
 *  BMapKit
 *
 *  Copyright 2011 Baidu Inc. All rights reserved.
 *
 */

#import "BMKAnnotation.h"
#import <BaiduMapAPI_Base/BMKTypes.h>

/// 该类是地图覆盖物的基类，所有地图的覆盖物需要继承自此类
@protocol BMKOverlay <BMKAnnotation>
@required

/// 返回区域中心坐标.
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

/// 返回区域外接矩形
@property (nonatomic, readonly) BMKMapRect boundingMapRect;

@optional
/**
 *判断指定的矩形是否与本Overlay相交，用于更精确的控制overlay view的显示.
 *默认使用BMKMapRectIntersectsRect([overlay boundingRect], mapRect)代替.
 *@param mapRect 指定的BMKMapRect
 *@return 如果相交返回YES，否则返回NO
 */
- (BOOL)intersectsMapRect:(BMKMapRect)mapRect;

@end

