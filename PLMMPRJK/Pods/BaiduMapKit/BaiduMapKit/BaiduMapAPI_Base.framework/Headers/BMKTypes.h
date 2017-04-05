//
//  BMKType.h
//  MapPlatform
//
//  Created by BaiduMapAPI on 13-3-26.
//  Copyright (c) 2013年 baidu. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>
#import <CoreLocation/CoreLocation.h>

#import <UIKit/UIKit.h>
typedef enum
{
    BMK_COORDTYPE_GPS = 0, ///GPS设备采集的原始GPS坐标
    BMK_COORDTYPE_COMMON,  ///google地图、soso地图、aliyun地图、mapabc地图和amap地图所用坐标
} BMK_COORD_TYPE;
enum {
    BMKMapTypeNone       = 0,               ///< 空白地图
    BMKMapTypeStandard   = 1,               ///< 标准地图
    BMKMapTypeSatellite  = 2,               ///< 卫星地图
};
typedef NSUInteger BMKMapType;

typedef enum {
	BMKErrorOk = 0,	///< 正确，无错误
    BMKErrorConnect = 2,	///< 网络连接错误
	BMKErrorData = 3,	///< 数据错误
	BMKErrorRouteAddr = 4, ///<起点或终点选择(有歧义)
	BMKErrorResultNotFound = 100,	///< 搜索结果未找到
	BMKErrorLocationFailed = 200,	///< 定位失败
	BMKErrorPermissionCheckFailure = 300,	///< 百度地图API授权Key验证失败
	BMKErrorParse = 310		///< 数据解析失败
}BMKErrorCode;
//鉴权结果状态码
typedef enum {
    E_PERMISSIONCHECK_CONNECT_ERROR = -300,//链接服务器错误
    E_PERMISSIONCHECK_DATA_ERROR = -200,//服务返回数据异常
    E_PERMISSIONCHECK_OK = 0,	// 授权验证通过
	E_PERMISSIONCHECK_KEY_ERROR = 101,	//ak不存在
	E_PERMISSIONCHECK_MCODE_ERROR = 102,	//mcode签名值不正确
	E_PERMISSIONCHECK_UID_KEY_ERROR = 200,	// APP不存在，AK有误请检查再重试
	E_PERMISSIONCHECK_KEY_FORBIDEN= 201,	// APP被用户自己禁用，请在控制台解禁
    /*
     *更多鉴权状态码请参考：
     *http://developer.baidu.com/map/index.php?title=lbscloud/api/appendix
     */
}BMKPermissionCheckResultCode;
//检索结果状态码
typedef enum{
    BMK_SEARCH_NO_ERROR = 0,///<检索结果正常返回
    BMK_SEARCH_AMBIGUOUS_KEYWORD,///<检索词有岐义
    BMK_SEARCH_AMBIGUOUS_ROURE_ADDR,///<检索地址有岐义
    BMK_SEARCH_NOT_SUPPORT_BUS,///<该城市不支持公交搜索
    BMK_SEARCH_NOT_SUPPORT_BUS_2CITY,///<不支持跨城市公交
    BMK_SEARCH_RESULT_NOT_FOUND,///<没有找到检索结果
    BMK_SEARCH_ST_EN_TOO_NEAR,///<起终点太近
    BMK_SEARCH_KEY_ERROR,///<key错误
    BMK_SEARCH_NETWOKR_ERROR,///网络连接错误
    BMK_SEARCH_NETWOKR_TIMEOUT,///网络连接超时
    BMK_SEARCH_PERMISSION_UNFINISHED,///还未完成鉴权，请在鉴权通过后重试
    BMK_SEARCH_INDOOR_ID_ERROR,///室内图ID错误
    BMK_SEARCH_FLOOR_ERROR,///室内图检索楼层错误
    BMK_SEARCH_INDOOR_ROUTE_NO_IN_BUILDING,///起终点不在支持室内路线的室内图内
    BMK_SEARCH_INDOOR_ROUTE_NO_IN_SAME_BUILDING,///起终点不在同一个室内
    BMK_SEARCH_PARAMETER_ERROR,///参数错误
}BMKSearchErrorCode;

//调起百度地图结果状态码
typedef enum{
    BMK_OPEN_NO_ERROR = 0,///<正常
    BMK_OPEN_WEB_MAP,///打开的是web地图
    BMK_OPEN_OPTION_NULL,///<传入的参数为空
    BMK_OPEN_NOT_SUPPORT,///<没有安装百度地图，或者版本太低
    BMK_OPEN_POI_DETAIL_UID_NULL,///<poi详情 poiUid为空
    BMK_OPEN_POI_NEARBY_KEYWORD_NULL,///<poi周边 keyWord为空
    BMK_OPEN_ROUTE_START_ERROR,///<路线起点有误
    BMK_OPEN_ROUTE_END_ERROR,///<路线终点有误
    BMK_OPEN_PANORAMA_UID_ERROR,///<调起全景 poiUid不正确
    BMK_OPEN_PANORAMA_ABSENT,///<调起全景 此处不支持全景
    BMK_OPEN_PERMISSION_UNFINISHED,///还未完成鉴权，请在鉴权通过后重试
    BMK_OPEN_KEY_ERROR,///<app key错误
    BMK_OPEN_NETWOKR_ERROR,///网络连接错误
}BMKOpenErrorCode;

///表示一个经纬度范围
typedef struct {
    CLLocationDegrees latitudeDelta;	///< 纬度范围
    CLLocationDegrees longitudeDelta;	///< 经度范围
} BMKCoordinateSpan;

///表示一个经纬度区域
typedef struct {
    CLLocationCoordinate2D northEast;	///< 东北角点经纬度坐标
    CLLocationCoordinate2D southWest;	///< 西南角点经纬度坐标
} BMKCoordinateBounds;

///表示一个经纬度区域
typedef struct {
	CLLocationCoordinate2D center;	///< 中心点经纬度坐标
	BMKCoordinateSpan span;		///< 经纬度范围
} BMKCoordinateRegion;

///表示一个经纬度坐标点
typedef struct {
	int latitudeE6;		///< 纬度，乘以1e6之后的值
	int longitudeE6;	///< 经度，乘以1e6之后的值
} BMKGeoPoint;

///地理坐标点，用直角地理坐标表示
typedef struct {
    double x;	///< 横坐标
    double y;	///< 纵坐标
} BMKMapPoint;

///矩形大小，用直角地理坐标表示
typedef struct {
    double width;	///< 宽度
    double height;	///< 高度
} BMKMapSize;

///矩形，用直角地理坐标表示
typedef struct {
    BMKMapPoint origin; ///< 屏幕左上点对应的直角地理坐标
    BMKMapSize size;	///< 坐标范围
} BMKMapRect;

///地图缩放比例
typedef CGFloat BMKZoomScale;

/// 经过投影后的世界范围大小，与经纬度（-85，180）投影后的坐标值对应
UIKIT_EXTERN const BMKMapSize BMKMapSizeWorld;
/// 经过投影后的世界矩形范围
UIKIT_EXTERN const BMKMapRect BMKMapRectWorld;
/// 空的直角坐标矩形
UIKIT_EXTERN const BMKMapRect BMKMapRectNull;

///线路检索节点信息,一个路线检索节点可以通过经纬度坐标或城市名加地名确定
@interface BMKPlanNode : NSObject{
    NSString*              _cityName;
    NSString*              _name;
    CLLocationCoordinate2D _pt;
}

///节点所在城市
@property (nonatomic, strong) NSString* cityName;
///节点所在城市ID
@property (nonatomic, assign) NSInteger cityID;
///节点名称
@property (nonatomic, strong) NSString* name;
///节点坐标
@property (nonatomic) CLLocationCoordinate2D pt;
@end

///室内路线检索节点信息
@interface BMKIndoorPlanNode : NSObject

///节点所在楼层
@property (nonatomic, retain) NSString* floor;
///节点坐标
@property (nonatomic) CLLocationCoordinate2D pt;

@end

///此类表示地址结果的层次化信息
@interface BMKAddressComponent : NSObject

/// 街道号码
@property (nonatomic, strong) NSString* streetNumber;
/// 街道名称
@property (nonatomic, strong) NSString* streetName;
/// 区县名称
@property (nonatomic, strong) NSString* district;
/// 城市名称
@property (nonatomic, strong) NSString* city;
/// 省份名称
@property (nonatomic, strong) NSString* province;
/// 国家
@property (nonatomic, strong) NSString* country;
/// 国家代码
@property (nonatomic, strong) NSString* countryCode;

@end
