//
//  MWFloatView.h
//
//  Created by 刘家飞 on 2016/10/12.
//  Copyright © 2016年 MagicWindow. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MWFloatViewDelegate <NSObject>

@optional
/**
 *  即将从当前App返回应用A的时候需要的参数
 *  @return void
 */
- (void)willReturnOriginApp;

@end


@interface MWFloatView : UIView

@property (nonatomic, weak, nullable) id <MWFloatViewDelegate> delegate;

/**
 *  初始化浮层buttonView
 *  @param y buttonView的y轴的起始位置
 *  @return void
 */
- (nonnull id)initWithYPoint:(float)y;

/**
 *  是否开启debug模式，一旦开始debug模式，在不需要返回的时候也会展示buttonView，供开发者参考buttonView的展示样式
 *  @param enable YES开启，NO不开启，默认不开启
 *  @return void
 */
- (void)debugEnable:(BOOL)enable;

/**
 *  是否允许buttonView上下滑动
 *  @param enable YES允许滑动，NO不允许滑动，默认允许滑动
 *  @return void
 */
- (void)dragEnable:(BOOL)enable;

/**
 *  设置buttonView的上下滑动的区域范围，默认是0～deviceHeight
 *  @param minY：buttonView的允许滑动y轴的最小值，maxY： buttonView的允许滑动y轴的最大值
 *  @return void
 */
- (void)setMinY:(float)minY andMaxY:(float)maxY;

/**
 *  设置从当前App返回应用A的时候需要的参数
 *  @param params 返回A时需要传入的参数
 *  @return void
 */
- (void)setReturnOriginAppParams:(nonnull NSDictionary *)params;

/**
 *  将buttonView添加到view上
 *  @return void
 */
- (void)show;

/**
 *  将buttonView隐藏掉
 *  @return void
 */
- (void)hide;

@end
