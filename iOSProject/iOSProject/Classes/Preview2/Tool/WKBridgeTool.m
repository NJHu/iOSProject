//
//  WKBridgeTool.m
//  iOSProject
//
//  Created by HuXuPeng on 2018/3/17.
//  Copyright © 2018年 github.com/njhu. All rights reserved.
//


#import "WKWebViewJsBridge.h"
#import "WKBridgeTool.h"


@implementation WKBridgeTool

+ (void)receiveActionURL:(NSURL *)actionURL {
    
}

+ (BOOL)isWebViewJavascriptBridgeURL:(NSURL *)url {
    return [url.scheme.lowercaseString isEqualToString:kProtocolScheme];
}

+ (void)bridgeRegisterDefault:(WKWebViewJsBridge *)bridge {
    
    
    //启动页面
    [bridge registerHandler:kStartPageMessage handle:^(id data, void (^responseCallback)(id responseData)) {
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
        
        !responseCallback ?: responseCallback(nil);
    }];
    
    
    LMJWeakSelf(bridge);
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
            
            [pageData enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                pageData[key] = pageData[key][@"value"];
            }];
            
            if ([viewController isKindOfClass:UINavigationController.class]) {
                [((UINavigationController *)viewController).viewControllers.firstObject setValuesForKeysWithDictionary:pageData];
            } else {
                [viewController setValuesForKeysWithDictionary:pageData];
            }
        }
        
        
            NSString *startType = data[@"startType"];
            
            if ([viewController isKindOfClass:UINavigationController.class] || [startType isEqualToString:@"present"]) {
                [UIApplication.sharedApplication.keyWindow.currentViewController presentViewController:viewController animated:YES completion:nil];
            }else {
                
                UINavigationController *navVc = UIApplication.sharedApplication.keyWindow.currentViewController.navigationController;
                if (!navVc || ![navVc isKindOfClass:[UINavigationController class]]) {
                    navVc = (UINavigationController *)UIApplication.sharedApplication.keyWindow.topMostWindowController;
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
    
    !callback ?: callback(nil);
    NSLog(@"%@", data);
    
//    NSDictionary *dict = @{
//                           @"class" : @"className",
//                           @"classInit": @"alloc init",
////                            @"classInit": @"sharedManager"
//                           @"action": @""
//    }
//
//    if (![data isKindOfClass:NSDictionary.class]) {
//        return;
//    }
//    @try {
//        NSString *action = data[@"action"][@"ios"];
//        if (LMJIsEmpty(action)) {
//            return;
//        }
//        NSArray *arr = [action componentsSeparatedByString:split];
//        NSString *className = arr[0];
//        NSString *methodName = arr[arr.count -1];
//        NSString *instanceName = nil;
//        if (arr.count == 3) {
//            instanceName = arr[1];
//        }
//        Class class = NSClassFromString(className);
//        if (!class) {
//            return;
//        }
//
//#pragma clang diagnostic push
//#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
//        id obj = class;
//        if (e_isNotEmpty(instanceName)) {
//            if ([@"()" isEqualToString:instanceName]) {
//                obj = [[class alloc] init];
//            } else if ([class respondsToSelector:NSSelectorFromString(instanceName)]){
//                obj = [class performSelector:NSSelectorFromString(instanceName)];
//            } else {
//                return;
//            }
//        }
//        SEL method = NSSelectorFromString(methodName);
//        if (![obj respondsToSelector:method]) {
//            return;
//        }
//
//        id methodData = data[@"data"];
//        NSArray *dataArr = nil;
//        if (LMJIsEmpty(methodData)) {
//            dataArr = @[];
//        } else {
//            if ([methodData isKindOfClass:NSDictionary.class]) {
//                id iosData = methodData[@"ios"];
//                if ([iosData isKindOfClass:NSArray.class]) {
//                    dataArr = iosData;
//                } else {
//                    dataArr = @[iosData];
//                }
//            } else if ([methodData isKindOfClass:NSArray.class]){
//                dataArr = methodData;
//            }
//        }
//        // 方法签名(方法的描述)
//        NSMethodSignature *signature = [class methodSignatureForSelector:method];
//        if (!signature) {
//            signature = [class instanceMethodSignatureForSelector:method];
//        }
//        if (!signature) {
//            return;
//        }
//        // NSInvocation : 利用一个NSInvocation对象包装一次方法调用（方法调用者、方法名、方法参数、方法返回值）
//        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
//        invocation.target = obj;
//        invocation.selector = method;
//        // 设置参数
//        NSInteger paramsCount = signature.numberOfArguments - 2;
//        paramsCount = MIN(paramsCount, dataArr.count);
//        for (NSInteger i = 0; i < paramsCount; i++) {
//            id object = dataArr[i];
//            if ([object isKindOfClass:[NSNull class]]) continue;
//            [invocation setArgument:&object atIndex:i + 2];
//        }
//
//        // 调用方法
//        [invocation invoke];
//        id result = nil;
//        void *tempResultSet;
//        if (signature.methodReturnLength) {
//            [invocation getReturnValue:&tempResultSet];
//            result = (__bridge id)(tempResultSet);
//        }
//        if (result && callback) {
//            callback(result);
//        }
//    } @catch (NSException *exception) {
//        NSLog(@"%@: %@", exception.name, exception.reason);
//    }
//#pragma clang diagnostic pop
    
}


@end
