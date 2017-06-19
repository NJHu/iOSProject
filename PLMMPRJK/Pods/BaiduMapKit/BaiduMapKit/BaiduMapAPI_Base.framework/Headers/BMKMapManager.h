/*
 *  BMKMapManager.h
 *  BMapKit
 *
 *  Copyright 2011 Baidu Inc. All rights reserved.
 *
 */

#import "BMKGeneralDelegate.h"
#import <UIKit/UIKit.h>
#import "BMKTypes.h"

enum EN_PERMISSION_STATUS
{
	E_PERMISSION_OK = 0,	// 授权验证通过
	E_PERMISSION_SERVER_ERROR = -200, //服务端数据错误，无法解析服务端返回数据
	E_PERMISSION_NETWORK_ERROR = -300, //无法建立与服务端的连接
    
};

//地图模块枚举
typedef enum {
    BMKMapModuleTile = 0,   //瓦片图模块
}BMKMapModule;

///主引擎类
@interface BMKMapManager : NSObject

/**
 *百度地图SDK所有接口均支持百度坐标（BD09LL）和国测局坐标（GCJ02），用此方法设置您使用的坐标类型.
 *默认是BD09LL（BMK_COORDTYPE_BD09LL）坐标.
 *如果需要使用GCJ02坐标，需要设置CoordinateType为：BMK_COORDTYPE_COMMON.
 */
+ (BOOL)setCoordinateTypeUsedInBaiduMapSDK:(BMK_COORD_TYPE) coorType;

/**
 *获取百度地图SDK当前使用的经纬度类型
 *@return 经纬度类型
 */
+ (BMK_COORD_TYPE)getCoordinateTypeUsedInBaiduMapSDK;

/**
 *是否开启打印某模块的log，默认不打印log
 *debug时，建议打开，有利于调试程序；release时建议关闭
 *@param enable 是否开启
 *@param mapModule 地图模块
 */
+ (void)logEnable:(BOOL) enable module:(BMKMapModule) mapModule;

/**
*启动引擎
*@param key 申请的有效key
*@param delegate 
*/
-(BOOL)start:(NSString*)key generalDelegate:(id<BMKGeneralDelegate>)delegate;

/**
 *获取所有在线服务消耗的发送流量,单位：字节
 */
-(int)getTotalSendFlaxLength;

/**
 *获取所有在线服务消耗的接收流量,单位：字节
 */
-(int)getTotalRecvFlaxLength;

/**
*停止引擎
*/
-(BOOL)stop;



@end


