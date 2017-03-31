//
//  WBHttpRequest+WeiboGame.h
//  WeiboSDK
//
//  Created by insomnia on 15/3/11.
//  Copyright (c) 2015年 SINA iOS Team. All rights reserved.
//

#import "WBHttpRequest.h"

@interface WBHttpRequest (WeiboGame)

/*!
 @method
 
 @abstract
 新增游戏对象。 在http://open.weibo.com/wiki/%E6%B8%B8%E6%88%8F%E6%8E%A5%E5%8F%A3 中有关于该接口的细节说明。
 
 @param userID              当前授权用户的uid
 
 @param accessToken         当前授权用户的accessToken
 
 @param otherProperties     一个NSDictionary字典，承载任意想额外添加到请求中的参数。
 
 @param queue               指定发送请求的NSOperationQueue，如果这个参数为nil，则请求会发送在MainQueue( [NSOperationQueue mainQueue] )中。
 
 @param handler             完成请求后会回调handler，处理完成请求后的逻辑。
 */
+ (WBHttpRequest *)addGameObject:(NSString*)userID
                 withAccessToken:(NSString*)accessToken
              andOtherProperties:(NSDictionary*)otherProperties
                           queue:(NSOperationQueue*)queue
           withCompletionHandler:(WBRequestHandler)handler;

/*!
 @method
 
 @abstract
 游戏成就对象入库/更新。 在http://open.weibo.com/wiki/%E6%B8%B8%E6%88%8F%E6%8E%A5%E5%8F%A3 中有关于该接口的细节说明。
 
 @param userID              当前授权用户的uid
 
 @param accessToken         当前授权用户的accessToken
 
 @param otherProperties     一个NSDictionary字典，承载任意想额外添加到请求中的参数。
 
 @param queue               指定发送请求的NSOperationQueue，如果这个参数为nil，则请求会发送在MainQueue( [NSOperationQueue mainQueue] )中。
 
 @param handler             完成请求后会回调handler，处理完成请求后的逻辑。
 */
+ (WBHttpRequest *)addGameAchievementObject:(NSString*)userID
                            withAccessToken:(NSString*)accessToken
                         andOtherProperties:(NSDictionary*)otherProperties
                                      queue:(NSOperationQueue*)queue
                      withCompletionHandler:(WBRequestHandler)handler;

/*!
 @method
 
 @abstract
 用户获得游戏成就关系入库/更新。 在http://open.weibo.com/wiki/%E6%B8%B8%E6%88%8F%E6%8E%A5%E5%8F%A3 中有关于该接口的细节说明。
 
 @param userID              当前授权用户的uid
 
 @param accessToken         当前授权用户的accessToken
 
 @param otherProperties     一个NSDictionary字典，承载任意想额外添加到请求中的参数。
 
 @param queue               指定发送请求的NSOperationQueue，如果这个参数为nil，则请求会发送在MainQueue( [NSOperationQueue mainQueue] )中。
 
 @param handler             完成请求后会回调handler，处理完成请求后的逻辑。
 */
+ (WBHttpRequest *)addGameAchievementGain:(NSString*)userID
                          withAccessToken:(NSString*)accessToken
                       andOtherProperties:(NSDictionary*)otherProperties
                                    queue:(NSOperationQueue*)queue
                    withCompletionHandler:(WBRequestHandler)handler;

/*!
 @method
 
 @abstract
 用户游戏得分关系入库/更新。 在http://open.weibo.com/wiki/%E6%B8%B8%E6%88%8F%E6%8E%A5%E5%8F%A3 中有关于该接口的细节说明。
 
 @param userID              当前授权用户的uid
 
 @param accessToken         当前授权用户的accessToken
 
 @param otherProperties     一个NSDictionary字典，承载任意想额外添加到请求中的参数。
 
 @param queue               指定发送请求的NSOperationQueue，如果这个参数为nil，则请求会发送在MainQueue( [NSOperationQueue mainQueue] )中。
 
 @param handler             完成请求后会回调handler，处理完成请求后的逻辑。
 */
+ (WBHttpRequest *)addGameScoreGain:(NSString*)userID
                    withAccessToken:(NSString*)accessToken
                 andOtherProperties:(NSDictionary*)otherProperties
                              queue:(NSOperationQueue*)queue
              withCompletionHandler:(WBRequestHandler)handler;


/*!
 @method
 
 @abstract
 读取玩家游戏分数。 在http://open.weibo.com/wiki/%E6%B8%B8%E6%88%8F%E6%8E%A5%E5%8F%A3 中有关于该接口的细节说明。
 
 @param userID              当前授权用户的uid
 
 @param accessToken         当前授权用户的accessToken
 
 @param otherProperties     一个NSDictionary字典，承载任意想额外添加到请求中的参数。
 
 @param queue               指定发送请求的NSOperationQueue，如果这个参数为nil，则请求会发送在MainQueue( [NSOperationQueue mainQueue] )中。
 
 @param handler             完成请求后会回调handler，处理完成请求后的逻辑。
 */
+ (WBHttpRequest *)requestForGameScore:(NSString*)userID
                       withAccessToken:(NSString*)accessToken
                    andOtherProperties:(NSDictionary*)otherProperties
                                 queue:(NSOperationQueue*)queue
                 withCompletionHandler:(WBRequestHandler)handler;

/*!
 @method
 
 @abstract
 读取玩家互粉好友游戏分数。 在http://open.weibo.com/wiki/%E6%B8%B8%E6%88%8F%E6%8E%A5%E5%8F%A3 中有关于该接口的细节说明。
 
 @param userID              当前授权用户的uid
 
 @param accessToken         当前授权用户的accessToken
 
 @param otherProperties     一个NSDictionary字典，承载任意想额外添加到请求中的参数。
 
 @param queue               指定发送请求的NSOperationQueue，如果这个参数为nil，则请求会发送在MainQueue( [NSOperationQueue mainQueue] )中。
 
 @param handler             完成请求后会回调handler，处理完成请求后的逻辑。
 */
+ (WBHttpRequest *)requestForFriendsGameScore:(NSString*)userID
                              withAccessToken:(NSString*)accessToken
                           andOtherProperties:(NSDictionary*)otherProperties
                                        queue:(NSOperationQueue*)queue
                        withCompletionHandler:(WBRequestHandler)handler;

/*!
 @method
 
 @abstract
 读取玩家获取成就列表。 在http://open.weibo.com/wiki/%E6%B8%B8%E6%88%8F%E6%8E%A5%E5%8F%A3 中有关于该接口的细节说明。
 
 @param userID              当前授权用户的uid
 
 @param accessToken         当前授权用户的accessToken
 
 @param otherProperties     一个NSDictionary字典，承载任意想额外添加到请求中的参数。
 
 @param queue               指定发送请求的NSOperationQueue，如果这个参数为nil，则请求会发送在MainQueue( [NSOperationQueue mainQueue] )中。
 
 @param handler             完成请求后会回调handler，处理完成请求后的逻辑。
 */
+ (WBHttpRequest *)requestForGameAchievementGain:(NSString*)userID
                                 withAccessToken:(NSString*)accessToken
                              andOtherProperties:(NSDictionary*)otherProperties
                                           queue:(NSOperationQueue*)queue
                           withCompletionHandler:(WBRequestHandler)handler;

@end
