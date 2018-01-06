//
//  WBHttpRequest+WeiboToken.h
//  WeiboSDK
//
//  Created by DannionQiu on 14/11/6.
//  Copyright (c) 2014年 SINA iOS Team. All rights reserved.
//

#import "WBHttpRequest.h"

@interface WBHttpRequest (WeiboToken)
/*!
 @method
 
 @abstract
 使用RefreshToken去换取新的身份凭证AccessToken.
 
 @discussion
 在SSO授权登录后，服务器会下发有效期为7天的refreshToken以及有效期为1天的AccessToken。
 当有效期为1天的AccessToken过期时，可以调用该接口带着refreshToken信息区换取新的AccessToken。
 @param refreshToken        refreshToken
 
 @param queue               指定发送请求的NSOperationQueue，如果这个参数为nil，则请求会发送在MainQueue( [NSOperationQueue mainQueue] )中。
 
 @param handler             完成请求后会回调handler，处理完成请求后的逻辑。
 */
+ (WBHttpRequest *)requestForRenewAccessTokenWithRefreshToken:(NSString*)refreshToken
                                                        queue:(NSOperationQueue*)queue
                                        withCompletionHandler:(WBRequestHandler)handler;
@end
