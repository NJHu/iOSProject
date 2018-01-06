/*
 *  BMKOffineMapType.h
 *  BMapKit
 *
 *  Copyright 2011 Baidu Inc. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

///离线地图搜索城市记录结构
@interface BMKOLSearchRecord : NSObject
{
	NSString* _cityName;
	int		  _size;
	int		  _cityID;
    int       _cityType;
    NSArray*  _childCities;
}
///城市名称
@property (nonatomic, strong) NSString* cityName;
///数据包总大小
@property (nonatomic) int size;
///城市ID
@property (nonatomic) int cityID;
///城市类型 0：全国；1：省份；2：城市；如果是省份，可以通过childCities得到子城市列表
@property (nonatomic) int cityType;
///子城市列表
@property (nonatomic, strong) NSArray*  childCities;


@end


///离线地图更新信息
@interface BMKOLUpdateElement : NSObject
{
	NSString* _cityName;
	int		  _cityID;
	int		  _size;
	int		  _serversize;
	BOOL	  _update;
	int		  _ratio;
	int		  _status;
	CLLocationCoordinate2D _pt;
}
///城市名称
@property (nonatomic, strong) NSString* cityName;
///城市ID
@property (nonatomic) int cityID;
///已下载数据大小，单位：字节
@property (nonatomic) int size;
///服务端数据大小，当update为YES时有效，单位：字节
@property (nonatomic) int serversize;
///下载比率，100为下载完成，下载完成后会自动导入，status为4时离线包导入完成
@property (nonatomic) int ratio;
///下载状态, -1:未定义 1:正在下载　2:等待下载　3:已暂停　4:完成 5:校验失败 6:网络异常 7:读写异常 8:Wifi网络异常 9:离线包数据格式异常，需重新下载离线包 10:离线包导入中
@property (nonatomic) int status;
///更新状态，离线包是否有更新（有更新需重新下载）
@property (nonatomic) BOOL update;
///城市中心点
@property (nonatomic) CLLocationCoordinate2D pt;

@end

