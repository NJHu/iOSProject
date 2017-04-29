//
//  WBHttpRequest+WeiboUser.h
//  WeiboSDK
//
//  Created by DannionQiu on 14-9-23.
//  Copyright (c) 2014年 SINA iOS Team. All rights reserved.
//

#import "WBHttpRequest.h"

@interface WBHttpRequest (WeiboUser)

/*!
 @method
 
 @abstract
 Creates a request representing a Open API call to the "friendships/friends".
 
 @discussion
 Simplifies preparing a request and sending request to retrieve the user's friends.
 
 A successful Open API call will return an NSDictionary of objects which contanis an array of <WeiboUser> objects representing the
 user's friends.
 
 You can see more details about this API in http://open.weibo.com/wiki/2/friendships/friends/en
 
 @param currentUserID       should be the current User's UserID which has been authorized.
 
 @param accessToken         The token string.
 
 @param otherProperties     Any additional properties for the Open API Request.
 
 @param queue               specify the queue that you want to send request on, if this param is nil, the request will be start on MainQueue( [NSOperationQueue mainQueue] ).
 
 @param handler             the comletion block which will be executed after received response from Open API server.
 */
+ (WBHttpRequest *)requestForFriendsListOfUser:(NSString*)currentUserID
                               withAccessToken:(NSString*)accessToken
                            andOtherProperties:(NSDictionary*)otherProperties
                                         queue:(NSOperationQueue*)queue
                         withCompletionHandler:(WBRequestHandler)handler;

/*!
 @method
 
 @abstract
 Creates a request representing a Open API call to the "friendships/friends/ids".
 
 @discussion
 Simplifies preparing a request and sending request to retrieve the user's friends' UserID.
 
 A successful Open API call will return an NSDictionary of objects which contanis an array of NSString representing the
 user's friends' UserID.
 
 You can see more details about this API in http://open.weibo.com/wiki/2/friendships/friends/ids/en
 
 @param currentUserID       should be the current User's UserID which has been authorized.
 
 @param accessToken         The token string.
 
 @param otherProperties     Any additional properties for the Open API Request.
 
 @param queue               specify the queue that you want to send request on, if this param is nil, the request will be start on MainQueue( [NSOperationQueue mainQueue] ).
 
 @param handler             the comletion block which will be executed after received response from Open API server.
 */
+ (WBHttpRequest *)requestForFriendsUserIDListOfUser:(NSString*)currentUserID
                                     withAccessToken:(NSString*)accessToken
                                  andOtherProperties:(NSDictionary*)otherProperties
                                               queue:(NSOperationQueue*)queue
                               withCompletionHandler:(WBRequestHandler)handler;


/*!
 @method
 
 @abstract
 Creates a request representing a Open API call to the "friendships/friends/in_common".
 
 @discussion
 Simplifies preparing a request and sending request to retrieve the common friends list between two users..
 
 A successful Open API call will return an NSDictionary of objects which contanis an array of <WeiboUser> objects representing the
 user's friends.
 
 You can see more details about this API in http://open.weibo.com/wiki/2/friendships/friends/in_common/en
 
 @param currentUserID       should be the current User's UserID which has been authorized.
 
 @param accessToken         The token string.
 
 @param otherProperties     Any additional properties for the Open API Request.
 
 @param queue               specify the queue that you want to send request on, if this param is nil, the request will be start on MainQueue( [NSOperationQueue mainQueue] ).
 
 @param handler             the comletion block which will be executed after received response from Open API server.
 */
+ (WBHttpRequest *)requestForCommonFriendsListBetweenUser:(NSString*)currentUserID
                                                  andUser:(NSString*)anotherUserID
                                          withAccessToken:(NSString*)accessToken
                                       andOtherProperties:(NSDictionary*)otherProperties
                                                    queue:(NSOperationQueue*)queue
                                    withCompletionHandler:(WBRequestHandler)handler;

/*!
 @method
 
 @abstract
 Creates a request representing a Open API call to the "friendships/friends/bilateral".
 
 @discussion
 Simplifies preparing a request and sending request to retrieve the list of the users that are following the specified user and are being followed by the specified user.
 
 A successful Open API call will return an NSDictionary of objects which contanis an array of <WeiboUser> objects representing the
 users that are following the specified user and are being followed by the specified user.
 
 You can see more details about this API in http://open.weibo.com/wiki/2/friendships/friends/bilateral/en
 
 @param currentUserID       should be the current User's UserID which has been authorized.
 
 @param accessToken         The token string.
 
 @param otherProperties     Any additional properties for the Open API Request.
 
 @param queue               specify the queue that you want to send request on, if this param is nil, the request will be start on MainQueue( [NSOperationQueue mainQueue] ).
 
 @param handler             the comletion block which will be executed after received response from Open API server.
 */
+ (WBHttpRequest *)requestForBilateralFriendsListOfUser:(NSString*)currentUserID
                                        withAccessToken:(NSString*)accessToken
                                     andOtherProperties:(NSDictionary*)otherProperties
                                                  queue:(NSOperationQueue*)queue
                                  withCompletionHandler:(WBRequestHandler)handler;

/*!
 @method
 
 @abstract
 Creates a request representing a Open API call to the "friendships/followers".
 
 @discussion
 Simplifies preparing a request and sending request to retrieve the user's followers.
 
 A successful Open API call will return an NSDictionary of objects which contanis an array of <WeiboUser> objects representing the
 user's followers.
 
 You can see more details about this API in http://open.weibo.com/wiki/2/friendships/followers/en
 
 @param currentUserID       should be the current User's UserID which has been authorized.
 
 @param accessToken         The token string.
 
 @param otherProperties     Any additional properties for the Open API Request.
 
 @param queue               specify the queue that you want to send request on, if this param is nil, the request will be start on MainQueue( [NSOperationQueue mainQueue] ).
 
 @param handler             the comletion block which will be executed after received response from Open API server.
 */
+ (WBHttpRequest *)requestForFollowersListOfUser:(NSString*)currentUserID
                                 withAccessToken:(NSString*)accessToken
                              andOtherProperties:(NSDictionary*)otherProperties
                                           queue:(NSOperationQueue*)queue
                           withCompletionHandler:(WBRequestHandler)handler;

/*!
 @method
 
 @abstract
 Creates a request representing a Open API call to the "friendships/followers/ids".
 
 @discussion
 Simplifies preparing a request and sending request to retrieve the user's followers' UserID.
 
 A successful Open API call will return an NSDictionary of objects which contanis an array of NSString representing the
 user's followers' UserID.
 
 You can see more details about this API in http://open.weibo.com/wiki/2/friendships/followers/ids/en
 
 @param currentUserID       should be the current User's UserID which has been authorized.
 
 @param accessToken         The token string.
 
 @param otherProperties     Any additional properties for the Open API Request.
 
 @param queue               specify the queue that you want to send request on, if this param is nil, the request will be start on MainQueue( [NSOperationQueue mainQueue] ).
 
 @param handler             the comletion block which will be executed after received response from Open API server.
 */
+ (WBHttpRequest *)requestForFollowersUserIDListOfUser:(NSString*)currentUserID
                                     withAccessToken:(NSString*)accessToken
                                  andOtherProperties:(NSDictionary*)otherProperties
                                               queue:(NSOperationQueue*)queue
                               withCompletionHandler:(WBRequestHandler)handler;

/*!
 @method
 
 @abstract
 Creates a request representing a Open API call to the "friendships/followers/active".
 
 @discussion
 Simplifies preparing a request and sending request to retrieve the active(high quality) followers list of a user.
 
 A successful Open API call will return an NSDictionary of objects which contanis an array of <WeiboUser> objects representing the active(high quality) followers list of a user.
 
 You can see more details about this API in http://open.weibo.com/wiki/2/friendships/followers/active/en
 
 @param currentUserID       should be the current User's UserID which has been authorized.
 
 @param accessToken         The token string.
 
 @param otherProperties     Any additional properties for the Open API Request.
 
 @param queue               specify the queue that you want to send request on, if this param is nil, the request will be start on MainQueue( [NSOperationQueue mainQueue] ).
 
 @param handler             the comletion block which will be executed after received response from Open API server.
 */
+ (WBHttpRequest *)requestForActiveFollowersListOfUser:(NSString*)currentUserID
                                       withAccessToken:(NSString*)accessToken
                                    andOtherProperties:(NSDictionary*)otherProperties
                                                 queue:(NSOperationQueue*)queue
                                 withCompletionHandler:(WBRequestHandler)handler;

/*!
 @method
 
 @abstract
 Creates a request representing a Open API call to the "friendships/friends_chain/followers".
 
 @discussion
 Simplifies preparing a request and sending request to retrieve the users that are being followed by the authenticating user and are following the specified user.
 
 A successful Open API call will return an NSDictionary of objects which contanis an array of <WeiboUser> objects representing the users that are being followed by the authenticating user and are following the specified user.
 
 You can see more details about this API in http://open.weibo.com/wiki/2/friendships/friends_chain/followers/en
 
 @param currentUserID       should be the current User's UserID which has been authorized.
 
 @param accessToken         The token string.
 
 @param otherProperties     Any additional properties for the Open API Request.
 
 @param queue               specify the queue that you want to send request on, if this param is nil, the request will be start on MainQueue( [NSOperationQueue mainQueue] ).
 
 @param handler             the comletion block which will be executed after received response from Open API server.
 */
+ (WBHttpRequest *)requestForBilateralFollowersListOfUser:(NSString*)currentUserID
                                          withAccessToken:(NSString*)accessToken
                                       andOtherProperties:(NSDictionary*)otherProperties
                                                    queue:(NSOperationQueue*)queue
                                    withCompletionHandler:(WBRequestHandler)handler;

/*!
 @method
 
 @abstract
 Creates a request representing a Open API call to the "friendships/show".
 
 @discussion
 Simplifies preparing a request and sending request to retrieve the relationship of two users.
 
 A successful Open API call will return an NSDictionary of objects which contanis the relationship of two users.
 
 You can see more details about this API in http://open.weibo.com/wiki/2/friendships/show
 
 @param targetUserID        a User ID
 
 @param sourceUserID        a User ID
 
 @param accessToken         The token string.
 
 @param otherProperties     Any additional properties for the Open API Request.
 
 @param queue               specify the queue that you want to send request on, if this param is nil, the request will be start on MainQueue( [NSOperationQueue mainQueue] ).
 
 @param handler             the comletion block which will be executed after received response from Open API server.
 */
+ (WBHttpRequest *)requestForFriendshipDetailBetweenTargetUser:(NSString*)targetUserID
                                                 andSourceUser:(NSString*)sourceUserID
                                               withAccessToken:(NSString*)accessToken
                                            andOtherProperties:(NSDictionary*)otherProperties
                                                         queue:(NSOperationQueue*)queue
                                         withCompletionHandler:(WBRequestHandler)handler;

/*!
 @method
 
 @abstract
 Creates a request representing a Open API call to the "friendships/create".
 
 @discussion
 Simplifies preparing a request and sending request to Follow a user.
 
 A successful Open API call will return an <WeiboUser> object representing the user to be followed.
 
 You can see more details about this API in http://open.weibo.com/wiki/2/friendships/create/en
 
 @param theUserToBeFollowed the userID of the user which you want to follow.
 
 @param accessToken         The token string.
 
 @param otherProperties     Any additional properties for the Open API Request.
 
 @param queue               specify the queue that you want to send request on, if this param is nil, the request will be start on MainQueue( [NSOperationQueue mainQueue] ).
 
 @param handler             the comletion block which will be executed after received response from Open API server.
 */
+ (WBHttpRequest *)requestForFollowAUser:(NSString*)theUserToBeFollowed
                         withAccessToken:(NSString*)accessToken
                      andOtherProperties:(NSDictionary*)otherProperties
                                   queue:(NSOperationQueue*)queue
                   withCompletionHandler:(WBRequestHandler)handler;

/*!
 @method
 
 @abstract
 Creates a request representing a Open API call to the "friendships/destroy".
 
 @discussion
 Simplifies preparing a request and sending request to cancel following a user.
 
 A successful Open API call will return an <WeiboUser> object representing the user to be followed.
 
 You can see more details about this API in http://open.weibo.com/wiki/2/friendships/destroy/en
 
 @param theUserThatYouDontLike the userID of the user which you want to cancel following.
 
 @param accessToken         The token string.
 
 @param otherProperties     Any additional properties for the Open API Request.
 
 @param queue               specify the queue that you want to send request on, if this param is nil, the request will be start on MainQueue( [NSOperationQueue mainQueue] ).
 
 @param handler             the comletion block which will be executed after received response from Open API server.
 */
+ (WBHttpRequest *)requestForCancelFollowAUser:(NSString*)theUserThatYouDontLike
                               withAccessToken:(NSString*)accessToken
                            andOtherProperties:(NSDictionary*)otherProperties
                                         queue:(NSOperationQueue*)queue
                         withCompletionHandler:(WBRequestHandler)handler;

/*!
 @method
 
 @abstract
 Creates a request representing a Open API call to the "friendships/followers/destroy".
 
 @discussion
 Simplifies preparing a request and sending request to remove a follower of the authenticating user.
 
 A successful Open API call will return an <WeiboUser> object representing the user to be followed.
 
 this API requires advanced level authorization. You can see more details about advanced level authorization in http://open.weibo.com/wiki/%E6%8E%88%E6%9D%83%E6%9C%BA%E5%88%B6%E8%AF%B4%E6%98%8E#scope
 
 You can see more details about this API in http://open.weibo.com/wiki/2/friendships/followers/destroy/en
 
 @param theUserThatYouDontLike the userID of the follower which you want to remove.
 
 @param accessToken         The token string.
 
 @param otherProperties     Any additional properties for the Open API Request.
 
 @param queue               specify the queue that you want to send request on, if this param is nil, the request will be start on MainQueue( [NSOperationQueue mainQueue] ).
 
 @param handler             the comletion block which will be executed after received response from Open API server.
 */
+ (WBHttpRequest *)requestForRemoveFollowerUser:(NSString*)theUserThatYouDontLike
                                 withAccessToken:(NSString*)accessToken
                              andOtherProperties:(NSDictionary*)otherProperties
                                           queue:(NSOperationQueue*)queue
                           withCompletionHandler:(WBRequestHandler)handler;

/*!
 @method
 
 @abstract
 Creates a request representing a Open API call to the "messages/invite".
 
 @discussion
 Simplifies preparing a request and sending request to send invitation to a bilateral friend of the authenticating user.
 
 A successful Open API call will return  an NSDictionary of objects which contanis <WeiboUser> objects representing sender and receiver and other invitation details.
 
 You can see more details about this API in http://open.weibo.com/wiki/2/messages/invite
 
 @param theUserThatShouldBeYourBilateralFriend    the userID of the follower which you want to remove.
 
 @param accessToken         The token string.
 
 @param text                The text content in your invitation message. should not be nil.
 
 @param url                 The url in your invitation message. can be nil.

 @param logoUrl             The logoUrl in your invitation message. can be nil.
 
 @param queue               specify the queue that you want to send request on, if this param is nil, the request will be start on MainQueue( [NSOperationQueue mainQueue] ).
 
 @param handler             the comletion block which will be executed after received response from Open API server.
 */
+ (WBHttpRequest *)requestForInviteBilateralFriend:(NSString*)theUserThatShouldBeYourBilateralFriend
                                   withAccessToken:(NSString*)accessToken
                                        inviteText:(NSString*)text
                                         inviteUrl:(NSString*)url
                                     inviteLogoUrl:(NSString*)logoUrl
                                             queue:(NSOperationQueue*)queue
                             withCompletionHandler:(WBRequestHandler)handler;


/*!
 @method
 
 @abstract
 Creates a request representing a Open API call to the "users/show".
 
 @discussion
 Simplifies preparing a request and sending request to retrieve user profile by user ID..
 
 A successful Open API call will return a <WeiboUser> object representing the user profile by user ID.
 
 You can see more details about this API in http://open.weibo.com/wiki/2/users/show/en
 
 @param aUserID             a User ID.
 
 @param accessToken         The token string.
 
 @param otherProperties     Any additional properties for the Open API Request.
 
 @param queue               specify the queue that you want to send request on, if this param is nil, the request will be start on MainQueue( [NSOperationQueue mainQueue] ).
 
 @param handler             the comletion block which will be executed after received response from Open API server.
 */
+ (WBHttpRequest *)requestForUserProfile:(NSString*)aUserID
                         withAccessToken:(NSString*)accessToken
                      andOtherProperties:(NSDictionary*)otherProperties
                                   queue:(NSOperationQueue*)queue
                   withCompletionHandler:(WBRequestHandler)handler;

@end
