//
//  BMKOpenPanorama.h
//  UtilsComponent
//
//  Created by wzy on 16/5/12.
//  Copyright © 2016年 baidu. All rights reserved.
//

#ifndef BMKOpenPanorama_h
#define BMKOpenPanorama_h

#import <BaiduMapAPI_Base/BMKTypes.h>
#import "BMKOpenOption.h"

@protocol BMKOpenPanoramaDelegate;

///调起百度地图全景参数类
@interface BMKOpenPanoramaOption : BMKOpenOption

///poi的uid
@property (nonatomic, strong) NSString* poiUid;

@end

///调起百度地图 -- 全景
@interface BMKOpenPanorama : NSObject

@property (nonatomic, weak) id<BMKOpenPanoramaDelegate> delegate;

/**
 * 调起百度地图全景页面
 * 异步，调起结果在BMKOpenPanoramaDelegate的onGetOpenPanoramaStatus:通知
 *@param option 调起百度地图全景参数类（BMKOpenPanoramaOption）
 */
- (void)openBaiduMapPanorama:(BMKOpenPanoramaOption *) option;

@end

///调起百度地图全景delegate，用于获取调起状态
@protocol BMKOpenPanoramaDelegate <NSObject>

- (void)onGetOpenPanoramaStatus:(BMKOpenErrorCode) ecode;

@end

#endif /* BMKOpenPanorama_h */
