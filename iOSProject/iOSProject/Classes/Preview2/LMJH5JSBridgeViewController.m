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
    
    
    NSString *htmlPath = [@"JSBridge_js" stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.html", NSStringFromClass([self class])]];
    
    NSURL *fileUrl = [[NSBundle mainBundle] URLForResource:htmlPath withExtension:nil];
    
    NSURL *jsCssSorceUrl = [[NSBundle mainBundle] URLForResource:[htmlPath pathComponents].firstObject withExtension:nil];
    
    [self.webView loadFileURL:fileUrl allowingReadAccessToURL:jsCssSorceUrl];
    
    [self addData];
    
    LMJWeak(self);
    [self.jsBridge registerHandler:@"alertToast" handle:^(id data, void (^responseCallBack)(id responseData)) {
        [weakself.view makeToast:data duration:3 position:CSToastPositionCenter];
    }];
    
    self.webView.lmj_height = self.view.lmj_height * 0.7;
    self.view.backgroundColor = [UIColor greenColor];
    
    UIButton *btn = [UIButton initWithFrame:CGRectMake(0, self.view.lmj_height * 0.8, kScreenWidth, 44) buttonTitle:@"oc 调用 js 注册的方法" normalBGColor:[UIColor whiteColor] selectBGColor:[UIColor redColor] normalColor:[UIColor blackColor] selectColor:[UIColor greenColor] buttonFont:[UIFont boldSystemFontOfSize:17] cornerRadius:5 doneBlock:^(UIButton *btn) {
        [weakself callJS];
    }];
    
    [self.view addSubview:btn];

//    <script type="text/javascript" src="./H5Bridge.js"></script>
    // js 引入的第二种方式, 第一种方式是H5 页面直接引入
//    NSString *jsbridge_js = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"JSBridge_js/H5Bridge.js" ofType:nil] encoding:NSUTF8StringEncoding error:nil];
//    WKUserScript *userJs = [[WKUserScript alloc] initWithSource:jsbridge_js injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:NO];
//    [self.webView.configuration.userContentController addUserScript:userJs];
}

- (void)addData
{
    [[NSUserDefaults standardUserDefaults] setObject:@"我是存在偏好设置里边value" forKey:@"sesstionId"];
}

- (void)callJS
{
    [self.webView.scrollView scrollToTop];
    static int i = 0;
    i+=2;
    LMJWeak(self);
    [self.jsBridge callHandler:@"insertContent" data:[NSString stringWithFormat:@"我是oc调用js传给js的内容, 内容: %d", i] responseCallback:^(id responseData) {
        NSLog(@"%@", responseData);
        [weakself.view makeToast:responseData duration:3 position:CSToastPositionCenter];
    }];
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

- (void)dealloc {
    _jsBridge = nil;
}

@end
