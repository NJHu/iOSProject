//
//  NetWorkBaseUrlConfig.m
//  MobileProject
//
//  Created by wujunyang on 16/1/5.
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#import "NetWorkBaseUrlConfig.h"

static NSString *const developer = @"developer";
static NSString *const product = @"product";

static NSString *const ACCOUNT_SERVERCENTER_Key=@"ACCOUNT_SERVERCENTER";
static NSString *const PICTURE_SERVERCENTER_key=@"PICTURE_SERVERCENTER";
static NSString *const BUSINESSLOGIC_SERVERCENTER_key=@"BUSINESSLOGIC_SERVERCENTER";
static NSString *const UPDATEVERSION_SERVERCENTER_key=@"UPDATEVERSION_SERVERCENTER";

@interface NetWorkBaseUrlConfig()
@property(nonatomic ,assign) SERVERCENTER_TYPE netType;
@property(nonatomic ,strong) NSMutableDictionary *configDictionary;
//开发测试环境
@property(nonatomic ,strong) NSDictionary *develpoerDictionary;
//产品环境
@property(nonatomic ,strong) NSDictionary *productDictionary;
@end

@implementation NetWorkBaseUrlConfig

+(instancetype)shareconfig
{
    static id share;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        share = [[NetWorkBaseUrlConfig alloc] init];
    });
    
    return share;
}

-(id)init
{
    if (self = [super init]) {
        //测试环境
        self.develpoerDictionary=@{ACCOUNT_SERVERCENTER_Key:@"http://private-eda6s5-mocks.com/",PICTURE_SERVERCENTER_key:@"http://baidu.com/image-service/",BUSINESSLOGIC_SERVERCENTER_key:@"业务逻辑前缀",UPDATEVERSION_SERVERCENTER_key:@"版本升级前缀"};
        //产品环境
        self.productDictionary=@{ACCOUNT_SERVERCENTER_Key:@"http://private-eda66-mock.com/",PICTURE_SERVERCENTER_key:@"http://baidues.com/",BUSINESSLOGIC_SERVERCENTER_key:@"业务逻辑前缀",UPDATEVERSION_SERVERCENTER_key:@"版本升级前缀"};
        
        self.configDictionary = [NSMutableDictionary dictionary];
        [self.configDictionary setObject:self.develpoerDictionary forKey:developer];
        [self.configDictionary setObject:self.productDictionary forKey:product];
    }
    return self;
}

-(NSString*)urlWithCenterType:(SERVERCENTER_TYPE)type
{
    NSString *urlResult=@"";
    NSString *validEnvironment = @"";
    
    //过滤不同Tag
    #ifdef LOCAL
    validEnvironment=developer;
    #else
    validEnvironment=product;
    #endif
    
    NSString *urlKey = @"";
    switch (type) {
        case ACCOUNT_SERVERCENTER:
            urlKey = ACCOUNT_SERVERCENTER_Key;
            break;
        case PICTURE_SERVERCENTER:
            urlKey = PICTURE_SERVERCENTER_key;
            break;
        case BUSINESSLOGIC_SERVERCENTER:
            urlKey = BUSINESSLOGIC_SERVERCENTER_key;
            break;
        case UPDATEVERSION_SERVERCENTER:
            urlKey = UPDATEVERSION_SERVERCENTER_key;
            break;
        default:
            break;
    }
    urlResult = self.configDictionary[validEnvironment][urlKey];
    return urlResult;
}

@end
