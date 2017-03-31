//
//  BMKUserLocation.h
//  BaseComponent
//
//  Created by Baidu on 3/26/14.
//  Copyright (c) 2014 baidu. All rights reserved.
//
#import <CoreLocation/CLLocation.h>
#import <Foundation/Foundation.h>
#import "BMKBaseComponent.h"
@class CLLocation;
@class CLHeading;
@interface BMKUserLocation : NSObject

/// 位置更新状态，如果正在更新位置信息，则该值为YES
@property (readonly, nonatomic, getter=isUpdating) BOOL updating;

/// 位置信息，尚未定位成功，则该值为nil
@property (readonly, nonatomic,strong) CLLocation *location;

/// heading信息，尚未定位成功，则该值为nil
@property (readonly, nonatomic, strong) CLHeading *heading;

/// 定位标注点要显示的标题信息
@property (strong, nonatomic) NSString *title;

/// 定位标注点要显示的子标题信息.
@property (strong, nonatomic) NSString *subtitle;

@end
