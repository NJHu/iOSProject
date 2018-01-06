//
//  TextHelper.h
//  RAlert
//
//  Created by roycms on 2016/11/26.
//  Copyright © 2016年 roycms. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface TextHelper : NSObject

/**
 返回 attributedStringForString  格式的str

 @param str str description
 @param lineSpacing lineSpacing description
 @return return value description
 */
+ (NSMutableAttributedString *)attributedStringForString:(NSString *)str lineSpacing:(CGFloat)lineSpacing;
@end
