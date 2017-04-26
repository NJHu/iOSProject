//
//  LMJRequestBaseViewController.h
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/4/24.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJNavUIBaseViewController.h"

@class LMJRequestBaseViewController;
@protocol LMJRequestBaseViewControllerDelegate <NSObject>

@optional
#pragma mark - 处理无网络连接的情况
- (void)requestNoConnection:(LMJRequestBaseViewController *)requestBaseViewController;

#pragma mark - 处理网络错误提示
- (BOOL)request:(LMJRequestBaseViewController *)requestBaseViewController error:(NSError *)error;

#pragma mark - 网络监听
/*
 NotReachable = 0,
 ReachableViaWiFi = 2,
 ReachableViaWWAN = 1,
 ReachableVia2G = 3,
 ReachableVia3G = 4,
 ReachableVia4G = 5,
 */
- (void)networkStatusChange:(NetworkStatus)networkStatus;

@end





@interface LMJRequestBaseViewController : LMJNavUIBaseViewController<LMJRequestBaseViewControllerDelegate>

#pragma mark - 加载框
- (void)showLoading;

- (void)dismissLoading;

#pragma mark - 请求网络数据
- (void)request:(LMJBaseRequest *)request completion:(void (^)(id responseData))completion;

//在后台发请求数据， 不显示loading
- (void)requestInBackgroud:(LMJBaseRequest *)request completion:(void (^)(id responseData))completion;

- (void)request:(LMJBaseRequest *)request showLoading:(BOOL)showLoading completion:(void (^)(id responseData))completion;


@end
