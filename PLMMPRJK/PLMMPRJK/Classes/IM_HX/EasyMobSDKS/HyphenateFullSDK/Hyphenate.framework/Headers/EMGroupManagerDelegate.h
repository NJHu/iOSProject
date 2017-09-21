/*!
 *  \~chinese
 *  @header EMGroupManagerDelegate.h
 *  @abstract 此协议定义了群组相关的回调
 *  @author Hyphenate
 *  @version 3.00
 *
 *  \~english
 *  @header EMGroupManagerDelegate.h
 *  @abstract This protocol defined the callbacks of group
 *  @author Hyphenate
 *  @version 3.00
 */

#import <Foundation/Foundation.h>

/*!
 *  \~chinese 
 *  离开群组的原因
 *
 *  \~english
 *  The reason of user leaving the group
 */
typedef enum{
    EMGroupLeaveReasonBeRemoved = 0,    /*! \~chinese 被移除 \~english Removed by owner */
    EMGroupLeaveReasonUserLeave,        /*! \~chinese 自己主动离开 \~english User leave the group */
    EMGroupLeaveReasonDestroyed,        /*! \~chinese 群组销毁 \~english Group has been destroyed */
}EMGroupLeaveReason;

@class EMGroup;
@class EMGroupSharedFile;

/*!
 *  \~chinese
 *  群组相关的回调
 *
 *  \~english
 *  Delegate
 */
@protocol EMGroupManagerDelegate <NSObject>

@optional

/*!
 *  \~chinese
 *  用户A邀请用户B入群,用户B接收到该回调
 *
 *  @param aGroupId    群组ID
 *  @param aInviter    邀请者
 *  @param aMessage    邀请信息
 *
 *  \~english
 *  Delegate method will be invoked when receiving a group invitation
 *
 *  After user A invites user B into the group, user B will receive this callback
 *
 *  @param aGroupId    The group ID
 *  @param aInviter    Inviter
 *  @param aMessage    Invitation message
 */
- (void)groupInvitationDidReceive:(NSString *)aGroupId
                          inviter:(NSString *)aInviter
                          message:(NSString *)aMessage;

/*!
 *  \~chinese
 *  用户B同意用户A的入群邀请后，用户A接收到该回调
 *
 *  @param aGroup    群组实例
 *  @param aInvitee  被邀请者
 *
 *  \~english
 *  Delegate method will be invoked when the group invitation is accepted
 *
 *  After user B accepted user A‘s group invitation, user A will receive this callback
 *
 *  @param aGroup    User joined group
 *  @param aInvitee  Invitee
 */
- (void)groupInvitationDidAccept:(EMGroup *)aGroup
                         invitee:(NSString *)aInvitee;

/*!
 *  \~chinese
 *  用户B拒绝用户A的入群邀请后，用户A接收到该回调
 *
 *  @param aGroup    群组
 *  @param aInvitee  被邀请者
 *  @param aReason   拒绝理由
 *
 *  \~english
 *  Delegate method will be invoked when the group invitation is declined.
 *
 *  After user B declined user A's group invitation, user A will receive the callback
 *
 *  @param aGroup    Group instance
 *  @param aInvitee  Invitee
 *  @param aReason   Decline reason
 */
- (void)groupInvitationDidDecline:(EMGroup *)aGroup
                          invitee:(NSString *)aInvitee
                           reason:(NSString *)aReason;

/*!
 *  \~chinese
 *  SDK自动同意了用户A的加B入群邀请后，用户B接收到该回调，需要设置EMOptions的isAutoAcceptGroupInvitation为YES
 *
 *  @param aGroup    群组实例
 *  @param aInviter  邀请者
 *  @param aMessage  邀请消息
 *
 *  \~english
 *  Delegate method will be invoked after SDK automatically accepted the group invitation
 *
 *  User B will receive this callback after SDK automatically accept user A's group invitation, need set EMOptions's isAutoAcceptGroupInvitation property to YES
 *
 *  @param aGroup    Group instance
 *  @param aInviter  Inviter
 *  @param aMessage  Invite message
 */
- (void)didJoinGroup:(EMGroup *)aGroup
             inviter:(NSString *)aInviter
             message:(NSString *)aMessage;

/*!
 *  \~chinese
 *  离开群组回调
 *
 *  @param aGroup    群组实例
 *  @param aReason   离开原因
 *
 *  \~english
 *  Delegate method will be invoked when user leaves a group
 *
 *  @param aGroup    Group instance
 *  @param aReason   Leave reason
 */
- (void)didLeaveGroup:(EMGroup *)aGroup
               reason:(EMGroupLeaveReason)aReason;

/*!
 *  \~chinese
 *  群组的群主收到用户的入群申请，群的类型是EMGroupStylePublicJoinNeedApproval
 *
 *  @param aGroup     群组实例
 *  @param aApplicant 申请者
 *  @param aReason    申请者的附属信息
 *
 *  \~english
 *  Delegate method will be invoked when the group owner receives a group request and group's style is EMGroupStylePublicJoinNeedApproval
 *
 *  @param aGroup     Group instance
 *  @param aUsername  The user initialized the group join request
 *  @param aReason    The user's message
 */
- (void)joinGroupRequestDidReceive:(EMGroup *)aGroup
                              user:(NSString *)aUsername
                            reason:(NSString *)aReason;

/*!
 *  \~chinese
 *  群主拒绝用户A的入群申请后，用户A会接收到该回调，群的类型是EMGroupStylePublicJoinNeedApproval
 *
 *  @param aGroupId    群组ID
 *  @param aReason     拒绝理由
 *
 *  \~english
 *  Delegate method will be invoked when the group owner declines a join group request
 *
 *  User A will receive this callback after group's owner declined the group request, group's style is EMGroupStylePublicJoinNeedApproval
 *
 *  @param aGroupId    Group id
 *  @param aReason     Decline reason
 */
- (void)joinGroupRequestDidDecline:(NSString *)aGroupId
                            reason:(NSString *)aReason;

/*!
 *  \~chinese
 *  群主同意用户A的入群申请后，用户A会接收到该回调，群的类型是EMGroupStylePublicJoinNeedApproval
 *
 *  @param aGroup   通过申请的群组
 *
 *  \~english
 *  Delegate method will be invoked when the group owner approves a join group request
 *
 *  User A will receive this callback after group's owner approve the group request, group's style is EMGroupStylePublicJoinNeedApproval
 *
 *  @param aGroup   Group instance
 */
- (void)joinGroupRequestDidApprove:(EMGroup *)aGroup;

/*!
 *  \~chinese
 *  群组列表发生变化
 *
 *  @param aGroupList  群组列表<EMGroup>
 *
 *  \~english
 *  Group List updated
 *
 *  @param aGroupList  Group list<EMGroup>
 */
- (void)groupListDidUpdate:(NSArray *)aGroupList;


/*!
 *  \~chinese
 *  有成员被加入禁言列表
 *
 *  @param aGroup           群组
 *  @param aMutedMembers    被禁言的成员
 *  @param aMuteExpire      禁言失效时间，当前不可用
 *
 *  \~english
 *  Users are added to the mute list
 *
 *  @param aGroup           Group
 *  @param aMutedMembers    Users to be added
 *  @param aMuteExpire      Mute expire, not available at this time
 */
- (void)groupMuteListDidUpdate:(EMGroup *)aGroup
             addedMutedMembers:(NSArray *)aMutedMembers
                    muteExpire:(NSInteger)aMuteExpire;

/*!
 *  \~chinese
 *  有成员被移出禁言列表
 *
 *  @param aGroup           群组
 *  @param aMutedMembers    移出禁言列表的成员
 *
 *  \~english
 *  Users are removed from the mute list
 *
 *  @param aGroup           Group
 *  @param aMutedMembers    Users to be removed
 */
- (void)groupMuteListDidUpdate:(EMGroup *)aGroup
           removedMutedMembers:(NSArray *)aMutedMembers;

/*!
 *  \~chinese
 *  有成员被加入管理员列表
 *
 *  @param aGroup    群组
 *  @param aAdmin    加入管理员列表的成员
 *
 *  \~english
 *  User is added to the admin list
 *
 *  @param aGroup    Group
 *  @param aAdmin    User to be added
 */
- (void)groupAdminListDidUpdate:(EMGroup *)aGroup
                     addedAdmin:(NSString *)aAdmin;

/*!
 *  \~chinese
 *  有成员被移出管理员列表
 *
 *  @param aGroup    群组
 *  @param aAdmin    移出管理员列表的成员
 *
 *  \~english
 *  User is removed to the admin list
 *
 *  @param aGroup    Group
 *  @param aAdmin    User to be removed
 */
- (void)groupAdminListDidUpdate:(EMGroup *)aGroup
                   removedAdmin:(NSString *)aAdmin;

/*!
 *  \~chinese
 *  群组创建者有更新
 *
 *  @param aGroup       群组
 *  @param aNewOwner    新群主
 *  @param aOldOwner    旧群主
 *
 *  \~english
 *  Owner is updated
 *
 *  @param aGroup       Group
 *  @param aNewOwner    New Owner
 *  @param aOldOwner    Old Owner
 */
- (void)groupOwnerDidUpdate:(EMGroup *)aGroup
                   newOwner:(NSString *)aNewOwner
                   oldOwner:(NSString *)aOldOwner;

/*!
 *  \~chinese
 *  有用户加入群组
 *
 *  @param aGroup       加入的群组
 *  @param aUsername    加入者
 *
 *  \~english
 *  Delegate method will be invoked when a user joins a group.
 *
 *  @param aGroup       Joined group
 *  @param aUsername    The user who joined group
 */
- (void)userDidJoinGroup:(EMGroup *)aGroup
                    user:(NSString *)aUsername;

/*!
 *  \~chinese
 *  有用户离开群组
 *
 *  @param aGroup       离开的群组
 *  @param aUsername    离开者
 *
 *  \~english
 *  Delegate method will be invoked when a user leaves a group.
 *
 *  @param aGroup       Left group
 *  @param aUsername    The user who leaved group
 */
- (void)userDidLeaveGroup:(EMGroup *)aGroup
                     user:(NSString *)aUsername;

/*!
 *  \~chinese
 *  群公告有更新
 *
 *  @param aGroup           群组
 *  @param aAnnouncement    群公告
 *
 *  \~english
 *  Delegate method will be invoked when a user update the announcement from a group.
 *
 *  @param aGroup           Group
 *  @param aAnnouncement    Announcement
 */
- (void)groupAnnouncementDidUpdate:(EMGroup *)aGroup
                      announcement:(NSString *)aAnnouncement;

/*!
 *  \~chinese
 *  有用户上传群共享文件
 *
 *  @param aGroup       群组
 *  @param aSharedFile  共享文件
 *
 *  \~english
 *  Delegate method will be invoked when a user upload share file to a group.
 *
 *  @param aGroup       Group
 *  @param aSharedFile  Share File
 */
- (void)groupFileListDidUpdate:(EMGroup *)aGroup
               addedSharedFile:(EMGroupSharedFile *)aSharedFile;

/*!
 *  \~chinese
 *  有用户删除群共享文件
 *
 *  @param aGroup       群组
 *  @param aFileId      共享文件ID
 *
 *  \~english
 *  Delegate method will be invoked when a user remove share file from a group.
 *
 *  @param aGroup       Group
 *  @param aFileId      File ID
 */
- (void)groupFileListDidUpdate:(EMGroup *)aGroup
             removedSharedFile:(NSString *)aFileId;

#pragma mark - Deprecated methods

/*!
 *  \~chinese
 *  用户A邀请用户B入群,用户B接收到该回调
 *
 *  @param aGroupId    群组ID
 *  @param aInviter    邀请者
 *  @param aMessage    邀请信息
 *
 *  \~english
 *  Delegate method will be invoked when user receives a group invitation
 *
 *  After user A invites user B into the group, user B will receive this callback
 *
 *  @param aGroupId    The group ID
 *  @param aInviter    Inviter
 *  @param aMessage    Invite message
 */
- (void)didReceiveGroupInvitation:(NSString *)aGroupId
                          inviter:(NSString *)aInviter
                          message:(NSString *)aMessage __deprecated_msg("Use -groupInvitationDidReceive:inviter:message:");

/*!
 *  \~chinese
 *  用户B同意用户A的入群邀请后，用户A接收到该回调
 *
 *  @param aGroup    群组实例
 *  @param aInvitee  被邀请者
 *
 *  \~english
 *  Delegate method will be invoked when a group invitation is accepted
 *
 *  After user B accepted user A‘s group invitation, user A will receive this callback
 *
 *  @param aGroup    Group to join
 *  @param aInvitee  Invitee
 */
- (void)didReceiveAcceptedGroupInvitation:(EMGroup *)aGroup
                                  invitee:(NSString *)aInvitee __deprecated_msg("Use -groupInvitationDidAccept:invitee:");

/*!
 *  \~chinese
 *  用户B拒绝用户A的入群邀请后，用户A接收到该回调
 *
 *  @param aGroup    群组
 *  @param aInvitee  被邀请者
 *  @param aReason   拒绝理由
 *
 *  \~english
 *  Delegate method will be invoked when a group invitation is declined
 *
 *  After user B declined user A's group invitation, user A will receive the callback
 *
 *  @param aGroup    Group instance
 *  @param aInvitee  Invitee
 *  @param aReason   Decline reason
 */
- (void)didReceiveDeclinedGroupInvitation:(EMGroup *)aGroup
                                  invitee:(NSString *)aInvitee
                                   reason:(NSString *)aReason __deprecated_msg("Use -groupInvitationDidDecline:invitee:reason:");

/*!
 *  \~chinese
 *  SDK自动同意了用户A的加B入群邀请后，用户B接收到该回调，需要设置EMOptions的isAutoAcceptGroupInvitation为YES
 *
 *  @param aGroup    群组实例
 *  @param aInviter  邀请者
 *  @param aMessage  邀请消息
 *
 *  \~english
 *  User B will receive this callback after SDK automatically accept user A's group invitation.
 *  Set EMOptions's isAutoAcceptGroupInvitation property to YES for this delegate method
 *
 *  @param aGroup    Group instance
 *  @param aInviter  Inviter
 *  @param aMessage  Invite message
 */
- (void)didJoinedGroup:(EMGroup *)aGroup
               inviter:(NSString *)aInviter
               message:(NSString *)aMessage __deprecated_msg("Use -didJoinGroup:inviter:message:");

/*!
 *  \~chinese
 *  离开群组回调
 *
 *  @param aGroup    群组实例
 *  @param aReason   离开原因
 *
 *  \~english
 *  Callback of leave group
 *
 *  @param aGroup    Group instance
 *  @param aReason   Leave reason
 */
- (void)didReceiveLeavedGroup:(EMGroup *)aGroup
                       reason:(EMGroupLeaveReason)aReason __deprecated_msg("Use -didLeaveGroup:reason:");

/*!
 *  \~chinese
 *  群组的群主收到用户的入群申请，群的类型是EMGroupStylePublicJoinNeedApproval
 *
 *  @param aGroup     群组实例
 *  @param aApplicant 申请者
 *  @param aReason    申请者的附属信息
 *
 *  \~english
 *  Group's owner receive user's applicaton of joining group, group's style is EMGroupStylePublicJoinNeedApproval
 *
 *  @param aGroup     Group
 *  @param aApplicant The applicant
 *  @param aReason    The applicant's message
 */
- (void)didReceiveJoinGroupApplication:(EMGroup *)aGroup
                             applicant:(NSString *)aApplicant
                                reason:(NSString *)aReason __deprecated_msg("Use -joinGroupRequestDidReceive:user:reason:");

/*!
 *  \~chinese
 *  群主拒绝用户A的入群申请后，用户A会接收到该回调，群的类型是EMGroupStylePublicJoinNeedApproval
 *
 *  @param aGroupId    群组ID
 *  @param aReason     拒绝理由
 *
 *  \~english
 *  User A will receive this callback after group's owner declined the join group request
 *
 *  @param aGroupId    Group id
 *  @param aReason     Decline reason
 */
- (void)didReceiveDeclinedJoinGroup:(NSString *)aGroupId
                             reason:(NSString *)aReason __deprecated_msg("Use -joinGroupRequestDidDecline:reason:");

/*!
 *  \~chinese
 *  群主同意用户A的入群申请后，用户A会接收到该回调，群的类型是EMGroupStylePublicJoinNeedApproval
 *
 *  @param aGroup   通过申请的群组
 *
 *  \~english
 *  User A will receive this callback after group's owner accepted it's application, group's style is EMGroupStylePublicJoinNeedApproval
 *
 *  @param aGroup   Group instance
 */
- (void)didReceiveAcceptedJoinGroup:(EMGroup *)aGroup __deprecated_msg("Use -joinGroupRequestDidApprove:");

/*!
 *  \~chinese
 *  群组列表发生变化
 *
 *  @param aGroupList  群组列表<EMGroup>
 *
 *  \~english
 *  Group List changed
 *
 *  @param aGroupList  Group list<EMGroup>
 */
- (void)didUpdateGroupList:(NSArray *)aGroupList __deprecated_msg("Use -groupListDidUpdate:");

@end
