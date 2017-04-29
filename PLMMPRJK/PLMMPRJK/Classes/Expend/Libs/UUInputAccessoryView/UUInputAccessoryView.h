//
//  inputAccessoryView.h
//  InputAccessoryView-WindowLayer
//  为一些无输入源的控件添加输入响应。比如按钮、cell、view等添加输入源. 键盘上方出现一个输入框，可以绑定，定义键盘的类型，实例如下：

//  - (IBAction)click:(UIButton *)sender {
//      UIKeyboardType type = sender.tag == 1 ? UIKeyboardTypeNumberPad : UIKeyboardTypeDefault;
//      NSString *content = sender.tag == 2 ? [sender titleForState:UIControlStateNormal] : @"默认绑定值";
//
//     [UUInputAccessoryView showKeyboardType:type
//                               content:content
//                                 Block:^(NSString *contentStr)
// {
//     if (contentStr.length == 0) return ;
//     [sender setTitle:contentStr forState:UIControlStateNormal];
// }];
//}
//  Created by shake on 14/11/14.
//  Copyright (c) 2014年 uyiuyao. All rights reserved.

#import <UIKit/UIKit.h>

typedef void(^UUInputAccessoryBlock)(NSString *contentStr);

@interface UUInputAccessoryView : NSObject


+ (void)showBlock:(UUInputAccessoryBlock)block;


+ (void)showKeyboardType:(UIKeyboardType)type
                   Block:(UUInputAccessoryBlock)block;


+ (void)showKeyboardType:(UIKeyboardType)type
                 content:(NSString *)content
                   Block:(UUInputAccessoryBlock)block;

@end
