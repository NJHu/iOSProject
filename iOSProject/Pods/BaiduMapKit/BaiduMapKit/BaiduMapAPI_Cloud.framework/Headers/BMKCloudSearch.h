/*
 *  BMKCloudSearch.h
 *  BMapKit
 *
 *  Copyright 2013 Baidu Inc. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>
#import "BMKCloudSearchInfo.h"
#import "BMKCloudPOIList.h"

@protocol BMKCloudSearchDelegate;
/// 云检索类型
typedef enum
{
    BMK_NONE_SEARCH                 = 0,
    BMK_CLOUD_LOCAL_SEARCH          = 1,///<本地云检索
    BMK_CLOUD_NEARBY_SEARCH         = 2,///<周边云检索
    BMK_CLOUD_BOUND_SEARCH          = 3,///<区域云检索
    BMK_CLOUD_DETAIL_SEARCH         = 4,///<POI详情
    BMK_CLOUD_RGC_SEARCH            = 5///<云RGC检索
}BMKCloudSearchType;

//云检索结果状态码
typedef enum{
    BMK_CLOUD_PERMISSION_UNFINISHED = -4,///<还未完成鉴权，请在鉴权通过后重试
    BMK_CLOUD_NETWOKR_ERROR = -3,///<网络连接错误
    BMK_CLOUD_NETWOKR_TIMEOUT = -2,///<网络连接超时
    BMK_CLOUD_RESULT_NOT_FOUND = -1,///<没有找到检索结果
    BMK_CLOUD_NO_ERROR = 0,///<检索结果正常返回
    BMK_CLOUD_SERVER_ERROR = 1,///<云检索服务器内部错误
    BMK_CLOUD_PARAM_ERROR = 2,///<输入参数有误（geoTableId或者其它参数有误）
    /*
     *更多云检索状态码请参考：
     *http://developer.baidu.com/map/index.php?title=lbscloud/api/appendix
     */
}BMKCloudErrorCode;

///云检索服务
@interface BMKCloudSearch : NSObject
/// 检索模块的Delegate，此处记得不用的时候需要置nil，否则影响内存的释放
@property (nonatomic, weak) id<BMKCloudSearchDelegate> delegate;
/**
 *本地云检索
 *异步函数，返回结果在BMKCloudSearchDelegate的onGetCloudPoiResult通知
 *@param searchInfo 搜索参数
 *@return 成功返回YES，否则返回NO
 */
- (BOOL)localSearchWithSearchInfo:(BMKCloudLocalSearchInfo *)searchInfo;
/**
 *周边云检索
 *异步函数，返回结果在BMKCloudSearchDelegate的onGetCloudPoiResult通知
 *@param searchInfo 搜索参数
 *@return 成功返回YES，否则返回NO
 */
- (BOOL)nearbySearchWithSearchInfo:(BMKCloudNearbySearchInfo *)searchInfo;
/**
 *矩形云检索
 *异步函数，返回结果在BMKCloudSearchDelegate的onGetCloudPoiResult通知
 *@param searchInfo 搜索参数
 *@return 成功返回YES，否则返回NO
 */
- (BOOL)boundSearchWithSearchInfo:(BMKCloudBoundSearchInfo *)searchInfo;

/**
 *详情云检索
 *异步函数，返回结果在BMKCloudSearchDelegate的onGetCloudPoiDetailResult通知
 *@param searchInfo 搜索参数
 *@return 成功返回YES，否则返回NO
 */
- (BOOL)detailSearchWithSearchInfo:(BMKCloudDetailSearchInfo *)searchInfo;

/**
 *云RGC检索：根据地理坐标获取地址信息
 *异步函数，返回结果在BMKCloudSearchDelegate的onGetCloudReverseGeoCodeResult通知
 *@param searchInfo 云RGC检索信息类
 *@return 成功返回YES，否则返回NO
 */
- (BOOL)cloudReverseGeoCodeSearch:(BMKCloudReverseGeoCodeSearchInfo*)searchInfo;

@end

///云检索delegate，用于获取云检索结果
@protocol BMKCloudSearchDelegate<NSObject>
@optional
/**
 *返回云检索POI列表结果
 *@param poiResultList 云检索结果列表，成员类型为BMKCloudPOIList
 *@param type 返回结果类型： BMK_CLOUD_LOCAL_SEARCH,BMK_CLOUD_NEARBY_SEARCH,BMK_CLOUD_BOUND_SEARCH
 *@param error 错误号，@see BMKCloudErrorCode
 */
- (void)onGetCloudPoiResult:(NSArray*)poiResultList searchType:(int)type errorCode:(int)error;

/**
 *返回云检索POI详情
 *@param poiDetailResult 类型为BMKCloudPOIInfo
 *@param type 返回结果类型： BMK_CLOUD_DETAIL_SEARCH
 *@param error 错误号，@see BMKCloudErrorCode
 */
- (void)onGetCloudPoiDetailResult:(BMKCloudPOIInfo*)poiDetailResult searchType:(int)type errorCode:(int)error;

/**
 *返回云RGC检索结果
 *@param cloudRGCResult 搜索结果
 *@param type 返回结果类型： BMK_CLOUD_RGC_SEARCH
 *@param error 错误号，@see BMKCloudErrorCode
 */
- (void)onGetCloudReverseGeoCodeResult:(BMKCloudReverseGeoCodeResult*)cloudRGCResult searchType:(BMKCloudSearchType) type errorCode:(NSInteger) errorCode;

@end
