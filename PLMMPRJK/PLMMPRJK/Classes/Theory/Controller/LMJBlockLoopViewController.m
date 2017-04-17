//
//  LMJBlockLoopViewController.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/4/17.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJBlockLoopViewController.h"
#import "MPBlockView.h"
#import "MPBlockLoopOperation.h"
#import "LMJChildBlockViewController.h"
#import "LMJModalBlockViewController.h"


@interface LMJBlockLoopViewController ()

@property(nonatomic,strong)UIButton *myButton,*myModelButton,*myBlockButton;

@property(nonatomic,strong)MPBlockView *myBlockView;

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
    
    //1:Block内部就完成处理，block不要以属性开放出来，否则不好管理,MPWeakSelf、MPStrongSelf因为它block执行时就自个打破循环
    _myBlockView=[[MPBlockView alloc] init];
    _myBlockView.backgroundColor=[UIColor blueColor];
    [self.view addSubview:_myBlockView];
    [_myBlockView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(100);
        make.right.mas_equalTo(-20);
        make.size.mas_equalTo(CGSizeMake(100, 50));
    }];
    
    LMJWeakSelf(self);
    [_myBlockView startWithErrorBlcok:^(NSString *name) {
        
        //不要在这里面存放 关于MPBlockLoopViewController的属性 否则也会内存无法释放 例如：_info=name;
        [weakself showErrorMessage:name];
    }];
    
}


//调用其它类的一些内存问题
-(void)myBlockButtonAction
{
    //1：
    [MPBlockLoopOperation operateWithSuccessBlock:^{
        [self showErrorMessage:@"成功执行完成"];
    }];
    
    //这种不会出现block 因为MPBlockLoopOperation没在MPBlockLoopViewController的属性中,所以三者不会是一个闭圈
    MPBlockLoopOperation *operation=[[MPBlockLoopOperation alloc]initWithAddress:@"厦门市思明区"];
    
    //2：单纯这么响应不会出现内存没有释放的问题
    [operation startNoBlockShow:@"12345677888"];
    
    //3：如果带有block 又引入self就要进行弱化对象operation，否则会出现内存释放的问题
    LMJWeakSelf(self);
    [operation startWithAddBlock:^(NSString *name) {
        
        [weakself showErrorMessage:operation.myAddress];
    }];
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
        [_myBlockButton setTitle:@"响应MPBlockLoopOperation中的block" forState:UIControlStateNormal];
        [_myBlockButton addTarget:self action:@selector(myBlockButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _myBlockButton;
}










#pragma mark 重写BaseViewController设置内容

- (UIColor *)set_colorBackground
{
    return [UIColor RandomColor];
}

- (void)left_button_event:(UIButton *)sender
{
    NSLog(@"%s", __func__);
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)right_button_event:(UIButton *)sender
{
    NSLog(@"%s", __func__);
}

- (void)title_click_event:(UILabel *)sender
{
    NSLog(@"%@", sender);
}

- (NSMutableAttributedString *)setTitle
{
    return [self changeTitle:@"blockLoop"];;
}

- (UIButton *)set_leftButton
{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [btn setImage:[UIImage imageNamed:@"navigationButtonReturnClick"] forState:UIControlStateNormal];
    
    [btn setImage:[UIImage imageNamed:@"navigationButtonReturn"] forState:UIControlStateHighlighted];
    
    return btn;
}


- (UIButton *)set_rightButton
{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    btn.backgroundColor = [UIColor yellowColor];
    
    return btn;
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
