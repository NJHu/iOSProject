//
//  NSMutableURLRequest+Upload.m
//  UploadExamples
//
//  Created by 刘凡 on 15/1/31.
//  Copyright (c) 2015年 joyios. All rights reserved.
//

#import "NSMutableURLRequest+Upload.h"

@implementation NSMutableURLRequest (Upload)

+ (instancetype)requestWithURL:(NSURL *)URL fileURL:(NSURL *)fileURL name:(NSString *)name {
    return [self requestWithURL:URL fileURLs:@[fileURL] name:name];
}

+ (instancetype)requestWithURL:(NSURL *)URL fileURL:(NSURL *)fileURL fileName:(NSString *)fileName name:(NSString *)name {
    return [self requestWithURL:URL fileURLs:@[fileURL] fileNames:@[fileName] name:name];
}

+ (instancetype)requestWithURL:(NSURL *)URL fileURLs:(NSArray *)fileURLs name:(NSString *)name {
    
    NSMutableArray *fileNames = [NSMutableArray arrayWithCapacity:fileURLs.count];
    [fileURLs enumerateObjectsUsingBlock:^(NSURL *fileURL, NSUInteger idx, BOOL *stop) {
        [fileNames addObject:fileURL.path.lastPathComponent];
    }];
    
    return [self requestWithURL:URL fileURLs:fileURLs fileNames:fileNames name:name];
}

+ (instancetype)requestWithURL:(NSURL *)URL fileURLs:(NSArray *)fileURLs fileNames:(NSArray *)fileNames name:(NSString *)name {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    
    request.HTTPMethod = @"POST";
    
    NSMutableData *data = [NSMutableData data];
    NSString *boundary = multipartFormBoundary();
    
    if (fileURLs.count > 1) {
        name = [name stringByAppendingString:@"[]"];
    }
    
    [fileURLs enumerateObjectsUsingBlock:^(NSURL *fileURL, NSUInteger idx, BOOL *stop) {
        NSString *bodyStr = [NSString stringWithFormat:@"\n--%@\n", boundary];
        [data appendData:[bodyStr dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSString *fileName = fileNames[idx];
        bodyStr = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\" \n", name, fileName];
        [data appendData:[bodyStr dataUsingEncoding:NSUTF8StringEncoding]];
        [data appendData:[@"Content-Type: application/octet-stream\n\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        [data appendData:[NSData dataWithContentsOfURL:fileURL]];
        
        [data appendData:[@"\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }];
    
    NSString *tailStr = [NSString stringWithFormat:@"--%@--\n", boundary];
    [data appendData:[tailStr dataUsingEncoding:NSUTF8StringEncoding]];
    
    request.HTTPBody = data;
    
    NSString *headerString = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request setValue:headerString forHTTPHeaderField:@"Content-Type"];
    
    return request;
}

static NSString * multipartFormBoundary() {
    return [NSString stringWithFormat:@"Boundary+%08X%08X", arc4random(), arc4random()];
}

@end