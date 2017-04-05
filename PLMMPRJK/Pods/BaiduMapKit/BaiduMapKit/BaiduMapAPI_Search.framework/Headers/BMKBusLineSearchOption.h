/*
 *  BMKBusLineSearchOption.h
 *  BMapKit
 *
 *  Copyright 2014 Baidu Inc. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>
/// 公交线路检索信息类
@interface BMKBusLineSearchOption : NSObject
{
    NSString        *_city;
    NSString        *_busLineUid;
}
///城市名
@property (nonatomic, strong) NSString *city;
///公交线路的uid
@property (nonatomic, strong) NSString *busLineUid;

@end

