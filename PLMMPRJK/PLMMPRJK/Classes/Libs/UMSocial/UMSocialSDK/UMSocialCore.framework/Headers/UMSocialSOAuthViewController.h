//
//  UMSocialSOAuthViewController.h
//  UMSocialSDK
//
//  Created by wangfei on 16/8/15.
//  Copyright © 2016年 dongjianxiong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UMSBaeViewController.h"

#import "UMSocialPlatformConfig.h"

@interface UMSocialSOAuthViewController : UMSBaeViewController<UIWebViewDelegate,UIAlertViewDelegate>

@property (nonatomic,strong)  UIWebView *webView;

@property(nonatomic,assign) UMSocialPlatformType platformType;

@property (nonatomic, copy) UMSocialRequestCompletionHandler authCompletionBlock;

@property (nonatomic,strong) NSString* waitUrl;

@end
