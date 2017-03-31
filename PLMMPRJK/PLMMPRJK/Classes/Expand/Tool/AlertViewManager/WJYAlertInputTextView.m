//
//  WJYAlertInputTextView.m
//  MobileProject
//
//  Created by wujunyang on 16/8/4.
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#import "WJYAlertInputTextView.h"


@interface WJYAlertInputTextView()<UITextViewDelegate>

@property(nonatomic,strong)UIView *showView;
@property(nonatomic,strong)UIView *bottomLineView,*seperateLineView;
@property(nonatomic,copy)NSString *viewTitle,*leftButtonTitle,*rightButtonTitle,*placeholderText;
@end

static const CGFloat kAlertViewHeight=200;
static const CGFloat kAlertViewLeftAndRight=15;
static const CGFloat kTopTitleLabelSapn=10;
static const CGFloat kTitleLabelHeight=16;
static const CGFloat kLeftAndRightSpan=10;
static const CGFloat kTopContentTextHeight=10;
static const CGFloat kContentTextViewHeight=100;
static const CGFloat kButtonHeight=44;

@implementation WJYAlertInputTextView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

-(instancetype)initPagesViewWithTitle:(NSString *)title leftButtonTitle:(NSString *)leftButtonTitle rightButtonTitle:(NSString *)rightButtonTitle placeholderText:(NSString *)placeholderText
{
    self = [super initWithFrame:[[UIScreen mainScreen] bounds]];
    if (self) {
        _viewTitle=title;
        _leftButtonTitle=leftButtonTitle;
        _rightButtonTitle=rightButtonTitle;
        _placeholderText=placeholderText;
        
        [self layoutViewPage];
    }
    return self;
}


-(void)layoutViewPage
{
    if (!self.showView) {
        self.showView=[[UIView alloc]init];
        self.showView.backgroundColor=[UIColor whiteColor];
        [self addSubview:self.showView];
        [self.showView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(kAlertViewLeftAndRight);
            make.right.mas_equalTo(-kAlertViewLeftAndRight);
            make.center.mas_equalTo(0);
            make.height.mas_equalTo(kAlertViewHeight);
        }];
    }
    
    
    if (!self.titleLabel) {
        self.titleLabel=[[UILabel alloc]init];
        self.titleLabel.font=[UIFont systemFontOfSize:14];
        self.titleLabel.text=self.viewTitle;
        self.titleLabel.textColor=[UIColor blackColor];
        self.titleLabel.textAlignment=NSTextAlignmentCenter;
        [self.showView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(kLeftAndRightSpan);
            make.right.mas_equalTo(-kLeftAndRightSpan);
            make.top.mas_equalTo(kTopTitleLabelSapn);
            make.height.mas_equalTo(kTitleLabelHeight);
        }];
    }
    
    //区别是否有头部的布局
    CGFloat curContentTextTop=self.viewTitle.length?kTopTitleLabelSapn+kTitleLabelHeight+kTopContentTextHeight:kTopTitleLabelSapn;
    CGFloat curContentTextHeight=self.viewTitle.length?kContentTextViewHeight:kContentTextViewHeight+kTopTitleLabelSapn+kTitleLabelHeight;
    
    if (!self.contentTextView) {
        self.contentTextView = [[UIPlaceHolderTextView alloc]init];
        self.contentTextView.delegate=self;
        self.contentTextView.layer.borderWidth = 0.5f;
        self.contentTextView.layer.borderColor = RGB(234, 234, 234).CGColor;
        self.contentTextView.font = SYSTEMFONT(12);
        self.contentTextView.textColor = [UIColor blackColor];
        self.contentTextView.placeholder=self.placeholderText;
        self.contentTextView.placeholderColor = HEXCOLOR(0x666666);
        self.contentTextView.returnKeyType=UIReturnKeyDone;
        [self.showView addSubview:self.contentTextView];
        [self.contentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(kLeftAndRightSpan);
            make.right.mas_equalTo(-kLeftAndRightSpan);
            make.top.mas_equalTo(curContentTextTop);
            make.height.mas_equalTo(curContentTextHeight);
        }];
    }
    
    if (!self.leftButton) {
        self.leftButton=[[UIButton alloc]init];
        [self.leftButton setTitle:self.leftButtonTitle forState:UIControlStateNormal];
        [self.leftButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [self.leftButton addTarget:self action:@selector(leftBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.showView addSubview:self.leftButton];
        [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.height.mas_equalTo(kButtonHeight);
        }];
    }
    
    if (!self.rightButton) {
        self.rightButton=[[UIButton alloc]init];
        [self.rightButton setTitle:self.rightButtonTitle forState:UIControlStateNormal];
        [self.rightButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [self.rightButton addTarget:self action:@selector(rightBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.showView addSubview:self.rightButton];
        [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.height.mas_equalTo(kButtonHeight);
            make.left.mas_equalTo(self.leftButton.right);
            make.width.mas_equalTo(self.leftButton);
        }];
    }
    
    
    if (!self.bottomLineView) {
        self.bottomLineView=[[UIView alloc]init];
        self.bottomLineView.backgroundColor=[UIColor grayColor];
        [self.showView addSubview:self.bottomLineView];
        [self.bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.mas_equalTo(0);
            make.bottom.mas_equalTo(-kButtonHeight);
            make.height.mas_equalTo(0.3);
        }];
    }
    

    if (!self.seperateLineView) {
        self.seperateLineView=[[UIView alloc]init];
        self.seperateLineView.backgroundColor=[UIColor grayColor];
        [self.showView addSubview:self.seperateLineView];
        [self.seperateLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.leftButton.right).offset(0);
            make.height.mas_equalTo(kButtonHeight);
            make.width.mas_equalTo(0.3);
            make.bottom.mas_equalTo(0);
        }];
    }
    
}


#pragma mark UITextViewDelegate

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
    
}


#pragma mark 自定义代码

-(void)leftBtnClicked
{
    if (self.leftBlock) {
        self.leftBlock(self.contentTextView.text);
    }
}

-(void)rightBtnClicked
{
    if (self.rightBlock) {
        self.rightBlock(self.contentTextView.text);
    }
}

@end
