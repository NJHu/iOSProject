//
//  MCLocalHTMLViewController.m
//  iOSProject
//
//  Created by HuXuPeng on 2018/1/24.
//  Copyright © 2018年 github.com/njhu. All rights reserved.
//

#import "MCLocalHTMLViewController.h"

@interface MCLocalHTMLViewController ()

@end

@implementation MCLocalHTMLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 加载本地 html 并包含 js 要建立实体文件夹
    [self.webView loadRequest:[NSURLRequest requestWithURL:[[NSBundle mainBundle] URLForResource:@"adm/index.html" withExtension:nil]]];
    self.webView.allowsBackForwardNavigationGestures = NO;
}

@end
