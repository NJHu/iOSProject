//
//  RAlertView.m
//  RAlert
//
//  Created by roycms on 2016/10/11.
//  Copyright © 2016年 roycms. All rights reserved.
//

#import "RAlertView.h"

@interface RAlertView ()

@property (nonatomic,strong)NSArray *themeArray;

@end
@implementation RAlertView


/**
 init

 @param style style description
 @return return value description
 */
- (instancetype)initWithStyle:(AlertStyle)style {
    self = [super init];
    if (self) {
        [self initWindow:style];
    }
    return self;
}

/**
 init

 @param style style description
 @param width width description
 @return return value description
 */
- (instancetype)initWithStyle:(AlertStyle)style width:(CGFloat)width{
    self = [super init];
    if (self) {
        [self initWindow:style];
        [self setAlertWidth:width];
    }
    return self;
}

/**
 准备默认数据
 */
-(void)prepareData{
    
    self.themeArray = @[RGB16(0X1abc9c),
                        RGB16(0X27ae60),
                        RGB16(0X2980b9),
                        RGB16(0X2c3e50),
                        RGB16(0Xf39c12),
                        RGB16(0Xc0392b),
                        RGB16(0X7f8c8d),
                        RGB16(0X8e44ad)];
    
    [self.confirmButton setBackgroundColor:self.themeArray[(arc4random() % 8)]];
    [self.confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

/**
 设置弹框的宽度

 @param width width 宽度值  范围 0-1  百分比
 */
-(void)setAlertWidth:(CGFloat)width{
    
    [self.mainView mas_updateConstraints:^(MASConstraintMaker *make) {
        if (width > 1) {
            make.width.offset(width);
        }
        else if(width > 0 && width <= 1){
            make.width.offset([UIScreen mainScreen].bounds.size.width * width);
        }
        else{
            make.width.offset([UIScreen mainScreen].bounds.size.width * 0.7);
        }
    }];
}

/**
 设置 主题的 set 方法

 @param theme theme description
 */
-(void)setTheme:(UIColor*)theme{
    
    [self.confirmButton setBackgroundColor:theme];
    [self.confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}


/**
 单击 背景 是否关闭弹窗

 @param isClickBackgroundCloseWindow isClickBackgroundCloseWindow description
 */
-(void)setIsClickBackgroundCloseWindow:(BOOL)isClickBackgroundCloseWindow{
    if(isClickBackgroundCloseWindow){
        UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(exit)];
        [self addGestureRecognizer:tapGesture];
    }
}

-(void)initWindow:(AlertStyle)style{
    
    [self viewInitUI];
    
    switch (style) {
        case SimpleAlert:
            [self simpleAlertViewInitUI];
            break;
        case ConfirmAlert:
            [self confirmAlertViewInitUI];
            
            break;
        case CancelAndConfirmAlert:
            [self cancelAndConfirmAlertViewInitUI];
            break;
    }
    
    [self animateSenior];
    [self prepareData];
}

/**
 view 初始化
 */
-(void)viewInitUI{
    
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    
    [window addSubview:self];
    [self addSubview:self.mainView];
    [self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.8]];
    [self.mainView insertSubview:self.closedButton atIndex:999];
    [self.mainView addSubview:self.headerTitleLabel];
    [self.mainView insertSubview:self.contentView atIndex:0];
    
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(window);
    }];
    self.mainView.translatesAutoresizingMaskIntoConstraints =NO;
    
    [self.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.mainView.superview);
        make.width.offset([UIScreen mainScreen].bounds.size.width * 0.7);
    }];

    [self.closedButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mainView);
        make.right.equalTo(self.mainView);
        make.width.height.offset(35);
    }];
    [self.headerTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mainView).offset(10);
        make.left.equalTo(self.mainView).offset(15);
        make.right.equalTo(self.mainView).offset(-30);
    }];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerTitleLabel.mas_bottom).offset(5);
        make.left.equalTo(self.headerTitleLabel);
        make.right.equalTo(self.mainView).offset(-15);
        make.bottom.equalTo(self.mainView).offset(-10);
    }];
}

/**
 无按钮  弹窗样式
 */
-(void)simpleAlertViewInitUI{
    
    [self.contentTextLabel setFont:[UIFont systemFontOfSize:15]];
    [self.contentView addSubview:self.contentTextLabel];
    [self.contentTextLabel sizeToFit];
    
    [self.contentTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(10);
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView).offset(-10);
    }];
}

/**
 只有确认按钮 的弹窗样式
 */
-(void)confirmAlertViewInitUI{
    
    [self.mainView addSubview:self.confirmButton];
    [self.contentView addSubview:self.contentTextLabel];
    
    [self.contentTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(10);
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
    }];
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentTextLabel.mas_bottom).offset(10);
        make.left.right.equalTo(self.mainView);
        make.bottom.equalTo(self.mainView);
        make.height.offset(40);
    }];
}

/**
 有取消 按钮 和 确认按钮的弹窗样式
 */
-(void)cancelAndConfirmAlertViewInitUI{
    [self.mainView addSubview:self.cancelButton];
    [self.mainView addSubview:self.confirmButton];
    [self.contentView addSubview:self.contentTextLabel];
    
    [self.contentTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(10);
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
    }];
    
    NSMutableArray *arrayM = @[].mutableCopy;
    [arrayM addObject:self.cancelButton];
    [arrayM addObject:self.confirmButton];
    
    [arrayM mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:0 leadSpacing:0 tailSpacing:0];
    [arrayM mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@40);
        make.bottom.equalTo(self.mainView);
        make.top.equalTo(self.contentTextLabel.mas_bottom).offset(10);
    }];
}

/**
 弹窗飞入 动画
 */
-(void)animate{
    
    [self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0]];
    [UIView animateWithDuration:0.12 animations:^{
        [self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.8]];
    }];
    
    self.mainView.transform = CGAffineTransformMakeTranslation(0, 600);
    [UIView animateWithDuration:0.12 animations:^{
        self.mainView.transform = CGAffineTransformMakeTranslation(0, 0);
    }];
}

/**
 弹窗飞入 渐变 动画
 */
-(void)animateSenior{

    self.mainView.transform = CGAffineTransformMakeTranslation(0, 600);
    [UIView animateWithDuration:0.2 delay:0 usingSpringWithDamping:0.35 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveLinear animations:^{
        self.mainView.transform = CGAffineTransformMakeTranslation(0, 0);
    } completion:^(BOOL finished) {
    }];
}

#pragma make 事件

/**
 销毁弹窗  方法
 */
-(void)exit{
    [self removeFromSuperview];
}

/**
 关闭按钮事件

 @param sender sender description
 */
-(void)closedButtonClick:(UIButton *)sender{
    [self exit];
}

/**
 确定按钮的事件

 @param sender sender description
 */
-(void)confirmButtonClick:(UIButton*)sender{
    
    if(self.confirm){
        self.confirm();
    }
    [self exit];
}

/**
 取消按钮的 事件

 @param sender sender description
 */
-(void)cancelButtonClick:(UIButton*)sender{
    if(self.cancel){
        self.cancel();
    }
    [self exit];
}

#pragma make 懒加载

-(UIView*)mainView{
    if (_mainView == nil) {
        _mainView = [[UIView alloc]init];
        [_mainView setBackgroundColor:[UIColor whiteColor]];
        [_mainView.layer setMasksToBounds:YES];
        [_mainView.layer setCornerRadius:4];
    }
    return _mainView;
}
-(UIButton *)confirmButton{
    if(_confirmButton == nil){
        _confirmButton = [[UIButton alloc]init];
        [_confirmButton setBackgroundColor:RGB16(0Xfddb43)];
        [_confirmButton setTitle:@"Ok" forState:UIControlStateNormal];
        [_confirmButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_confirmButton setTitleColor:RGB16(0X3d3d3d) forState:UIControlStateNormal];
        [_confirmButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [_confirmButton addTarget:self action:@selector(confirmButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmButton;
}
-(UIButton *)cancelButton{
    if(_cancelButton == nil){
        _cancelButton = [[UIButton alloc]init];
        [_cancelButton setBackgroundColor:RGB16(0XEBECED)];
        [_cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_cancelButton setTitleColor:RGB16(0X3d3d3d) forState:UIControlStateNormal];
        [_cancelButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [_cancelButton addTarget:self action:@selector(cancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

-(UIButton *)closedButton{
    if(_closedButton == nil){
        _closedButton = [[UIButton alloc]init];
        [_closedButton setImage:[UIImage imageNamed:@"closed.png"] forState:UIControlStateNormal];
        [_closedButton addTarget:self action:@selector(closedButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closedButton;
}

-(UILabel*)headerTitleLabel {
    if (_headerTitleLabel == nil) {
        _headerTitleLabel = [[UILabel alloc]init];
        [_headerTitleLabel setFont:[UIFont systemFontOfSize:15]];
        [_headerTitleLabel setTextAlignment:NSTextAlignmentCenter];
        [_headerTitleLabel setTextColor:RGB16(0X3d3d3d)];
    }
    return _headerTitleLabel;
}

-(UIView *)contentView{
    if(_contentView==nil){
        _contentView =[[UIView alloc]init];
        [_contentView setBackgroundColor:[UIColor whiteColor]];
    }
    return _contentView;
}

-(UILabel*)contentTextLabel {
    if (_contentTextLabel == nil) {
        _contentTextLabel = [[UILabel alloc]init];
        [_contentTextLabel setFont:[UIFont systemFontOfSize:13]];
        [_contentTextLabel setTextAlignment:NSTextAlignmentCenter];
        [_contentTextLabel setTextColor:RGB16(0X898989)];
        _contentTextLabel.numberOfLines = 0;
    }
    return _contentTextLabel;
}

@end
