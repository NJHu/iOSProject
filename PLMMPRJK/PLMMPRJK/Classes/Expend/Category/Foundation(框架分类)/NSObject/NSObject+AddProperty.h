//
//  NSObject+AddProperty.h
//  iOS-Categories (https://github.com/shaojiankui/iOS-Categories)
//
//  Created by Jakey on 14/12/15.
//  Copyright (c) 2014年 www.skyfox.org. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (AddProperty)
/**
 *  @brief  catgory runtime实现get set方法增加一个字符串属性
 */
@property (nonatomic,strong) NSString *stringProperty;
/**
 *  @brief  catgory runtime实现get set方法增加一个NSInteger属性
 */
@property (nonatomic,assign) NSInteger integerProperty;
@end
