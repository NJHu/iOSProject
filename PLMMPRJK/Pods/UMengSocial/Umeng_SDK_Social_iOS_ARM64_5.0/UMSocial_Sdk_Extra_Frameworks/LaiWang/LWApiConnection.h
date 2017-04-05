//
//  LWApiConnection.h
//  LWApiSDK
//
//  Created by Leyteris on 9/26/13.
//  Copyright (c) 2013 Laiwang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LWApiConfig.h"
#import "LWApiUtils.h"

/**
 *  该类为终端SDK所有连接类的基类
 */
@interface LWApiConnection : NSObject

/**
 *  用户自定义的String值，用于上下文，会回传回请求客户端
 */
@property (nonatomic, strong) NSString *userInfo;

/**
 *  sdk的版本信息
 */
@property (nonatomic, strong) NSString *sdkVersion;

/**
 *  用于从object解析为URL
 *
 *  @return 返回一个map用于url拼写
 */
- (NSMutableDictionary *)parse;

/**
 *  用于从URL解析为object
 *
 *  @param map url的paramsMap解析到object
 */
- (void)structure:(NSDictionary *)map;

@end
