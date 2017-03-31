//
//  MPLocationManager.h
//  MobileProject
//
//  Created by wujunyang on 16/1/15.
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BaiduMapAPI_Map/BMKMapView.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>

typedef void(^KSystemLocationBlock)(CLLocation *loction, NSError *error);
typedef void(^KBMKLocationBlock)(BMKUserLocation *loction, NSError *error);

@interface MPLocationManager : NSObject


+ (void)installMapSDK;


+ (id)shareInstance;

/**
 *  启动系统定位
 *
 *  @param systemLocationBlock 系统定位成功或失败回调成功
 */
- (void)startSystemLocationWithRes:(KSystemLocationBlock)systemLocationBlock;

/**
 *  启动百度地图定位
 *
 *  @param bmkLocationBlock 百度地图定位成功或失败回调成功
 */
- (void)startBMKLocationWithReg:(KBMKLocationBlock)bmkLocationBlock;


@end
