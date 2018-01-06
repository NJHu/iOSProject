/*
 *  BMKShape.h
 *  BMapKit
 *
 *  Copyright 2011 Baidu Inc. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>
#import"BMKAnnotation.h"

/// 该类为一个抽象类，定义了基于BMKAnnotation的BMKShape类的基本属性和行为，不能直接使用，必须子类化之后才能使用
@interface BMKShape : NSObject <BMKAnnotation> {
}

/// 要显示的标题；注意：如果不设置title,无法点击annotation,也无法使用回调函数；
@property (copy) NSString *title;
/// 要显示的副标题
@property (copy) NSString *subtitle;

@end
