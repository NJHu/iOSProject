/*
 *  BMKBusLineSearch.h
 *  BMapKit
 *
 *  Copyright 2014 Baidu Inc. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>
#import "BMKPoiSearchType.h"
#import <BaiduMapAPI_Base/BMKTypes.h>
#import "BMKBusLineSearchOption.h"
#import "BMKRouteSearchType.h"
#import "BMKSearchBase.h"

@protocol BMKBusLineSearchDelegate;
///busline搜索服务
@interface BMKBusLineSearch : BMKSearchBase
/// 检索模块的Delegate，此处记得不用的时候需要置nil，否则影响内存的释放
@property (nonatomic, weak) id<BMKBusLineSearchDelegate> delegate;

/**
 *公交详情检索
 *异步函数，返回结果在BMKBusLineSearchDelegate的onGetBusDetailResult通知
 *@param busLineSearchOption 公交线路检索信息类
 *@return 成功返回YES，否则返回NO
 */
- (BOOL)busLineSearch:(BMKBusLineSearchOption*)busLineSearchOption;


@end

///搜索delegate，用于获取搜索结果
@protocol BMKBusLineSearchDelegate<NSObject>
@optional
/**
 *返回busdetail搜索结果
 *@param searcher 搜索对象
 *@param busLineResult 搜索结果
 *@param error 错误号，@see BMKSearchErrorCode
 */
- (void)onGetBusDetailResult:(BMKBusLineSearch*)searcher result:(BMKBusLineResult*)busLineResult errorCode:(BMKSearchErrorCode)error;

@end




