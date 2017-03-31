//
//  NSURLConnection+SelfSigned.h
//  SAB Connect
//
//  Created by Yuriy on 8/18/14.
//  Copyright (c) 2014 yuriy. All rights reserved.
//
// A category on NSURLConnection that allows making async requests that accept all https certificates. 
//https://github.com/yuriy128/NSURLConnection-SelfSigned
#import <Foundation/Foundation.h>

@interface NSURLConnection (SelfSigned)

/**
 *  Sends async request while accepting all self-signed certs
 *
 */
+ (void)sendAsynchronousRequestAcceptingAllCerts:(NSURLRequest *)request queue:(NSOperationQueue *)queue completionHandler:(void (^)(NSURLResponse *, NSData *, NSError *))handler;

@end
