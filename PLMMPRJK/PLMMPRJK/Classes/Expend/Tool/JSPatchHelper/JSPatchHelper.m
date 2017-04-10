//
//  JSPatchHelper.m
//  MobileProject
//
//  Created by wujunyang on 16/6/13.
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#import "JSPatchHelper.h"

//文件名称
static NSString * const jsPatchJsFileName=@"main.js";

@implementation JSPatchHelper

+ (instancetype)sharedInstance
{
    static JSPatchHelper* instance = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [JSPatchHelper new];
    });

    return instance;
}


+(void)HSDevaluateScript
{
    //从本地获取下载的JS文件
    NSURL *p = FilePath;
    
    //判断文件是否存在
    NSString *curFilePath=[p.path stringByAppendingString:[NSString stringWithFormat:@"/%@",jsPatchJsFileName]];
    if (![[NSFileManager defaultManager] fileExistsAtPath:curFilePath]) {
        return;
    }
    
    //获取内容
    NSString *js = [NSString stringWithContentsOfFile:curFilePath encoding:NSUTF8StringEncoding error:nil];
    
    //如果有内容
    if (js.length > 0)
    {
        //-------
        //服务端要对JS内容进行加密，在此处解密js内容；增加安全性
        //----
        
        
        //运行
        [JPEngine startEngine];
        [JPEngine evaluateScript:js];
    }
}


+(void)loadJSPatch
{
    //优化间隔一段时间 再去请求一次 否则太频繁(这边定义为一个小时才去请求一次)
    NSDate *myNowDate=[NSDate date];
    if (!BBUserDefault.MBJsPatchTime) {
        BBUserDefault.MBJsPatchTime=myNowDate;
    }
    NSLog(@"%@",BBUserDefault.MBJsPatchTime);
    if ([myNowDate timeIntervalSinceDate:BBUserDefault.MBJsPatchTime]<3600) {
        return;
    }
    
    //重新赋值
    BBUserDefault.MBJsPatchTime=myNowDate;
    
    
    //使用AFNetWork下载在服务器的js文件
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSURL *URL = [NSURL URLWithString:kJSPatchServerPath];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response)
                                              {
                                                  NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
                                                  if (httpResponse.statusCode==200) {
                                                      NSURL *documentsDirectoryURL = FilePath;
                                                      //保存到本地 Library/Caches目录下
                                                      return [documentsDirectoryURL URLByAppendingPathComponent:jsPatchJsFileName];
                                                  }
                                                  else
                                                  {
                                                      return nil;
                                                  }
                                              }
                                                            completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error)
                                              {
                                                  NSLog(@"下载失败 to: %@", filePath);
                                              }];
    [downloadTask resume];
}


@end
