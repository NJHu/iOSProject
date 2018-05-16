//
//  SINUserManager.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/6/20.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "SINUserManager.h"
//#import <HMEmoticonManager.h>
#import "LMJUMengHelper.h"

@interface SINUserManager ()

@end

@implementation SINUserManager

- (BOOL)isLogined {
    if (!self.accessToken) {
        return NO;
    }
    if (!self.expiration || [self.expiration compare:[NSDate date]] != NSOrderedDescending) {
        return NO;
    }
    return YES;
}

// 登录新浪
- (void)sinaLogin:(void(^)(NSError *error))completion
{
    [LMJUMengHelper getUserInfoForPlatform:UMSocialPlatformType_Sina completion:^(UMSocialUserInfoResponse *result, NSError *error) {
        if (error) {
            NSLog(@"%@", error);
            completion(error);
            return ;
        }
        NSLog(@"%@", result.uid);
        NSLog(@"%@", result.openid);
        NSLog(@"%@", result.refreshToken);
        NSLog(@"%@", result.expiration);
        NSLog(@"%@", result.accessToken);
        NSLog(@"%@", result.iconurl);
        NSLog(@"%@", result.name);
        NSLog(@"%@", result.originalResponse);
        
        self.name = result.name;
        self.expiration = result.expiration;
        self.accessToken = result.accessToken;
        self.iconurl = result.iconurl;
        self.uid = result.uid;
        
//        [HMEmoticonManager sharedManager].userIdentifier = self.uid;
        
        [self saveToFile];
        completion(nil);
    }];
}


- (void)saveToFile
{
    [NSKeyedArchiver archiveRootObject:self toFile:[[self class] archiveFilePath]];
}

#pragma mark - mjcoding

- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        _name = [decoder decodeObjectForKey:LMJKeyPath(self, name)];
        _expiration = [decoder decodeObjectForKey:LMJKeyPath(self, expiration)];
        _accessToken = [decoder decodeObjectForKey:LMJKeyPath(self, accessToken)];
        _iconurl = [decoder decodeObjectForKey:LMJKeyPath(self, iconurl)];
        _uid = [decoder decodeObjectForKey:LMJKeyPath(self, uid)];
    }
    return self; 
} 

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.name forKey:LMJKeyPath(self, name)];
    [encoder encodeObject:self.expiration forKey:LMJKeyPath(self, expiration)];
    [encoder encodeObject:self.accessToken forKey:LMJKeyPath(self, accessToken)];
    [encoder encodeObject:self.iconurl forKey:LMJKeyPath(self, iconurl)];
    [encoder encodeObject:self.uid forKey:LMJKeyPath(self, uid)];
}



+ (NSString *)archiveFilePath
{
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject stringByAppendingString:NSStringFromClass(self)];
}


#pragma mark - 单例
- (instancetype)init
{
    self = [super init];
    if (self) {
        // 测试作者信息, 自己获取请注释
        if ([LMJThirdSDKSinaAppKey isEqualToString:@"4061770881"]) {
            _name = @"NJ影伴人久";
            _accessToken = @"2.00afSYxFZJms7Eb7fba204741DuUPB";
            _iconurl = @"https://tvax3.sinaimg.cn/crop.1.0.510.510.180/005XyiFAly8fescv0z62zj30e80e6q3o.jpg";
            _uid = @"5460642906";
            _expiration = [NSDate distantFuture];
        }
    }
    return self;
}




static id _instance = nil;
+ (instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [NSKeyedUnarchiver unarchiveObjectWithFile:[self archiveFilePath]];
        if (!_instance) {
            _instance = [[self alloc] init];
        }
    });
    
    return _instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    
    return _instance;
}

- (id)copyWithZone:(NSZone *)zone
{
    return _instance;
}

- (id)mutableCopyWithZone:(NSZone *)zone
{
    return _instance;
}


@end
