//
//  MPLocation.h  火星坐标系转换扩展
//  MobileProject
// 分为 地球坐标，火星坐标（iOS mapView 高德 ， 国内google ,搜搜、阿里云 都是火星坐标），百度坐标(百度地图数据主要都是四维图新提供的)
//火星坐标: MKMapView
//地球坐标: CLLocationManager
//当用到CLLocationManager 得到的数据转化为火星坐标, MKMapView不用处理
//API                坐标系
//百度地图API         百度坐标
//腾讯搜搜地图API      火星坐标
//搜狐搜狗地图API      搜狗坐标
//阿里云地图API       火星坐标
//图吧MapBar地图API   图吧坐标
//高德MapABC地图API   火星坐标
//灵图51ditu地图API   火星坐标
//  Created by wujunyang on 16/1/15.
//  Copyright © 2016年 wujunyang. All rights reserved.


#import <CoreLocation/CoreLocation.h>

@interface CLLocation(MPLocation)


//从地图坐标转化到火星坐标
- (CLLocation*)locationMarsFromEarth;

//从火星坐标转化到百度坐标
- (CLLocation*)locationBaiduFromMars;

//从百度坐标到火星坐标
- (CLLocation*)locationMarsFromBaidu;

@end
