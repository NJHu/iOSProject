//
//  BMKOpenRouteOption.h
//  UtilsComponent
//
//  Created by wzy on 15/3/26.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#ifndef UtilsComponent_BMKOpenRouteOption_h
#define UtilsComponent_BMKOpenRouteOption_h

#import <UIKit/UIKit.h>
#import "BMKOpenOption.h"
#import <BaiduMapAPI_Base/BMKTypes.h>

typedef enum
{
    BMK_OPEN_TRANSIT_RECOMMAND = 3,     //推荐
    BMK_OPEN_TRANSIT_TRANSFER_FIRST,	//少换乘
    BMK_OPEN_TRANSIT_WALK_FIRST,		//少步行
    BMK_OPEN_TRANSIT_NO_SUBWAY,         //不坐地铁
    BMK_OPEN_TRANSIT_TIME_FIRST,		//时间短
}BMKOpenTransitPolicy;

///此类管理调起百度地图路线时传入的参数
@interface BMKOpenRouteOption : BMKOpenOption

///起点
@property (nonatomic, strong) BMKPlanNode *startPoint;
///终点
@property (nonatomic, strong) BMKPlanNode *endPoint;

@end

///此类管理调起百度地图步行路线时传入的参数
@interface BMKOpenWalkingRouteOption : BMKOpenRouteOption

@end

///此类管理调起百度地图驾车路线时传入的参数
@interface BMKOpenDrivingRouteOption : BMKOpenRouteOption

@end

///此类管理调起百度地图公共交通路线时传入的参数
@interface BMKOpenTransitRouteOption : BMKOpenRouteOption

//策略，默认：BMK_OPEN_TRANSIT_RECOMMAND(异常值，强制使用BMK_OPEN_TRANSIT_RECOMMAND)
@property (nonatomic, assign) BMKOpenTransitPolicy openTransitPolicy;

@end


#endif
