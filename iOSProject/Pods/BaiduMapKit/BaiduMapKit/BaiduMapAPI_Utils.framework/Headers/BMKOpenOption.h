//
//  BMKOpenOption.h
//  UtilsComponent
//
//  Created by wzy on 15/3/26.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#ifndef UtilsComponent_BMKOpenOption_h
#define UtilsComponent_BMKOpenOption_h

///调起百度地图参数基类
@interface BMKOpenOption : NSObject

///应用返回scheme，用于调起后返回，没有不能返回
@property (nonatomic, strong) NSString* appScheme;
///调起百度地图客户端失败后，是否支持调起web地图，默认：YES
@property (nonatomic, assign) BOOL isSupportWeb;

@end

#endif

