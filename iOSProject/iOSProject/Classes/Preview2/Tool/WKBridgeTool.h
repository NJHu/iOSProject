//
//  WKBridgeTool.h
//  iOSProject
//
//  Created by HuXuPeng on 2018/3/17.
//  Copyright © 2018年 github.com/njhu. All rights reserved.
//

#import <Foundation/Foundation.h>
#define kProtocolScheme    @"njhu"
#define kReturnMessage     @"__return_message__"
#define kInitAppMessage    @"__init_app__"
#define kStartPageMessage   @"startpage"
#define kStartActionMessage @"startaction"
#define kGetMessage         @"get"
#define kSetMessage         @"set"
#define kCloseMessage       @"close"
#define kSplit @"_:_"


@class WKWebViewJsBridge;

@interface WKBridgeTool : NSObject

/**
 注册一些基本事件

 调用app原生页面
 调用app原生功能或事件（app原生类的静态方法
 获取app本地存储的数据, keys为要获取数据数组key： ["username", "password"]
 保存数据到app原生, data 为要保存到app本地的数据： {"username":"xxx", "password":"xxx"}
 关闭h5
 */
+ (void)bridgeRegisterDefault:(WKWebViewJsBridge *)bridge;

+ (BOOL)isWebViewJavascriptBridgeURL:(NSURL *)url;

/**
给 H5 发送消息
 */

+ (NSString *)returnMsg;

+ (void)dispatchMsgToh5:(NSDictionary *)responseMsg webView:(WKWebView *)webView;

+ (NSString *)returnMsg:(NSString *)msg;

+ (NSString *)returnMsg:(NSString *)msg msg2:(NSString *)msg2;

- (NSString *)returnMsg;

- (NSString *)returnMsg:(NSString *)msg;

- (NSString *)returnMsg:(NSString *)msg msg2:(NSString *)msg2;

@end
