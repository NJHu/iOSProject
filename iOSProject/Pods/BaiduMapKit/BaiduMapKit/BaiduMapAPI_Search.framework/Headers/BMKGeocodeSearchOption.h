/*
 *  BMKGeoCodeSearchOption.h
 *  BMapKit
 *
 *  Copyright 2013 Baidu Inc. All rights reserved.
 *
 */

#import <BaiduMapAPI_Base/BMKTypes.h>
/// geo检索信息类
@interface BMKGeoCodeSearchOption : NSObject
{
    NSString        *_address;
    NSString        *_city;
}
///地址
@property (nonatomic, strong) NSString *address;
///城市名
@property (nonatomic, strong) NSString *city;
@end

///反geo检索信息类
@interface BMKReverseGeoCodeOption : NSObject {
    CLLocationCoordinate2D        _reverseGeoPoint;
}
///经纬度
@property (nonatomic, assign) CLLocationCoordinate2D reverseGeoPoint;
@end



