//
//  BMKFavPoiManager.h
//  UtilsComponent
//
//  Created by wzy on 15/4/9.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#ifndef UtilsComponent_BMKFavPoiManager_h
#define UtilsComponent_BMKFavPoiManager_h

#import "BMKFavPoiInfo.h"

///收藏点管理类
@interface BMKFavPoiManager : NSObject

/**
 * 添加一个poi点
 * @param favPoiInfo 点信息,in/out，输出包含favId和添加时间
 * @return -2:收藏夹已满，-1:名称为空，0：添加失败，1：添加成功
 */
- (NSInteger)addFavPoi:(BMKFavPoiInfo*) favPoiInfo;

/**
 * 获取一个收藏点信息
 * @param favId 添加时返回的favId，也可通过getAllFavPois获取的信息中BMKFavPoiInfo的属性favId
 * @return 收藏点信息,没有返回nil
 */
- (BMKFavPoiInfo*)getFavPoi:(NSString*) favId;

/**
 * 获取所有收藏点信息
 * @return 点信息数组
 */
- (NSArray*)getAllFavPois;

/**
 * 更新一个收藏点
 * @param favId 添加时返回的favId，也可通过getAllFavPois获取的信息中BMKFavPoiInfo的属性favId
 * @param favPoiInfo 点信息,in/out，输出包含修改时间
 * @return 成功返回YES，失败返回NO
 */
- (BOOL)updateFavPoi:(NSString*) favId favPoiInfo:(BMKFavPoiInfo*) favPoiInfo;

/**
 * 删除一个收藏点
 * @param favId 添加时返回的favId，也可通过getAllFavPois获取的信息中BMKFavPoiInfo的属性favId
 * @return 成功返回YES，失败返回NO
 */
- (BOOL)deleteFavPoi:(NSString*) favId;

/**
 * 清空所有收藏点
 * @return 成功返回YES，失败返回NO
 */
- (BOOL)clearAllFavPois;

@end

#endif
