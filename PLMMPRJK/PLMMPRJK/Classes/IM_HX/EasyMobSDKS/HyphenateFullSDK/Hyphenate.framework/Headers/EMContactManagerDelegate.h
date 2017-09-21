/*!
 *  \~chinese
 *  @header     EMContactManagerDelegate.h
 *  @abstract   此协议定义了好友相关的回调
 *  @author     Hyphenate
 *  @version    3.00
 *
 *  \~english
 *  @header     EMContactManagerDelegate.h
 *  @abstract   The protocol of contact callbacks definitions
 *  @author     Hyphenate
 *  @version    3.00
 */

#import <Foundation/Foundation.h>

@class EMError;

/*!
 *  \~chinese
 *  好友相关的回调
 *
 *  \~english
 *  Contact related callbacks
 */
@protocol EMContactManagerDelegate <NSObject>

@optional

/*!
 *  \~chinese
 *  用户B同意用户A的加好友请求后，用户A会收到这个回调
 *
 *  @param aUsername   用户B
 *
 *  \~english
 *  Delegate method will be invoked if a friend request is approved
 *   
 *  User A will receive this callback after user B approved user A's friend request
 *
 *  @param aUsername   User who approves a friend's request
 */
- (void)friendRequestDidApproveByUser:(NSString *)aUsername;

/*!
 *  \~chinese
 *  用户B拒绝用户A的加好友请求后，用户A会收到这个回调
 *
 *  @param aUsername   用户B
 *
 *  \~english
 *  Delegate method will be invoked if a friend request is declined.
 *
 *  User A will receive this callback after user B declined user A's friend request
 *
 *  @param aUsername   User who declined a friend's request
 */
- (void)friendRequestDidDeclineByUser:(NSString *)aUsername;

/*!
 *  \~chinese
 *  用户B删除与用户A的好友关系后，用户A，B会收到这个回调
 *
 *  @param aUsername   用户B
 *
 *  \~english
 *  Delegate method will be invoked if user is removed as a contact by another user
 *
 *  User A and B both will receive this callback after User B unfriended user A
 *
 *  @param aUsername   User who unfriended the current user
 */
- (void)friendshipDidRemoveByUser:(NSString *)aUsername;

/*!
 *  \~chinese
 *  用户B同意用户A的好友申请后，用户A和用户B都会收到这个回调
 *
 *  @param aUsername   用户好友关系的另一方
 *
 *  \~english
 *  Delegate method will be invoked id the user is added as a contact by another user.
 *
 *  Both user A and B will receive this callback after User B agreed user A's add-friend invitation
 *
 *  @param aUsername   Another user of user‘s friend relationship
 */
- (void)friendshipDidAddByUser:(NSString *)aUsername;

/*!
 *  \~chinese
 *  用户B申请加A为好友后，用户A会收到这个回调
 *
 *  @param aUsername   用户B
 *  @param aMessage    好友邀请信息
 *
 *  \~english
 *  Delegate method will be invoked when a user received a friend request
 *
 *  User A will receive this callback when received a friend request from user B
 *
 *  @param aUsername   Friend request sender
 *  @param aMessage    Friend request message
 */
- (void)friendRequestDidReceiveFromUser:(NSString *)aUsername
                                message:(NSString *)aMessage;

#pragma mark - Deprecated methods

/*!
 *  \~chinese
 *  用户B同意用户A的加好友请求后，用户A会收到这个回调
 *
 *  @param aUsername   用户B
 *
 *  \~english
 *  User A will receive this callback after user B accepted user A's friend request
 *
 *  @param aUsername   User B
 */
- (void)didReceiveAgreedFromUsername:(NSString *)aUsername __deprecated_msg("Use -friendRequestDidApproveByUser:");

/*!
 *  \~chinese
 *  用户B拒绝用户A的加好友请求后，用户A会收到这个回调
 *
 *  @param aUsername   用户B
 *
 *  \~english
 *  User A will receive this callback after user B declined user A's add-friend invitation
 *
 *  @param aUsername   User B
 */
- (void)didReceiveDeclinedFromUsername:(NSString *)aUsername __deprecated_msg("Use -friendRequestDidDeclineByUser:");

/*!
 *  \~chinese
 *  用户B删除与用户A的好友关系后，用户A会收到这个回调
 *
 *  @param aUsername   用户B
 *
 *  \~english
 *  User A will receive this callback after User B delete the friend relationship between user A
 *
 *  @param aUsername   User B
 */
- (void)didReceiveDeletedFromUsername:(NSString *)aUsername __deprecated_msg("Use -friendshipDidRemoveByUser:");

/*!
 *  \~chinese
 *  用户B同意用户A的好友申请后，用户A和用户B都会收到这个回调
 *
 *  @param aUsername   用户好友关系的另一方
 *
 *  \~english
 *  Both user A and B will receive this callback after User B agreed user A's add-friend invitation
 *
 *  @param aUsername   Another user of user‘s friend relationship
 */
- (void)didReceiveAddedFromUsername:(NSString *)aUsername __deprecated_msg("Use -friendshipDidAddByUser:");

/*!
 *  \~chinese
 *  用户B申请加A为好友后，用户A会收到这个回调
 *
 *  @param aUsername   用户B
 *  @param aMessage    好友邀请信息
 *
 *  \~english
 *  User A will receive this callback after user B requested to add user A as a friend
 *
 *  @param aUsername   User B
 *  @param aMessage    Friend invitation message
 */
- (void)didReceiveFriendInvitationFromUsername:(NSString *)aUsername
                                       message:(NSString *)aMessage __deprecated_msg("Use -friendRequestDidReceiveFromUser:message:");


@end
