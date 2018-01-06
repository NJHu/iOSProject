//
//  BMKOpenRoute.h
//  UtilsComponent
//
//  Created by wzy on 15/3/26.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#ifndef UtilsComponent_BMKOpenRoute_h
#define UtilsComponent_BMKOpenRoute_h
#import "BMKOpenRouteOption.h"
#import <BaiduMapAPI_Base/BMKTypes.h>

///调起百度地图 -- 路线
///注：从iphone百度地图 8.2.0版本开始支持
@interface BMKOpenRoute : NSObject

/**
 * 调起百度地图步行路线页面
 * 注：从iphone百度地图 8.2.0版本开始支持
 *@param option 步行路线参数类（BMKOpenWalkingRouteOption）
 *@return  调起结果
 */
+ (BMKOpenErrorCode)openBaiduMapWalkingRoute:(BMKOpenWalkingRouteOption *) option;

/**
 * 调起百度地图公交路线页面
 * 注：从iphone百度地图 8.2.0版本开始支持
 *@param option 公交路线参数类（BMKOpenTransitRouteOption）
 *@return  调起结果
 */
+ (BMKOpenErrorCode)openBaiduMapTransitRoute:(BMKOpenTransitRouteOption *) option;

/**
 * 调起百度地图驾车路线检索页面
 * 注：从iphone百度地图 8.2.0版本开始支持
 *@param option 驾车路线参数类（BMKOpenDrivingRouteOption）
 *@return  调起结果
 */
+ (BMKOpenErrorCode)openBaiduMapDrivingRoute:(BMKOpenDrivingRouteOption *) option;

@end


#endif
