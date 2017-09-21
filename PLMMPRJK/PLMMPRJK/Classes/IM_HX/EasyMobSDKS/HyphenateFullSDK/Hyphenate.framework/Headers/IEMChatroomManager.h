/*!
 *  \~chinese
 *  @header IEMChatroomManager.h
 *  @abstract 此协议定义了聊天室相关操作
 *  @author Hyphenate
 *  @version 3.00
 *
 *  \~english
 *  @header IEMChatroomManager.h
 *  @abstract This protocol defines the chat room operations
 *  @author Hyphenate
 *  @version 3.00
 */

#import <Foundation/Foundation.h>

#import "EMCommonDefs.h"
#import "EMChatroomManagerDelegate.h"
#import "EMChatroomOptions.h"
#import "EMChatroom.h"
#import "EMPageResult.h"

#import "EMCursorResult.h"

@class EMError;

/*!
 *  \~chinese
 *  聊天室相关操作
 *
 *  \~english
 *  Chatroom operations
 */
@protocol IEMChatroomManager <NSObject>

@required

#pragma mark - Delegate

/*!
 *  \~chinese
 *  添加回调代理
 *
 *  @param aDelegate  要添加的代理
 *  @param aQueue     添加回调代理
 *
 *  \~english
 *  Add delegate
 *
 *  @param aDelegate  Delegate
 *  @param aQueue     (optional) The queue of calling delegate methods. Pass in nil to run on main thread.
 */
- (void)addDelegate:(id<EMChatroomManagerDelegate>)aDelegate
      delegateQueue:(dispatch_queue_t)aQueue;

/*!
 *  \~chinese
 *  移除回调代理
 *
 *  @param aDelegate  要移除的代理
 *
 *  \~english
 *  Remove delegate
 *
 *  @param aDelegate  Delegate
 */
- (void)removeDelegate:(id<EMChatroomManagerDelegate>)aDelegate;

#pragma mark - Fetch Chatrooms

/*!
 *  \~chinese
 *  从服务器获取指定数目的聊天室
 *
 *  同步方法，会阻塞当前线程
 *
 *  @param aPageNum         获取第几页
 *  @param aPageSize        获取多少条
 *  @param pError           出错信息
 *
 *  @return 聊天室列表<EMChatroom>
 *
 *  \~english
 *  Get pagesize number chatroom from server.
 *
 *  Synchronization method will block the current thread
 *
 *  @param aPageNum         Page number
 *  @param aPageSize        Page size
 *  @param pError   Error
 *
 *  @return Chat room list<EMChatroom>
 */
- (EMPageResult *)getChatroomsFromServerWithPage:(NSInteger)aPageNum
                                        pageSize:(NSInteger)aPageSize
                                           error:(EMError **)pError;

/*!
 *  \~chinese
 *  从服务器获取指定数目的聊天室
 *
 *  @param aPageNum             获取第几页
 *  @param aPageSize            获取多少条
 *  @param aCompletionBlock      完成的回调
 *
 *  \~english
 *  Get all the chatrooms from server
 *
 *  @param aPageNum         Page number
 *  @param aPageSize        Page size
 *  @param aCompletionBlock     The callback block of completion
 *
 */

- (void)getChatroomsFromServerWithPage:(NSInteger)aPageNum
                              pageSize:(NSInteger)aPageSize
                            completion:(void (^)(EMPageResult *aResult, EMError *aError))aCompletionBlock;

#pragma mark - Create

/*!
 *  \~chinese
 *  创建聊天室
 *
 *  同步方法，会阻塞当前线程
 *
 *  @param aSubject             名称
 *  @param aDescription         描述
 *  @param aInvitees            成员（不包括创建者自己）
 *  @param aMessage             邀请消息
 *  @param aMaxMembersCount     群组最大成员数
 *  @param pError               出错信息
 *
 *  @return    创建的聊天室
 *
 *  \~english
 *  Create a chatroom
 *
 *  Synchronization method will block the current thread
 *
 *  @param aSubject             Subject
 *  @param aDescription         Description
 *  @param aInvitees            Members, without creater
 *  @param aMessage             Invitation message
 *  @param aMaxMembersCount     Max members count
 *  @param pError               Error
 *
 *  @return    Created chatroom
 */
- (EMChatroom *)createChatroomWithSubject:(NSString *)aSubject
                           description:(NSString *)aDescription
                              invitees:(NSArray *)aInvitees
                               message:(NSString *)aMessage
                          maxMembersCount:(NSInteger)aMaxMembersCount
                                 error:(EMError **)pError;

/*!
 *  \~chinese
 *  创建群组
 *
 *  @param aSubject                 群组名称
 *  @param aDescription             群组描述
 *  @param aInvitees                群组成员（不包括创建者自己）
 *  @param aMessage                 邀请消息
 *  @param aMaxMembersCount         群组最大成员数
 *  @param aCompletionBlock         完成的回调
 *
 *
 *  \~english
 *  Create a group
 *
 *  @param aSubject                 Group subject
 *  @param aDescription             Group description
 *  @param aInvitees                Group members, without creater
 *  @param aMessage                 Invitation message
 *  @param aMaxMembersCount         Max members count
 *  @param aCompletionBlock         The callback block of completion
 *
 */
- (void)createChatroomWithSubject:(NSString *)aSubject
                      description:(NSString *)aDescription
                         invitees:(NSArray *)aInvitees
                          message:(NSString *)aMessage
                  maxMembersCount:(NSInteger)aMaxMembersCount
                       completion:(void (^)(EMChatroom *aChatroom, EMError *aError))aCompletionBlock;

#pragma mark - Edit Chatroom

/*!
 *  \~chinese
 *  加入聊天室
 *
 *  同步方法，会阻塞当前线程
 *
 *  @param aChatroomId  聊天室的ID
 *  @param pError       返回的错误信息
 *
 *  @result 所加入的聊天室
 *
 *  \~english
 *  Join a chatroom
 *
 *  Synchronization method will block the current thread
 *
 *  @param aChatroomId  Chatroom id
 *  @param pError       Error
 *
 *  @result Joined chatroom
 */
- (EMChatroom *)joinChatroom:(NSString *)aChatroomId
                       error:(EMError **)pError;

/*!
 *  \~chinese
 *  加入聊天室
 *
 *  @param aChatroomId      聊天室的ID
 *  @param aCompletionBlock      完成的回调
 *
 *
 *  \~english
 *  Join a chatroom
 *
 *  @param aChatroomId      Chatroom id
 *  @param aCompletionBlock     The callback block of completion
 *
 */
- (void)joinChatroom:(NSString *)aChatroomId
          completion:(void (^)(EMChatroom *aChatroom, EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  退出聊天室
 *
 *  同步方法，会阻塞当前线程
 *
 *  @param aChatroomId  聊天室ID
 *  @param pError       错误信息
 *
 *
 *  \~english
 *  Leave a chatroom
 *
 *  Synchronization method will block the current thread
 *
 *  @param aChatroomId  Chatroom id
 *  @param pError       Error
 *
 */
- (void)leaveChatroom:(NSString *)aChatroomId
                error:(EMError **)pError;

/*!
 *  \~chinese
 *  退出聊天室
 *
 *  @param aChatroomId          聊天室ID
 *  @param aCompletionBlock      完成的回调
 *
 *
 *  \~english
 *  Leave a chatroom
 *
 *  @param aChatroomId      Chatroom id
 *  @param aCompletionBlock     The callback block of completion
 *
 */
- (void)leaveChatroom:(NSString *)aChatroomId
           completion:(void (^)(EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  解散聊天室, 需要owner权限
 *
 *  同步方法，会阻塞当前线程
 *
 *  @param aChatroomId  聊天室ID
 *
 *  @result    错误信息, 成功返回nil
 *
 *  \~english
 *  Destroy a group, owner‘s authority is required
 *
 *  Synchronization method will block the current thread
 *
 *  @param aChatroomId  Chatroom id
 *
 *  @result    Error, return nil if success
 */
- (EMError *)destroyChatroom:(NSString *)aChatroomId;

/*!
 *  \~chinese
 *  解散群组, 需要owner权限
 *
 *  @param aChatroomId      聊天室ID
 *  @param aCompletionBlock 完成的回调
 *
 *  \~english
 *  Destroy a group, owner‘s authority is required
 *
 *  @param aChatroomId      Chatroom id
 *  @param aCompletionBlock The callback block of completion
 *
 */
- (void)destroyChatroom:(NSString *)aChatroomId
             completion:(void (^)(EMError *aError))aCompletionBlock;

#pragma mark - Fetch

/*!
 *  \~chinese
 *  获取聊天室详情
 *  
 *  同步方法，会阻塞当前线程
 *
 *  @param aChatroomId           聊天室ID
 *  @param pError                错误信息
 *
 *  @return    聊天室
 *
 *  \~english
 *  Fetch chatroom's specification
 *
 *  Synchronization method, will block the current thread
 *
 *  @param aChatroomId           Chatroom id
 *  @param pError                Error
 *
 *  @return    Chatroom instance
 */
- (EMChatroom *)getChatroomSpecificationFromServerWithId:(NSString *)aChatroomId
                                                   error:(EMError **)pError;

/*!
 *  \~chinese
 *  获取聊天室详情
 *
 *  @param aChatroomId           聊天室ID
 *  @param aCompletionBlock      完成的回调
 *
 *  \~english
 *  Fetch chat room specifications
 *
 *  @param aChatroomId           Chatroom id
 *  @param aCompletionBlock      The callback block of completion
 *
 */
- (void)getChatroomSpecificationFromServerWithId:(NSString *)aChatroomId
                                      completion:(void (^)(EMChatroom *aChatroom, EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  获取聊天室成员列表
 *
 *  @param aChatroomId      聊天室ID
 *  @param aCursor          游标，首次调用传空
 *  @param aPageSize        获取多少条
 *  @param pError           错误信息
 *
 *  @return    列表和游标
 *
 *  \~english
 *  Get the list of chatroom members from the server
 *
 *  @param aChatroomId      Chatroom id
 *  @param aCursor          Cursor, input nil the first time
 *  @param aPageSize        Page size
 *  @param pError           Error
 *
 *  @return    List and cursor
 *
 */
- (EMCursorResult *)getChatroomMemberListFromServerWithId:(NSString *)aChatroomId
                                                   cursor:(NSString *)aCursor
                                                 pageSize:(NSInteger)aPageSize
                                                    error:(EMError **)pError;

/*!
 *  \~chinese
 *  获取聊天室成员列表
 *
 *  @param aChatroomId      聊天室ID
 *  @param aCursor          游标，首次调用传空
 *  @param aPageSize        获取多少条
 *  @param aCompletionBlock 完成的回调
 *
 *
 *  \~english
 *  Get the list of chatroom members from the server
 *
 *  @param aChatroomId      Chatroom id
 *  @param aCursor          Cursor, input nil the first time
 *  @param aPageSize        Page size
 *  @param aCompletionBlock The callback block of completion
 *
 */
- (void)getChatroomMemberListFromServerWithId:(NSString *)aChatroomId
                                       cursor:(NSString *)aCursor
                                     pageSize:(NSInteger)aPageSize
                                   completion:(void (^)(EMCursorResult *aResult, EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  获取聊天室黑名单列表, 需要owner/admin权限
 *
 *  @param aChatroomId      聊天室ID
 *  @param aPageNum         获取第几页
 *  @param aPageSize        获取多少条
 *  @param pError           错误信息
 *
 *
 *  \~english
 *  Get the blacklist of chatroom from the server, need owner / admin permissions
 *
 *  @param aChatroomId      Chatroom id
 *  @param aPageNum         Page number
 *  @param aPageSize        Page size
 *  @param pError           Error
 *
 */
- (NSArray *)getChatroomBlacklistFromServerWithId:(NSString *)aChatroomId
                                       pageNumber:(NSInteger)aPageNum
                                         pageSize:(NSInteger)aPageSize
                                            error:(EMError **)pError;

/*!
 *  \~chinese
 *  获取聊天室黑名单列表, 需要owner/admin权限
 *
 *  @param aChatroomId      聊天室ID
 *  @param aPageNum         获取第几页
 *  @param aPageSize        获取多少条
 *  @param aCompletionBlock 完成的回调
 *
 *
 *  \~english
 *  Get chatroom's blacklist, need owner / admin permissions
 *
 *  @param aChatroomId      Chatroom id
 *  @param aPageNum         Page number
 *  @param aPageSize        Page size
 *  @param aCompletionBlock The callback block of completion
 *
 */
- (void)getChatroomBlacklistFromServerWithId:(NSString *)aChatroomId
                                  pageNumber:(NSInteger)aPageNum
                                    pageSize:(NSInteger)aPageSize
                                  completion:(void (^)(NSArray *aList, EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  获取聊天室被禁言列表
 *
 *  @param aChatroomId      聊天室ID
 *  @param aPageNum         获取第几页
 *  @param aPageSize        获取多少条
 *  @param pError           错误信息
 *
 *
 *  \~english
 *  Get the mutes of chatroom from the server
 *
 *  @param aChatroomId      Chatroom id
 *  @param aPageNum         Page number
 *  @param aPageSize        Page size
 *  @param pError           Error
 *
 */
- (NSArray *)getChatroomMuteListFromServerWithId:(NSString *)aChatroomId
                                      pageNumber:(NSInteger)aPageNum
                                        pageSize:(NSInteger)aPageSize
                                           error:(EMError **)pError;

/*!
 *  \~chinese
 *  获取聊天室被禁言列表
 *
 *  @param aChatroomId      聊天室ID
 *  @param aPageNum         获取第几页
 *  @param aPageSize        获取多少条
 *  @param aCompletionBlock 完成的回调
 *
 *
 *  \~english
 *  Get the mutes of chatroom from the server
 *
 *  @param aChatroomId      Chatroom id
 *  @param aPageNum         Page number
 *  @param aPageSize        Page size
 *  @param aCompletionBlock The callback block of completion
 *
 */
- (void)getChatroomMuteListFromServerWithId:(NSString *)aChatroomId
                                 pageNumber:(NSInteger)aPageNum
                                   pageSize:(NSInteger)aPageSize
                                 completion:(void (^)(NSArray *aList, EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  获取聊天室公告
 *
 *  @param aChatroomId      聊天室ID
 *  @param pError           错误信息
 *
 *  @return    聊天室公告
 *
 *  \~english
 *  Get the announcement of chatroom from the server
 *
 *  @param aChatroomId      Chatroom id
 *  @param pError           error
 *
 *  @return    The announcement of chatroom
 */
- (NSString *)getChatroomAnnouncementWithId:(NSString *)aChatroomId
                                      error:(EMError **)pError;

/*!
 *  \~chinese
 *  获取聊天室公告
 *
 *  @param aChatroomId      聊天室ID
 *  @param aCompletionBlock 完成的回调
 *
 *
 *  \~english
 *  Get the announcement of chatroom from the server
 *
 *  @param aChatroomId      Chatroom id
 *  @param aCompletionBlock The callback block of completion
 *
 */
- (void)getChatroomAnnouncementWithId:(NSString *)aChatroomId
                           completion:(void (^)(NSString *aAnnouncement, EMError *aError))aCompletionBlock;

#pragma mark - Edit

/*!
 *  \~chinese
 *  更改聊天室主题, 需要owner权限
 *
 *  同步方法，会阻塞当前线程
 *
 *  @param aSubject     新主题
 *  @param aChatroomId  聊天室ID
 *  @param pError       错误信息
 *
 *  @result    聊天室对象
 *
 *  \~english
 *  Change chatroom subject, owner‘s authority is required
 *
 *  Synchronization method will block the current thread
 *
 *  @param aSubject     New subject
 *  @param aChatroomId  Chatroom id
 *  @param pError       Error
 *
 *  @result    Chatroom instance
 */
- (EMChatroom *)updateSubject:(NSString *)aSubject
                  forChatroom:(NSString *)aChatroomId
                        error:(EMError **)pError;

/*!
 *  \~chinese
 *  更改聊天室主题, 需要owner权限
 *
 *  @param aSubject         新主题
 *  @param aChatroomId      聊天室ID
 *  @param aCompletionBlock 完成的回调
 *
 *
 *  \~english
 *  Change the chatroom subject, owner‘s authority is required
 *
 *  @param aSubject         New subject
 *  @param aChatroomId      Chatroom id
 *  @param aCompletionBlock The callback block of completion
 *
 */
- (void)updateSubject:(NSString *)aSubject
          forChatroom:(NSString *)aChatroomId
           completion:(void (^)(EMChatroom *aChatroom, EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  更改聊天室说明信息, 需要owner权限
 *
 *  同步方法，会阻塞当前线程
 *
 *  @param aDescription 说明信息
 *  @param aChatroomId  聊天室ID
 *  @param pError       错误信息
 *
 *  @result    聊天室对象
 *
 *  \~english
 *  Change chatroom description, owner‘s authority is required
 *
 *  Synchronization method will block the current thread
 *
 *  @param aDescription New description
 *  @param aChatroomId  Chatroom id
 *  @param pError       Error
 *
 *  @result    Chatroom
 */
- (EMChatroom *)updateDescription:(NSString *)aDescription
                      forChatroom:(NSString *)aChatroomId
                            error:(EMError **)pError;

/*!
 *  \~chinese
 *  更改聊天室说明信息, 需要owner权限
 *
 *  @param aDescription     说明信息
 *  @param aChatroomId      聊天室ID
 *  @param aCompletionBlock 完成的回调
 *
 *
 *  \~english
 *  Change the chatroom description, owner‘s authority is required
 *
 *  @param aDescription     New description
 *  @param aChatroomId      Chatroom id
 *  @param aCompletionBlock The callback block of completion
 *
 */
- (void)updateDescription:(NSString *)aDescription
              forChatroom:(NSString *)aChatroomId
               completion:(void (^)(EMChatroom *aChatroom, EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  将成员移出聊天室, 需要owner/admin权限
 *
 *  同步方法，会阻塞当前线程
 *
 *  @param aMembers     要移出的用户列表
 *  @param aChatroomId  聊天室ID
 *  @param pError       错误信息
 *
 *  @result    聊天室实例
 *
 *  \~english
 *  Remove members from a chatroom, required owner‘s authority
 *
 *  Synchronization method will block the current thread
 *
 *  @param aMembers     Users to be removed
 *  @param aChatroomId  Chatroom id
 *  @param pError       Error
 *
 *  @result    Chatroom instance
 */
- (EMChatroom *)removeMembers:(NSArray *)aMembers
                 fromChatroom:(NSString *)aChatroomId
                        error:(EMError **)pError;

/*!
 *  \~chinese
 *  将成员移出聊天室, 需要owner/admin权限
 *
 *  @param aMembers         要移出的用户列表
 *  @param aChatroomId      聊天室ID
 *  @param aCompletionBlock 完成的回调
 *
 *
 *  \~english
 *  Remove members from a group, owner‘s authority is required
 *
 *  @param aMembers         Users to be removed
 *  @param aChatroomId      Chatroom id
 *  @param aCompletionBlock The callback block of completion
 *
 */
- (void)removeMembers:(NSArray *)aMembers
         fromChatroom:(NSString *)aChatroomId
           completion:(void (^)(EMChatroom *aChatroom, EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  加人到聊天室黑名单, 需要owner权限
 *
 *  同步方法，会阻塞当前线程
 *
 *  @param aMembers     要加入黑名单的用户
 *  @param aChatroomId  聊天室ID
 *  @param pError       错误信息
 *
 *  @result    聊天室实例
 *
 *  \~english
 *  Add users to chatroom blacklist, required owner‘s authority
 *
 *  Synchronization method will block the current thread
 *
 *  @param aMembers     Users to be added
 *  @param aChatroomId  Chatroom id
 *  @param pError       Error
 *
 *  @result    Chatroom instance
 */
- (EMChatroom *)blockMembers:(NSArray *)aMembers
                fromChatroom:(NSString *)aChatroomId
                       error:(EMError **)pError;

/*!
 *  \~chinese
 *  加人到聊天室黑名单, 需要owner权限
 *
 *  @param aMembers         要加入黑名单的用户
 *  @param aChatroomId      聊天室ID
 *  @param aCompletionBlock 完成的回调
 *
 *
 *  \~english
 *  Add users to chatroom blacklist, owner‘s authority is required
 *
 *  @param aMembers         Users to be added
 *  @param aChatroomId      Chatroom id
 *  @param aCompletionBlock The callback block of completion
 *
 */
- (void)blockMembers:(NSArray *)aMembers
        fromChatroom:(NSString *)aChatroomId
          completion:(void (^)(EMChatroom *aChatroom, EMError *aError))aCompletionBlock;


/*!
 *  \~chinese
 *  从聊天室黑名单中减人, 需要owner权限
 *
 *  同步方法，会阻塞当前线程
 *
 *  @param aMembers     要从黑名单中移除的用户名列表
 *  @param aChatroomId  聊天室ID
 *  @param pError       错误信息
 *
 *  @result    聊天室对象
 *
 *  \~english
 *  Remove users from chatroom blacklist, required owner‘s authority
 *
 *  Synchronization method will block the current thread
 *
 *  @param aMembers     Users to be removed
 *  @param aChatroomId  Chatroom id
 *  @param pError       Error
 *
 *  @result    Chatroom instance
 */
- (EMChatroom *)unblockMembers:(NSArray *)aMembers
                  fromChatroom:(NSString *)aChatroomId
                         error:(EMError **)pError;

/*!
 *  \~chinese
 *  从聊天室黑名单中减人, 需要owner权限
 *
 *  @param aMembers         要从黑名单中移除的用户名列表
 *  @param aChatroomId      聊天室ID
 *  @param aCompletionBlock 完成的回调
 *
 *
 *  \~english
 *  Remove users from chatroom blacklist, owner‘s authority is required
 *
 *  @param aMembers         Users to be removed
 *  @param aChatroomId      Chatroom id
 *  @param aCompletionBlock The callback block of completion
 *
 */
- (void)unblockMembers:(NSArray *)aMembers
          fromChatroom:(NSString *)aChatroomId
            completion:(void (^)(EMChatroom *aChatroom, EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  改变聊天室创建者，需要Owner权限
 *
 *  同步方法，会阻塞当前线程
 *
 *  @param aChatroomId  聊天室ID
 *  @param aNewOwner    新Owner
 *  @param pError       错误信息
 *
 *  @result    聊天室实例
 *
 *  \~english
 *  Change chatroom owner, need Owner permissions
 *
 *  Synchronization method will block the current thread
 *
 *  @param aChatroomId  Chatroom id
 *  @param aNewOwner    New owner
 *  @param pError       Error
 *
 *  @result    Chatroom instance
 */
- (EMChatroom *)updateChatroomOwner:(NSString *)aChatroomId
                           newOwner:(NSString *)aNewOwner
                              error:(EMError **)pError;

/*!
 *  \~chinese
 *  改变聊天室创建者，需要Owner权限
 *
 *  @param aChatroomId      聊天室ID
 *  @param aNewOwner        新Owner
 *  @param aCompletionBlock 完成的回调
 *
 *
 *  \~english
 *  Change chatroom owner, need Owner permissions
 *
 *  @param aChatroomId      Chatroom id
 *  @param aNewOwner        New owner
 *  @param aCompletionBlock The callback block of completion
 *
 */
- (void)updateChatroomOwner:(NSString *)aChatroomId
                   newOwner:(NSString *)aNewOwner
                 completion:(void (^)(EMChatroom *aChatroom, EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  添加聊天室管理员，需要Owner权限
 *
 *  同步方法，会阻塞当前线程
 *
 *  @param aAdmin       要添加的管理员
 *  @param aChatroomId  聊天室ID
 *  @param pError       错误信息
 *
 *  @result    聊天室实例
 *
 *  \~english
 *  Add chatroom admin, need Owner permissions
 *
 *  Synchronization method will block the current thread
 *
 *  @param aAdmin       Admin
 *  @param aChatroomId  Chatroom id
 *  @param pError       Error
 *
 *  @result    Group instance
 */
- (EMChatroom *)addAdmin:(NSString *)aAdmin
              toChatroom:(NSString *)aChatroomId
                   error:(EMError **)pError;

/*!
 *  \~chinese
 *  添加聊天室管理员，需要Owner权限
 *
 *  @param aAdmin           要添加的群组管理员
 *  @param aChatroomId      聊天室ID
 *  @param aCompletionBlock 完成的回调
 *
 *
 *  \~english
 *  Add chatroom admin, need Owner permissions
 *
 *  @param aAdmin           Admin
 *  @param aChatroomId      Chatroom id
 *  @param aCompletionBlock The callback block of completion
 *
 */
- (void)addAdmin:(NSString *)aAdmin
      toChatroom:(NSString *)aChatroomId
      completion:(void (^)(EMChatroom *aChatroomp, EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  移除聊天室管理员，需要Owner权限
 *
 *  同步方法，会阻塞当前线程
 *
 *  @param aAdmin       要移除的群组管理员
 *  @param aChatroomId  聊天室ID
 *  @param pError       错误信息
 *
 *  @result    聊天室实例
 *
 *  \~english
 *  Remove chatroom admin, need Owner permissions
 *
 *  Synchronization method will block the current thread
 *
 *  @param aAdmin       Admin
 *  @param aChatroomId  Chatroom id
 *  @param pError       Error
 *
 *  @result    Chatroom instance
 */
- (EMChatroom *)removeAdmin:(NSString *)aAdmin
               fromChatroom:(NSString *)aChatroomId
                      error:(EMError **)pError;

/*!
 *  \~chinese
 *  移除聊天室管理员，需要Owner权限
 *
 *  @param aAdmin           要添加的群组管理员
 *  @param aChatroomId      聊天室ID
 *  @param aCompletionBlock 完成的回调
 *
 *
 *  \~english
 *  Remove chatroom admin, need Owner permissions
 *
 *  @param aAdmin           Admin
 *  @param aChatroomId      Chatroom id
 *  @param aCompletionBlock The callback block of completion
 *
 */
- (void)removeAdmin:(NSString *)aAdmin
       fromChatroom:(NSString *)aChatroomId
         completion:(void (^)(EMChatroom *aChatroom, EMError *aError))aCompletionBlock;


/*!
 *  \~chinese
 *  将一组成员禁言，需要Owner / Admin权限
 *
 *  同步方法，会阻塞当前线程
 *
 *  @param aMuteMembers         要禁言的成员列表<NSString>
 *  @param aMuteMilliseconds    禁言时长
 *  @param aChatroomId          聊天室ID
 *  @param pError               错误信息
 *
 *  @result    聊天室实例
 *
 *  \~english
 *  Mute chatroom members, need Owner / Admin permissions
 *
 *  Synchronization method will block the current thread
 *
 *  @param aMuteMembers         The list of mute, type is <NSString>
 *  @param aMuteMilliseconds    Muted time duration in millisecond
 *  @param aChatroomId          Chatroom id
 *  @param pError               Error
 *
 *  @result    Chatroom instance
 */
- (EMChatroom *)muteMembers:(NSArray *)aMuteMembers
           muteMilliseconds:(NSInteger)aMuteMilliseconds
               fromChatroom:(NSString *)aChatroomId
                      error:(EMError **)pError;

/*!
 *  \~chinese
 *  将一组成员禁言，需要Owner / Admin权限
 *
 *  @param aMuteMembers         要禁言的成员列表<NSString>
 *  @param aMuteMilliseconds    禁言时长
 *  @param aChatroomId          聊天室ID
 *  @param aCompletionBlock     完成的回调
 *
 *  \~english
 *  Mute chatroom members, need Owner / Admin permissions
 *
 *  Synchronization method will block the current thread
 *
 *  @param aMuteMembers         The list of mute, type is <NSString>
 *  @param aMuteMilliseconds    Muted time duration in millisecond
 *  @param aChatroomId          Chatroom id
 *  @param aCompletionBlock     The callback block of completion
 *
 */
- (void)muteMembers:(NSArray *)aMuteMembers
   muteMilliseconds:(NSInteger)aMuteMilliseconds
       fromChatroom:(NSString *)aChatroomId
         completion:(void (^)(EMChatroom *aChatroom, EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  解除禁言，需要Owner / Admin权限
 *
 *  同步方法，会阻塞当前线程
 *
 *  @param aMuteMembers     被解除的列表<NSString>
 *  @param aChatroomId      聊天室ID
 *  @param pError           错误信息
 *
 *  @result    聊天室实例
 *
 *  \~english
 *  Unmute chatroom members, need Owner / Admin permissions
 *
 *  Synchronization method will block the current thread
 *
 *  @param aMembers         The list of unmute, type is <NSString>
 *  @param aChatroomId      Chatroom id
 *  @param pError           Error
 *
 *  @result    Chatroom instance
 */
- (EMChatroom *)unmuteMembers:(NSArray *)aMembers
                 fromChatroom:(NSString *)aChatroomId
                        error:(EMError **)pError;

/*!
 *  \~chinese
 *  解除禁言，需要Owner / Admin权限
 *
 *  @param aMuteMembers     被解除的列表<NSString>
 *  @param aChatroomId      聊天室ID
 *  @param aCompletionBlock 完成的回调
 *
 *  \~english
 *  Unmute chatroom members, need Owner / Admin permissions
 *
 *  Synchronization method will block the current thread
 *
 *  @param aMembers         The list of unmute, type is <NSString>
 *  @param aChatroomId      Chatroom id
 *  @param aCompletionBlock The callback block of completion
 *
 */
- (void)unmuteMembers:(NSArray *)aMembers
         fromChatroom:(NSString *)aChatroomId
           completion:(void (^)(EMChatroom *aChatroom, EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  修改聊天室公告，需要Owner / Admin权限
 *
 *  @param aChatroomId      聊天室ID
 *  @param aAnnouncement    群公告
 *  @param pError           错误信息
 *
 *  @result    聊天室实例
 *
 *  \~english
 *  Change the announcement of chatroom, need Owner / Admin permissions
 *
 *  Synchronization method will block the current thread
 *
 *  @param aChatroomId      Chatroom id
 *  @param aAnnouncement    announcement of chatroom
 *  @param pError           error
 *
 *  @result    Chatroom instance
 */
- (EMChatroom *)updateChatroomAnnouncementWithId:(NSString *)aChatroomId
                                    announcement:(NSString *)aAnnouncement
                                           error:(EMError **)pError;

/*!
 *  \~chinese
 *  修改聊天室公告，需要Owner / Admin权限
 *
 *  @param aChatroomId      聊天室ID
 *  @param aAnnouncement    群公告
 *  @param aCompletionBlock 完成的回调
 *
 *  \~english
 *  Change the announcement of chatroom, need Owner / Admin permissions
 *
 *  @param aChatroomId      Chatroom id
 *  @param aAnnouncement    announcement of chatroom
 *  @param aCompletionBlock The callback block of completion
 *
 */
- (void)updateChatroomAnnouncementWithId:(NSString *)aChatroomId
                            announcement:(NSString *)aAnnouncement
                              completion:(void (^)(EMChatroom *aChatroom, EMError *aError))aCompletionBlock;

#pragma mark - EM_DEPRECATED_IOS 3.3.0

/*!
 *  \~chinese
 *  获取聊天室详情
 *
 *  同步方法，会阻塞当前线程
 *
 *  @param aChatroomId           聊天室ID
 *  @param aIncludeMembersList   是否获取成员列表，为YES时，返回200个成员
 *  @param pError                错误信息
 *
 *  @return    聊天室
 *
 *  \~english
 *  Fetch chatroom's specification
 *
 *  Synchronization method, will block the current thread
 *
 *  @param aChatroomId           Chatroom id
 *  @param aIncludeMembersList   Whether to get member list，When YES, returns 200 members
 *  @param pError                Error
 *
 *  @return    Chatroom instance
 */
- (EMChatroom *)fetchChatroomInfo:(NSString *)aChatroomId
               includeMembersList:(BOOL)aIncludeMembersList
                            error:(EMError **)pError EM_DEPRECATED_IOS(3_1_0, 3_3_0, "Use -[IEMChatroomManager getChatroomSpecificationFromServerWithId:error:]");

/*!
 *  \~chinese
 *  获取聊天室详情
 *
 *  @param aChatroomId           聊天室ID
 *  @param aIncludeMembersList   是否获取成员列表，为YES时，返回200个成员
 *  @param aCompletionBlock      完成的回调
 *
 *  \~english
 *  Fetch chat room specifications
 *
 *  @param aChatroomId           Chatroom id
 *  @param aIncludeMembersList   Whether to get member list，When YES, returns 200 members
 *  @param aCompletionBlock      The callback block of completion
 *
 */
- (void)getChatroomSpecificationFromServerByID:(NSString *)aChatroomId
                            includeMembersList:(BOOL)aIncludeMembersList
                                    completion:(void (^)(EMChatroom *aChatroom, EMError *aError))aCompletionBlock EM_DEPRECATED_IOS(3_1_0, 3_3_0, "Use -[IEMChatroomManager getChatroomSpecificationFromServerWithId:completion:]");

#pragma mark - EM_DEPRECATED_IOS 3.2.3

/*!
 *  \~chinese
 *  添加回调代理
 *
 *  @param aDelegate  要添加的代理
 *
 *  \~english
 *  Add delegate
 *
 *  @param aDelegate  Delegate
 */
- (void)addDelegate:(id<EMChatroomManagerDelegate>)aDelegate EM_DEPRECATED_IOS(3_1_0, 3_2_2, "Use -[IEMChatroomManager addDelegate:delegateQueue:]");

#pragma mark - EM_DEPRECATED_IOS < 3.2.3

/*!
 *  \~chinese
 *  从服务器获取所有的聊天室
 *
 *  同步方法，会阻塞当前线程
 *
 *  @param pError   出错信息
 *
 *  @return 聊天室列表<EMChatroom>
 *
 *  \~english
 *  Get all the chatrooms from server
 *
 *  Synchronization method will block the current thread
 *
 *  @param pError   Error
 *
 *  @return Chat room list<EMChatroom>
 */
- (NSArray *)getAllChatroomsFromServerWithError:(EMError **)pError __deprecated_msg("Use -getChatroomsFromServerWithPage");

/*!
 *  \~chinese
 *  从服务器获取所有的聊天室
 *
 *  @param aCompletionBlock      完成的回调
 *
 *  \~english
 *  Get all the chatrooms from server
 *
 *  @param aCompletionBlock     The callback block of completion
 *
 */
- (void)getAllChatroomsFromServerWithCompletion:(void (^)(NSArray *aList, EMError *aError))aCompletionBlock __deprecated_msg("Use -getChatroomsFromServerWithPage");

/*!
 *  \~chinese
 *  从服务器获取所有的聊天室
 *
 *  @param aSuccessBlock         成功的回调
 *  @param aFailureBlock         失败的回调
 *
 *  \~english
 *  Get all the chatrooms from server
 *
 *  @param aSuccessBlock         The callback block of success
 *  @param aFailureBlock         The callback block of failure
 *
 */
- (void)asyncGetAllChatroomsFromServer:(void (^)(NSArray *aList))aSuccessBlock
                               failure:(void (^)(EMError *aError))aFailureBlock __deprecated_msg("Use -getAllChatroomsFromServerWithCompletion:");

/*!
 *  \~chinese
 *  加入聊天室
 *
 *  @param aChatroomId      聊天室的ID
 *  @param aSuccessBlock    成功的回调
 *  @param aFailureBlock    失败的回调
 *
 *
 *  \~english
 *  Join a chatroom
 *
 *  @param aChatroomId      Chatroom id
 *  @param aSuccessBlock    The callback block of success
 *  @param aFailureBlock    The callback block of failure
 *
 */
- (void)asyncJoinChatroom:(NSString *)aChatroomId
                  success:(void (^)(EMChatroom *aRoom))aSuccessBlock
                  failure:(void (^)(EMError *aError))aFailureBlock __deprecated_msg("Use -joinChatroom:completion:");

/*!
 *  \~chinese
 *  退出聊天室
 *
 *  @param aChatroomId          聊天室ID
 *  @param aSuccessBlock        成功的回调
 *  @param aFailureBlock        失败的回调
 *
 *  @result 退出的聊天室
 *
 *  \~english
 *  Leave a chatroom
 *
 *  @param aChatroomId      Chatroom id
 *  @param aSuccessBlock    The callback block of success
 *  @param aFailureBlock    The callback block of failure
 *
 *  @result Leaved chatroom
 */
- (void)asyncLeaveChatroom:(NSString *)aChatroomId
                   success:(void (^)(EMChatroom *aRoom))aSuccessBlock
                   failure:(void (^)(EMError *aError))aFailureBlock __deprecated_msg("Use -leaveChatroom:completion:");

/*!
 *  \~chinese
 *  获取聊天室详情
 *
 *  @param aChatroomId           聊天室ID
 *  @param aIncludeMembersList   是否获取成员列表
 *  @param aSuccessBlock         成功的回调
 *  @param aFailureBlock         失败的回调
 *
 *  \~english
 *  Fetch chatroom's specification
 *
 *  @param aChatroomId           Chatroom id
 *  @param aIncludeMembersList   Whether get member list
 *  @param aSuccessBlock         The callback block of success
 *  @param aFailureBlock         The callback block of failure
 *
 */
- (void)asyncFetchChatroomInfo:(NSString *)aChatroomId
            includeMembersList:(BOOL)aIncludeMembersList
                       success:(void (^)(EMChatroom *aChatroom))aSuccessBlock
                       failure:(void (^)(EMError *aError))aFailureBlock __deprecated_msg("Use -getChatroomSpecificationFromServerByID:includeMembersList:completion:");
@end
