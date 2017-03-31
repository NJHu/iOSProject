//
//  BMKOpenPoiOption.h
//  UtilsComponent
//
//  Created by wzy on 15/3/26.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#ifndef UtilsComponent_BMKOpenPoiOption_h
#define UtilsComponent_BMKOpenPoiOption_h

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "BMKOpenOption.h"

///调起百度地图： poi详情参数类
@interface BMKOpenPoiDetailOption : BMKOpenOption

///poi的uid
@property (nonatomic, strong) NSString* poiUid;

@end


///调起百度地图： poi周边参数类
@interface BMKOpenPoiNearbyOption : BMKOpenOption

///中心点（经纬度）
@property (nonatomic, assign) CLLocationCoordinate2D location;
///半径
@property (nonatomic, assign) NSUInteger radius;
///关键词
@property (nonatomic, strong) NSString* keyword;

@end


#endif

