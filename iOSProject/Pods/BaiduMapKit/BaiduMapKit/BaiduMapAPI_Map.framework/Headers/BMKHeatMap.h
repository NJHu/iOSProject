/*
 *  BMKHeatMap.h
 *  BMapKit
 *
 *  Copyright 2013 Baidu Inc. All rights reserved.
 *
 */
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <BaiduMapAPI_Base/BMKTypes.h>
#import "BMKGradient.h"
///热力图节点信息
@interface BMKHeatMapNode : NSObject{
    double                 _intensity;
    CLLocationCoordinate2D _pt;
}

///点的强度权值
@property (nonatomic) double intensity;
///点的位置坐标
@property (nonatomic) CLLocationCoordinate2D pt;

@end



///热力图的绘制数据和显示样式类
@interface BMKHeatMap : NSObject
{
	int    _mRadius; //Heatmap point radius
    BMKGradient* _mGradient;//Gradient of the color map
    double   _mOpacity;//Opacity of the overall heatmap overlay [0...1]
    NSMutableArray*  _mData;
    
}
///设置热力图点半径，默认为12ps
@property (nonatomic, assign) int mRadius;
///设置热力图渐变，有默认值 DEFAULT_GRADIENT
@property (nonatomic, strong) BMKGradient* mGradient;
///设置热力图层透明度，默认 0.6
@property (nonatomic, assign) double mOpacity;
///用户传入的热力图数据,数组,成员类型为BMKHeatMapNode
@property (nonatomic, strong) NSMutableArray* mData;

@end



