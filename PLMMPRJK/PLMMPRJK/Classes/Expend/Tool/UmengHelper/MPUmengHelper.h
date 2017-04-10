//
//  MPUmengHelper.h
//  MobileProject
//
//  Created by wujunyang on 16/1/15.
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UMMobClick/MobClick.h"

@interface MPUmengHelper : NSObject

/*!
 * 启动友盟统计功能
 */
+ (void)UMAnalyticStart;

/// 在viewWillAppear调用,才能够获取正确的页面访问路径、访问深度（PV）的数据
+ (void)beginLogPageView:(__unsafe_unretained Class)pageView;

/// 在viewDidDisappeary调用，才能够获取正确的页面访问路径、访问深度（PV）的数据
+ (void)endLogPageView:(__unsafe_unretained Class)pageView;


/*!
 * 自定义名称
 */
/// 在viewWillAppear调用,才能够获取正确的页面访问路径、访问深度（PV）的数据
+(void)beginLogPageViewName:(NSString *)pageViewName;

/// 在viewDidDisappeary调用，才能够获取正确的页面访问路径、访问深度（PV）的数据
+(void)endLogPageViewName:(NSString *)pageViewName;

@end
