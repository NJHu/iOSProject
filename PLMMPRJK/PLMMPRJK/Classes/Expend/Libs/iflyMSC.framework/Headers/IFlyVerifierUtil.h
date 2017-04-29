//
//  IFlyVerifierUtil.h
//  IFlyMSC
//
//  Created by 张剑 on 15/4/28.
//  Copyright (c) 2015年 iflytek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 *  身份验证工具类
 */
@interface IFlyVerifierUtil : NSObject

#pragma mark - ISV

/**
 *  返回定长的随机数字字符串（不包含数字1，而且2和5不邻接）
 *
 *  @param length 随机字符串长度
 *
 *  @return 随机字符串
 */
+(NSString*)generateNumberPassword:(int)length;


#pragma mark - Face
/**
 *  ARGB彩图转灰度图，Detector和Alignment需要灰度图的输入
 *
 *  @param sourceImage ARGB彩图
 *
 *  @return 灰度图
 */
+ (UIImage*)ARGBToGray:(UIImage*)sourceImage;

@end
