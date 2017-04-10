//
//  UIPlaceHolderTextView.h
//  MobileProject 带有提示输入的TextView
//
//  Created by wujunyang on 16/1/14.
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIPlaceHolderTextView : UITextView
@property (nonatomic, strong) NSString *placeholder;
@property (nonatomic, strong) UIColor *placeholderColor;

-(void)textChanged:(NSNotification*)notification;
@end
