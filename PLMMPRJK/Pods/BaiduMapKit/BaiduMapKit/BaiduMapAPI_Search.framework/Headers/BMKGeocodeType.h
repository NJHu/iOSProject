/*
 *  BMKGeocodeType.h
 *  BMapKit
 *
 *  Copyright 2011 Baidu Inc. All rights reserved.
 *
 */

#import <BaiduMapAPI_Base/BMKTypes.h>

///反地址编码结果
@interface BMKReverseGeoCodeResult : NSObject
{
	BMKAddressComponent* _addressDetail;
	NSString* _address;
	CLLocationCoordinate2D _location;
	NSArray* _poiList;
}
///层次化地址信息
@property (nonatomic, strong) BMKAddressComponent* addressDetail;
///地址名称
@property (nonatomic, strong) NSString* address;
///商圈名称
@property (nonatomic, strong) NSString* businessCircle;
///结合当前位置POI的语义化结果描述
@property (nonatomic, strong) NSString* sematicDescription;
///城市编码
@property (nonatomic, strong) NSString* cityCode;
///地址坐标
@property (nonatomic) CLLocationCoordinate2D location;
///地址周边POI信息，成员类型为BMKPoiInfo
@property (nonatomic, strong) NSArray* poiList;

@end

///地址编码结果
@interface BMKGeoCodeResult : NSObject
{
    CLLocationCoordinate2D _location;
    NSString* _address;
}
///地理编码位置
@property (nonatomic) CLLocationCoordinate2D location;
///地理编码地址
@property (nonatomic,strong) NSString* address;

@end



