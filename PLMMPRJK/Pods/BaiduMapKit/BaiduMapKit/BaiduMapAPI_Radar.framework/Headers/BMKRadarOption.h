//
//  BMKRadarOption.h
//  RadarComponent
//
//  Created by wzy on 15/4/22.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#ifndef RadarComponent_BMKRadarOption_h
#define RadarComponent_BMKRadarOption_h

#import <CoreLocation/CoreLocation.h>

///用户信息类
@interface BMKRadarUploadInfo : NSObject

///地址坐标，百度经纬度坐标 (必须)
@property (nonatomic, assign) CLLocationCoordinate2D pt;

///扩展信息，和该用户相关的信息（可选）
@property (nonatomic, strong) NSString* extInfo;

@end

typedef enum{
    BMK_RADAR_SORT_TYPE_DISTANCE_FROM_NEAR_TO_FAR = 0,//距离由近及远排序
    BMK_RADAR_SORT_TYPE_DISTANCE_FROM_FAR_TO_NEAR,//距离由远及近排序
    BMK_RADAR_SORT_TYPE_TIME_FROM_PAST_TO_RECENT,//时间由过去到现在排序
    BMK_RADAR_SORT_TYPE_TIME_FROM_RECENT_TO_PAST,//时间由现在到过去排序
}BMKRadarSortType;

///时间区间
@interface BMKDateRange : NSObject

///起始时间
@property (nonatomic, strong) NSDate* startDate;
///终止时间
@property (nonatomic, strong) NSDate* endDate;

@end

///查询周边的用户信息参数类
@interface BMKRadarNearbySearchOption : NSObject

///地址坐标，百度经纬度坐标 (不设置，默认使用最后一次上传的坐标)
@property (nonatomic, assign) CLLocationCoordinate2D centerPt;
///检索半径，单位米，默认1000
@property (nonatomic, assign) NSUInteger radius;
///分页索引，可选，默认为0
@property (nonatomic, assign) NSInteger pageIndex;
///页容量，可选，默认为50
@property (nonatomic, assign) NSInteger pageCapacity;
///排序类型：默认按距离由近及远排序，BMK_RADAR_SORT_TYPE_DISTANCE_FROM_NEAR_TO_FAR
@property (nonatomic, assign) BMKRadarSortType sortType;
///时间区间，可选，获取该时间区间内的用户信息
@property (nonatomic, strong) BMKDateRange* dateRange;


@end

#endif
