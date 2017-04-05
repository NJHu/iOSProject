/*
 *  BMKPoiSearchType.h
 *  BMapKit
 *
 *  Copyright 2011 Baidu Inc. All rights reserved.
 *
 */

#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>
enum {
	BMKInvalidCoordinate = -1,  ///<无效坐标
    BMKCarTrafficFIRST = 60,    ///<驾乘检索策略常量：躲避拥堵，若无实时路况，默认按照时间优先策略
	BMKCarTimeFirst = 0,		///<驾乘检索策略常量：时间优先
	BMKCarDisFirst,				///<驾乘检索策略常量：最短距离
	BMKCarFeeFirst,				///<驾乘检索策略常量：较少费用
	BMKBusTimeFirst,			///<公交检索策略常量：时间优先
	BMKBusTransferFirst,		///<公交检索策略常量：最少换乘
	BMKBusWalkFirst,			///<公交检索策略常量：最小步行距离
	BMKBusNoSubway,				///<公交检索策略常量：不含地铁
	BMKTypeCityList = 7,		///<POI检索类型：城市列表
	BMKTypePoiList = 11,		///<POI检索类型：城市内搜索POI列表
	BMKTypeAreaPoiList = 21,	///<POI检索类型：范围搜索、周边搜索POI列表
	BMKTypeAreaMultiPoiList = 45	///<POI检索类型：多关键字范围搜索、周边搜索POI列表
};

///城市列表信息类
@interface BMKCityListInfo : NSObject
{
	NSString* _city;
	int		  _num;
}
///城市名称
@property (nonatomic, strong) NSString* city;
///该城市所含搜索结果数目
@property (nonatomic) int num;

@end


///POI信息类
@interface BMKPoiInfo : NSObject
{
	NSString* _name;			///<POI名称
    NSString* _uid;
	NSString* _address;		///<POI地址
	NSString* _city;			///<POI所在城市
	NSString* _phone;		///<POI电话号码
	NSString* _postcode;		///<POI邮编
	int		  _epoitype;		///<POI类型，0:普通点 1:公交站 2:公交线路 3:地铁站 4:地铁线路
	CLLocationCoordinate2D _pt;	///<POI坐标
}
///POI名称
@property (nonatomic, strong) NSString* name;
///POIuid
@property (nonatomic, strong) NSString* uid;
///POI地址
@property (nonatomic, strong) NSString* address;
///POI所在城市
@property (nonatomic, strong) NSString* city;
///POI电话号码
@property (nonatomic, strong) NSString* phone;
///POI邮编
@property (nonatomic, strong) NSString* postcode;
///POI类型，0:普通点 1:公交站 2:公交线路 3:地铁站 4:地铁线路
@property (nonatomic) int epoitype;
///POI坐标
@property (nonatomic) CLLocationCoordinate2D pt;
///是否有全景
@property (nonatomic, assign) BOOL panoFlag;
@end

///POI门址信息类
@interface BMKPoiAddressInfo : NSObject

///名称
@property (nonatomic, strong) NSString* name;
///地址
@property (nonatomic, strong) NSString* address;
///坐标
@property (nonatomic, assign) CLLocationCoordinate2D pt;

@end


///POI搜索结果类
@interface BMKPoiResult : NSObject
{
	int _totalPoiNum;		///<本次POI搜索的总结果数
	int _currPoiNum;			///<当前页的POI结果数
	int _pageNum;			///<本次POI搜索的总页数
	int _pageIndex;			///<当前页的索引
	
	NSArray* _poiInfoList;	///<POI列表，成员是BMKPoiInfo
	NSArray* _cityList;		///<城市列表，成员是BMKCityListInfo
}
///本次POI搜索的总结果数
@property (nonatomic) int totalPoiNum;
///当前页的POI结果数
@property (nonatomic) int currPoiNum;
///本次POI搜索的总页数
@property (nonatomic) int pageNum;
///当前页的索引
@property (nonatomic) int pageIndex;
///POI列表，成员是BMKPoiInfo
@property (nonatomic, strong) NSArray* poiInfoList;
///城市列表，成员是BMKCityListInfo
@property (nonatomic, strong) NSArray* cityList;

///是否返回的有门址信息列表
@property (nonatomic, assign) BOOL isHavePoiAddressInfoList;
///门址信息列表，成员是BMKPoiAddrsInfo(当进行的是poi城市检索，且检索关键字是具体的门址信息（如在北京搜"上地十街10号"）时，会返回此信息)
@property (nonatomic, strong) NSArray* poiAddressInfoList;

@end

///poi详情检索结果类
@interface BMKPoiDetailResult : NSObject {
    NSString* _name;
    CLLocationCoordinate2D _pt;
    NSString* _address;
    NSString* _phone;
    NSString* _uid;
    NSString* _tag;
    NSString* _detailUrl;
    NSString* _type;
    double  _price;
    double _overallRating;
    double _tasteRating;
    double _serviceRating;
    double _environmentRating;
    double _facilityRating;
    double _hygieneRating;
    double _technologyRating;
    int _imageNum;
    int _grouponNum;
    int _commentNum;
    int _favoriteNum;
    int _checkInNum;
    NSString* _shopHours;
}
///POI名称
@property (nonatomic, strong) NSString* name;
///POI地址
@property (nonatomic, strong) NSString* address;
///POI电话号码
@property (nonatomic, strong) NSString* phone;
///POIuid
@property (nonatomic, strong) NSString* uid;
///POI标签
@property (nonatomic, strong) NSString* tag;
///POI详情页url
@property (nonatomic, strong) NSString* detailUrl;
///POI所属分类，如“hotel”，“cater”，“life”
@property (nonatomic, strong) NSString* type;
///POI地理坐标
@property (nonatomic) CLLocationCoordinate2D pt;
///POI价格
@property (nonatomic) double price;
///POI综合评分
@property (nonatomic) double overallRating;
///POI口味评分
@property (nonatomic) double tasteRating;
///POI服务评分
@property (nonatomic) double serviceRating;
///POI环境评分
@property (nonatomic) double environmentRating;
///POI设施评分
@property (nonatomic) double facilityRating;
///POI卫生评分
@property (nonatomic) double hygieneRating;
///POI技术评分
@property (nonatomic) double technologyRating;
///POI图片数目
@property (nonatomic) int imageNum;
///POI团购数目
@property (nonatomic) int grouponNum;
///POI评论数目
@property (nonatomic) int commentNum;
///POI收藏数目
@property (nonatomic) int favoriteNum;
///POI签到数目
@property (nonatomic) int checkInNum;
///POI营业时间
@property (nonatomic, strong) NSString* shopHours;
@end

///室内POI信息类
@interface BMKPoiIndoorInfo : NSObject

///POI名称
@property (nonatomic, strong) NSString* name;
///POIuid
@property (nonatomic, strong) NSString* uid;
///该室内POI所在 室内ID
@property (nonatomic, strong) NSString* indoorId;
///该室内POI所在楼层
@property (nonatomic, strong) NSString* floor;
///POI地址
@property (nonatomic, strong) NSString* address;
///POI所在城市
@property (nonatomic, strong) NSString* city;
///POI电话号码
@property (nonatomic, strong) NSString* phone;
///POI坐标
@property (nonatomic) CLLocationCoordinate2D pt;
///POI标签
@property (nonatomic, strong) NSString* tag;
///价格
@property (nonatomic, assign) double price;
///星级（0-50），50表示五星
@property (nonatomic, assign) NSInteger starLevel;
///是否有团购
@property (nonatomic, assign) BOOL grouponFlag;
///是否有外卖
@property (nonatomic, assign) BOOL takeoutFlag;
///是否排队
@property (nonatomic, assign) BOOL waitedFlag;
///团购数,-1表示没有团购信息
@property (nonatomic, assign) NSInteger grouponNum;

@end

///POI室内搜索结果类
@interface BMKPoiIndoorResult : NSObject

///本次POI室内搜索的总结果数
@property (nonatomic, assign) NSInteger totalPoiNum;
///当前页的室内POI结果数
@property (nonatomic, assign) NSInteger currPoiNum;
///本次POI室内搜索的总页数
@property (nonatomic, assign) NSInteger pageNum;
///当前页的索引
@property (nonatomic) int pageIndex;
///室内POI列表，成员是BMKPoiIndoorInfo
@property (nonatomic, strong) NSArray* poiIndoorInfoList;

@end

