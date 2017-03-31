/*
 *  BMKShareUrlSearchOption.h
 *  BMapKit
 *
 *  Copyright 2014 Baidu Inc. All rights reserved.
 *
 */

#import <BaiduMapAPI_Base/BMKTypes.h>
/// poi详情短串分享检索信息类
@interface BMKPoiDetailShareURLOption : NSObject
{
    NSString        *_uid;
}
///poi的uid
@property (nonatomic, strong) NSString *uid;

@end

///反geo短串分享检索信息类
@interface BMKLocationShareURLOption : NSObject {
    NSString                *_name;
    NSString                *_snippet;
    CLLocationCoordinate2D  _location;
}
///名称
@property (nonatomic, strong) NSString *name;
///通过短URL调起客户端时作为附加信息显示在名称下面
@property (nonatomic, strong) NSString *snippet;
///经纬度
@property (nonatomic, assign) CLLocationCoordinate2D location;
@end


///路线规划短串分享
typedef enum {
    BMK_ROUTE_PLAN_SHARE_URL_TYPE_DRIVE = 0,        //驾车路线规划短串分享
    BMK_ROUTE_PLAN_SHARE_URL_TYPE_WALK = 1,         //步行路线规划短串分享
    BMK_ROUTE_PLAN_SHARE_URL_TYPE_RIDE = 2,         //骑行路线规划短串分享
    BMK_ROUTE_PLAN_SHARE_URL_TYPE_TRANSIT = 3,      //公交路线规划短串分享
}BMKRoutePlanShareURLType;

///路线规划短串分享检索信息类
@interface BMKRoutePlanShareURLOption : NSObject

///路线规划短串分享类型
@property (nonatomic, assign) BMKRoutePlanShareURLType routePlanType;
///起点，可通过关键字、坐标两种方式指定，使用关键字时必须指定from.cityID
@property (nonatomic, strong) BMKPlanNode *from;
///终点，可通过关键字、坐标两种方式指定，使用关键字时必须指定to.cityID
@property (nonatomic, strong) BMKPlanNode *to;
///cityID，当进行公交路线规划短串分享且起终点通过关键字指定时，必须指定
@property (nonatomic, assign) NSUInteger cityID;
///公交路线规划短串分享时使用，分享的是第几条线路
@property (nonatomic, assign) NSUInteger routeIndex;

@end