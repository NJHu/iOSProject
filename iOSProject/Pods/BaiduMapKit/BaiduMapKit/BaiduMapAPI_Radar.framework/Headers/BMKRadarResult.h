//
//  BMKRadarResult.h
//  RadarComponent
//
//  Created by wzy on 15/4/22.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#ifndef RadarComponent_BMKRadarResult_h
#define RadarComponent_BMKRadarResult_h

#import "BMKRadarOption.h"

///雷达结果码
typedef enum {
    BMK_RADAR_NO_ERROR = 0,///<成功
    BMK_RADAR_NO_RESULT,///<无结果
    BMK_RADAR_AK_NOT_BIND,///<app key没有绑定，请到管理后台绑定
    BMK_RADAR_NETWOKR_ERROR,///网络连接错误
    BMK_RADAR_NETWOKR_TIMEOUT,///网络连接超时
    BMK_RADAR_PERMISSION_UNFINISHED,///还未完成鉴权，请在鉴权通过后重试
    BMK_RADAR_AK_ERROR,///<app key错误
    BMK_RADAR_USERID_NOT_EXIST,///<userId不存在
    BMK_RADAR_FORBID_BY_USER,///<被开发者禁用
    BMK_RADAR_FORBID_BY_ADMIN///<被管理员禁用
}BMKRadarErrorCode;

///周边的用户信息类
@interface BMKRadarNearbyInfo : NSObject

///用户id
@property (nonatomic, strong) NSString* userId;
///地址坐标
@property (nonatomic, assign) CLLocationCoordinate2D pt;
///距离
@property (nonatomic, assign) NSUInteger distance;
///扩展信息
@property (nonatomic, strong) NSString* extInfo;
///设备类型
@property (nonatomic, strong) NSString* mobileType;
///设备系统
@property (nonatomic, strong) NSString* osType;
///时间戳
@property (nonatomic, assign) NSTimeInterval timeStamp;


@end


///查询周边的用户信息结果类
@interface BMKRadarNearbyResult : NSObject

///总结果数
@property (nonatomic, assign) NSInteger totalNum;
///总页数
@property (nonatomic, assign) NSInteger pageNum;
///当前页结果数
@property (nonatomic, assign) NSInteger currNum;
///当前页索引
@property (nonatomic, assign) NSInteger pageIndex;
///结果列表 : BMKRadarNearbyInfo数组
@property (nonatomic, strong) NSArray* infoList;


@end

#endif
