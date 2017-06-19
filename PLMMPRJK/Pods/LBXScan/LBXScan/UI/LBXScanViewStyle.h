//
//  LBXScanViewStyle.h
//  
//  github:https://github.com/MxABC/LBXScan
//  Created by lbxia on 15/11/15.
//  Copyright © 2015年 lbxia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


/**
 扫码区域动画效果
 */
typedef NS_ENUM(NSInteger,LBXScanViewAnimationStyle)
{
    LBXScanViewAnimationStyle_LineMove,   //线条上下移动
    LBXScanViewAnimationStyle_NetGrid,//网格
    LBXScanViewAnimationStyle_LineStill,//线条停止在扫码区域中央
    LBXScanViewAnimationStyle_None    //无动画
    
};

/**
 扫码区域4个角位置类型
 */
typedef NS_ENUM(NSInteger, LBXScanViewPhotoframeAngleStyle)
{
    LBXScanViewPhotoframeAngleStyle_Inner,//内嵌，一般不显示矩形框情况下
    LBXScanViewPhotoframeAngleStyle_Outer,//外嵌,包围在矩形框的4个角
    LBXScanViewPhotoframeAngleStyle_On   //在矩形框的4个角上，覆盖
};


NS_ASSUME_NONNULL_BEGIN

@interface LBXScanViewStyle : NSObject


#pragma mark -中心位置矩形框
/**
 @brief  是否需要绘制扫码矩形框，默认YES
 */
@property (nonatomic, assign) BOOL isNeedShowRetangle;


/**
 *  默认扫码区域为正方形，如果扫码区域不是正方形，设置宽高比
 */
@property (nonatomic, assign) CGFloat whRatio;


/**
 @brief  矩形框(视频显示透明区)域向上移动偏移量，0表示扫码透明区域在当前视图中心位置，< 0 表示扫码区域下移, >0 表示扫码区域上移
 */
@property (nonatomic, assign) CGFloat centerUpOffset;

/**
 *  矩形框(视频显示透明区)域离界面左边及右边距离，默认60
 */
@property (nonatomic, assign) CGFloat xScanRetangleOffset;

/**
 @brief  矩形框线条颜色
 */
@property (nonatomic, strong) UIColor *colorRetangleLine;



#pragma mark -矩形框(扫码区域)周围4个角
/**
 @brief  扫码区域的4个角类型
 */
@property (nonatomic, assign) LBXScanViewPhotoframeAngleStyle photoframeAngleStyle;

//4个角的颜色
@property (nonatomic, strong) UIColor* colorAngle;

//扫码区域4个角的宽度和高度
@property (nonatomic, assign) CGFloat photoframeAngleW;
@property (nonatomic, assign) CGFloat photoframeAngleH;
/**
 @brief  扫码区域4个角的线条宽度,默认6，建议8到4之间
 */
@property (nonatomic, assign) CGFloat photoframeLineW;




#pragma mark --动画效果
/**
 @brief  扫码动画效果:线条或网格
 */
@property (nonatomic, assign) LBXScanViewAnimationStyle anmiationStyle;

/**
 *  动画效果的图像，如线条或网格的图像，如果为nil，表示不需要动画效果
 */
@property (nonatomic,strong,nullable) UIImage *animationImage;



#pragma mark -非识别区域颜色,默认 RGBA (0,0,0,0.5)

/**
 must be create by [UIColor colorWithRed: green: blue: alpha:]
 */
@property (nonatomic, strong) UIColor *notRecoginitonArea;


@end

NS_ASSUME_NONNULL_END
