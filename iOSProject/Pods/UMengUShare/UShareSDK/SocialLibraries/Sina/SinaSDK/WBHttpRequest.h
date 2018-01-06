//
//  WBHttpRequest.h
//  WeiboSDK
//
//  Created by DannionQiu on 14-9-18.
//  Copyright (c) 2014年 SINA iOS Team. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#pragma mark - WBHttpRequest and WBHttpRequestDelegate
@class WBHttpRequest;

/**
 接收并处理来自微博sdk对于网络请求接口的调用响应 以及logOutWithToken的请求
 */
@protocol WBHttpRequestDelegate <NSObject>

/**
 收到一个来自微博Http请求的响应
 
 @param response 具体的响应对象
 */
@optional
- (void)request:(WBHttpRequest *)request didReceiveResponse:(NSURLResponse *)response;

/**
 收到一个来自微博Http请求失败的响应
 
 @param error 错误信息
 */
@optional
- (void)request:(WBHttpRequest *)request didFailWithError:(NSError *)error;

/**
 收到一个来自微博Http请求的网络返回
 
 @param result 请求返回结果
 */
@optional
- (void)request:(WBHttpRequest *)request didFinishLoadingWithResult:(NSString *)result;

/**
 收到一个来自微博Http请求的网络返回
 
 @param data 请求返回结果
 */
@optional
- (void)request:(WBHttpRequest *)request didFinishLoadingWithDataResult:(NSData *)data;

/**
 收到快速SSO授权的重定向
 
 @param URI
 */
@optional
- (void)request:(WBHttpRequest *)request didReciveRedirectResponseWithURI:(NSURL *)redirectUrl;

@end


/**
 微博封装Http请求的消息结构
 
 */
@interface WBHttpRequest : NSObject
{
    NSURLConnection                 *connection;
    NSMutableData                   *responseData;
}

/**
 用户自定义请求地址URL
 */
@property (nonatomic, strong) NSString *url;

/**
 用户自定义请求方式
 
 支持"GET" "POST"
 */
@property (nonatomic, strong) NSString *httpMethod;

/**
 用户自定义请求参数字典
 */
@property (nonatomic, strong) NSDictionary *params;

/**
 WBHttpRequestDelegate对象，用于接收微博SDK对于发起的接口请求的请求的响应
 */
@property (nonatomic, weak) id<WBHttpRequestDelegate> delegate;

/**
 用户自定义TAG
 
 用于区分回调Request
 */
@property (nonatomic, strong) NSString* tag;

/**
 统一HTTP请求接口
 调用此接口后，将发送一个HTTP网络请求
 @param url 请求url地址
 @param httpMethod  支持"GET" "POST"
 @param params 向接口传递的参数结构
 @param delegate WBHttpRequestDelegate对象，用于接收微博SDK对于发起的接口请求的请求的响应
 @param tag 用户自定义TAG,将通过回调WBHttpRequest实例的tag属性返回
 */
+ (WBHttpRequest *)requestWithURL:(NSString *)url
                       httpMethod:(NSString *)httpMethod
                           params:(NSDictionary *)params
                         delegate:(id<WBHttpRequestDelegate>)delegate
                          withTag:(NSString *)tag;

/**
 统一微博Open API HTTP请求接口
 调用此接口后，将发送一个HTTP网络请求（用于访问微博open api）
 @param accessToken 应用获取到的accessToken，用于身份验证
 @param url 请求url地址
 @param httpMethod  支持"GET" "POST"
 @param params 向接口传递的参数结构
 @param delegate WBHttpRequestDelegate对象，用于接收微博SDK对于发起的接口请求的请求的响应
 @param tag 用户自定义TAG,将通过回调WBHttpRequest实例的tag属性返回
 */
+ (WBHttpRequest *)requestWithAccessToken:(NSString *)accessToken
                                      url:(NSString *)url
                               httpMethod:(NSString *)httpMethod
                                   params:(NSDictionary *)params
                                 delegate:(id<WBHttpRequestDelegate>)delegate
                                  withTag:(NSString *)tag;



/**
 取消网络请求接口
 调用此接口后，将取消当前网络请求，建议同时[WBHttpRequest setDelegate:nil];
 注意：该方法只对使用delegate的request方法有效。无法取消任何使用block的request的网络请求接口。
 */
- (void)disconnect;

#pragma mark - block extension

typedef void (^WBRequestHandler)(WBHttpRequest *httpRequest,
                                 id result,
                                 NSError *error);

/**
 统一微博Open API HTTP请求接口
 调用此接口后，将发送一个HTTP网络请求（用于访问微博open api）
 @param url 请求url地址
 @param httpMethod  支持"GET" "POST"
 @param params 向接口传递的参数结构
 @param queue 发起请求的NSOperationQueue对象，如queue为nil,则在主线程（[NSOperationQueue mainQueue]）发起请求。
 @param handler 接口请求返回调用的block方法
 */
+ (WBHttpRequest *)requestWithURL:(NSString *)url
                       httpMethod:(NSString *)httpMethod
                           params:(NSDictionary *)params
                            queue:(NSOperationQueue*)queue
            withCompletionHandler:(WBRequestHandler)handler;


/**
 统一HTTP请求接口
 调用此接口后，将发送一个HTTP网络请求
 @param url 请求url地址
 @param httpMethod  支持"GET" "POST"
 @param params 向接口传递的参数结构
 @param queue 发起请求的NSOperationQueue对象，如queue为nil,则在主线程（[NSOperationQueue mainQueue]）发起请求。
 @param handler 接口请求返回调用的block方法
 */
+ (WBHttpRequest *)requestWithAccessToken:(NSString *)accessToken
                                      url:(NSString *)url
                               httpMethod:(NSString *)httpMethod
                                   params:(NSDictionary *)params
                                    queue:(NSOperationQueue*)queue
                    withCompletionHandler:(WBRequestHandler)handler;

@end
