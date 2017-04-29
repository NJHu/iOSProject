//
//  WBSDKRelationshipButton.h
//  WeiboSDK
//
//  Created by DannionQiu on 14/10/26.
//  Copyright (c) 2014年 SINA iOS Team. All rights reserved.
//

#import "WBSDKBasicButton.h"

enum
{
    WBSDKRelationshipButtonStateFollow,
    WBSDKRelationshipButtonStateUnfollow
};
typedef NSUInteger WBSDKRelationshipButtonState;



@interface WBSDKRelationshipButton : WBSDKBasicButton

/**
 初始化一个关注组件按钮
 @param frame 按钮的frame值
 @param accessToken 用户授权后获取的Token
 @param currentUserID 当前用户的uid值
 @param followerUserID 希望当前用户加关注的用户uid值
 @param handler   回调函数，当用户点击按钮，进行完关注组件相关的交互之后，回调的函数。
 */
- (id)initWithFrame:(CGRect)frame
        accessToken:(NSString*)accessToken
        currentUser:(NSString*)currentUserID
         followUser:(NSString*)followerUserID
  completionHandler:(WBSDKButtonHandler)handler;

@property (nonatomic, strong)NSString* accessToken;
@property (nonatomic, strong)NSString* currentUserID;
@property (nonatomic, strong)NSString* followUserID;


@property (nonatomic, assign)WBSDKRelationshipButtonState currentRelationShip;


/**
 获取最新的关注状态
 该方法会调用OpenApi，获取当前用户与目标用户之间的关注状态，并将按钮的状态改变为正确的状态。
 */
- (void)checkCurrentRelationship;

@end
