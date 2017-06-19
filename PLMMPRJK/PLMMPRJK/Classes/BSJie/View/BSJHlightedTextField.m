//
//  BSJHlightedTextField.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/5/18.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "BSJHlightedTextField.h"

static NSString *const BSJHlightTextFieldPlaceHolderColorKeyPath = @"_placeholderLabel.textColor";

@interface BSJHlightedTextField ()
/** <#digest#> */
@property (nonatomic, strong) UIColor *oriPlaceHolderColor;

@end

@implementation BSJHlightedTextField

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupUIOnce];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setupUIOnce];
}

- (void)setupUIOnce
{
    
    NSLog(@"%@", [UITextField instanceVariable]);
    
    
    self.oriPlaceHolderColor = [self valueForKeyPath:BSJHlightTextFieldPlaceHolderColorKeyPath];
    self.tintColor = self.textColor;
}


- (BOOL)becomeFirstResponder
{
    [self setValue:self.textColor forKeyPath:BSJHlightTextFieldPlaceHolderColorKeyPath];
    
   return [super becomeFirstResponder];
}


- (BOOL)resignFirstResponder
{
    [self setValue:self.oriPlaceHolderColor forKeyPath:BSJHlightTextFieldPlaceHolderColorKeyPath];
    
    return [super resignFirstResponder];
}



- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
}

+ (void)load
{
    
    
}

@end
