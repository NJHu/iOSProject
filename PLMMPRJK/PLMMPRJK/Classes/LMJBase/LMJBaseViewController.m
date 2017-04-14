//
//  LLMJBBaseViewController.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/4/11.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJBaseViewController.h"

@interface LMJBaseViewController ()

/** <#digest#> */
@property (nonatomic, strong) Reachability *reachHost;

@end

@implementation LMJBaseViewController


#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    

    [self.reachHost startNotifier];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 配置友盟统计
    [MPUmengHelper beginLogPageViewName:self.title];
    
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.view endEditing:YES];
}


- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    // 配置友盟统计
    [MPUmengHelper endLogPageViewName:self.title];

}




- (instancetype)initWithTitle:(NSString *)title
{
    if (self = [super init]) {
        self.title = title.copy;
    }
    
    return self;
}


- (Reachability *)reachHost
{
    if(_reachHost == nil)
    {
        _reachHost = [Reachability reachabilityWithHostName:kURL_Reachability__Address];
        
        
        [kNotificationCenter addObserver:self selector:@selector(netStatusChange:) name:kReachabilityChangedNotification object:nil];
        
    }
    return _reachHost;
}

- (void)netStatusChange:(NSNotification *)noti
{
    NSLog(@"-----%@",noti.userInfo);
    
    //判断网络状态
    switch (self.reachHost.currentReachabilityStatus) {
        case NotReachable:
            [MBProgressHUD showInfo:@"当前网络连接失败，请查看设置" ToView:self.view];
            break;
        case ReachableViaWiFi:
            NSLog(@"wifi上网2");
            break;
        case ReachableViaWWAN:
            NSLog(@"手机上网2");
            break;
        default:
            break;
    }
    
}

- (void)dealloc
{
    
    LMJLog(@"%@", self.class);
    
    [kNotificationCenter removeObserver:self];
    self.reachHost = nil;
    
}

@end







