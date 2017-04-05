/*
 *  BMKCloudSearchInfo.h
 *  BMapKit
 *
 *  Copyright 2013 Baidu Inc. All rights reserved.
 *
 */
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

/// 云检索基础信息类，所有类型云检索的基类
@interface BMKBaseCloudSearchInfo : NSObject
{
    NSString        *_ak;
    NSString        *_sn;
    int             _geoTableId;
}
///access_key（必须），最大长度50
@property (nonatomic, strong) NSString *ak;
///用户的权限签名，（可选），最大长度50
@property (nonatomic, strong) NSString *sn;
///geo table 表主键（必须）
@property (nonatomic, assign) int      geoTableId;

@end

/// 本地,周边,矩形云检索基础信息类
@interface BMKCloudSearchInfo : BMKBaseCloudSearchInfo {
    NSString        *_keyword;
    NSString        *_tags;
    NSString        *_sortby;
    NSString        *_filter;
    NSInteger       _pageIndex;
    NSInteger       _pageSize;

}
///检索关键字，必选。最长45个字符
@property (nonatomic, strong) NSString *keyword;
///标签，可选，空格分隔的多字符串，最长45个字符，样例：美食 小吃
@property (nonatomic, strong) NSString *tags;
/**
 * 排序字段，可选： sortby={keyname}:1 升序；sortby={keyname}:-1 降序。
 * 以下keyname为系统预定义的：
 *     1.distance 距离排序
 *     2.weight 权重排序
 * 默认为按weight排序
 * 如果需要自定义排序则指定排序字段
 *     样例：按照价格由便宜到贵排序sortby=price:1
 */
///排序字段，可选： sortby={keyname}:1 升序；sortby={keyname}:-1 降序
@property (nonatomic, strong) NSString *sortby;
/**
 * 过滤条件，可选
 * '|'竖线分隔的多个key-value对
 * key为筛选字段的名称(存储服务中定义)
 * value可以是整形或者浮点数的一个区间：格式为“small,big”逗号分隔的2个数字
 * 样例：筛选价格为9.99到19.99并且生产时间为2013年的项：price:9.99,19.99|time:2012,2012
 */
///过滤条件，可选:'|'竖线分隔的多个key-value对,price:9.99,19.99|time:2012,2012
@property (nonatomic, strong) NSString *filter;

///分页索引，可选，默认为0
@property (nonatomic, assign) NSInteger       pageIndex;
///分页数量，可选，默认为10，最多为50
@property (nonatomic, assign) NSInteger       pageSize;


@end
///本地云检索参数信息类
@interface BMKCloudLocalSearchInfo : BMKCloudSearchInfo {
    NSString        *_region;
}
///区域名称(市或区的名字，如北京市，海淀区)，必选, 必须最长25个字符
@property (nonatomic, strong) NSString *region;
@end

///周边云检索参数信息类
@interface BMKCloudNearbySearchInfo : BMKCloudSearchInfo {
    NSString        *_location;
    int             _radius;
}
///检索的中心点，逗号分隔的经纬度(116.4321,38.76623),string(25)
@property (nonatomic, strong) NSString *location;
///周边检索半径
@property (nonatomic, assign) int      radius;
@end

///矩形云检索参数信息类
@interface BMKCloudBoundSearchInfo : BMKCloudSearchInfo {
    NSString        *_bounds;
}
///矩形区域，左下角和右上角的经纬度坐标点。2个点用;号分隔(116.30,36.20;117.30,37.20),string(25)
@property (nonatomic, strong) NSString *bounds;
@end

///详情云检索参数信息类
@interface BMKCloudDetailSearchInfo : BMKBaseCloudSearchInfo {
    NSString        *_uid;
}
///uid为poi点的id值
@property (nonatomic, strong) NSString *uid;
@end

///云RGC检索参数信息类
@interface BMKCloudReverseGeoCodeSearchInfo : NSObject

///geo table 表主键（必须）
@property (nonatomic, assign) NSInteger geoTableId;
///经纬度
@property (nonatomic, assign) CLLocationCoordinate2D reverseGeoPoint;

@end

