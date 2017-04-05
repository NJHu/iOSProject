/*
 *  BMKNavigation.h
 *  BMapKit
 *
 *  Copyright 2011 Baidu Inc. All rights reserved.
 *
 */
#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Base/BMKTypes.h>
//定义调起导航的两种类型
//注：自2.8.0开始废弃，只支持调起客户端导航，在调起客户端导航时，才会调起web导航
typedef enum
{
    BMK_NAVI_TYPE_NATIVE = 0,//客户端导航
    BMK_NAVI_TYPE_WEB,//web导航
} BMK_NAVI_TYPE;

///此类管理调起导航时传入的参数
@interface BMKNaviPara : NSObject
{
	BMKPlanNode* _startPoint;
	BMKPlanNode* _endPoint;
	BMK_NAVI_TYPE _naviType;
    NSString* _appScheme;
    NSString* _appName;
}
///起点，必须包含经纬度坐标（调起地图客户端时设置起点无效，以“我的位置”为起点）
@property (nonatomic, strong) BMKPlanNode* startPoint;
///终点，必须包含经纬度坐标
@property (nonatomic, strong) BMKPlanNode* endPoint;
///导航类型 注：自2.8.0开始废弃，只支持调起客户端导航，在调起客户端导航时，才会调起web导航
@property (nonatomic, assign) BMK_NAVI_TYPE naviType __deprecated_msg("自2.8.0开始废弃");
///应用返回scheme
@property (nonatomic, strong) NSString* appScheme;
///应用名称
@property (nonatomic, strong) NSString* appName;
///调起百度地图客户端驾车导航失败后（步行、骑行导航设置该参数无效），是否支持调起web地图，默认：YES
@property (nonatomic, assign) BOOL isSupportWeb;

@end

///调起百度地图 -- 导航（驾车、步行、骑行）
@interface BMKNavigation : NSObject

/**
*调起百度地图客户端驾车导航页面
*@param para 调起驾车导航时传入得参数
*/
+ (BMKOpenErrorCode)openBaiduMapNavigation:(BMKNaviPara*)para;

/**
 *调起百度地图客户端步行导航页面(不支持调起web地图)
 *客户端v8.8以后支持
 *@param para 调起步行导航时传入得参数
 */
+ (BMKOpenErrorCode)openBaiduMapWalkNavigation:(BMKNaviPara*)para;

/**
 *调起百度地图客户端骑行导航页面(不支持调起web地图)
 *客户端v8.8以后支持
 *@param para 调起骑行导航时传入得参数
 */
+ (BMKOpenErrorCode)openBaiduMapRideNavigation:(BMKNaviPara*)para;

@end


