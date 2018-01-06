/*
 *  BMKPointAnnotation.h
 *  BMapKit
 *
 *  Copyright 2011 Baidu Inc. All rights reserved.
 *
 */


#import <Foundation/Foundation.h>
#import "BMKShape.h"
#import <CoreLocation/CLLocation.h>

///表示一个点的annotation
@interface BMKPointAnnotation : BMKShape {
	@package
    CLLocationCoordinate2D _coordinate;
    BOOL _lockedToScreen;
    CGPoint _lockedScreenPoint;
}
///该点的坐标
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

///标注固定在指定屏幕位置,  必须与screenPointToLock一起使用。 注意：拖动Annotation isLockedToScreen会被设置为false。
///若isLockedToScreen为true，拖动地图时annotaion不会跟随移动；
///若isLockedToScreen为false，拖动地图时annotation会跟随移动。
@property (nonatomic, assign) BOOL isLockedToScreen;

///标注锁定在屏幕上的位置，注意：地图初始化后才能设置screenPointToLock。可以在地图加载完成的回调方法：mapViewDidFinishLoading中使用此属性。
@property (nonatomic, assign) CGPoint screenPointToLock;

@end
