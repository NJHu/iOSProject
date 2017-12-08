//
//  LMJLiftCycleViewController.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/4/13.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJLiftCycleViewController.h"

@interface LMJLiftCycleViewController ()

/** <#digest#> */
@property (weak, nonatomic) UITextView *inputTextView;

@end

@implementation LMJLiftCycleViewController


- (void)loadView
{
    [super loadView];
    
    [self life:__FUNCTION__];
}

#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    UIView *oneView = [[UIView alloc] initWithFrame:CGRectMake(100, self.lmj_navgationBar.lmj_height, 100, 100)];
    
    [self.view addSubview:oneView];
    
    
    UIView *twoView = [[UIView alloc] initWithFrame:CGRectMake(100, 200, 100, 100)];
    
    [self.view addSubview:twoView];
    
    
    [self life:__FUNCTION__];
}


- (void)life:(const char *)func
{
    NSMutableString *strM = [NSMutableString stringWithFormat:@"%@", self.inputTextView.text ?: @""];
    
    [strM appendString:[NSString stringWithUTF8String:func]];
    
    self.inputTextView.text = [strM.copy stringByAppendingString:@"\n"];
    
}

- (UITextView *)inputTextView
{
    if(_inputTextView == nil)
    {
        UITextView *textView = [[UITextView alloc] init];
        
        [self.view addSubview:textView];
        
//        textView.userInteractionEnabled = YES;
//        textView.editable = YES;
//        textView.selectable = NO;
//        textView.scrollEnabled = YES;
        
//        [textView addPlaceHolder:@"我是占位的"];
        
        [textView makeConstraints:^(MASConstraintMaker *make) {
            
            make.edges.equalTo(UIEdgeInsetsMake(60, 0, 0, 0));
            
        }];
        
        textView.textColor = [UIColor RandomColor];
        textView.font = AdaptedFontSize(16);
        
        _inputTextView = textView;
        
    }
    return _inputTextView;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self life:__FUNCTION__];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    [self life:__FUNCTION__];
    
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    [self life:__FUNCTION__];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [self life:__FUNCTION__];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self life:__FUNCTION__];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self life:__FUNCTION__];
}


- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self life:__FUNCTION__];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self life:__FUNCTION__];
}



#pragma mark 重写BaseViewController设置内容

- (UIColor *)lmjNavigationBackgroundColor:(LMJNavigationBar *)navigationBar
{
    return [UIColor yellowColor];
}

- (void)leftButtonEvent:(UIButton *)sender navigationBar:(LMJNavigationBar *)navigationBar
{
    NSLog(@"%s", __func__);
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightButtonEvent:(UIButton *)sender navigationBar:(LMJNavigationBar *)navigationBar
{
    NSLog(@"%s", __func__);
}

- (void)titleClickEvent:(UILabel *)sender navigationBar:(LMJNavigationBar *)navigationBar
{
    NSLog(@"%@", sender);
}

- (NSMutableAttributedString*)lmjNavigationBarTitle:(LMJNavigationBar *)navigationBar
{
    return [self changeTitle:@"生命周期"];
}

- (UIImage *)lmjNavigationBarLeftButtonImage:(UIButton *)leftButton navigationBar:(LMJNavigationBar *)navigationBar
{
[leftButton setImage:[UIImage imageNamed:@"navigationButtonReturn"] forState:UIControlStateHighlighted];

return [UIImage imageNamed:@"navigationButtonReturnClick"];
}


- (UIImage *)lmjNavigationBarRightButtonImage:(UIButton *)rightButton navigationBar:(LMJNavigationBar *)navigationBar
{
    rightButton.backgroundColor = [UIColor RandomColor];
    
    return nil;
}



#pragma mark 自定义代码

-(NSMutableAttributedString *)changeTitle:(NSString *)curTitle
{
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:curTitle];
    
    [title addAttribute:NSForegroundColorAttributeName value:HEXCOLOR(0x333333) range:NSMakeRange(0, title.length)];
    
    [title addAttribute:NSFontAttributeName value:CHINESE_SYSTEM(16) range:NSMakeRange(0, title.length)];
    
    return title;
}



@end
