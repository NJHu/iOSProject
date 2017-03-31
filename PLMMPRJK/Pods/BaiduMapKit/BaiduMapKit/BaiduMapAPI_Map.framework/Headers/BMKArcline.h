/*
 *  BMKArcline.h
 *  BMapKit
 *
 *  Copyright 2011 Baidu Inc. All rights reserved.
 *
 */

#import "BMKMultiPoint.h"
#import "BMKOverlay.h"

/// 此类用于定义一段圆弧
@interface BMKArcline : BMKMultiPoint <BMKOverlay>
{
    BMKMapRect _boundingMapRect;
    bool isYouArc;
}

/**
 *根据指定坐标点生成一段圆弧
 *@param points 指定的直角坐标点数组(需传入3个点)
 *@return 新生成的圆弧对象
 */
+ (BMKArcline *)arclineWithPoints:(BMKMapPoint *)points;

/**
 *根据指定经纬度生成一段圆弧
 *@param coords 指定的经纬度坐标点数组(需传入3个点)
 *@return 新生成的圆弧对象
 */
+ (BMKArcline *)arclineWithCoordinates:(CLLocationCoordinate2D *)coords;

/**
 *重新设置圆弧坐标
 *@param points 指定的直角坐标点数组(需传入3个点)
 *@return 是否设置成功
 */
- (BOOL)setArclineWithPoints:(BMKMapPoint *)points;

/**
 *重新设置圆弧坐标
 *@param coords 指定的经纬度坐标点数组(需传入3个点)
 *@param count 坐标点的个数
 *@return 是否设置成功
 */
- (BOOL)setArclineWithCoordinates:(CLLocationCoordinate2D *)coords;

@end
