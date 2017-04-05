//
//  LWApiUtils.h
//  LWApiSDK
//
//  Created by Leyteris on 9/23/13.
//  Copyright (c) 2013 Laiwang. All rights reserved.
//

@interface LWApiUtils : NSObject

+ (NSString *)urldecode:(NSString *)url;
+ (NSString *)urlencode:(NSString *)url;

+ (NSURL *)urlAddParams:(NSURL *)url params:(NSDictionary *)params;
+ (NSDictionary *)urlParams:(NSURL *)url;
+ (NSString *)urlProtocol:(NSURL *)url;

@end