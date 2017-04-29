//
//  UITextField+Extension.h
//  MobileProject
//
//  Created by wujunyang on 16/7/13.
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (Extension)

- (NSRange)selectedRange;

- (void)setSelectedRange:(NSRange)range;

/**
 *  设置空格插入的位置 使用方式
 *  - textField:shouldChangeCharactersInRange:replacementString:
 *  执行如下代码 123456 2345 2345 345666
 *  NSArray *insertPosition = @[@(6), @(10), @(14), @(18)];
 *  [textField insertWhitSpaceInsertPosition:insertPosition replacementString:string textlength:20];
 *  return NO;
 *
 *  @param insertPosition 插入的位置
 *  @param string         插入的字符串
 *  @param length         文本长度
 */
- (void)insertWhitSpaceInsertPosition:(NSArray *)insertPosition replacementString:(NSString *)string textlength:(NSInteger)length;


@end
