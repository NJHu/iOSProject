/*
 *  BMKCloudPOIList.h
 *  BMapKit
 *
 *  Copyright 2013 Baidu Inc. All rights reserved.
 *
 */
#import <BaiduMapAPI_Base/BMKTypes.h>

/// 云检索结果列表类
@interface BMKCloudPOIList : NSObject {
    NSInteger               _status;
    NSInteger               _total;
    NSInteger               _size;
    NSInteger               _pageNum;
    NSArray                 *_POIs;
    
}
///搜索状态
@property (nonatomic, assign) NSInteger     status;
///结果总数
@property (nonatomic, assign) NSInteger     total;
///当前页返回数量
@property (nonatomic, assign) NSInteger     size;
///页数
@property (nonatomic, assign) NSInteger     pageNum;
///POI结果列表
@property (nonatomic, strong) NSArray       *POIs;

@end


/// 云检索结果信息类
@interface BMKCloudPOIInfo : NSObject {
    int             _uid;
    int             _geotableId;
    NSString        *_title;
    NSString        *_address;
    NSString        *_province;
    NSString        *_city;
    NSString        *_district;
    float           _latitude;
    float           _longitude;
    NSString        *_tags;
    float           _distance;
    float           _weight;
    NSMutableDictionary *_customDict;
    int             _creattime;
    int             _modifytime;
    int             _type;
    

}
///poi数据id
@property (nonatomic, assign) int             uid;
///所属table的id
@property (nonatomic, assign) int             geotableId;
///poi名称
@property (nonatomic, strong) NSString        *title;
///poi地址
@property (nonatomic, strong) NSString        *address;
///poi所属省
@property (nonatomic, strong) NSString        *province;
///poi所属城市
@property (nonatomic, strong) NSString        *city;
///poi所属区县
@property (nonatomic, strong) NSString        *district;
///poi所处位置的纬度
@property (nonatomic, assign) float           latitude;
///poi所处位置的经度
@property (nonatomic, assign) float           longitude;
///poi标签
@property (nonatomic, strong) NSString        *tags;
///poi距离
@property (nonatomic, assign) float           distance;
///权重
@property (nonatomic, assign) float           weight;
///自定义列
@property (nonatomic, strong) NSMutableDictionary *customDict;
///创建时间
@property (nonatomic, assign) int             creattime;
///修改时间
@property (nonatomic, assign) int             modifytime;
///类型
@property (nonatomic, assign) int             type;
///处于位置点的方向
@property (nonatomic, strong) NSString        *direction;
@end

/// 云检索结果百度地图POI信息类
@interface BMKCloudMapPOIInfo : NSObject

///poi名称
@property (nonatomic, strong) NSString *name;
///poi uid
@property (nonatomic, strong) NSString *uid;
///POI坐标
@property (nonatomic, assign) CLLocationCoordinate2D pt;
///poi地址
@property (nonatomic, strong) NSString *address;
///poi标签
@property (nonatomic, strong) NSString *tags;
///poi距离
@property (nonatomic, assign) CGFloat distance;
///处于位置点的方向
@property (nonatomic, strong) NSString* direction;
@end

/// 云RGC检索结果类
@interface BMKCloudReverseGeoCodeResult : NSObject

///层次化地址信息
@property (nonatomic, strong) BMKAddressComponent* addressDetail;
///地址名称
@property (nonatomic, strong) NSString* address;
///地址坐标
@property (nonatomic) CLLocationCoordinate2D location;
///用户定义位置描述
@property (nonatomic, strong) NSString* customLocationDescription;
///推荐的位置描述(结合poiList和customPoiList计算推荐结果)
@property (nonatomic, strong) NSString* recommendedLocationDescription;
///地址周边百度地图POI信息，成员类型为BMKCloudMapPOIInfo
@property (nonatomic, strong) NSArray* poiList;
///地址周边POI信息，成员类型为BMKCloudPOIInfo
@property (nonatomic, strong) NSArray* customPoiList;

@end


