//
//  LMJWebViewController.m
//  PLMMPRJK
//
//  Created by NJHu on 2017/4/9.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJWebViewController.h"

@interface LMJWebViewController ()

/** <#digest#> */
@property (weak, nonatomic) UIProgressView *progressView;

/** <#digest#> */
@property (strong, nonatomic) UIButton *backBtn;

/** <#digest#> */
@property (strong, nonatomic) UIButton *closeBtn;

@end

@implementation LMJWebViewController


#pragma mark - 生命周期
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.fd_interactivePopDisabled = YES;
    
    LMJWeakSelf(self);
    [self.webView addObserverBlockForKeyPath:CFPKeyPath(weakself.webView, estimatedProgress) block:^(id  _Nonnull obj, id  _Nullable oldVal, id  _Nullable newVal) {
        
        
        weakself.progressView.progress = weakself.webView.estimatedProgress;
        // 加载完成
        if (weakself.webView.estimatedProgress  >= 1.0f ) {
            
            [UIView animateWithDuration:0.25f animations:^{
                weakself.progressView.alpha = 0.0f;
                weakself.progressView.progress = 0.0f;
            }];
            
        }else{
            weakself.progressView.alpha = 1.0f;
        }
        
    }];
    
    
    
    if ([self isNeedAutoTitle]) {
        
        [self.webView addObserverBlockForKeyPath:CFPKeyPath(self.webView, title) block:^(id  _Nonnull obj, id  _Nullable oldVal, id  _Nullable newVal) {
            
            if ([newVal isKindOfClass:[NSString class]]) {
                
                weakself.title = newVal;
                [weakself changeNavgationTitle:[weakself changeTitle:weakself.title]];
                
            }
            
        }];
    }
    
    
    
    
    if (self.gotoURL.length > 0) {
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.gotoURL]]];
    }
    
}



- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];

    [self.view bringSubviewToFront:self.progressView];
    
}


#pragma mark - title
- (NSMutableAttributedString*)lmjNavigationBarTitle:(LMJNavigationBar *)navigationBar
{
    return [self changeTitle:@""];
}

#pragma mark 自定义代码

-(NSMutableAttributedString *)changeTitle:(NSString *)curTitle
{
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:curTitle];
    [title addAttribute:NSForegroundColorAttributeName value:HEXCOLOR(0x333333) range:NSMakeRange(0, title.length)];
    [title addAttribute:NSFontAttributeName value:CHINESE_SYSTEM(17) range:NSMakeRange(0, title.length)];
    
    return title;
}




#pragma mark - 设置左上角的一个返回按钮和一个关闭按钮

#pragma mark - LMJNavUIBaseViewControllerDataSource
\
/** 导航条的左边的 view */
- (UIView *)lmjNavigationBarLeftView:(LMJNavigationBar *)navigationBar
{
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 90, 44)];
    
    leftView.backgroundColor = [UIColor yellowColor];
    
    self.backBtn.origin = CGPointZero;
    
    self.closeBtn.mj_x = leftView.mj_w - self.closeBtn.mj_w;
    
    [leftView addSubview:self.backBtn];
    
    [leftView addSubview:self.closeBtn];
    
    return leftView;
}



#pragma mark - Delegate

/** 中间如果是 label 就会有点击 */
-(void)titleClickEvent:(UILabel *)sender navigationBar:(LMJNavigationBar *)navigationBar
{
    
}




- (UIButton *)backBtn
{
    if(_backBtn == nil)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"navigationButtonReturn"] forState:UIControlStateNormal];
        
        [btn setImage:[UIImage imageNamed:@"navigationButtonReturnClick"] forState:UIControlStateHighlighted];
        
        btn.size = CGSizeMake(34, 44);
        
        [btn addTarget:self action:@selector(leftButtonEvent:navigationBar:) forControlEvents:UIControlEventTouchUpInside];
        
        _backBtn = btn;
    }
    return _backBtn;
}

- (UIButton *)closeBtn
{
    if(_closeBtn == nil)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [btn setTitle:@"关闭" forState:UIControlStateNormal];
        
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        
        btn.size = CGSizeMake(44, 44);
        
        btn.hidden = YES;
        
        [btn addTarget:self action:@selector(left_close_button_event:) forControlEvents:UIControlEventTouchUpInside];
        
        _closeBtn = btn;
    }
    return _closeBtn;
}

- (void)leftButtonEvent:(UIButton *)sender navigationBar:(LMJNavigationBar *)navigationBar
{
    [self backBtnClick:sender webView:self.webView];
}

- (void)left_close_button_event:(UIButton *)sender
{
    [self closeBtnClick:sender webView:self.webView];
}




#pragma mark - LMJWebViewControllerDelegate, LMJWebViewControllerDataSource
- (BOOL)isNeedProgressIndicator
{
    return YES;
}

- (BOOL)isNeedAutoTitle
{
    return YES;
}

- (void)backBtnClick:(UIButton *)backBtn webView:(WKWebView *)webView
{
    if (self.webView.canGoBack) {
        
        self.closeBtn.hidden = NO;
        
        [self.webView goBack];
        
    }else
    {
        [self closeBtnClick:self.closeBtn webView:self.webView];
    }
}

- (void)closeBtnClick:(UIButton *)closeBtn webView:(WKWebView *)webView
{
    // 判断两种情况: push 和 present
    if ((self.navigationController.presentedViewController || self.navigationController.presentingViewController) && self.navigationController.childViewControllers.count == 1) {
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}


#pragma mark - webDelegate

// 1, 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    LMJLog(@"decidePolicyForNavigationAction   ====    %@", navigationAction);
    decisionHandler(WKNavigationActionPolicyAllow);
    
}

// 2开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    
    LMJLog(@"didStartProvisionalNavigation   ====    %@", navigation);
    
}


// 4, 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    
    LMJLog(@"decidePolicyForNavigationResponse   ====    %@", navigationResponse);
    decisionHandler(WKNavigationResponsePolicyAllow);
    
}

// 5,内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation {
    
    LMJLog(@"didCommitNavigation   ====    %@", navigation);
}

// 3, 6, 加载 HTTPS 的链接，需要权限认证时调用  \  如果 HTTPS 是用的证书在信任列表中这不要此代理方法
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler {
    
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        if ([challenge previousFailureCount] == 0) {
            
            NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
            completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
        } else {
            
            completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
        }
    } else {
        
        completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
    }
}

// 7页面加载完调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    
    LMJLog(@"didFinishNavigation   ====    %@", navigation);
    
}

// 8页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    
    LMJLog(@"didFailProvisionalNavigation   ====    %@\nerror   ====   %@", navigation, error);
    
    [SVProgressHUD showErrorWithStatus:@"网页加载失败"];
}


#pragma mark - 懒加载

- (WKWebView *)webView
{
    if(_webView == nil)
    {
        //初始化一个WKWebViewConfiguration对象
        WKWebViewConfiguration *config = [WKWebViewConfiguration new];
        //初始化偏好设置属性：preferences
        config.preferences = [WKPreferences new];
        //The minimum font size in points default is 0;
        config.preferences.minimumFontSize = 0;
        //是否支持JavaScript
        config.preferences.javaScriptEnabled = YES;
        //不通过用户交互，是否可以打开窗口
        config.preferences.javaScriptCanOpenWindowsAutomatically = YES;
        // 检测各种特殊的字符串：比如电话、网站
//                config.dataDetectorTypes = UIDataDetectorTypeAll;
        // 播放视频
        config.allowsInlineMediaPlayback = YES;

        
        WKWebView *webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:config];
        
        webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        webView.navigationDelegate = self;
        webView.UIDelegate = self;
        
        webView.opaque = NO;
        webView.backgroundColor = [UIColor clearColor];
        
        //滑动返回看这里
        webView.allowsBackForwardNavigationGestures = YES;
        
        [self.view addSubview:webView];
        
        
        if ([self.parentViewController isKindOfClass:[UINavigationController class]]) {
            webView.scrollView.contentInset  = UIEdgeInsetsMake(64.0, 0, 0, 0);
            webView.scrollView.scrollIndicatorInsets = webView.scrollView.contentInset;
        }
        
        _webView = webView;
    }
    return _webView;
}


- (UIProgressView *)progressView
{
    if(_progressView == nil && [self.parentViewController isKindOfClass:[UINavigationController class]])
    {
        UIProgressView *progressView = [[UIProgressView alloc] init];
        
        [self.view addSubview:progressView];
        
        _progressView = progressView;
        
        progressView.height = 1;
        
        progressView.width = Main_Screen_Width;
        
        progressView.top = 64.0;
        progressView.tintColor = [UIColor greenColor];
        
        if ([self respondsToSelector:@selector(isNeedProgressIndicator)]) {
            
            if (![self isNeedProgressIndicator]) {
                progressView.hidden = YES;
            }
            
        }
        
    }
    return _progressView;
}

- (void)dealloc
{
    LMJLog(@"LMJWebViewController -- dealloc");
    
    [self.webView removeObserverBlocks];
    
    self.webView.UIDelegate = nil;
    self.webView.navigationDelegate = nil;
}


@end








