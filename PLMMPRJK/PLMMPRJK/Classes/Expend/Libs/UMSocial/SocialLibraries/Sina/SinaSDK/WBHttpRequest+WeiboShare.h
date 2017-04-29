//
//  WBHttpRequest+WeiboShare.h
//  WeiboSDK
//
//  Created by DannionQiu on 14/10/31.
//  Copyright (c) 2014年 SINA iOS Team. All rights reserved.
//

#import "WBHttpRequest.h"

@class WBImageObject;

@interface WBHttpRequest (WeiboShare)

/*!
 @method

 @abstract
 获得当前授权用户的微博id列表。
 
 @param userID              当前授权用户的uid
 
 @param accessToken         当前授权用户的accessToken
 
 @param otherProperties     一个NSDictionary字典，承载任意想额外添加到请求中的参数。

 @param queue               指定发送请求的NSOperationQueue，如果这个参数为nil，则请求会发送在MainQueue( [NSOperationQueue mainQueue] )中。

 @param handler             完成请求后会回调handler，处理完成请求后的逻辑。
*/
+ (WBHttpRequest *)requestForStatusIDsFromCurrentUser:(NSString*)userID
                                      withAccessToken:(NSString*)accessToken
                                   andOtherProperties:(NSDictionary*)otherProperties
                                                queue:(NSOperationQueue*)queue
                                withCompletionHandler:(WBRequestHandler)handler;

/*!
 @method
 
 @abstract
 转发微博。转发微博id所对应的微博。
 
 @param statusID            微博id，微博的唯一标识符。
  
 @param text                添加的转发文本，内容不超过140个汉字，不填则默认为“转发微博”。
 
 @param accessToken         当前授权用户的accessToken
 
 @param otherProperties     一个NSDictionary字典，承载任意想额外添加到请求中的参数。
 
 @param queue               指定发送请求的NSOperationQueue，如果这个参数为nil，则请求会发送在MainQueue( [NSOperationQueue mainQueue] )中。
 
 @param handler             完成请求后会回调handler，处理完成请求后的逻辑。
 */
+ (WBHttpRequest *)requestForRepostAStatus:(NSString*)statusID
                                repostText:(NSString*)text
                           withAccessToken:(NSString*)accessToken
                        andOtherProperties:(NSDictionary*)otherProperties
                                     queue:(NSOperationQueue*)queue
                     withCompletionHandler:(WBRequestHandler)handler;

/*!
 @method
 
 @abstract
 发表一个微博(无图或者带一张图片的微博)。
 
 @param statusText          要发布的微博文本内容，内容不超过140个汉字。
 
 @param imageObject         要上传的图片，仅支持JPEG、GIF、PNG格式，图片大小小于5M。这个参数可为nil。由于只能传一张图片，若imageObject和url都有值，请看@caution。
 
 @param url                 图片的URL地址，必须以http开头。这个参数可为nil，由于只能传一张图片，若imageObject和url都有值，请看@caution。
 
 @param accessToken         当前授权用户的accessToken
 
 @param otherProperties     一个NSDictionary字典，承载任意想额外添加到请求中的参数。
 
 @param queue               指定发送请求的NSOperationQueue，如果这个参数为nil，则请求会发送在MainQueue( [NSOperationQueue mainQueue] )中。
 
 @param handler             完成请求后会回调handler，处理完成请求后的逻辑。
 
 @caution 注意，如果参数imageObject和url都有值，则发布带有imageObject所对应的图片，忽略url所对应的图片。
 */
+ (WBHttpRequest *)requestForShareAStatus:(NSString*)statusText
                        contatinsAPicture:(WBImageObject*)imageObject
                             orPictureUrl:(NSString*)url
                          withAccessToken:(NSString*)accessToken
                       andOtherProperties:(NSDictionary*)otherProperties
                                    queue:(NSOperationQueue*)queue
                    withCompletionHandler:(WBRequestHandler)handler;


@end
