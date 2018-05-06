//
//  LMJKeyboardHandleViewController.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/4/21.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJKeyboardHandleViewController.h"
#import "MBProgressHUD+LMJ.h"
#import "UITextView+WZB.h"

@interface LMJKeyboardHandleViewController ()

/** <#digest#> */
@property (weak, nonatomic) UITextView *textView;

/** <#digest#> */
@property (weak, nonatomic) UITextView *textView0;

@property (weak, nonatomic) UITextView *textView1;

/** <#digest#> */
@property (nonatomic, strong) UIView *myTopView;

/** <#digest#> */
@property (nonatomic, strong) UIView *myBottomView;

/** <#digest#> */
@property (nonatomic, strong) UITextField *myTextField;

/** <#digest#> */
@property (nonatomic, strong) UIButton *myRightButton;


@property(nonatomic)BOOL isSelect;
@property (nonatomic, strong) NSNumber *duration;
@property (nonatomic, strong) NSNumber *curve;

@property(nonatomic) CGFloat keyBoardHeight;
@end

static const CGFloat topViewHeigt = 100;

@implementation LMJKeyboardHandleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [MBProgressHUD showAutoMessage:@"点击右上角弹出隐藏视图键盘"];
    
    [self textView];
    [self textView0];
    [self textView1];
    
    self.myTopView = [[UIView alloc]init];
    self.myTopView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, topViewHeigt);
    self.myTopView.backgroundColor = [UIColor redColor];
    
    
    self.myTextField = [[UITextField alloc]init];
    self.myTextField.borderStyle = UITextBorderStyleNone;
    self.myTextField.layer.borderColor = [UIColor grayColor].CGColor;
    self.myTextField.layer.borderWidth = 1;
    self.myTextField.placeholder = @"请输入文本内容";
    [self.myTopView addSubview:self.myTextField];
    [self.myTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-50);
        make.height.mas_equalTo(40);
    }];
    
    [self.view addSubview:self.myTopView];
    
    self.myRightButton = [[UIButton alloc]init];
    [self.myRightButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.myRightButton setTitle:@"照片" forState:UIControlStateNormal];
    [self.myRightButton addTarget:self action:@selector(myAction)forControlEvents:UIControlEventTouchUpInside];
    [self.myTopView addSubview:self.myRightButton];
    [self.myRightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.right.mas_equalTo(-10);
    }];
    
    
    self.myBottomView=[[UIView alloc]init];
    
    self.myBottomView.backgroundColor=[UIColor yellowColor];
    
    UILabel *myLabel=[[UILabel alloc]init];
    myLabel.text=@"我是自定义视图";
    myLabel.textColor = [UIColor redColor];
    [self.myBottomView addSubview:myLabel];
    [myLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.myBottomView);
    }];
    
    
    //增加监听，当键盘出现或改变时收到消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    //增加监听，当键盘退出时收到消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)noti
{
    // ------获取键盘的高度
    NSDictionary *userInfo    = [noti userInfo];
    
    // 键盘弹出后的frame的结构体对象
    NSValue *valueEndFrame = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    // 得到键盘弹出后的键盘视图所在y坐标
    CGRect keyboardRect       = [valueEndFrame CGRectValue];
    CGFloat KBHeight              = keyboardRect.size.height;
    self.keyBoardHeight = KBHeight;
    
    // ------键盘出现或改变时的操作代码
    NSLog(@"当前的键盘高度为：%f",KBHeight);
    // 键盘弹出的动画时间
    self.duration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    // 键盘弹出的动画曲线
    self.curve = [userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // 添加移动动画，使视图跟随键盘移动(动画时间和曲线都保持一致)
    [UIView animateWithDuration:[_duration doubleValue] animations:^{
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationCurve:[self->_curve intValue]];
        
        self.myTopView.frame = CGRectMake(0, self.view.lmj_height - topViewHeigt, kScreenWidth, topViewHeigt);
    }];
}

- (void)keyboardWillHide:(NSNotification *)noti
{
    // ------键盘退出时的操作代码
    NSDictionary *userInfo    = [noti userInfo];
    self.duration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    
    // 添加移动动画，使视图跟随键盘移动(动画时间和曲线都保持一致)
    [UIView animateWithDuration:[_duration doubleValue] animations:^{
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationCurve:[self->_curve intValue]];
        self.myTopView.frame=CGRectMake(0, kScreenHeight, kScreenWidth, topViewHeigt);
    }];
}


- (void)myAction
{
    self.myBottomView.frame = CGRectMake(0, 0, kScreenWidth, self.keyBoardHeight);
    
    [self.myTextField resignFirstResponder];
    
    self.myTextField.inputView = self.myTextField.inputView ? nil : self.myBottomView;
    
    [self.myTextField becomeFirstResponder];
}


#pragma mark - lmjtextDlegate
- (BOOL)textViewControllerEnableAutoToolbar:(LMJTextViewController *)textViewController
{
    return NO;
}


#pragma mark - LMJNavUIBaseViewControllerDataSource

/** 导航条右边的按钮 */
- (UIImage *)lmjNavigationBarRightButtonImage:(UIButton *)rightButton navigationBar:(LMJNavigationBar *)navigationBar
{
    
    [rightButton setTitle:@"弹出键盘" forState:UIControlStateNormal];
    
    rightButton.lmj_width = 100;
    
    [rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    return nil;
}


/** 右边的按钮的点击 */
-(void)rightButtonEvent:(UIButton *)sender navigationBar:(LMJNavigationBar *)navigationBar
{
    [self.myTextField becomeFirstResponder];
}

#pragma mark - LMJNavUIBaseViewControllerDataSource

/** 导航条左边的按钮 */
- (UIImage *)lmjNavigationBarLeftButtonImage:(UIButton *)leftButton navigationBar:(LMJNavigationBar *)navigationBar
{
    [leftButton setImage:[UIImage imageNamed:@"NavgationBar_white_back"] forState:UIControlStateHighlighted];
    
    return [UIImage imageNamed:@"NavgationBar_blue_back"];
}

#pragma mark - LMJNavUIBaseViewControllerDelegate
/** 左边的按钮的点击 */
-(void)leftButtonEvent:(UIButton *)sender navigationBar:(LMJNavigationBar *)navigationBar
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (UITextView *)textView
{
    if(_textView == nil)
    {
        
        UITextView *textView = [[UITextView alloc] init];
        [self.view addSubview:textView];
        
        _textView = textView;
        
        [textView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(self.view.mas_top).offset(100);
            make.left.mas_equalTo(self.view.mas_left).offset(100);
            make.height.mas_equalTo(100);
            make.right.mas_equalTo(self.view.mas_right).offset(-100);
        }];
        
        textView.backgroundColor = [UIColor RandomColor];
        
        textView.wzb_placeholder = @"我是占位文字";
    }
    return _textView;
}


- (UITextView *)textView0
{
    if(_textView0 == nil)
    {
        
        UITextView *textView = [[UITextView alloc] init];
        [self.view addSubview:textView];
        
        _textView0 = textView;
        
        
        [textView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(self.textView.mas_bottom).offset(44);
            make.left.mas_equalTo(self.view.mas_left).offset(100);
            make.height.mas_equalTo(100);
            make.right.mas_equalTo(self.view.mas_right).offset(-100);
            
        }];
        
        textView.backgroundColor = [UIColor RandomColor];
        
        textView.wzb_placeholder = @"我是占位文字";
        textView.wzb_placeholderColor = [UIColor RandomColor];
        
    }
    return _textView0;
}

- (UITextView *)textView1
{
    if(_textView1 == nil)
    {
        
        UITextView *textView = [[UITextView alloc] init];
        [self.view addSubview:textView];
        
        _textView1 = textView;
        
        
        [textView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(self.textView0.mas_bottom).offset(44);
            make.left.mas_equalTo(self.view.mas_left).offset(100);
            make.height.mas_equalTo(100);
            make.right.mas_equalTo(self.view.mas_right).offset(-100);
            
        }];
        
        textView.backgroundColor = [UIColor RandomColor];
        
        textView.wzb_placeholder = @"我是占位文字";
        textView.wzb_placeholderColor = [UIColor RandomColor];
        
    }
    return _textView1;
}
@end
