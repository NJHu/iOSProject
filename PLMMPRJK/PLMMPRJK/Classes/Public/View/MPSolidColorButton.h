//
//  MPSolidColorButton.h
//  MobileProject 针对背景为纯色的Button简单封装
//
//  使用方式
//  MPSolidColorButton *mySolidColorButton=[[MPSolidColorButton alloc]initWithFrame:CGRectMake(130, 200, 100, 40) buttonTitle:@"请点我" normalBGColor:[UIColor grayColor] selectBGColor:[UIColor redColor] normalColor:[UIColor whiteColor] selectColor:[UIColor blueColor] buttonFont:CHINESE_SYSTEM(14) cornerRadius:2 doneBlock:^(UIButton *button) {
//    DDLogError(@"你好");
//  }];
//  [self.view addSubview:mySolidColorButton];

//  Created by wujunyang on 16/8/18.
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImage+Color.h"


typedef void(^SolidColorButtonBlock)(UIButton *button);

@interface MPSolidColorButton : UIButton

//点击事件Block
@property(nonatomic,copy)SolidColorButtonBlock doneBlock;

/**
 *  @author wujunyang, 16-08-18 17:08:49
 *
 *  @brief
 *
 *  @param frame         frame
 *  @param buttonTitle   标题
 *  @param normalBGColor 未选中的背景色
 *  @param selectBGColor 选中的背景色
 *  @param normalColor   未选中的文字色
 *  @param selectColor   选中的文字色
 *  @param buttonFont    文字字体
 *  @param cornerRadius  圆角值 没有则为0
 *  @param doneBlock     点击事件
 *
 *  @return 
 */
-(instancetype)initWithFrame:(CGRect)frame buttonTitle:(NSString *)buttonTitle normalBGColor:(UIColor *)normalBGColor selectBGColor:(UIColor *)selectBGColor
                 normalColor:(UIColor *)normalColor selectColor:(UIColor *)selectColor buttonFont:(UIFont *)buttonFont cornerRadius:(CGFloat )cornerRadius
                   doneBlock:(SolidColorButtonBlock)doneBlock;


+(MPSolidColorButton *)initWithFrame:(CGRect)frame buttonTitle:(NSString *)buttonTitle normalBGColor:(UIColor *)normalBGColor selectBGColor:(UIColor *)selectBGColor
                  normalColor:(UIColor *)normalColor selectColor:(UIColor *)selectColor buttonFont:(UIFont *)buttonFont cornerRadius:(CGFloat )cornerRadius
                    doneBlock:(SolidColorButtonBlock)doneBlock;

@end
