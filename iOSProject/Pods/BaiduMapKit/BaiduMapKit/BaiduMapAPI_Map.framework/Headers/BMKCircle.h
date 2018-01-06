/*
 *  BMKCircle.h
 *  BMapKit
 *
 *  Copyright 2011 Baidu Inc. All rights reserved.
 *
 */

#import "BMKShape.h"
#import "BMKMultiPoint.h"
#import "BMKOverlay.h"

/// 该类用于定义一个圆
@interface BMKCircle : BMKMultiPoint <BMKOverlay> {
@package
    BOOL _invalidate;
    CLLocationCoordinate2D _coordinate;
    CLLocationDistance _radius;
    BMKMapRect _boundingMapRect;
}

/**
 *根据中心点和半径生成圆
 *@param coord 中心点的经纬度坐标
 *@param radius 半径，单位：米
 *@return 新生成的圆
 */
+ (BMKCircle *)circleWithCenterCoordinate:(CLLocationCoordinate2D)coord
                                  radius:(CLLocationDistance)radius;

/**
 *根据指定的直角坐标矩形生成圆，半径由较长的那条边决定，radius = MAX(width, height)/2
 *@param mapRect 指定的直角坐标矩形
 *@return 新生成的圆
 */
+ (BMKCircle *)circleWithMapRect:(BMKMapRect)mapRect;

/// 中心点坐标
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

/// 半径，单位：米
@property (nonatomic, assign) CLLocationDistance radius;

/// 该圆的外接矩形
@property (nonatomic, readonly) BMKMapRect boundingMapRect;

/**
 *设置圆的中心点和半径
 *@param coord 中心点的经纬度坐标
 *@param radius 半径，单位：米
 *@return 是否设置成功
 */
- (BOOL)setCircleWithCenterCoordinate:(CLLocationCoordinate2D)coord radius:(CLLocationDistance)radius;
/**
 *根据指定的直角坐标矩形设置圆，半径由较长的那条边决定，radius = MAX(width, height)/2
 *@param mapRect 指定的直角坐标矩形
 *@return 是否设置成功
 */
- (BOOL)setCircleWithMapRect:(BMKMapRect)mapRect;

@end
