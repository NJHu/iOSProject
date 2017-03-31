//
//  UIWebView+Blocks.m
//
//  Created by Shai Mishali on 1/1/13.
//  Copyright (c) 2013 Shai Mishali. All rights reserved.
//

#import "UIWebView+Blocks.h"

static void (^__loadedBlock)(UIWebView *webView);
static void (^__failureBlock)(UIWebView *webView, NSError *error);
static void (^__loadStartedBlock)(UIWebView *webView);
static BOOL (^__shouldLoadBlock)(UIWebView *webView, NSURLRequest *request, UIWebViewNavigationType navigationType);

static uint __loadedWebItems;

@implementation UIWebView (Block)

#pragma mark - UIWebView+Blocks

+(UIWebView *)loadRequest:(NSURLRequest *)request
                   loaded:(void (^)(UIWebView *webView))loadedBlock
                   failed:(void (^)(UIWebView *webView, NSError *error))failureBlock{

    return [self loadRequest:request loaded:loadedBlock failed:failureBlock loadStarted:nil shouldLoad:nil];
}

+(UIWebView *)loadHTMLString:(NSString *)htmlString
                      loaded:(void (^)(UIWebView *webView))loadedBlock
                      failed:(void (^)(UIWebView *webView, NSError *error))failureBlock{
    
    return [self loadHTMLString:htmlString loaded:loadedBlock failed:failureBlock loadStarted:nil shouldLoad:nil];
}

+(UIWebView *)loadHTMLString:(NSString *)htmlString
                      loaded:(void (^)(UIWebView *))loadedBlock
                      failed:(void (^)(UIWebView *, NSError *))failureBlock
                 loadStarted:(void (^)(UIWebView *webView))loadStartedBlock
                  shouldLoad:(BOOL (^)(UIWebView *webView, NSURLRequest *request, UIWebViewNavigationType navigationType))shouldLoadBlock{
    __loadedWebItems = 0;
    __loadedBlock = loadedBlock;
    __failureBlock = failureBlock;
    __loadStartedBlock = loadStartedBlock;
    __shouldLoadBlock = shouldLoadBlock;
    
    UIWebView *webView = [[UIWebView alloc] init];
    webView.delegate = (id)[self class];
    [webView loadHTMLString:htmlString baseURL:nil];
    
    return webView;
}

+(UIWebView *)loadRequest:(NSURLRequest *)request
                   loaded:(void (^)(UIWebView *webView))loadedBlock
                   failed:(void (^)(UIWebView *webView, NSError *error))failureBlock
              loadStarted:(void (^)(UIWebView *webView))loadStartedBlock
               shouldLoad:(BOOL (^)(UIWebView *webView, NSURLRequest *request, UIWebViewNavigationType navigationType))shouldLoadBlock{
    __loadedWebItems    = 0;
    
    __loadedBlock       = loadedBlock;
    __failureBlock      = failureBlock;
    __loadStartedBlock  = loadStartedBlock;
    __shouldLoadBlock   = shouldLoadBlock;
    
    UIWebView *webView  = [[UIWebView alloc] init];
    webView.delegate    = (id) [self class];
    
    [webView loadRequest: request];
    
    return webView;
}

#pragma mark - Private Static delegate
+(void)webViewDidFinishLoad:(UIWebView *)webView{
    __loadedWebItems--;
    
    if(__loadedBlock && (!TRUE_END_REPORT || __loadedWebItems == 0)){
        __loadedWebItems = 0;
        __loadedBlock(webView);
    }
}

+(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{    
    __loadedWebItems--;
    
    if(__failureBlock)
        __failureBlock(webView, error);
}

+(void)webViewDidStartLoad:(UIWebView *)webView{    
    __loadedWebItems++;
    
    if(__loadStartedBlock && (!TRUE_END_REPORT || __loadedWebItems > 0))
        __loadStartedBlock(webView);
}

+(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    if(__shouldLoadBlock)
        return __shouldLoadBlock(webView, request, navigationType);
    
    return YES;
}

@end
