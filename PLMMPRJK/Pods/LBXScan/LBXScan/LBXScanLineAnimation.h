//
//  LBXScanLineAnimation.h
//
//  github:https://github.com/MxABC/LBXScan
//  Created by lbxia on 15/11/3.
//  Copyright © 2015年 lbxia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LBXScanLineAnimation : UIImageView



/**
 *  开始扫码线动画
 *
 *  @param animationRect 显示在parentView中得区域
 *  @param parentView    动画显示在UIView
 *  @param image     扫码线的图像
 */
- (void)startAnimatingWithRect:(CGRect)animationRect InView:(UIView*)parentView Image:(UIImage*)image;

/**
 *  停止动画
 */
- (void)stopAnimating;

@end
