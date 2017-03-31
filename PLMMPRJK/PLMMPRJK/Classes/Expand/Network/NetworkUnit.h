//
//  NetworkUnit.h
//  zxwTool
//
//  Created by zhuxuwei on 14-3-28.
//  Copyright (c) 2014年 zxwo0o@qq.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

#define NoErrorForDeleCartItem @"当前没有网络，请联网后再试"

////  网络类型

typedef NS_ENUM(NSInteger,NETWORK_TYPE) {
    NETWORK_TYPE_NONE= 0,
    NETWORK_TYPE_2G= 2,
    NETWORK_TYPE_3G= 3,
    NETWORK_TYPE_4G= 4,
    NETWORK_TYPE_WIFI= 10,
};

typedef void(^netStatus)(NetworkStatus netStatus);

@interface NetworkUnit : NSObject{
    
}

@property(nonatomic ,copy)netStatus netStatusBlock;
+(id)sharedInstance;
+(NETWORK_TYPE)getNetworkTypeFromStatusBar;

-(void)addObserverReachabilityChanged:(void(^)(NetworkStatus netStatus)) netStatusBlock;
-(NSInteger)delayTime:(NetworkStatus) netStatus;

@end
