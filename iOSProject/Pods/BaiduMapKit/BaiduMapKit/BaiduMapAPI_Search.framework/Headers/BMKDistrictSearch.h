//
//  BMKDistrictSearch.h
//  SearchComponent
//
//  Created by wzy on 15/12/14.
//  Copyright © 2015年 baidu. All rights reserved.
//

#ifndef BMKDistrictSearch_h
#define BMKDistrictSearch_h
#import <BaiduMapAPI_Base/BMKTypes.h>
#import "BMKSearchBase.h"

/// 行政区域检索信息
@interface BMKDistrictSearchOption : NSObject

/// 城市名字（必须）
@property (nonatomic, strong) NSString *city;
/// 区县名字（可选）
@property (nonatomic, strong) NSString *district;

@end

#pragma mark -

/// 行政区域检索结果
@interface BMKDistrictResult : NSObject

/// 行政区域编码
@property (nonatomic, assign) NSInteger code;
/// 行政区域名称
@property (nonatomic, strong) NSString *name;
/// 行政区域中心点
@property (nonatomic, assign) CLLocationCoordinate2D center;
/// 行政区边界直角地理坐标点数据(NSString数组，字符串数据格式为: @"x,y;x,y")
@property (nonatomic, strong) NSArray *paths;

@end

#pragma mark -

@protocol BMKDistrictSearchDelegate;

/// 行政区域搜索服务
@interface BMKDistrictSearch : BMKSearchBase
/// 检索模块的delegate，此处记得不用的时候需要置nil，否则影响内存的释放
@property (nonatomic, weak) id<BMKDistrictSearchDelegate> delegate;

/**
 *行政区域检索
 *异步函数，返回结果在BMKDistrictSearchDelegate的onGetDistrictResult通知
 *@param districtSearchOption 公交线路检索信息类
 *@return 成功返回YES，否则返回NO
 */
- (BOOL)districtSearch:(BMKDistrictSearchOption*)districtSearchOption;

@end

#pragma mark -

///搜索delegate，用于获取行政区域搜索结果
@protocol BMKDistrictSearchDelegate<NSObject>
@optional
/**
 *返回行政区域搜索结果
 *@param searcher 搜索对象
 *@param result 搜索结BMKDistrictSearch果
 *@param error 错误号，@see BMKSearchErrorCode
 */
- (void)onGetDistrictResult:(BMKDistrictSearch *)searcher result:(BMKDistrictResult *)result errorCode:(BMKSearchErrorCode)error;

@end

#endif /* BMKDistrictSearch_h */
