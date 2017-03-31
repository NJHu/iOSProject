//
//  BMKCloudVersion.h
//  LBSSearchComponent
//
//  Created by wzy on 15/9/9.
//  Copyright © 2015年 baidu. All rights reserved.
//

#ifndef BMKCloudVersion_h
#define BMKCloudVersion_h

#import <UIKit/UIKit.h>

/**
 *重要：
 *base组件的版本和cloud组件的版本必须一致，否则不能正常使用
 */

/**
 *获取当前地图API cloud组件 的版本号
 *当前cloud组件版本 : 3.2.1
 *return  返回当前API cloud组件 的版本号
 */
UIKIT_EXTERN NSString* BMKGetMapApiCloudComponentVersion();

/**
 *检查cloud组件的版本号是否和base组件的版本号一致
 *return    版本号一致返回YES
 */
UIKIT_EXTERN BOOL BMKCheckCloudComponentIsLegal();

#endif /* BMKCloudVersion_h */
