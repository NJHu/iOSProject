//
//  LMJBlockLoopViewController.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/4/17.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJBlockLoopViewController.h"
#import "LMJChildBlockViewController.h"
#import "LMJModalBlockViewController.h"
#import "LMJBlockLoopOperation.h"

@interface LMJBlockLoopViewController ()

@property(nonatomic,strong) UIButton *myButton,*myModelButton,*myBlockButton;

@property(nonatomic,strong) UIView *myBlockView;

@end

@implementation LMJBlockLoopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    [self.view addSubview:self.myButton];
    [self.myButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(100);
        make.left.mas_equalTo(20);
    }];
    
    
    [self.view addSubview:self.myBlockButton];
    [self.myBlockButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(170);
        make.left.mas_equalTo(20);
    }];
    
    [self.view addSubview:self.myModelButton];
    [self.myModelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(220);
        make.left.mas_equalTo(20);
    }];
    
    //1:Block内部就完成处理，block不要以属性开放出来，否则不好管理,因为它block执行时就自个打破循环
    _myBlockView=[[UIView alloc] init];
    _myBlockView.backgroundColor=[UIColor RandomColor];
    [self.view addSubview:_myBlockView];
    [_myBlockView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(100);
        make.right.mas_equalTo(-20);
        make.size.mas_equalTo(CGSizeMake(100, 50));
    }];
    
    LMJWeakSelf(self);
    [_myBlockView addTapGestureRecognizer:^(UITapGestureRecognizer *recognizer, NSString *gestureId) {
        
            //不要在这里面存放 关于BlockLoopViewController的属性 否则也会内存无法释放 例如：_info=name;
        [weakself.view makeToast:@"点击了"];
        
    }];
    
}


//调用其它类的一些内存问题
-(void)myBlockButtonAction
{
    LMJWeakSelf(self);
    //1：
    [LMJBlockLoopOperation operateWithSuccessBlock:^{
        [weakself showErrorMessage:@"成功执行完成"];
    }];
    
    //这种不会出现block 因为MPBlockLoopOperation没在MPBlockLoopViewController的属性中,所以三者不会是一个闭圈
    LMJBlockLoopOperation *operation = [[LMJBlockLoopOperation alloc] init];
    
    //3：如果带有block 又引入self就要进行弱化对象operation，否则会出现内存释放的问题
    LMJWeakSelf(operation);
    operation.logAddress = ^(NSString *address) {
        
        [weakself showErrorMessage:weakoperation.address];
    };
}

//子页开放的block
-(void)myButtonAction
{
    LMJChildBlockViewController *vc=[[LMJChildBlockViewController alloc]init];
    vc.successBlock=^()
    {
        [self loadPage];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)myModelButtonAction
{
    LMJModalBlockViewController *vc=[[LMJModalBlockViewController alloc]init];
    
    LMJWeakSelf(vc);
    vc.successBlock=^()
    {

        if (weakvc) {
            [weakvc dismissViewControllerAnimated:YES completion:nil];
        }
    };
    
    [self presentViewController:vc animated:YES completion:nil];
}

-(void)showErrorMessage:(NSString *)message
{
    NSLog(@"当前信息,%@",message);
}

-(void)loadPage
{
    NSLog(@"刷新当前的数据源");
}










-(UIButton *)myButton
{
    if (!_myButton) {
        _myButton=[UIButton new];
        _myButton.backgroundColor=[UIColor redColor];
        [_myButton setTitle:@"跳转子页" forState:UIControlStateNormal];
        [_myButton addTarget:self action:@selector(myButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _myButton;
}

-(UIButton *)myModelButton
{
    if (!_myModelButton) {
        _myModelButton=[UIButton new];
        _myModelButton.backgroundColor=[UIColor redColor];
        [_myModelButton setTitle:@"弹出模态窗口" forState:UIControlStateNormal];
        [_myModelButton addTarget:self action:@selector(myModelButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _myModelButton;
}

-(UIButton *)myBlockButton
{
    if (!_myBlockButton) {
        _myBlockButton=[UIButton new];
        _myBlockButton.backgroundColor=[UIColor redColor];
        [_myBlockButton setTitle:@"响应BlockLoopOperation中的block" forState:UIControlStateNormal];
        [_myBlockButton addTarget:self action:@selector(myBlockButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _myBlockButton;
}










#pragma mark 重写BaseViewController设置内容

- (UIColor *)lmjNavigationBackgroundColor:(LMJNavigationBar *)navigationBar
{
    return [UIColor RandomColor];
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
    return [self changeTitle:@"blockLoop"];;
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
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:curTitle ?: @""];
    
    [title addAttribute:NSForegroundColorAttributeName value:[UIColor RandomColor] range:NSMakeRange(0, title.length)];
    
    [title addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, title.length)];
    
    return title;
}


@end
