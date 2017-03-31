//
//  MPLocationManager.m
//  MobileProject
//
//  Created by wujunyang on 16/1/15.
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#import "MPLocationManager.h"

@interface MPLocationManager()<BMKGeneralDelegate,BMKLocationServiceDelegate,CLLocationManagerDelegate>
@property (nonatomic, readwrite, strong) CLLocationManager *locationManager;
@property (nonatomic, readwrite, strong) BMKLocationService *locService;

@property (nonatomic, readwrite, copy) KSystemLocationBlock kSystemLocationBlock;
@property (nonatomic, readwrite, copy) KBMKLocationBlock    kBMKLocationBlock;
@end

@implementation MPLocationManager

+ (id)shareInstance{
    static id helper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[MPLocationManager alloc]  init];
    });
    return helper;
}


+ (void)installMapSDK{
    BMKMapManager *manager = [[BMKMapManager alloc] init];
    [manager start:kBaiduMapKey generalDelegate:nil];
}

#pragma mark - 苹果
/**
 *  苹果系统自带地图定位
 */
- (void)startSystemLocationWithRes:(KSystemLocationBlock)systemLocationBlock{
    self.kSystemLocationBlock = systemLocationBlock;
    
    if(!self.locationManager){
        self.locationManager =[[CLLocationManager alloc] init];
        self.locationManager.desiredAccuracy=kCLLocationAccuracyBest;
        //        self.locationManager.distanceFilter=10;
        if ([UIDevice currentDevice].systemVersion.floatValue >=8) {
            [self.locationManager requestWhenInUseAuthorization];//使用程序其间允许访问位置数据（iOS8定位需要）
        }
    }
    self.locationManager.delegate=self;
    [self.locationManager startUpdatingLocation];//开启定位
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    CLLocation *currLocation=[locations lastObject];
    self.locationManager.delegate = nil;
    [self.locationManager stopUpdatingLocation];
    
    self.kSystemLocationBlock(currLocation, nil);
}
/**
 *定位失败，回调此方法
 */
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    if ([error code]==kCLErrorDenied) {
        NSLog(@"访问被拒绝");
    }
    if ([error code]==kCLErrorLocationUnknown) {
        NSLog(@"无法获取位置信息");
    }
    self.locationManager.delegate = nil;
    [self.locationManager stopUpdatingLocation];
    
    self.kSystemLocationBlock(nil, error);
}


#pragma mark - 百度
/**
 *  百度地图定位
 */
- (void)startBMKLocationWithReg:(KBMKLocationBlock)bmkLocationBlock{
    self.kBMKLocationBlock = bmkLocationBlock;
    
    //初始化BMKLocationService
    if (!self.locService) {
        self.locService = [[BMKLocationService alloc]init];
        self.locService.delegate = self;
    }
    self.locService.desiredAccuracy=kCLLocationAccuracyNearestTenMeters;
    //指定最小距离更新(米)，默认：kCLDistanceFilterNone
    self.locService.distanceFilter=100.f;
    //启动LocationService
    [self.locService startUserLocationService];
}

//实现相关delegate 处理位置信息更新
//处理方向变更信息
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    //NSLog(@"heading is %@",userLocation.heading);
    
}
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    //    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    [self.locService stopUserLocationService];
    
    self.kBMKLocationBlock(userLocation, nil);
}


/**
 *定位失败后，会调用此函数
 *@param error 错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error{
    [self.locService stopUserLocationService];
    
    self.kBMKLocationBlock(nil, error);
}


- (void)onGetPermissionState:(int)iError
{
    if (iError == 0)
    {
        NSLog(@"授权成功");
    }
    else
    {
        NSLog(@"授权错误码%d",iError);
    }
}
@end
