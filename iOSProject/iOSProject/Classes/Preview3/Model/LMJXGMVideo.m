//
//  LMJXGMVideo.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/5/7.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJXGMVideo.h"

@implementation LMJXGMVideo

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID" : @"id"};
}

- (void)setImage:(NSURL *)image
{
    _image = [NSURL URLWithString:[LMJXMGBaseUrl stringByAppendingPathComponent:image.absoluteString]];
}

- (void)setUrl:(NSURL *)url
{
    _url = [NSURL URLWithString:[LMJXMGBaseUrl stringByAppendingPathComponent:url.absoluteString]];
}

@end
