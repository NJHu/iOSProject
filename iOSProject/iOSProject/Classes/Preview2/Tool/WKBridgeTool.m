//
//  WKBridgeTool.m
//  iOSProject
//
//  Created by HuXuPeng on 2018/3/17.
//  Copyright © 2018年 github.com/njhu. All rights reserved.
//


#import "WKWebViewJsBridge.h"
#import "WKBridgeTool.h"
#import <ZFPlayer/UIWindow+CurrentViewController.h>
#import <NSObject+YYAdd.h>

@implementation WKBridgeTool

+ (void)receiveActionURL:(NSURL *)actionURL {
    
}

+ (BOOL)isWebViewJavascriptBridgeURL:(NSURL *)url {
    return [url.scheme.lowercaseString isEqualToString:kProtocolScheme];
}

+ (void)bridgeRegisterDefault:(WKWebViewJsBridge *)bridge {
    
    
    //启动页面
    [bridge registerHandler:kStartPageMessage handle:^void(id data, void (^responseCallback)(id responseData)) {
        [WKBridgeTool handlerPage:data callback:responseCallback];
    }];
    
    //调用方法
    [bridge registerHandler:kStartActionMessage handle:^(id data, void (^responseCallback)(id responseData)) {
        [WKBridgeTool handlerAction:data callback:responseCallback];
    }];
    //获取数据
    [bridge registerHandler:kGetMessage handle:^(id data, void (^responseCallback)(id responseData)) {
        if (![data isKindOfClass:NSArray.class]) {
            return;
        }
        NSArray *arr = data;
        if (LMJIsEmpty(arr)) {
            responseCallback(@{});
            return;
        }
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        for (NSString *key in arr) {
            id value = [[NSUserDefaults standardUserDefaults] objectForKey:key];
            if (value) {
                dict[key] = value;
            }
        }
        
        // 回调给 H5
        !responseCallback ?: responseCallback(dict);
    }];
    //保存数据
    [bridge registerHandler:kSetMessage handle:^(id data, void (^responseCallback)(id responseData)) {
        if (![data isKindOfClass:NSDictionary.class]) {
            return;
        }
        NSDictionary *dict = data;
        [dict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [[NSUserDefaults standardUserDefaults] setObject:obj forKey:key];
        }];
        
        !responseCallback ?: responseCallback(dict);
    }];
    
    
    LMJWeak(bridge);
    //关闭当前h5
    [bridge registerHandler:kCloseMessage handle:^(id data, void (^responseCallback)(id responseData)) {
        UIViewController *con = [weakbridge.webView viewController];
        
        // 判断两种情况: push 和 present
        if ((con.navigationController.presentedViewController || con.navigationController.presentingViewController) && con.navigationController.childViewControllers.count == 1) {
            
            [con dismissViewControllerAnimated:YES completion:nil];
            
        }else{
            [con.navigationController popViewControllerAnimated:YES];
        }
        
        !responseCallback ?: responseCallback(nil);
    }];
}


/*
 data: {
     pageName: {
     ios: 'iospagename',
     Android: 'Androidpagename'
     }
    //valueType 兼容安卓
     setPageData: {
        key: {value:value, valueType: type},
        key: {value:value, valueType: type},
     }
    startType: 'present/push'
 }
 */

+ (void) handlerPage:(id)data callback:(void(^)(id responseData))callback {
    if (![data isKindOfClass:NSDictionary.class]) {
        return;
    }
    NSString *pageName = data[@"pageName"][@"ios"];
    if (LMJIsEmpty(pageName)) {
        return;
    }
    @try {
        
        Class clazz = NSClassFromString(pageName);
        UIViewController *viewController = [[clazz alloc] init];
        if (![viewController isKindOfClass:[UIViewController class]]) {
            return;
        }
        
        NSMutableDictionary *pageData = [NSMutableDictionary dictionaryWithDictionary:data[@"setPageData"]];
        
        if (!LMJIsEmpty(pageData)) {
            UIViewController *setValueVC = viewController;
            
            if ([viewController isKindOfClass:UINavigationController.class]) {
                setValueVC = viewController.childViewControllers.firstObject;
            }
            
            [pageData enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                [setValueVC setValue:obj[@"value"] forKey:key];
            }];
        }
        
        
            NSString *startType = data[@"startType"];
            
            if ([viewController isKindOfClass:UINavigationController.class] || [startType isEqualToString:@"present"]) {
                [UIWindow.zf_currentViewController presentViewController:viewController animated:YES completion:nil];
            }else {
                
                UINavigationController *navVc = (UINavigationController *)UIWindow.zf_currentViewController;
                if (![navVc isKindOfClass:[UINavigationController class]]) {
                    navVc = navVc.navigationController;
                }
                if (navVc && [navVc isKindOfClass:[UINavigationController class]]) {
                    [navVc pushViewController:viewController animated:YES];
                }
            }
        
        if (callback) {
            callback(nil);
        }
    } @catch (NSException *exception) {
        NSLog(@"%@: %@", exception.name, exception.reason);
    }
}


+ (void)handlerAction:(id)data callback:(void(^)(id responseData))callback {
    

//    3、调用app原生静态方法或单例类方法 （工具类 或 静态功能方法， 只支持参数为 '基本数据类型'、'字符串' 的方法）
    //调用所需要的数据， 具体属性的值怎么写由app开发人员提供
//    var actionData = {
//        "action" : {
//            "ios" : "ios的类名_:_构造方法_:_执行的方法名",
//            "android" : "android全类名_:_构造方法_:_执行的方法名"
//        },
//        "data" : [ //可选参数，调用方法所需要的数据, 或为  {"android":[], "ios":[]}
//                  "value1",
//                  "value2"
//                  ]
//    };
//    //调用原生方法
//    app.startAction(actionData, function(data) {
//        //app执行完后的回调，data为执行原生方法的返回值
//    });
    
    if (![data isKindOfClass:NSDictionary.class]) {
        return;
    }
    NSDictionary *actionData = data;
    NSString *action = actionData[@"action"][@"ios"];
    if (LMJIsEmpty(action)) {
        return;
    }
    
    NSArray<NSString *> *calssInits = [action componentsSeparatedByString:kSplit];
    
    NSString *className = nil;
    NSString *init = nil;
    NSString *sel = nil;
    
    if (calssInits.count < 2) {
        return;
    }
    className = calssInits[0];
    if (calssInits.count == 2) {
        sel = calssInits[1];
    }
    if (calssInits.count == 3) {
        init = calssInits[1];
        sel = calssInits[2];
    }
    
    Class class = NSClassFromString(className);
    if (!class) {
        return;
    }
    
    id obj = class;
    if (!LMJIsEmpty(init)) {
        if ([@"()" isEqualToString:init]) {
            obj = [[class alloc] init];
        }else if ([class respondsToSelector:NSSelectorFromString(init)]) {
            
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            
            obj = [class performSelector:NSSelectorFromString(init)];
            
        }else {
            return;
        }
    }
    
    SEL method = NSSelectorFromString(sel);
    if (![obj respondsToSelector:method]) {
        return;
    }

    @try {
        id result;
        NSArray *args = actionData[@"data"];
        if (!LMJIsEmpty(args)) {
            if (args.count == 1) {
                result = [obj performSelector:method withObject:args[0]];
            }else if (args.count == 2) {
                result = [obj performSelector:method withObject:args[0] withObject:args[1]];
            }
        } else {
            result = [obj performSelector:method];
        }
        
        #pragma clang diagnostic pop
        
        !callback ?: callback(result);
    } @catch (NSException *exception) {
        NSLog(@"%@", exception);
    } @finally {
    }
}


+ (void)dispatchMsgToh5:(NSDictionary *)responseMsg webView:(WKWebView *)webView {
    
    NSString *messageJSON = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:responseMsg options:0 error:nil] encoding:NSUTF8StringEncoding];
    
    messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\\" withString:@"\\\\"];
    messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\'" withString:@"\\\'"];
    messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"];
    messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\r" withString:@"\\r"];
    messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\f" withString:@"\\f"];
    messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\u2028" withString:@"\\u2028"];
    messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\u2029" withString:@"\\u2029"];
    
    NSString *javascriptCommand = [NSString stringWithFormat:@"app._dispatchMessageFromApp('%@')", messageJSON];
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [webView evaluateJavaScript:javascriptCommand completionHandler:^(id _Nullable result, NSError * _Nullable error) {
            
            NSLog(@"%@", result);
        }];
    });
}

+ (NSString *)returnMsg {
   return [NSString stringWithFormat:@"我是类方法"];
}

+ (NSString *)returnMsg:(NSString *)msg {
    return [NSString stringWithFormat:@"我是类方法: %@", msg];
}

+ (NSString *)returnMsg:(NSString *)msg msg2:(NSString *)msg2 {
    return [NSString stringWithFormat:@"我是类多参数方法: %@,,%@", msg, msg2];
}

- (NSString *)returnMsg {
    return [NSString stringWithFormat:@"我是对象方法"];
}

- (NSString *)returnMsg:(NSString *)msg {
    return [NSString stringWithFormat:@"我是对象方法: %@", msg];
}

- (NSString *)returnMsg:(NSString *)msg msg2:(NSString *)msg2 {
    return [NSString stringWithFormat:@"我是对象多参数方法: %@,,%@", msg, msg2];
}

@end




