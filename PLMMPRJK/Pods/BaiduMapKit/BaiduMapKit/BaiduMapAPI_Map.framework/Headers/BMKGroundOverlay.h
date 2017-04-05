/*
 *  BMKGroundOverlay.h
 *  BMapKit
 *
 *  Copyright 2011 Baidu Inc. All rights reserved.
 *
 */
#import "BMKMultiPoint.h"
#import "BMKOverlay.h"
/// 该类用于定义一个图片图层
@interface BMKGroundOverlay : BMKMultiPoint<BMKOverlay>
{
  @public
    float zoomLevel;
    CLLocationCoordinate2D _pt;
    BMKCoordinateBounds _bound;
    CGPoint _anchor;
    UIImage* _icon;
    int iconID;
    BOOL isCenterPt;
    int left;
    int bottom;
    int width;
    int height;
}
/// 两种绘制GroundOverlay的方式之一：绘制的位置地理坐标，与anchor配对使用
@property (nonatomic,assign) CLLocationCoordinate2D pt;

/// 用位置绘制时图片的锚点，图片左上角为(0.0f,0.0f),向右向下为正
/// 使用groundOverlayWithPosition初始化时生效
@property (nonatomic,assign) CGPoint anchor;

/// 两种绘制GroundOverlay的方式之二：绘制的地理区域范围，图片在此区域内合理缩放
@property (nonatomic,assign) BMKCoordinateBounds bound;

/// 绘制图片
@property(nonatomic, strong) UIImage *icon;

///图片纹理透明度,最终透明度 = 纹理透明度 * alpha,取值范围为[0.0f, 1.0f]，默认为1.0f
@property(nonatomic) GLfloat alpha;

/**
 *根据指定经纬度坐标生成一个groundOverlay
 *@param position 指定的经纬度坐标
 *@param zoomLevel 不损失精度绘制原始图片的地图等级
 *@param anchor 绘制图片的锚点
 *@param icon   绘制使用的图片
 *@return 新生成的groundOverlay对象
 */
+ (BMKGroundOverlay *)groundOverlayWithPosition:(CLLocationCoordinate2D)position
                                                zoomLevel:(CGFloat)zoomLevel
                                                anchor:(CGPoint)anchor
                                                icon:(UIImage*)icon;

/**
 *根据指定区域生成一个groundOverlay
 *@param bounds 指定的经纬度区域
 *@param icon 绘制使用的图片
 *@return 新生成的groundOverlay对象
 */
+ (BMKGroundOverlay *)groundOverlayWithBounds:(BMKCoordinateBounds)bounds
                                                icon:(UIImage*)icon;


@end