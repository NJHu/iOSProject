//
//  LMJH5_OCViewController.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/5/5.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJH5_OCViewController.h"
#import "LMJOCJSHelper.h"

@interface LMJH5_OCViewController ()<LMJOCJSHelperDelegate>
/** <#digest#> */
@property (weak, nonatomic) UIView *addRedView;

/** <#digest#> */
@property (nonatomic, strong) LMJOCJSHelper *ocjsHelper;

@end

@implementation LMJH5_OCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 获取设备 deviceID 并回显到 H5
    [self.webView.configuration.userContentController addScriptMessageHandler:self.ocjsHelper name:LMJOCJSHelperScriptMessageHandlerName1_];
    
    [self.webView loadRequest:[NSMutableURLRequest requestWithURL:[[NSBundle mainBundle] URLForResource:NSStringFromClass(self.class) withExtension:@"html"]]];
}




#pragma mark - LMJWebViewControllerDelegate
- (void)webView:(WKWebView *)webView scrollView:(UIScrollView *)scrollView contentSize:(CGSize)contentSize
{
    [super webView:webView scrollView:scrollView contentSize:contentSize];

#pragma mark - 添加红色的 View================================================
    // 添加红色的 View
    static CGFloat contentSizeHeight = 0;
    if (contentSizeHeight != contentSize.height) {
        contentSizeHeight = contentSize.height;
        self.addRedView.frame = CGRectMake(0, contentSize.height - self.addRedView.lmj_height, kScreenWidth, self.addRedView.lmj_height);
    }
}


#pragma mark - webViewDelegate

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    [super webView:webView didFinishNavigation:navigation];
    
    
#pragma mark - 添加红色的 View================================================
    // 1不能用这种方法
    //    UIEdgeInsets contentInset = self.webView.scrollView.contentInset;
    //    contentInset.bottom = self.addRedView.lmj_height;
    //    self.webView.scrollView.contentInset = contentInset;
    
    //2 使用 div
    NSString *js = [NSString stringWithFormat:@"\
                    var appendDiv = document.getElementById(\"AppAppendDIV\");\
                    if (appendDiv) {\
                    appendDiv.style.height = \"%@px\";\
                    } else {\
                    var appendDiv = document.createElement(\"div\");\
                    appendDiv.setAttribute(\"id\",\"AppAppendDIV\");\
                    appendDiv.style.width= \"%@px\";\
                    appendDiv.style.height= \"%@px\";\
                    document.body.appendChild(appendDiv);\
                    }\
                    ", @(self.addRedView.lmj_height), @(kScreenWidth), @(self.addRedView.lmj_height)];
    [self.webView evaluateJavaScript:js completionHandler:^(id value, NSError *error) {
        // 执行完上面的那段 JS, webView.scrollView.contentSize.height 的高度已经是加上 div 的高度
        self.addRedView.frame = CGRectMake(0, self.webView.scrollView.contentSize.height - self.addRedView.lmj_height, kScreenWidth, self.addRedView.lmj_height);
    }];
    //==========================================================================
}


#pragma mark - UIDelegate
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{
    NSLog(@"%@", frame);
    
    [UIAlertController mj_showAlertWithTitle:@"Alert" message:message appearanceProcess:^(JXTAlertController * _Nonnull alertMaker) {
        
        alertMaker.addActionDestructiveTitle(@"confirm");
    } actionsBlock:^(NSInteger buttonIndex, UIAlertAction * _Nonnull action, JXTAlertController * _Nonnull alertSelf) {
        completionHandler();
    }];
}
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler
{
    NSLog(@"%@", frame);

    [UIAlertController mj_showAlertWithTitle:@"Alert" message:message appearanceProcess:^(JXTAlertController * _Nonnull alertMaker) {
        
        alertMaker.addActionDestructiveTitle(@"cancel").addActionDefaultTitle(@"confirm");
    } actionsBlock:^(NSInteger buttonIndex, UIAlertAction * _Nonnull action, JXTAlertController * _Nonnull alertSelf) {
        
        if (buttonIndex == 0) {
            completionHandler(NO);
        }else {
            completionHandler(YES);
        }
    }];
}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable result))completionHandler
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"输入框" message:prompt preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
        textField.textColor = [UIColor blackColor];
        textField.placeholder = defaultText;
        
    }];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        completionHandler([[alert.textFields lastObject] text]);
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        completionHandler(nil);
        
    }]];
    [self presentViewController:alert animated:YES completion:NULL];
}


#pragma mark - LMJOCJSHelperDelegate




#pragma mark - getter

- (UIView *)addRedView
{
    if(_addRedView == nil)
    {
        UIView *addRedView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 500)];
        [self.webView.scrollView insertSubview:addRedView atIndex:0];
        _addRedView = addRedView;
        
        UILabel *addCenterView = [[UILabel alloc] initWithFrame:CGRectMake(50, 100, 300, 100)];
        addCenterView.text = @"红色和绿色 是 添加的 Views";
        
        addCenterView.backgroundColor =  [UIColor greenColor];
        [addRedView addSubview:addCenterView];
        
        addRedView.backgroundColor = [UIColor redColor];
        
    }
    return _addRedView;
}

- (LMJOCJSHelper *)ocjsHelper
{
    if(_ocjsHelper == nil)
    {
        _ocjsHelper = [[LMJOCJSHelper alloc] init];
        _ocjsHelper.delegate = self;
        _ocjsHelper.webView = self.webView;
    }
    return _ocjsHelper;
}

- (void)dealloc
{
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:LMJOCJSHelperScriptMessageHandlerName1_];
}

@end
