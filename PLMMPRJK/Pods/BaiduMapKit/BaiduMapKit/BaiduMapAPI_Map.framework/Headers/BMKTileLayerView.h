//
//  BMKTileLayerView.h
//  MapComponent
//
//  Created by wzy on 15/8/7.
//  Copyright © 2015年 baidu. All rights reserved.
//

#ifndef BMKTileLayerView_h
#define BMKTileLayerView_h

#import "BMKOverlayView.h"
#import "BMKTileLayer.h"

/// 该类用于定义一个BMKTileLayerView
@interface BMKTileLayerView : BMKOverlayView

/**
 *@brief 根据指定的tileLayer生成将tiles显示在地图上的View
 *@param tileLayer 制定了覆盖图片，以及图片的覆盖区域
 *@return 以tileLayer新生成View
 */
- (id)initWithTileLayer:(BMKTileLayer*) tileLayer;

/// 该View对应的tileLayer数据对象
@property (nonatomic, readonly) BMKTileLayer *tileLayer;

@end

#endif /* BMKTileLayerView_h */