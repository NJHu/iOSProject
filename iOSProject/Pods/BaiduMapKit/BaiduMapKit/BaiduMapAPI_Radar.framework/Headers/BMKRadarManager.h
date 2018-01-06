//
//  BMKRadarManager.h
//  RadarComponent
//
//  Created by wzy on 15/4/22.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#ifndef RadarComponent_BMKRadarManager_h
#define RadarComponent_BMKRadarManager_h

#import "BMKRadarOption.h"
#import "BMKRadarResult.h"

///雷达delegate
@protocol BMKRadarManagerDelegate <NSObject>

@optional
/*
 *开启自动上传，需实现该回调
 */
- (BMKRadarUploadInfo*)getRadarAutoUploadInfo;

/**
 *返回雷达 上传结果
 *@param error 错误号，@see BMKRadarErrorCode
 */
- (void)onGetRadarUploadResult:(BMKRadarErrorCode) error;

/**
 *返回雷达 清除我的信息结果
 *@param error 错误号，@see BMKRadarErrorCode
 */
- (void)onGetRadarClearMyInfoResult:(BMKRadarErrorCode) error;

/**
 *返回雷达 查询周边的用户信息结果
 *@param result 结果，类型为@see BMKRadarNearbyResult
 *@param error 错误号，@see BMKRadarErrorCode
 */
- (void)onGetRadarNearbySearchResult:(BMKRadarNearbyResult*) result error:(BMKRadarErrorCode) error;

@end


///周边雷达管理类
@interface BMKRadarManager : NSObject

/// 上传时用，上传前需设置，不设置自动生成userId；切换用户时，需手动清除原先用户的位置信息
@property (nonatomic, strong) NSString* userId;

/**
 *获取周边雷达实例，使用引用计数管理该实例内存
 */
+ (BMKRadarManager*)getRadarManagerInstance;
/**
 *release周边雷达实例，使用引用计数管理该实例内存
 */
+ (void)releaseRadarManagerInstance;

/**
 *添加周边雷达delegate，用于结果回调
 *不需要时，需要使用removeRadarManagerDelegate:移除，否则影响内存释放
 *@param delegate,  添加的id<BMKRadarManagerDelegate>对象
 */
- (void)addRadarManagerDelegate:(id<BMKRadarManagerDelegate>) delegate;

/**
 *移除周边雷达delegate，取消结果回调
 *@param delegate,  需要移除的id<BMKRadarManagerDelegate>对象
 */
- (void)removeRadarManagerDelegate:(id<BMKRadarManagerDelegate>) delegate;

/**
 *启动自动上传用户位置信息
 *必须实现回调方法@see getRadarAutoUploadInfo，获取@see BMKRadarUploadInfo
 *@param interval 时间间隔，不小于5s（小于强制设为5s）
 */
- (void)startAutoUpload:(NSTimeInterval) interval;

/**
 *停止自动上传用户位置信息
 */
- (void)stopAutoUpload;

/**
 *单次上传用户位置信息
 *上传时间间隔不小于5s，否则return NO
 *返回结果回调：@see onGetRadarUploadResult:
 *@param info 位置信息
 */
- (BOOL)uploadInfoRequest:(BMKRadarUploadInfo*) info;

/**
 *清除我的位置信息
 *返回结果回调：@see onGetRadarClearMyInfoResult:
 */
- (BOOL)clearMyInfoRequest;

/**
 *查询周边的用户信息
 *返回结果回调：@see onGetRadarNearbySearchResult:error:
 *@param option 查询参数: 类型为@see BMKRadarNearbySearchOption
 */
- (BOOL)getRadarNearbySearchRequest:(BMKRadarNearbySearchOption*) option;

@end
#endif
