//
//  main.m
//  PLMMPRJK
//
//  Created by NJHu on 2017/3/29.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMJAppDelegate.h"

void UncaughtExceptionHandler(NSException *exception);

int main(int argc, char * argv[]) {
    @autoreleasepool {
        
        @try {
            
            return UIApplicationMain(argc, argv, nil, NSStringFromClass([LMJAppDelegate class]));
            
        } @catch (NSException *exception) {
            
            UncaughtExceptionHandler(exception);
            
            
        } @finally {
            
//            [[NSRunLoop currentRunLoop] runUntilDate:[NSDate distantFuture]];
            
        }
        
        
        
        
    }
}


// 设置一个C函数，用来接收崩溃信息
void UncaughtExceptionHandler(NSException *exception) {
    // 可以通过exception对象获取一些崩溃信息，我们就是通过这些崩溃信息来进行解析的，例如下面的symbols数组就是我们的崩溃堆栈。
    NSArray *symbols = [exception callStackSymbols];
    NSString *reason = [exception reason];
    NSString *name = [exception name];
    
    NSMutableDictionary *dictM = [NSMutableDictionary dictionaryWithContentsOfFile:[[NSFileManager cachesPath] stringByAppendingPathComponent:@"zplan_crash.plist"]];
    
    if (!dictM) {
        dictM = [NSMutableDictionary dictionary];
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmssSSS";
    NSString *timestamp = [formatter stringFromDate:[NSDate date]];
    
    
    NSDictionary *dict = @{
                           
                           timestamp : @{
                                   
                                   [timestamp stringByAppendingString:@"name"] : name,
                                   
                                   [timestamp stringByAppendingString:@"_reason"] : reason,
                                   [timestamp stringByAppendingString:@"__symbols"] : symbols
                                   
                                   }
                           
                           };
    
    
    [dictM setValuesForKeysWithDictionary:dict];
    
    [dictM writeToFile:[[NSFileManager cachesPath] stringByAppendingPathComponent:@"zplan_crash.plist"] atomically:YES];
    
}
