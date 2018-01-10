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
    
    
    [btnM mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(80);
        make.height.mas_equalTo(44);
        
    }];
    
}

- (void)show:(UIButton *)btn
{
    if (btn.tag == 0) {
        
        
        [UIAlertController mj_showAlertWithTitle:@"one button" message:@"content" appearanceProcess:^(JXTAlertController * _Nonnull alertMaker) {
            
            alertMaker.addActionDefaultTitle(@"default_btn");
            
        } actionsBlock:^(NSInteger buttonIndex, UIAlertAction * _Nonnull action, JXTAlertController * _Nonnull alertSelf) {
            NSLog(@"%zd, %@, %@", buttonIndex, action, alertSelf);
        }];
        
    }else if (btn.tag == 1)
    {
        [UIAlertController mj_showAlertWithTitle:@"multiple btn" message:@"contentcontentcontentcontentcontentcontent" appearanceProcess:^(JXTAlertController * _Nonnull alertMaker) {
            alertMaker.addActionDefaultTitle(@"default_btn").addActionCancelTitle(@"cancel_btn").addActionDestructiveTitle(@"Destructive_btn");
        } actionsBlock:^(NSInteger buttonIndex, UIAlertAction * _Nonnull action, JXTAlertController * _Nonnull alertSelf) {
            NSLog(@"%zd, %@, %@", buttonIndex, action, alertSelf);
        }];
        
    }else if (btn.tag == 2)
    {
        [UIAlertController mj_showAlertWithTitle:@"title" message:@"content" appearanceProcess:^(JXTAlertController * _Nonnull alertMaker) {
            
            [alertMaker addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                NSLog(@"%@", textField);
                textField.placeholder = @"placeholder";
            }];
            
            [alertMaker addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                NSLog(@"%@", textField);
                textField.placeholder = @"placeholder";
            }];
            
            alertMaker.addActionDestructiveTitle(@"textOf1");
            alertMaker.addActionDestructiveTitle(@"textOf2");
            
        } actionsBlock:^(NSInteger buttonIndex, UIAlertAction * _Nonnull action, JXTAlertController * _Nonnull alertSelf) {
            if (buttonIndex == 0) {
                NSLog(@"%@", [alertSelf.textFields.firstObject text]);
            }else {
                NSLog(@"%@", [alertSelf.textFields.lastObject text]);
            }
        }];
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
    
    [myLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(130);
        make.left.mas_equalTo(10);
    }];
    
    [mySenondLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(myLabel.mas_right).offset(10);
        make.top.mas_equalTo(myLabel.mas_top);
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
    
    [myLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(160);
        make.left.mas_equalTo(10);
        
        
        make.right.mas_lessThanOrEqualTo(-80).priorityHigh();
    }];
    
    [mySenondLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(myLabel.mas_right).offset(10);
        make.top.mas_equalTo(myLabel.mas_top);
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
    
    [myLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(190);
        make.left.mas_equalTo(10);
        
        
        make.right.mas_lessThanOrEqualTo(-80).priorityHigh();
    }];
    
    [mySenondLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(myLabel.mas_right).offset(10);
        make.top.mas_equalTo(myLabel.mas_top);
    }];
    
}


- (void)masonryEdgeCenter
{
    
    UIView *myView = [[UIView alloc] init];
    
    myView.backgroundColor = [UIColor RandomColor];
    
    [self.view addSubview:myView];
    
    [myView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(220);
        make.size.mas_equalTo(CGSizeMake(150, 100));
    }];
    
    
    UIView *myInView = [[UIView alloc] init];
    
    myInView.backgroundColor = [UIColor RandomColor];
    
    [myView addSubview:myInView];
    
    
    [myInView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        //        make.edges.mas_equalTo(UIEdgeInsetsMake(10, 5, 15, 5));
        make.edges.mas_equalTo(myView).insets(UIEdgeInsetsMake(10, 5, 15, 5));
    }];
    
    
    UIView *myCenterView = [[UIView alloc] init];
    
    myCenterView.backgroundColor = [UIColor RandomColor];
    
    [myView addSubview:myCenterView];
    
    
    [myCenterView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.size.mas_equalTo(CGSizeMake(50, 44));
        make.center.mas_equalTo(myView).centerOffset(CGPointMake(-10, 10));
    }];
    
    
    
    
}



- (void)masonryScrollView
{
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    
    scrollView.backgroundColor = [UIColor RandomColor];
    scrollView.bounces = YES;
    scrollView.showsVerticalScrollIndicator = scrollView.showsHorizontalScrollIndicator = YES;
    [self.view addSubview:scrollView];
    
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(220);
        make.left.mas_equalTo(170);
        make.right.mas_equalTo(self.view).offset(-10);
        make.bottom.offset(-100);
        
    }];
    
    
    UIView *containerView = [[UIView alloc] init];
    
    containerView.backgroundColor = [UIColor RandomColor];
    
    [scrollView addSubview:containerView];
    
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        //        make.edges.mas_equalTo(scrollView);
        make.edges.mas_equalTo(UIEdgeInsetsMake(10, 10, 10, 20));
        //        make.height.mas_equalTo(kScreenHeight);
        make.width.mas_equalTo(scrollView.mas_width);
    }];
    
    UIView *lastView = nil;
    
    for (NSInteger i = 0; i < 10; i++) {
        
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor RandomColor];
        [containerView addSubview:view];
        
        if (!lastView) {
            
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.top.mas_equalTo(containerView.mas_top);
                make.left.right.mas_equalTo(containerView);
                make.height.mas_equalTo(20 * (i + 1));
            }];
        }else
        {
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.top.mas_equalTo(lastView.mas_bottom).offset(10);
                make.left.right.mas_equalTo(containerView);
                make.height.mas_equalTo(20 * (i + 1));
                
            }];
        }
        
        lastView = view;
    }
    
    [containerView mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.mas_equalTo(lastView.mas_bottom).offset(20);
    }];
}

- (void)masonryUpdate
{
    
    UIView *myView = [[UIView alloc] init];
    
    myView.backgroundColor = [UIColor RandomColor];
    
    [self.view addSubview:myView];
    
    [myView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(10);
        make.bottom.offset(-20);
        make.size.mas_equalTo(CGSizeMake(150, 200));
    }];
    
    
    UIView *myInView = [[UIView alloc] init];
    
    myInView.backgroundColor = [UIColor RandomColor];
    
    [myView addSubview:myInView];
    
    
    [myInView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(myView).insets(UIEdgeInsetsMake(10, 5, 15, 5));
    }];
    
    LMJWeakSelf(myInView);
    LMJWeakSelf(myView);
    [myView addTapGestureRecognizer:^(UITapGestureRecognizer *recognizer, NSString *gestureId) {
        
        [weakmyInView mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.edges.mas_equalTo(UIEdgeInsetsMake(arc4random() & 50 + 1, arc4random() & 50 + 1, arc4random() & 50 + 1, arc4random() & 50 + 1));
            
        }];
        
        // 添加动画
        [UIView animateWithDuration:1 animations:^{
            [weakmyView layoutIfNeeded];
        }];
        
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
