//
//  MPSolidColorButton.m
//  MobileProject
//
//  Created by wujunyang on 16/8/18.
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#import "MPSolidColorButton.h"

@implementation MPSolidColorButton

-(instancetype)initWithFrame:(CGRect)frame buttonTitle:(NSString *)buttonTitle normalBGColor:(UIColor *)normalBGColor selectBGColor:(UIColor *)selectBGColor
                 normalColor:(UIColor *)normalColor selectColor:(UIColor *)selectColor buttonFont:(UIFont *)buttonFont cornerRadius:(CGFloat )cornerRadius
                   doneBlock:(SolidColorButtonBlock)doneBlock
{
    self=[super initWithFrame:frame];
    if (self) {
        self.layer.masksToBounds=YES;
        self.layer.cornerRadius=cornerRadius;
        self.doneBlock=doneBlock;
        
        self.titleLabel.font=buttonFont;
        [self setTitle:buttonTitle forState:UIControlStateNormal];
        [self setTitleColor:normalColor forState:UIControlStateNormal];
        [self setTitleColor:selectColor forState:UIControlStateHighlighted];
        [self setBackgroundImage:[UIImage imageWithColor:normalBGColor] forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage imageWithColor:selectBGColor] forState:UIControlStateHighlighted];
        
        [self addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)buttonAction:(UIButton *)button
{
    if (self.doneBlock) {
        self.doneBlock(button);
    }
}


+(MPSolidColorButton *)initWithFrame:(CGRect)frame buttonTitle:(NSString *)buttonTitle normalBGColor:(UIColor *)normalBGColor selectBGColor:(UIColor *)selectBGColor
                         normalColor:(UIColor *)normalColor selectColor:(UIColor *)selectColor buttonFont:(UIFont *)buttonFont cornerRadius:(CGFloat )cornerRadius
                           doneBlock:(SolidColorButtonBlock)doneBlock
{
    MPSolidColorButton *solidColorButton=[[MPSolidColorButton alloc]initWithFrame:frame buttonTitle:buttonTitle normalBGColor:normalBGColor selectBGColor:selectBGColor normalColor:normalColor selectColor:selectColor buttonFont:buttonFont cornerRadius:cornerRadius doneBlock:doneBlock];
    return solidColorButton;
}

@end
