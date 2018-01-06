/*
 *  BMKPoiSearchOption.h
 *  BMapKit
 *
 *  Copyright 2013 Baidu Inc. All rights reserved.
 *
 */
#import <Foundation/Foundation.h>
#import <BaiduMapAPI_Base/BMKTypes.h>

typedef enum{
    BMK_POI_SORT_BY_COMPOSITE = 0,//综合排序
    BMK_POI_SORT_BY_DISTANCE,//距离由近到远排序
}BMKPoiSortType;

/// 检索基础信息类，所有类型Poi检索的基类
@interface BMKBasePoiSearchOption : NSObject
{
    NSString        *_keyword;
    int             _pageIndex;
    int             _pageCapacity;
}
///搜索关键字
@property (nonatomic, strong) NSString *keyword;
///分页索引，可选，默认为0
@property (nonatomic, assign) int      pageIndex;
///分页数量，可选，默认为10，最多为50
@property (nonatomic, assign) int      pageCapacity;

@end

///本地云检索参数信息类
@interface BMKCitySearchOption : BMKBasePoiSearchOption {
    NSString        *_city;
}
///区域名称(市或区的名字，如北京市，海淀区)，必选, 必须最长25个字符
@property (nonatomic, strong) NSString *city;
///是否请求门址信息列表，默认为YES
@property (nonatomic, assign) BOOL requestPoiAddressInfoList;
@end

///周边云检索参数信息类
@interface BMKNearbySearchOption : BMKBasePoiSearchOption {
    CLLocationCoordinate2D        _location;
    int             _radius;
}
///检索的中心点，经纬度
@property (nonatomic, assign) CLLocationCoordinate2D location;
///周边检索半径
@property (nonatomic, assign) int      radius;
//搜索结果排序规则，可选，默认BMK_POI_SORT_BY_COMPOSITE
@property (nonatomic, assign) BMKPoiSortType sortType;

@end

///矩形云检索参数信息类
@interface BMKBoundSearchOption : BMKBasePoiSearchOption {
    CLLocationCoordinate2D _leftBottom;
    CLLocationCoordinate2D _rightTop;
    
}
///矩形区域，左下角和右上角的经纬度坐标点。
@property (nonatomic, assign) CLLocationCoordinate2D leftBottom;
@property (nonatomic, assign) CLLocationCoordinate2D rightTop;
@end

///室内POI检索参数信息类
@interface BMKPoiIndoorSearchOption : BMKBasePoiSearchOption
/// 室内ID（必须）
@property (nonatomic, strong) NSString *indoorId;
/// 楼层（可选），设置后，会优先获取该楼层的室内POI，然后是其它楼层的
@property (nonatomic, strong) NSString *floor;
@end

///poi详情检索信息类
@interface BMKPoiDetailSearchOption : NSObject {
    NSString* _poiUid;
}
///poi的uid，从poi检索返回的BMKPoiResult结构中获取
@property (nonatomic, strong) NSString* poiUid;

@end


