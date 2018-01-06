/*
 *  BMKPolyline.h
 *  BMapKit
 *
 *  Copyright 2011 Baidu Inc. All rights reserved.
 *
 */

#import "BMKMultiPoint.h"
#import "BMKOverlay.h"

/// 此类用于定义一段折线
@interface BMKPolyline : BMKMultiPoint <BMKOverlay>

/**
 *根据指定坐标点生成一段折线
 *@param points 指定的直角坐标点数组
 *@param count 坐标点的个数
 *@return 新生成的折线对象
 */
+ (BMKPolyline *)polylineWithPoints:(BMKMapPoint *)points count:(NSUInteger)count;

/**
 *根据指定坐标点生成一段折线
 *@param coords 指定的经纬度坐标点数组
 *@param count 坐标点的个数
 *@return 新生成的折线对象
 */
+ (BMKPolyline *)polylineWithCoordinates:(CLLocationCoordinate2D *)coords count:(NSUInteger)count;

/**
 *重新设置折线坐标点
 *@param points 指定的直角坐标点数组
 *@param count 坐标点的个数
 *@return 是否设置成功
 */
- (BOOL)setPolylineWithPoints:(BMKMapPoint *)points count:(NSInteger) count;

/**
 *重新设置折线坐标点
 *@param coords 指定的经纬度坐标点数组
 *@param count 坐标点的个数
 *@return 是否设置成功
 */
- (BOOL)setPolylineWithCoordinates:(CLLocationCoordinate2D *)coords count:(NSInteger) count;


#pragma mark - 以下方法和属性只适用于分段纹理绘制和分段颜色绘制

///纹理索引数组（颜色索引数组）
@property (nonatomic, strong) NSArray *textureIndex;

/**
 *分段纹理绘制/分段颜色绘制，根据指定坐标点生成一段折线
 *
 *分段纹理绘制：其对应的BMKPolylineView必须使用 - (BOOL)loadStrokeTextureImages:(NSArray *)textureImages; 加载纹理图片；否则使用默认的灰色纹理绘制
 *分段颜色绘制：其对应的BMKPolylineView必须设置colors属性
 *
 *@param points 指定的直角坐标点数组
 *@param count 坐标点的个数
 *@param textureIndex 纹理索引数组（颜色索引数组），成员为NSNumber,且为非负数，负数按0处理
 *@return 新生成的折线对象
 */
+ (BMKPolyline *)polylineWithPoints:(BMKMapPoint *)points count:(NSUInteger)count textureIndex:(NSArray*) textureIndex;

/**
 *根据指定坐标点生成一段折线
 *
 *分段纹理绘制：其对应的BMKPolylineView必须使用 - (BOOL)loadStrokeTextureImages:(NSArray *)textureImages; 加载纹理图片；否则使用默认的灰色纹理绘制
 *分段颜色绘制：其对应的BMKPolylineView必须设置colors属性
 *
 *@param coords 指定的经纬度坐标点数组
 *@param count 坐标点的个数
 *@param textureIndex 纹理索引数组（颜色索引数组），成员为NSNumber,且为非负数，负数按0处理
 *@return 新生成的折线对象
 */
+ (BMKPolyline *)polylineWithCoordinates:(CLLocationCoordinate2D *)coords count:(NSUInteger)count textureIndex:(NSArray*) textureIndex;

/**
 *重新设置折线坐标点 和 纹理索引
 *@param points 指定的直角坐标点数组
 *@param count 坐标点的个数
 *@param textureIndex 纹理索引数组（颜色索引数组），成员为NSNumber,且为非负数，负数按0处理
 *@return 是否设置成功
 */
- (BOOL)setPolylineWithPoints:(BMKMapPoint *)points count:(NSInteger) count textureIndex:(NSArray*) textureIndex;

/**
 *重新设置折线坐标点
 *@param coords 指定的经纬度坐标点数组
 *@param count 坐标点的个数
 *@param textureIndex 纹理索引数组（颜色索引数组），成员为NSNumber,且为非负数，负数按0处理
 *@return 是否设置成功
 */
- (BOOL)setPolylineWithCoordinates:(CLLocationCoordinate2D *)coords count:(NSInteger) count textureIndex:(NSArray*) textureIndex;

@end
