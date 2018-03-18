//
//  WKBridgeTool.h
//  iOSProject
//
//  Created by HuXuPeng on 2018/3/17.
//  Copyright © 2018年 github.com/njhu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kStartPageMessage   @"startPage"
#define kStartActionMessage @"startAction"
#define kGetMessage         @"get"
#define kSetMessage         @"set"
#define kCloseMessage       @"close"

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

+ (void) handlerPage:(id)data callback:(WVJBResponseCallback)callback;

+ (void)handlerAction:(id)data callback:(WVJBResponseCallback)callback;

@end
