//
//  BMKOpenPoi.h
//  UtilsComponent
//
//  Created by wzy on 15/3/26.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#ifndef UtilsComponent_BMKOpenPoi_h
#define UtilsComponent_BMKOpenPoi_h

#import "BMKOpenPoiOption.h"
#import <BaiduMapAPI_Base/BMKTypes.h>

///调起百度地图 -- poi
///注：从iphone百度地图 8.2.0版本开始支持
@interface BMKOpenPoi : NSObject

/**
 * 调起百度地图poi详情页面
 * 注：从iphone百度地图 8.2.0版本开始支持
 *@param option poi详情参数类（BMKOpenPoiDetailOption）
 *@return  调起结果
 */
+ (BMKOpenErrorCode)openBaiduMapPoiDetailPage:(BMKOpenPoiDetailOption *) option;

/**
 * 调起百度地图poi周边检索页面
 * 注：从iphone百度地图 8.2.0版本开始支持
 *@param option poi周边参数类（BMKOpenPoiNearbyOption）
 *@return  调起结果
 */
+ (BMKOpenErrorCode)openBaiduMapPoiNearbySearch:(BMKOpenPoiNearbyOption *) option;

@end

#endif
