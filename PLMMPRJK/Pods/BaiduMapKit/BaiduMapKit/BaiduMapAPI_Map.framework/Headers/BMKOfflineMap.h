/*
 *  BMKOfflineMap.h
 *  BMapKit
 *
 *  Copyright 2011 Baidu Inc. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>
#import "BMKOfflineMapType.h"


@protocol BMKOfflineMapDelegate;

///离线地图事件类型
enum  {
	TYPE_OFFLINE_UPDATE = 0,        ///<下载或更新
	TYPE_OFFLINE_ZIPCNT	= 1,        ///<检测到的压缩包个数
	TYPE_OFFLINE_UNZIP = 2,			///<当前解压的离线包
	TYPE_OFFLINE_ERRZIP = 3,		///<错误的离线包
	TYPE_OFFLINE_NEWVER = 4,		///<有新版本
	TYPE_OFFLINE_UNZIPFINISH = 5,	///<扫描完毕
	TYPE_OFFLINE_ADD = 6			///<新增离线包
};

///离线地图服务
@interface BMKOfflineMap : NSObject

@property (nonatomic, weak) id<BMKOfflineMapDelegate> delegate;



/**
 *自2.9.0起废弃，不支持扫描导入离线包
 *扫描离线地图压缩包,异步函数
 *@return 成功返回YES，否则返回NO
 */
- (BOOL)scan:(BOOL)deleteFailedr __deprecated_msg("废弃方法(空实现),自2.9.0起废弃,不支持扫描导入离线包");

/**
 *启动下载指定城市id的离线地图
 *@param cityID 指定的城市id
 *@return 成功返回YES，否则返回NO
 */
- (BOOL)start:(int)cityID;

/**
 *启动更新指定城市id的离线地图
 *@param cityID 指定的城市id
 *@return 成功返回YES，否则返回NO
 */
- (BOOL)update:(int)cityID;

/**
 *暂停下载指定城市id的离线地图
 *@param cityID 指定的城市id
 *@return 成功返回YES，否则返回NO
 */
- (BOOL)pause:(int)cityID;

/**
 *删除下载指定城市id的离线地图
 *@param cityID 指定的城市id
 *@return 成功返回YES，否则返回NO
 */
- (BOOL)remove:(int)cityID;

/**
 *返回热门城市列表
 *@return 热门城市列表,用户需要显示释放该数组，数组元素为BMKOLSearchRecord
 */
- (NSArray*)getHotCityList;

/**
 *返回所有支持离线地图的城市列表
 *@return 支持离线地图的城市列表,用户需要显示释放该数组，数组元素为BMKOLSearchRecord
 */
- (NSArray*)getOfflineCityList;

/**
 *根据城市名搜索该城市离线地图记录
 *@param cityName 城市名
 *@return 该城市离线地图记录,用户需要显示释放该数组，数组元素为BMKOLSearchRecord
 */
- (NSArray*)searchCity:(NSString*)cityName;

/**
 *返回各城市离线地图更新信息
 *@return 各城市离线地图更新信息,用户需要显示释放该数组，数组元素为BMKOLUpdateElement
 */
- (NSArray*)getAllUpdateInfo;

/**
 *返回指定城市id离线地图更新信息
 *@param cityID 指定的城市id
 *@return 指定城市id离线地图更新信息
 */
- (BMKOLUpdateElement*)getUpdateInfo:(int)cityID;

@end


///离线地图delegate，用于获取通知
@protocol BMKOfflineMapDelegate<NSObject>
/**
 *返回通知结果
 *@param type 事件类型： TYPE_OFFLINE_UPDATE,TYPE_OFFLINE_ZIPCNT,TYPE_OFFLINE_UNZIP, TYPE_OFFLINE_ERRZIP, TYPE_VER_UPDATE, TYPE_OFFLINE_UNZIPFINISH, TYPE_OFFLINE_ADD
 *@param state 事件状态，当type为TYPE_OFFLINE_UPDATE时，表示正在下载或更新城市id为state的离线包，当type为TYPE_OFFLINE_ZIPCNT时，表示检测到state个离线压缩包，当type为TYPE_OFFLINE_ADD时，表示新安装的离线地图数目，当type为TYPE_OFFLINE_UNZIP时，表示正在解压第state个离线包，当type为TYPE_OFFLINE_ERRZIP时，表示有state个错误包，当type为TYPE_VER_UPDATE时，表示id为state的城市离线包有更新，当type为TYPE_OFFLINE_UNZIPFINISH时，表示扫瞄完成，成功导入state个离线包
 */
- (void)onGetOfflineMapState:(int)type withState:(int)state;

@end


