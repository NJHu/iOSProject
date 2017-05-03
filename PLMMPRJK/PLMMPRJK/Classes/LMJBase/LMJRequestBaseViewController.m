//
//  LMJRequestBaseViewController.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/4/24.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJRequestBaseViewController.h"

@interface LMJRequestBaseViewController ()

/** <#digest#> */
@property (nonatomic, strong) Reachability *reachHost;

@end

@implementation LMJRequestBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self reachHost];
}


#pragma mark - 加载框
- (void)showLoading
{
    [MBProgressHUD showLoadToView:self.view];
}

- (void)dismissLoading
{
    [MBProgressHUD hideHUDForView:self.view];
}

// 显示加载框
- (void)request:(LMJBaseRequest *)request completion:(void (^)(id responseData))completion
{
    [self request:request showLoading:YES completion:completion];
}

//在后台发请求数据， 不显示loading
- (void)requestInBackgroud:(LMJBaseRequest *)request completion:(void (^)(id responseData))completion
{
    [self request:request showLoading:NO completion:completion];
}


#pragma mark - 请求网络数据
- (void)request:(LMJBaseRequest *)request showLoading:(BOOL)showLoading completion:(void (^)(id responseData))completion
{
    
    if ([LMJRequestManager sharedManager].currentNetworkStatus == AFNetworkReachabilityStatusNotReachable) {
        
        [self requestNoConnection:self];
        
        return;
    }
    
    
    !showLoading ?: [self showLoading];
    
    LMJWeakSelf(self);
    [request POST:^(LMJBaseResponse *response) {
        
        if (!weakself) {
            return ;
        }
        
        !showLoading ?: [self dismissLoading];
        
        if (response.error && ![self request:self error:response.error]) {
            return;
        }
        
        !completion ?: completion(response.data);
        
    }];
    
}




- (void)requestNoConnection:(LMJRequestBaseViewController *)requestBaseViewController
{
    [self.view makeToast:@"没用网络连接" duration:0.5 position:CSToastPositionCenter];
    NSLog(@"没用网络连接");
}


- (BOOL)request:(LMJRequestBaseViewController *)requestBaseViewController error:(NSError *)error
{
    NSLog(@"%@", error);
    
    [self.view makeToast: error.userInfo[LMJBaseResponseSystemErrorMsgKey] ?: error.userInfo[LMJBaseResponseCustomErrorMsgKey] duration:0.5 position:CSToastPositionCenter];
    
    return YES;
}


#pragma mark - 监听网络状态
- (Reachability *)reachHost
{
    if(_reachHost == nil)
    {
        _reachHost = [Reachability reachabilityWithHostName:kURL_Reachability__Address];
        
        LMJWeakSelf(self);
        [_reachHost setUnreachableBlock:^(Reachability * reachability){
        
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [weakself networkStatusChange:reachability.currentReachabilityStatus];
                
            });
            
        }];
        
        
        [_reachHost setReachableBlock:^(Reachability * reachability){
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [weakself networkStatusChange:reachability.currentReachabilityStatus];
                
            });
            
        }];
        
        [_reachHost startNotifier];
        
    }
    return _reachHost;
}


- (void)networkStatusChange:(NetworkStatus)networkStatus
{
    //判断网络状态
    switch (networkStatus) {
        case NotReachable:
            [MBProgressHUD showError:@"当前网络连接失败，请查看设置" ToView:self.view];
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
    [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
    [_reachHost stopNotifier];
    _reachHost = nil;
}

@end
