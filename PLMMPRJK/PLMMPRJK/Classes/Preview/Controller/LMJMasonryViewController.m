//
//  LMJMasonryViewController.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/4/29.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJMasonryViewController.h"

@interface LMJMasonryViewController ()

@end

@implementation LMJMasonryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self masonryArrayBtns];
    
    [self masonryLabels];
    
    [self masonryLabels2];
    
    [self masonryLabels3];
    
    
    [self masonryEdgeCenter];
    
    
    [self masonryScrollView];
    
    [self masonryUpdate];
}

- (void)masonryArrayBtns
{
    NSArray *strings = @[@"确认", @"取消", @"再考虑一下吧"];
    NSMutableArray<UIButton *> *btnM = [NSMutableArray array];
    for (NSInteger i = 0; i < 3; i++) {
        
        UIButton *btn = [[UIButton alloc] init];
        [btn setBackgroundColor:[UIColor RandomColor]];
        [self.view addSubview:btn];
        
        [btn setTitle:strings[i] forState:UIControlStateNormal];
        
        [btnM addObject:btn];
        btn.tag = i;
        
        [btn addTarget:self action:@selector(show:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    [btnM mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:20 leadSpacing:10 tailSpacing:10];
    
    
    [btnM makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(80);
        make.height.equalTo(44);
        
    }];
   
}

- (void)show:(UIButton *)btn
{
    if (btn.tag == 0) {
        
        [WJYAlertView showOneButtonWithTitle:@"一个" Message:@"我是内容" ButtonType:WJYAlertViewButtonTypeDefault ButtonTitle:btn.currentTitle Click:^{
            
            
        }];
    }else if (btn.tag == 1)
    {
        [WJYAlertView showMultipleButtonsWithTitle:@"任意按钮" Message:@"我是内容" Click:^(NSInteger index) {
            
        } Buttons:@{@(WJYAlertViewButtonTypeDefault) : @"OK"}, @{@(WJYAlertViewButtonTypeCancel) : @"cancel"}, @{@(WJYAlertViewButtonTypeWarn) : @"warn"}, nil];
    }else if (btn.tag == 2)
    {
        WJYAlertInputTextView *AlertInputTextView = [[WJYAlertInputTextView alloc] initPagesViewWithTitle:@"标题" leftButtonTitle:@"确认" rightButtonTitle:@"取消" placeholderText:@"我是占位文字1"];
        
        WJYAlertView *AlertView = [[WJYAlertView alloc] initWithCustomView:AlertInputTextView dismissWhenTouchedBackground:YES];
        
        [AlertInputTextView setLeftBlock:^void(NSString *title){
            
            [AlertView dismissWithCompletion:^{
                
                NSLog(@"%@", title);
            }];
        }];
        
        [AlertInputTextView setRightBlock:^void(NSString *title){
            
            [AlertView dismissWithCompletion:^{
                
                NSLog(@"%@", title);
            }];
            
        }];
        
        [AlertView show];
        
    }
}


- (void)masonryLabels
{
    
    UILabel *myLabel = [[UILabel alloc] init];
    
    myLabel.backgroundColor = [UIColor RandomColor];
    
    myLabel.text = @"不设置高度和宽度约束";
    
    [self.view addSubview:myLabel];
    
    
    UILabel *mySenondLabel = [[UILabel alloc] init];
    
    mySenondLabel.backgroundColor = [UIColor RandomColor];
    
    mySenondLabel.text = @"确认";
    
    [self.view addSubview:mySenondLabel];
    
    [myLabel makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(130);
        make.left.equalTo(10);
    }];
    
    [mySenondLabel makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(myLabel.mas_right).offset(10);
        make.top.equalTo(myLabel.mas_top);
    }];
    
}


- (void)masonryLabels2
{
    
    UILabel *myLabel = [[UILabel alloc] init];
    
    myLabel.backgroundColor = [UIColor RandomColor];
    
    myLabel.text = @"距离右边最少80, 文字多多多多多多多多多多多多多多多多多多";
    
    [self.view addSubview:myLabel];
    
    
    UILabel *mySenondLabel = [[UILabel alloc] init];
    
    mySenondLabel.backgroundColor = [UIColor RandomColor];
    
    mySenondLabel.text = @"确认";
    
    [self.view addSubview:mySenondLabel];
    
    [myLabel makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(160);
        make.left.equalTo(10);
        
        
        make.right.lessThanOrEqualTo(-80).priorityHigh();
    }];
    
    [mySenondLabel makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(myLabel.mas_right).offset(10);
        make.top.equalTo(myLabel.mas_top);
    }];
    
}



- (void)masonryLabels3
{
    
    UILabel *myLabel = [[UILabel alloc] init];
    
    myLabel.backgroundColor = [UIColor RandomColor];
    
    myLabel.text = @"距离右边最少80, 文字少";
    
    [self.view addSubview:myLabel];
    
    
    UILabel *mySenondLabel = [[UILabel alloc] init];
    
    mySenondLabel.backgroundColor = [UIColor RandomColor];
    
    mySenondLabel.text = @"确认";
    
    [self.view addSubview:mySenondLabel];
    
    [myLabel makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(190);
        make.left.equalTo(10);
        
        
        make.right.lessThanOrEqualTo(-80).priorityHigh();
    }];
    
    [mySenondLabel makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(myLabel.mas_right).offset(10);
        make.top.equalTo(myLabel.mas_top);
    }];
    
}


- (void)masonryEdgeCenter
{
    
    UIView *myView = [[UIView alloc] init];
    
    myView.backgroundColor = [UIColor RandomColor];
    
    [self.view addSubview:myView];
    
    [myView makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(10);
        make.top.equalTo(220);
        make.size.equalTo(CGSizeMake(150, 100));
    }];
    
    
    UIView *myInView = [[UIView alloc] init];
    
    myInView.backgroundColor = [UIColor RandomColor];
    
    [myView addSubview:myInView];
    
    
    [myInView makeConstraints:^(MASConstraintMaker *make) {
        
//        make.edges.equalTo(UIEdgeInsetsMake(10, 5, 15, 5));
        make.edges.equalTo(myView).insets(UIEdgeInsetsMake(10, 5, 15, 5));
    }];
    
    
    UIView *myCenterView = [[UIView alloc] init];
    
    myCenterView.backgroundColor = [UIColor RandomColor];
    
    [myView addSubview:myCenterView];
    
    
    [myCenterView makeConstraints:^(MASConstraintMaker *make) {
        
        make.size.equalTo(CGSizeMake(50, 44));
        make.center.equalTo(myView).centerOffset(CGPointMake(-10, 10));
    }];
    
    
    
    
}



- (void)masonryScrollView
{
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    
    scrollView.backgroundColor = [UIColor RandomColor];
    scrollView.bounces = YES;
    scrollView.showsVerticalScrollIndicator = scrollView.showsHorizontalScrollIndicator = YES;
    [self.view addSubview:scrollView];
    
    [scrollView makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(220);
        make.left.equalTo(170);
        make.right.equalTo(self.view).offset(10);
        make.bottom.offset(-100);
        
    }];
    
    
    UIView *containerView = [[UIView alloc] init];
    
    containerView.backgroundColor = [UIColor RandomColor];
    
    [scrollView addSubview:containerView];
    
    [containerView makeConstraints:^(MASConstraintMaker *make) {
        
//        make.edges.equalTo(scrollView);
        make.edges.equalTo(UIEdgeInsetsMake(10, 10, 10, 20));
//        make.height.equalTo(kScreenHeight);
        make.width.equalTo(scrollView.mas_width);
    }];
    
    UIView *lastView = nil;
    
    for (NSInteger i = 0; i < 10; i++) {
        
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor RandomColor];
        [containerView addSubview:view];
        
        if (!lastView) {
            
            [view makeConstraints:^(MASConstraintMaker *make) {
                
                make.top.equalTo(containerView.mas_top);
                make.left.right.equalTo(containerView);
                make.height.equalTo(20 * (i + 1));
            }];
        }else
        {
            [view makeConstraints:^(MASConstraintMaker *make) {
                
                make.top.equalTo(lastView.mas_bottom).offset(10);
                make.left.right.equalTo(containerView);
                make.height.equalTo(20 * (i + 1));
                
            }];
        }
        
        lastView = view;
    }
    
    [containerView updateConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(lastView.mas_bottom).offset(20);
    }];
}

- (void)masonryUpdate
{
    
    UIView *myView = [[UIView alloc] init];
    
    myView.backgroundColor = [UIColor RandomColor];
    
    [self.view addSubview:myView];
    
    [myView makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(10);
        make.bottom.offset(-20);
        make.size.equalTo(CGSizeMake(150, 200));
    }];
    
    
    UIView *myInView = [[UIView alloc] init];
    
    myInView.backgroundColor = [UIColor RandomColor];
    
    [myView addSubview:myInView];
    
    
    [myInView makeConstraints:^(MASConstraintMaker *make) {
        
        //        make.edges.equalTo(UIEdgeInsetsMake(10, 5, 15, 5));
        make.edges.equalTo(myView).insets(UIEdgeInsetsMake(10, 5, 15, 5));
    }];

    LMJWeakSelf(myInView);
    LMJWeakSelf(myView);
    [myView addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
       
        [weakmyInView remakeConstraints:^(MASConstraintMaker *make) {
            
            make.edges.equalTo(UIEdgeInsetsMake(arc4random() & 50 + 1, arc4random() & 50 + 1, arc4random() & 50 + 1, arc4random() & 50 + 1));
            
        }];
        
        [weakmyView layoutIfNeeded];
        
    }];
    
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

@end
