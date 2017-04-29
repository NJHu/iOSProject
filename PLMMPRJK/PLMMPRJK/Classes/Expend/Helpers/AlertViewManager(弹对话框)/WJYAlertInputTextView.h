//
//  WJYAlertInputTextView.h
//  MobileProject 带输入效果的自定义视图，用于WJYAlertView展现，因项目中引入IQKeyboardManager，所以就没再加键盘盖住做处理了
//
//  Created by wujunyang on 16/8/4.
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIPlaceHolderTextView.h"


typedef void (^alertLeftBlock)(NSString *text);
typedef void (^alertRightBlock)(NSString *text);


@interface WJYAlertInputTextView : UIView

@property (nonatomic, copy) alertLeftBlock leftBlock;
@property (nonatomic, copy) alertRightBlock rightBlock;

//开放出来
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UIPlaceHolderTextView *contentTextView;
@property(nonatomic,strong)UIButton *leftButton,*rightButton;


-(instancetype)initPagesViewWithTitle:(NSString *)title leftButtonTitle:(NSString *)leftButtonTitle rightButtonTitle:(NSString *)rightButtonTitle placeholderText:(NSString *)placeholderText;

@end
