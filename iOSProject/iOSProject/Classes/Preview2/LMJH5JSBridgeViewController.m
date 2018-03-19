//
//  LMJH5JSBridgeViewController.m
//  iOSProject
//
//  Created by HuXuPeng on 2018/3/17.
//  Copyright © 2018年 github.com/njhu. All rights reserved.
//

#import "LMJH5JSBridgeViewController.h"
#import "WKWebViewJsBridge.h"

@interface LMJH5JSBridgeViewController ()
/** <#digest#> */
@property (nonatomic, strong) WKWebViewJsBridge *jsBridge;
@end

@implementation LMJH5JSBridgeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.jsBridge = [[WKWebViewJsBridge alloc] initWithWebView:self.webView delegate:self];
    
    NSURL *fileUrl = [[NSBundle mainBundle] URLForResource:NSStringFromClass([self class]) withExtension:@"html"];
    NSURL *jsCssSorceUrl = [NSURL URLWithString: [[[NSBundle mainBundle] URLForResource:NSStringFromClass([self class]) withExtension:@"html"].absoluteString stringByReplacingOccurrencesOfString:@"LMJH5JSBridgeViewController.html" withString:@""]];
    
    [self.webView loadFileURL:fileUrl allowingReadAccessToURL:jsCssSorceUrl];
    
    [self addData];
    
    LMJWeakSelf(self);
    [self.jsBridge registerHandler:@"alertToast" handle:^(id data, void (^responseCallBack)(id responseData)) {
        [weakself.view makeToast:data duration:3 position:CSToastPositionCenter];
    }];
    
//    self.webView.lmj_height = self.view.lmj_height * 0.6;
//    self.view.backgroundColor = [UIColor yellowColor];
}

- (void)addData
{
    [[NSUserDefaults standardUserDefaults] setObject:@"我是存在偏好设置里边value" forKey:@"sesstionId"];
    
}

#pragma mark - LMJNavUIBaseViewControllerDataSource

/** 导航条右边的按钮 */
- (UIImage *)lmjNavigationBarRightButtonImage:(UIButton *)rightButton navigationBar:(LMJNavigationBar *)navigationBar
{
    [rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightButton setTitle:@"OC调JS注册的方法" forState:UIControlStateNormal];
    [rightButton sizeToFit];
    rightButton.height = 44;
    return nil;
}


/** 右边的按钮的点击 */
-(void)rightButtonEvent:(UIButton *)sender navigationBar:(LMJNavigationBar *)navigationBar
{
    
}


@end
