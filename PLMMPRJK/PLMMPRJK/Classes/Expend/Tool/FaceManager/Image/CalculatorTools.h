//
//  CalculatorTools.h
//  IFlyFaceDemo
//
//  Created by 付正 on 16/3/1.
//  Copyright © 2016年 fuzheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#pragma mark - Point
#pragma mark Rotate with device

/*!
 *  @brief 点旋转90°
 *                      ---
 *    --------         |   |
 *   |      o | -90->  |   |
 *    --------         | o |
 *                      ---
 *  @param p 原始点
 *  @param h 画布高
 *  @param w 画布宽
 *
 *  @return 旋转后的点
 *
 *  @since 1.0
 */
CGPoint pRotate90(CGPoint p, CGFloat h,CGFloat w);

/*!
 *  @brief 点旋转180°
 *
 *    --------           --------
 *   |      o | -180->  |o       |
 *    --------           --------
 *
 *  @param p 原始点
 *  @param h 画布高
 *  @param w 画布宽
 *
 *  @return 旋转后的点
 *
 *  @since 1.0
 */
CGPoint pRotate180(CGPoint p, CGFloat h,CGFloat w);

/*!
 *  @brief 点旋转270°
 *                       ---
 *    --------          | o |
 *   |      o | -270->  |   |
 *    --------          |   |
 *                       ---
 *  @param p 原始点
 *  @param h 画布高
 *  @param w 画布宽
 *
 *  @return 旋转后的点
 *
 *  @since 1.0
 */
CGPoint pRotate270(CGPoint p, CGFloat h,CGFloat w);

#pragma mark  axis mirror

/*!
 *  @brief 点以屏幕横向向中心线的镜像点
 *
 *  @param p 原始点
 *  @param w 画布高
 *
 *  @return 镜像点
 *
 *  @since 1.0
 */
CGPoint pXaxisMirror(CGPoint p,CGFloat h);

/*!
 *  @brief 点以屏幕纵向中心线的镜像点
 *
 *  @param p 原始点
 *  @param w 画布宽
 *
 *  @return 镜像点
 *
 *  @since 1.0
 */
CGPoint pYaxisMirror(CGPoint p,CGFloat w);

#pragma mark  scale

/*!
 *  @brief 点位置缩放
 *
 *  @param p      原始点
 *  @param wScale 缩放宽度
 *  @param hScale 缩放高度
 *
 *  @return 缩放后的点
 *
 *  @since 1.0
 */
CGPoint pScale(CGPoint p ,CGFloat wScale, CGFloat hScale);

#pragma mark  swap
/*!
 *  @brief 点交换x，y坐标
 *
 *  @param p 原始点
 *
 *  @return 交换后的点
 *
 *  @since 1.0
 */
CGPoint pSwap(CGPoint p);

#pragma mark - Rect
#pragma mark Rotate with device

/*!
 *  @brief 矩形旋转90°
 *
 *                      ---
 *    --------         |   |
 *   |      o | -90->  |   |
 *    --------         | o |
 *                      ---
 *
 *  @param p 原始矩形
 *  @param h 画布高
 *  @param w 画布宽
 *
 *  @return 旋转后的矩形
 *
 *  @since 1.0
 */
CGRect rRotate90(CGRect r, CGFloat h,CGFloat w);

/*!
 *  @brief 矩形旋转180°
 *
 *    --------           --------
 *   |      o | -180->  |o       |
 *    --------           --------
 *
 *  @param p 原始矩形
 *  @param h 画布高
 *  @param w 画布宽
 *
 *  @return 旋转后的矩形
 *
 *  @since 1.0
 */
CGRect rRotate180(CGRect r, CGFloat h,CGFloat w);

/*!
 *  @brief 矩形旋转270°
 *
 *                       ---
 *    --------          | o |
 *   |      o | -270->  |   |
 *    --------          |   |
 *                       ---
 *  @param p 原始矩形
 *  @param h 画布高
 *  @param w 画布宽
 *
 *  @return 旋转后的矩形
 *
 *  @since 1.0
 */
CGRect rRotate270(CGRect r, CGFloat h,CGFloat w);

#pragma mark  axis mirror

/*!
 *  @brief 矩形以屏幕横向向中心线的镜像矩形
 *
 *  @param p 原始点
 *  @param w 画布高
 *
 *  @return 镜像矩形
 *
 *  @since 1.0
 */
CGRect rXaxisMirror(CGRect r,CGFloat h);

/*!
 *  @brief 矩形以屏幕纵向中心线的镜像矩形
 *
 *  @param r 原始矩形
 *  @param w 画布宽
 *
 *  @return 镜像矩形
 *
 *  @since 1.0
 */
CGRect rYaxisMirror(CGRect r,CGFloat w);

#pragma mark  scale

/*!
 *  @brief 矩形位置缩放
 *
 *  @param r      原始矩形
 *  @param wScale 缩放宽度
 *  @param hScale 缩放高度
 *
 *  @return 缩放后的矩形
 *
 *  @since 1.0
 */
CGRect rScale(CGRect r ,CGFloat wScale, CGFloat hScale);

#pragma mark  swap

/*!
 *  @brief 矩形交换 x,y
 *
 *  @param r 原始矩形
 *
 *  @return 交换后的矩形
 *
 *  @since 1.0
 */
CGRect rSwap(CGRect r);


#pragma mark - other
/*!
 *  @brief 获得图片方向，获取手机朝向，返回值0,1,2,3分别表示0,90,180和270度
 *
 *  @param img 图片
 *
 *  @return 方向
 *
 *  @since 1.0
 */
int imageDirection(UIImage* img);

