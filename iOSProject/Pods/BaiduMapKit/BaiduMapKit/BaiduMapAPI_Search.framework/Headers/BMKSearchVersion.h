//
//  BMKSearchVersion.h
//  SearchComponent
//
//  Created by wzy on 15/9/9.
//  Copyright © 2015年 baidu. All rights reserved.
//

#ifndef BMKSearchVersion_h
#define BMKSearchVersion_h

#import <UIKit/UIKit.h>

/**
 *重要：
 *base组件的版本和search组件的版本必须一致，否则不能正常使用
 */

/**
 *获取当前地图API search组件 的版本号
 *当前search组件版本 : 3.4.2
 *return  返回当前API search组件 的版本号
 */
UIKIT_EXTERN NSString* BMKGetMapApiSearchComponentVersion();

/**
 *检查search组件的版本号是否和base组件的版本号一致
 *return    版本号一致返回YES
 */
UIKIT_EXTERN BOOL BMKCheckSearchComponentIsLegal();

#endif /* BMKSearchVersion_h */
