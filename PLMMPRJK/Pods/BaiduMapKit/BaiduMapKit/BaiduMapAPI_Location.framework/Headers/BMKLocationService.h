//
//  BMKLocationService.h
//  LocationComponent
//
//  Created by Baidu on 3/28/14.
//  Copyright (c) 2014 baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BaiduMapAPI_Base/BMKUserLocation.h>
@class CLLocation;
/// 定位服务Delegate,调用startUserLocationService定位成功后，用此Delegate来获取定位数据
@protocol BMKLocationServiceDelegate <NSObject>
@optional
/**
 *在将要启动定位时，会调用此函数
 */
- (void)willStartLocatingUser;

/**
 *在停止定位后，会调用此函数
 */
- (void)didStopLocatingUser;

/**
 *用户方向更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation;

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation;

/**
 *定位失败后，会调用此函数
 *@param error 错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error;
@end

@interface BMKLocationService : NSObject

/// 当前用户位置，返回坐标为百度坐标
@property (nonatomic, readonly) BMKUserLocation *userLocation;

/// 定位服务Delegate,调用startUserLocationService定位成功后，用此Delegate来获取定位数据
@property (nonatomic, weak) id<BMKLocationServiceDelegate> delegate;

/**
 *打开定位服务
 *需要在info.plist文件中添加(以下二选一，两个都添加默认使用NSLocationWhenInUseUsageDescription)：
 *NSLocationWhenInUseUsageDescription 允许在前台使用时获取GPS的描述
 *NSLocationAlwaysUsageDescription 允许永远可获取GPS的描述
 */
-(void)startUserLocationService;
/**
 *关闭定位服务
 */
-(void)stopUserLocationService;

#pragma mark - 定位参数，具体含义可参考CLLocationManager相关属性的注释

/// 设定定位的最小更新距离。默认为kCLDistanceFilterNone
@property(nonatomic, assign) CLLocationDistance distanceFilter;

/// 设定定位精度。默认为kCLLocationAccuracyBest。
@property(nonatomic, assign) CLLocationAccuracy desiredAccuracy;

/// 设定最小更新角度。默认为1度，设定为kCLHeadingFilterNone会提示任何角度改变。
@property(nonatomic, assign) CLLocationDegrees headingFilter;

/// 指定定位是否会被系统自动暂停。默认为YES。只在iOS 6.0之后起作用。
@property(nonatomic, assign) BOOL pausesLocationUpdatesAutomatically;

///指定定位：是否允许后台定位更新。默认为NO。只在iOS 9.0之后起作用。设为YES时，Info.plist中 UIBackgroundModes 必须包含 "location"
@property(nonatomic, assign) BOOL allowsBackgroundLocationUpdates;


#pragma mark - 废弃接口
/**
 * 2.9.0起废弃（使用distanceFilter属性替换），空实现
 *
 *在打开定位服务前设置
 *指定定位的最小更新距离(米)，默认：kCLDistanceFilterNone
 */
+ (void)setLocationDistanceFilter:(CLLocationDistance) distanceFilter __deprecated_msg("废弃方法（空实现），使用distanceFilter属性替换");
/**
 * 2.9.0起废弃（使用distanceFilter属性替换），空实现
 *
 *获取当前 定位的最小更新距离(米)
 */
+ (CLLocationDistance)getCurrentLocationDistanceFilter __deprecated_msg("废弃方法（空实现），使用distanceFilter属性替换");
/**
 * 2.9.0起废弃（使用desiredAccuracy属性替换），空实现
 *
 *在打开定位服务前设置
 *设置定位精确度，默认：kCLLocationAccuracyBest
 */
+ (void)setLocationDesiredAccuracy:(CLLocationAccuracy) desiredAccuracy __deprecated_msg("废弃方法（空实现），使用desiredAccuracy属性替换");
/**
 * 2.9.0起废弃（使用desiredAccuracy属性替换），空实现
 *
 *获取当前 定位精确度
 */
+ (CLLocationAccuracy)getCurrentLocationDesiredAccuracy __deprecated_msg("废弃方法（空实现），使用desiredAccuracy属性替换");

@end
