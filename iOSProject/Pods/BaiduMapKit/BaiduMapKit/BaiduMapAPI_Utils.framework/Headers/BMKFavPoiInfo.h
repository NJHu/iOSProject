//
//  BMKFavPoiInfo.h
//  UtilsComponent
//
//  Created by wzy on 15/4/8.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#ifndef UtilsComponent_BMKFavPoiInfo_h
#define UtilsComponent_BMKFavPoiInfo_h

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

///收藏点信息类
@interface BMKFavPoiInfo : NSObject

///数据ID，自动生成
@property (nonatomic, strong) NSString* favId;
///poi名称（添加或更新时，必须有）
@property (nonatomic, strong) NSString* poiName;
///poi点Uid
@property (nonatomic, strong) NSString* poiUid;
///poi坐标（添加或更新时，必须有）
@property (nonatomic, assign) CLLocationCoordinate2D pt;
///poi地址
@property (nonatomic, strong) NSString* address;
///城市名称
@property (nonatomic, strong) NSString* cityName;
///添加或最后修改时间戳
@property (nonatomic, assign) NSUInteger timeStamp;


@end

#endif
