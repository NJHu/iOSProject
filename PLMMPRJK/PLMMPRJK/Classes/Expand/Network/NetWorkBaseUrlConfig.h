//
//  NetWorkBaseUrlConfig.h
//  MobileProject 对前缀公共部分进行处理
//
//  Created by wujunyang on 16/1/5.
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetWorkEnvironment.h"

@interface NetWorkBaseUrlConfig : NSObject

@property(nonatomic ,readonly) SERVERCENTER_TYPE netType;

+(instancetype)shareconfig;

-(NSString*)urlWithCenterType:(SERVERCENTER_TYPE)type;

@end
