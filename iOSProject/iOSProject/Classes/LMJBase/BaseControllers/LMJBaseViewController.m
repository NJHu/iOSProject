//
//  LLMJBBaseViewController.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/4/11.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJBaseViewController.h"
#import "LMJUMengHelper.h"

@interface LMJBaseViewController ()



@end

@implementation LMJBaseViewController


#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (@available(iOS 11.0, *)){
            [[UIScrollView appearanceWhenContainedInInstancesOfClasses:@[[LMJBaseViewController class]]] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
        }
    });
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 配置友盟统计
    [LMJUMengHelper beginLogPageViewName:self.title ?: self.navigationItem.title];
    
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}


- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    // 配置友盟统计
    [LMJUMengHelper endLogPageViewName:self.title ?: self.navigationItem.title];
}

- (instancetype)initWithTitle:(NSString *)title
{
    if (self = [super init]) {
        self.title = title.copy;
    }
    return self;
}

- (void)dealloc
{
    NSLog(@"dealloc---%@", self.class);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end







