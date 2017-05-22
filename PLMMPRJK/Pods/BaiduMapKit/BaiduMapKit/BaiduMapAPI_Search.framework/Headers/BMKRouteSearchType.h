/*
 *  BMKRouteSearchType.h
 *	BMapKit
 *
 *  Copyright 2011 Baidu Inc. All rights reserved.
 *
 */

#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>
#import "BMKPoiSearchType.h"
#import <BaiduMapAPI_Base/BMKTypes.h>
///路段类型枚举
typedef enum
{
    BMK_BUSLINE                 = 0,///公交
	BMK_SUBWAY                  = 1,///地铁
 	BMK_WAKLING                 = 2,///步行
}BMKTransitStepType;

///交通方式枚举
typedef enum
{
    BMK_TRANSIT_SUBWAY        = 0,///地铁
    BMK_TRANSIT_TRAIN         = 1,///火车
    BMK_TRANSIT_PLANE         = 2,///飞机
    BMK_TRANSIT_BUSLINE       = 3,///公交
    BMK_TRANSIT_DRIVING       = 4,///驾车
    BMK_TRANSIT_WAKLING       = 5,///步行
    BMK_TRANSIT_COACH         = 6,///大巴
}BMKMassTransitType;


///室内路线结点类型
typedef enum
{
    BMK_INDOOR_STEP_NODE_TYPE_ELEVATOR        = 1,///直梯
    BMK_INDOOR_STEP_NODE_TYPE_ESCALATOR       = 2,///扶梯
    BMK_INDOOR_STEP_NODE_TYPE_STAIR           = 3,///楼梯
    BMK_INDOOR_STEP_NODE_TYPE_SECURITY_CHECK  = 4,///安检
}BMKIndoorStepNodeType;

typedef enum
{
	BMK_TRANSIT_TIME_FIRST = 3,		//较快捷(公交)
	BMK_TRANSIT_TRANSFER_FIRST = 4,	//少换乘(公交)
	BMK_TRANSIT_WALK_FIRST = 5,		//少步行(公交)
	BMK_TRANSIT_NO_SUBWAY = 6,		//不坐地铁
}BMKTransitPolicy;

/// 公共交通：市内公交换乘策略
typedef enum
{
    BMK_MASS_TRANSIT_INCITY_RECOMMEND         = 0,//推荐
    BMK_MASS_TRANSIT_INCITY_TRANSFER_FIRST    = 1,//少换乘
    BMK_MASS_TRANSIT_INCITY_WALK_FIRST        = 2,//少步行
    BMK_MASS_TRANSIT_INCITY_NO_SUBWAY         = 3,//不坐地铁
    BMK_MASS_TRANSIT_INCITY_TIME_FIRST        = 4,//较快捷
    BMK_MASS_TRANSIT_INCITY_SUBWAY_FIRST      = 5,//地铁优先
}BMKMassTransitIncityPolicy;

/// 公共交通：跨城公交换乘策略
typedef enum
{
    BMK_MASS_TRANSIT_INTERCITY_TIME_FIRST    = 0,//较快捷
    BMK_MASS_TRANSIT_INTERCITY_START_EARLY   = 1,//出发早
    BMK_MASS_TRANSIT_INTERCITY_PRICE_FIRST   = 2,//价格低
}BMKMassTransitIntercityPolicy;

/// 公共交通：跨城交通方式策略
typedef enum
{
    BMK_MASS_TRANSIT_INTERCITY_TRANS_TRAIN_FIRST    = 0,//火车优先
    BMK_MASS_TRANSIT_INTERCITY_TRANS_PLANE_FIRST    = 1,//飞机优先
    BMK_MASS_TRANSIT_INTERCITY_TRANS_BUS_FIRST      = 2,//大巴优先
}BMKMassTransitIntercityTransPolicy;


typedef enum
{
    BMK_DRIVING_BLK_FIRST = -1, //躲避拥堵(自驾)
	BMK_DRIVING_TIME_FIRST = 0,	//最短时间(自驾)
	BMK_DRIVING_DIS_FIRST = 1,	//最短路程(自驾)
	BMK_DRIVING_FEE_FIRST,		//少走高速(自驾)

}BMKDrivingPolicy;

typedef enum
{
    BMK_DRIVING_REQUEST_TRAFFICE_TYPE_NONE = 0,                 //不带路况
    BMK_DRIVING_REQUEST_TRAFFICE_TYPE_PATH_AND_TRAFFICE = 1,    //道路和路况
}BMKDrivingRequestTrafficType;

///打车信息类
@interface BMKTaxiInfo : NSObject

///路线打车描述信息
@property (nonatomic, strong) NSString* desc;
///总路程，单位： 米
@property (nonatomic) int distance;
///总耗时，单位： 秒
@property (nonatomic) int duration;
///每千米单价(白天)，单位 元
@property (nonatomic) CGFloat perKMPrice;
///起步价(白天)，单位 元
@property (nonatomic) CGFloat startPrice;
///总价(预估) , 单位： 元
@property (nonatomic) int totalPrice;

@end

///路线换乘方案里的交通工具信息类
@interface BMKVehicleInfo : NSObject{
    NSString* _uid;
    NSString* _title;
    int       _passStationNum;
    int       _totalPrice;
    int       _zonePrice;
}
///该交通路线的标识
@property (nonatomic, strong) NSString* uid;
///该交通路线的名称
@property (nonatomic, strong) NSString* title;
///该交通路线的所乘站数
@property (nonatomic) int passStationNum;
///该交通路线的全程价格
@property (nonatomic) int totalPrice;
///该交通路线的所乘区间的区间价格
@property (nonatomic) int zonePrice;
@end

///此类代表一个时间段，每个属性都是一个时间段。
@interface BMKTime : NSObject{
    int       _dates;
    int       _hours;
    int       _minutes;
    int       _seconds;
    
}

///时间段，单位（天）
@property (nonatomic) int dates;
///时间段，单位（小时）
@property (nonatomic) int hours;
///时间段，单位（分）
@property (nonatomic) int minutes;
///时间段，单位（秒）
@property (nonatomic) int seconds;
@end

///此类表示路线中的一节点，节点包括：路线起终点，公交站点等
@interface BMKRouteNode : NSObject{
    NSString*              _uid;
    NSString*              _title;
    CLLocationCoordinate2D _location;
}
///该节点uid
@property (nonatomic, strong) NSString* uid;
///该节点的名称
@property (nonatomic, strong) NSString* title;
///该节点的坐标
@property (nonatomic) CLLocationCoordinate2D location;
@end
///此类表示公交站点信息
@interface BMKBusStation : BMKRouteNode
@end


///此类表示路线中的一个路段（基类）
@interface BMKRouteStep : NSObject{
    int          _distance;
    int          _duration;
    BMKMapPoint* _points;
    int          _pointsCount;
}
///路段长度 单位： 米
@property (nonatomic) int distance;
///路段耗时 单位： 秒
@property (nonatomic) int duration;
///路段所经过的地理坐标集合
@property (nonatomic) BMKMapPoint* points;
///路段所经过的地理坐标集合内点的个数
@property (nonatomic) int pointsCount;

@end

///此类表示公交线路中的一个路段
@interface BMKBusStep : BMKRouteStep
@end

///此类表示公交换乘路线中的一个路段
@interface BMKTransitStep : BMKRouteStep{
    BMKRouteNode*        _entrace;
    BMKRouteNode*        _exit;
    NSString*            _instruction;
    BMKTransitStepType   _stepType;
    BMKVehicleInfo*      _vehicleInfo;
}
///路段入口信息
@property (nonatomic, strong) BMKRouteNode* entrace;
///路段出口信息
@property (nonatomic, strong) BMKRouteNode* exit;
///路段换乘说明
@property (nonatomic, strong) NSString* instruction;
///路段类型
@property (nonatomic) BMKTransitStepType stepType;
///当路段为公交路段或地铁路段时，可以获取交通工具信息
@property (nonatomic, strong) BMKVehicleInfo* vehicleInfo;
@end

///公共交通方案里的交通工具信息基类类
@interface BMKBaseVehicleInfo : NSObject

///该交通路线的名称
@property (nonatomic, strong) NSString* name;
///出发站
@property (nonatomic, strong) NSString* departureStation;
///到达站
@property (nonatomic, strong) NSString* arriveStation;
///出发时间(BMKBusVehicleInfo时departureTime为空)
@property (nonatomic, strong) NSString* departureTime;
///到达时间(BMKBusVehicleInfo时arriveTime为空)
@property (nonatomic, strong) NSString* arriveTime;

@end

///公共交通方案里的交通工具信息类- 公交车、地铁
@interface BMKBusVehicleInfo : BMKBaseVehicleInfo

///该交通路线的所乘站数
@property (nonatomic, assign) NSInteger passStationNum;
///始发车发车时间
@property (nonatomic, strong) NSString* firstTime;
///末班车发车时间
@property (nonatomic, strong) NSString* lastTime;

@end
///公共交通方案里的交通工具信息类 - 飞机
@interface BMKPlaneVehicleInfo : BMKBaseVehicleInfo

///价格（单位：元）
@property (nonatomic, assign) CGFloat price;
///折扣
@property (nonatomic, assign) CGFloat discount;
///航空公司
@property (nonatomic, strong) NSString* airlines;
///订票网址
@property (nonatomic, strong) NSString* bookingUrl;

@end
///公共交通方案里的交通工具信息类 - 火车
@interface BMKTrainVehicleInfo : BMKBaseVehicleInfo

///价格（单位：元）
@property (nonatomic, assign) CGFloat price;
///订票电话
@property (nonatomic, strong) NSString* booking;

@end
///公共交通方案里的交通工具信息类 - 大巴
@interface BMKCoachVehicleInfo : BMKBaseVehicleInfo

///价格（单位：元）
@property (nonatomic, assign) CGFloat price;
///订票网址
@property (nonatomic, strong) NSString* bookingUrl;
///合作方名称
@property (nonatomic, strong) NSString* providerName;
///合作方官网
@property (nonatomic, strong) NSString* providerUrl;

@end

///此类表示公共交通路线中的路段
@interface BMKMassTransitStep : NSObject
///steps中是方案还是子路段，YES:steps是BMKMassTransitStep的子路段（A到B需要经过多个steps）;NO:steps是多个方案（A到B有多个方案选择）
@property (nonatomic, assign) BOOL isSubStep;
///本BMKMassTransitStep中的有几个方案或几个子路段，成员类型为BMKMassTransitSubStep
@property (nonatomic, strong) NSArray *steps;

@end

///此类表示公共交通路线中的一个路段
@interface BMKMassTransitSubStep : BMKRouteStep

///路段入口经纬度
@property (nonatomic, assign) CLLocationCoordinate2D entraceCoor;
///路段出口经纬度
@property (nonatomic, assign) CLLocationCoordinate2D exitCoor;
///路段说明
@property (nonatomic, strong) NSString* instructions;
///路段类型
@property (nonatomic) BMKMassTransitType stepType;
///该路段交通工具信息（当stepType为公交地铁时，BMKBusVehicleInfo对象；stepType为大巴时，BMKCoachVehicleInfo对象；stepType为飞机时，BMKPlaneVehicleInfo对象；stepType为火车时，BMKTrainVehicleInfo对象；其它为nil）
@property (nonatomic, strong) BMKBaseVehicleInfo* vehicleInfo;

@end

///此类表示驾车路线中的一个路段
@interface BMKDrivingStep : BMKRouteStep{
    int                  _direction;
    BMKRouteNode*        _entrace;
    NSString*            _entraceInstruction;
    BMKRouteNode*        _exit;
    NSString*            _exitInstruction;
    NSString*            _instruction;
    int                  _numTurns;
}
///该路段起点方向值
@property (nonatomic) int direction;
///路段入口信息
@property (nonatomic, strong) BMKRouteNode* entrace;
///路段入口的指示信息
@property (nonatomic, strong) NSString* entraceInstruction;
///路段出口信息
@property (nonatomic, strong) BMKRouteNode* exit;
///路段出口指示信息
@property (nonatomic, strong) NSString* exitInstruction;
///路段总体指示信息
@property (nonatomic, strong) NSString* instruction;
///路段需要转弯数
@property (nonatomic) int numTurns;
///路段是否有路况信息
@property (nonatomic) BOOL hasTrafficsInfo;
///路段的路况信息，成员为NSNumber。0：无数据；1：畅通；2：缓慢；3：拥堵
@property (nonatomic, strong) NSArray* traffics;

@end

///室内路线结点
@interface BMKIndoorStepNode : NSObject

///坐标
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
///类型
@property (nonatomic, assign) BMKIndoorStepNodeType type;
///描述
@property (nonatomic, strong) NSString* desc;

@end

/// 此类表示室内路线的一个路段
@interface BMKIndoorRouteStep : BMKRouteStep

///入口信息
@property (nonatomic, strong) BMKRouteNode* entrace;
///出口信息
@property (nonatomic, strong) BMKRouteNode* exit;
///路段指示信息
@property (nonatomic, strong) NSString* instructions;
///建筑物id
@property (nonatomic, strong) NSString* buildingid;
///室内楼层id
@property (nonatomic, strong) NSString* floorid;
///结点数组，成员类型为：BMKIndoorStepNode
@property (nonatomic, strong) NSArray* indoorStepNodes;

@end

///此类表示步行路线中的一个路段
@interface BMKWalkingStep : BMKRouteStep{
    int                  _direction;
    BMKRouteNode*        _entrace;
    NSString*            _entraceInstruction;
    BMKRouteNode*        _exit;
    NSString*            _exitInstruction;
    NSString*            _instruction;
}
///该路段起点方向值
@property (nonatomic) int direction;
///路段入口信息
@property (nonatomic, strong) BMKRouteNode* entrace;
///获取该路段入口指示信息
@property (nonatomic, strong) NSString* entraceInstruction;
///路段出口信息
@property (nonatomic, strong) BMKRouteNode* exit;
///获取该路段出口指示信息
@property (nonatomic, strong) NSString* exitInstruction;
///获取该路段指示信息
@property (nonatomic, strong) NSString* instruction;
@end

///此类表示骑行路线中的一个路段
@interface BMKRidingStep : BMKRouteStep

///该路段起点方向值
@property (nonatomic) NSInteger direction;
///路段入口信息
@property (nonatomic, strong) BMKRouteNode* entrace;
///获取该路段入口指示信息
@property (nonatomic, strong) NSString* entraceInstruction;
///路段出口信息
@property (nonatomic, strong) BMKRouteNode* exit;
///获取该路段出口指示信息
@property (nonatomic, strong) NSString* exitInstruction;
///获取该路段指示信息
@property (nonatomic, strong) NSString* instruction;

@end


///此类表示路线数据结构的基类,表示一条路线，路线可能包括：路线规划中的换乘/驾车/步行路线
///此类为路线数据结构的基类，一般关注其子类对象即可，无需直接生成该类对象
@interface BMKRouteLine : NSObject{
    int                  _distance;
    BMKTime*             _duration;
    BMKRouteNode*        _starting;
    BMKRouteNode*        _terminal;
    NSString*            _title;
    NSArray*             _steps;
}
///路线长度 单位： 米
@property (nonatomic) int distance;
///路线耗时 单位： 秒
@property (nonatomic, strong) BMKTime* duration;
///路线起点信息
@property (nonatomic, strong) BMKRouteNode* starting;
///路线终点信息
@property (nonatomic, strong) BMKRouteNode* terminal;
///路线名称(预留字段，现为空)
@property (nonatomic, strong) NSString* title;
///路线中的所有路段，成员类型为BMKWalkingStep，BMKDrivingStep，BMKTransitStep，BMKRidingStep，BMKIndoorRouteStep，BMKMassTransitStep
@property (nonatomic, strong) NSArray* steps;
@end

///此类表示一个换乘路线，换乘路线将根据既定策略调配多种交通工具
@interface BMKTransitRouteLine : BMKRouteLine
@end
///此类表示一条公共交通路线
@interface BMKMassTransitRouteLine : BMKRouteLine

///路线花费
@property (nonatomic, assign) CGFloat price;

@end
///此类表示一个室内路线
@interface BMKIndoorRouteLine : BMKRouteLine
@end
///此类表示一条驾车路线
@interface BMKDrivingRouteLine : BMKRouteLine{
    bool                 _isSupportTraffic;//从2.7.0开始，废弃
    NSArray*             _wayPoints;
}
///该路线所在区域是否含有交通流量信息，从2.7.0开始，废弃
@property (nonatomic) bool isSupportTraffic;
///路线途经点列表，成员类型为BMKPlanNode
@property (nonatomic, strong) NSArray* wayPoints;
///路线红绿灯个数
@property (nonatomic, assign) NSInteger lightNum;
///路线拥堵米数，发起请求时需设置参数 drivingRequestTrafficType = BMK_DRIVING_REQUEST_TRAFFICE_TYPE_PATH_AND_TRAFFICE 才有值
@property (nonatomic, assign) NSInteger congestionMetres;
///路线预估打车费(元)，负数表示无打车费信息
@property (nonatomic, assign) NSInteger taxiFares;

@end

///此类表示一条步行路线
@interface BMKWalkingRouteLine : BMKRouteLine
@end

///此类表示一条骑行路线
@interface BMKRidingRouteLine : BMKRouteLine
@end

///路线搜索地址结果类.当输入的起点或终点有多个地点选择时，或者选定的城市没有此地点，但其它城市有(驾乘或步行)，返回该类的实例
@interface BMKSuggestAddrInfo : NSObject
{
	NSArray* _startPoiList;
	NSArray* _endPoiList;
	NSArray* _startCityList;
	NSArray* _endCityList;
    NSArray* _wayPointsPoiList;
    NSArray* _wayPointsCityList;
}
///起点POI列表，成员类型为BMKPoiInfo
@property (nonatomic, strong) NSArray* startPoiList;
///起点城市列表，成员类型为BMKCityListInfo,如果输入的地点在本城市没有而在其它城市有，则返回其它城市的信息
@property (nonatomic, strong) NSArray* startCityList;
///终点POI列表，成员类型为BMKPoiInfo
@property (nonatomic, strong) NSArray* endPoiList;
///终点城市列表，成员类型为BMKCityListInfo,如果输入的地点在本城市没有而在其它城市有，则返回其它城市的信息
@property (nonatomic, strong) NSArray* endCityList;
///途经点POI列表，成员类型为NSArray<BMKPoiInfo*>
@property (nonatomic, strong) NSArray* wayPointPoiList;
///途经点城市列表，成员类型为NSArray<BMKCityListInfo*>,如果输入的地点在本城市没有而在其它城市有，则返回其它城市的信息
@property (nonatomic, strong) NSArray* wayPointCityList;
@end

///此类表示公共交通信息查询结果
@interface BMKBusLineResult : NSObject{
    NSString* _busCompany;
    NSString* _busLineName;
    NSString* _uid;
    NSString* _startTime;
    NSString* _endTime;
    int       _isMonTicket;
    NSArray*  _busStations;
    NSArray*  _busSteps;
}
///公交公司名称
@property (nonatomic, strong) NSString* busCompany;
///公交线路名称
@property (nonatomic, strong) NSString* busLineName;
///公交线路方向
@property (nonatomic, strong) NSString* busLineDirection;
///公交线路uid
@property (nonatomic, strong) NSString* uid;
///公交路线首班车时间
@property (nonatomic, strong) NSString* startTime;
///公交路线末班车时间
@property (nonatomic, strong) NSString* endTime;
///公交是线是否有月票
@property (nonatomic) int isMonTicket;
///起步票价
@property (nonatomic, assign) CGFloat basicPrice;
///全程票价
@property (nonatomic, assign) CGFloat totalPrice;
///所有公交站点信息,成员类型为BMKBusStation
@property (nonatomic, strong) NSArray* busStations;
///公交路线分段信息，成员类型为BMKBusStep
@property (nonatomic, strong) NSArray* busSteps;
@end

///此类表示步行路线结果
@interface BMKWalkingRouteResult : NSObject{
    BMKTaxiInfo*        _taxiInfo;
    BMKSuggestAddrInfo* _suggestAddrResult;
    NSArray*            _routes;
}
///该路线打车信息
@property (nonatomic, strong) BMKTaxiInfo* taxiInfo;
///返回起点或终点的地址信息结果
@property (nonatomic, strong) BMKSuggestAddrInfo* suggestAddrResult;
///步行结果,现在只返回一条。成员类型为BMKWalkingRouteLine
@property (nonatomic, strong) NSArray* routes;

@end

///此类表示驾车路线结果
@interface BMKDrivingRouteResult : NSObject{
    BMKTaxiInfo*        _taxiInfo;
    BMKSuggestAddrInfo* _suggestAddrResult;
    NSArray*            _routes;
}
///该路线打车信息
@property (nonatomic, strong) BMKTaxiInfo* taxiInfo;
///返回起点或终点的地址信息结果
@property (nonatomic, strong) BMKSuggestAddrInfo* suggestAddrResult;
///驾车结果,支持多路线。成员类型为BMKDrivingRouteLine
@property (nonatomic, strong) NSArray* routes;

@end

@interface BMKTransitRouteResult : NSObject{
    BMKTaxiInfo*        _taxiInfo;
    BMKSuggestAddrInfo* _suggestAddrResult;
    NSArray*            _routes;
}
///该路线打车信息
@property (nonatomic, strong) BMKTaxiInfo* taxiInfo;
///返回起点或终点的地址信息结果
@property (nonatomic, strong) BMKSuggestAddrInfo* suggestAddrResult;
///方案数组,成员类型为BMKTransitRouteLine
@property (nonatomic, strong) NSArray* routes;

@end

///此类表示公共交通路线结果
@interface BMKMassTransitRouteResult : NSObject

///返回起点或终点的地址信息结果
@property (nonatomic, strong) BMKSuggestAddrInfo* suggestAddrResult;
///方案数组,成员类型为BMKMassTransitRouteLine
@property (nonatomic, strong) NSArray* routes;
///总方案数
@property (nonatomic, assign) NSInteger totalRoutes;
///该路线打车信息(只有起终点是大陆地区且是同城的请求时才返回此字段, 否则此字段为nil)
@property (nonatomic, strong) BMKTaxiInfo* taxiInfo;

@end

///此类表示骑行路线结果
@interface BMKRidingRouteResult : NSObject

///返回起点或终点的地址信息结果
@property (nonatomic, strong) BMKSuggestAddrInfo* suggestAddrResult;
///骑行路线结果,成员类型为BMKRidingRouteLine
@property (nonatomic, strong) NSArray* routes;

@end

/// 此类表示室内路线结果
@interface BMKIndoorRouteResult : NSObject

///方案数组,成员类型为BMKIndoorRouteLine
@property (nonatomic, strong) NSArray* routes;

@end
