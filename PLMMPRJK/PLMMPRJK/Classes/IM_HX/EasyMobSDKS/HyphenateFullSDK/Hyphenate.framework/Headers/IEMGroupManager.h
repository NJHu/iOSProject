/*!
 *  \~chinese
 *  @header IEMGroupManager.h
 *  @abstract 此协议定义了群组相关操作
 *  @author Hyphenate
 *  @version 3.00
 *
 *  \~english
 *  @header IEMGroupManager.h
 *  @abstract This protocol defines the group operations
 *  @author Hyphenate
 *  @version 3.00
 */

#import <Foundation/Foundation.h>

#import "EMCommonDefs.h"
#import "EMGroupManagerDelegate.h"
#import "EMGroup.h"
#import "EMGroupOptions.h"
#import "EMCursorResult.h"
#import "EMGroupSharedFile.h"

/*!
 *  \~chinese
 *  群组相关操作
 *
 *  \~english
 *  Group operations
 */
@protocol IEMGroupManager <NSObject>

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
- (void)addDelegate:(id<EMGroupManagerDelegate>)aDelegate
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
- (void)removeDelegate:(id)aDelegate;


#pragma mark - Get Group

/*!
 *  \~chinese
 *  获取用户所有群组
 *
 *  @result 群组列表<EMGroup>
 *
 *  \~english
 *  Get all groups
 *
 *  @result Group list<EMGroup>
 *
 */
- (NSArray *)getJoinedGroups;

/*!
 *  \~chinese
 *  从内存中获取屏蔽了推送的群组ID列表
 *
 *  @param pError  错误信息
 *
 *  \~english
 *  Get the list of groups which have disabled Apple Push Notification Service
 *
 *  @param pError  Error
 */
- (NSArray *)getGroupsWithoutPushNotification:(EMError **)pError;


#pragma mark - Get group from server

/*!
 *  \~chinese
 *  按数目从服务器获取自己加入的群组
 *
 *  同步方法，会阻塞当前线程
 *
 *  @param aPageNum  获取自己加入群的cursor，首次调用传空
 *  @param aPageSize 期望返回结果的数量, 如果 < 0 则一次返回所有结果
 *  @param pError    出错信息
 *
 *  @return 群组列表<EMGroup>
 *
 *  \~english
 *  Get pagesize number group you joined from the server.
 *
 *  Synchronization method will block the current thread
 *
 *  @param aPageNum         Page number
 *  @param aPageSize        Page size
 *  @param pError   Error
 *
 *  @return Group list<EMGroup>
 */
- (NSArray *)getJoinedGroupsFromServerWithPage:(NSInteger)aPageNum
                                      pageSize:(NSInteger)aPageSize
                                         error:(EMError **)pError;

/*!
 *  \~chinese
 *  按数目从服务器获取自己加入的群组
 *
 *  @param aPageNum  获取自己加入群的cursor，首次调用传空
 *  @param aPageSize 期望返回结果的数量, 如果 < 0 则一次返回所有结果
 *  @param aCompletionBlock      完成的回调
 *
 *  \~english
 *  Get pagesize number group you joined from the server.
 *
 *  @param aPageNum             Page number
 *  @param aPageSize            Page size
 *  @param aCompletionBlock     The callback block of completion
 *
 */

- (void)getJoinedGroupsFromServerWithPage:(NSInteger)aPageNum
                                 pageSize:(NSInteger)aPageSize
                               completion:(void (^)(NSArray *aList, EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  从服务器获取指定范围内的公开群
 *  
 *  同步方法，会阻塞当前线程
 *
 *  @param aCursor   获取公开群的cursor，首次调用传空
 *  @param aPageSize 期望返回结果的数量, 如果 < 0 则一次返回所有结果
 *  @param pError    出错信息
 *
 *  @return    获取的公开群结果
 *
 *  \~english
 *  Get public groups with the specified range from the server
 *
 *  Synchronization method will block the current thread
 *
 *  @param aCursor   Cursor, input nil the first time
 *  @param aPageSize Expect result count, return all results if count is less than zero
 *  @param pError    Error
 *
 *  @return    The result
 */
- (EMCursorResult *)getPublicGroupsFromServerWithCursor:(NSString *)aCursor
                                               pageSize:(NSInteger)aPageSize
                                                  error:(EMError **)pError;

/*!
 *  \~chinese
 *  从服务器获取指定范围内的公开群
 *
 *  @param aCursor          获取公开群的cursor，首次调用传空
 *  @param aPageSize        期望返回结果的数量, 如果 < 0 则一次返回所有结果
 *  @param aCompletionBlock 完成的回调
 *
 *
 *  \~english
 *  Get public groups with the specified range from the server
 *
 *  @param aCursor          Cursor, input nil the first time
 *  @param aPageSize        Expect result count, return all results if count is less than zero
 *  @param aCompletionBlock The callback block of completion
 *
 */
- (void)getPublicGroupsFromServerWithCursor:(NSString *)aCursor
                                   pageSize:(NSInteger)aPageSize
                                 completion:(void (^)(EMCursorResult *aResult, EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  根据群ID搜索公开群
 *
 *  同步方法，会阻塞当前线程
 *
 *  @param aGroundId   群组id
 *  @param pError      错误信息
 *
 *  @return 搜索到的群组
 *
 *  \~english
 *  Search a public group with the id
 *
 *  Synchronization method will block the current thread
 *
 *  @param aGroundId   Group id
 *  @param pError      Error
 *
 *  @return The group with the id
 */
- (EMGroup *)searchPublicGroupWithId:(NSString *)aGroundId
                               error:(EMError **)pError;

/*!
 *  \~chinese
 *  根据群ID搜索公开群
 *
 *  @param aGroundId        群组id
 *  @param aCompletionBlock 完成的回调
 *
 *
 *  \~english
 *  Search public group with group id
 *
 *  @param aGroundId        Group id
 *  @param aCompletionBlock The callback block of completion
 *
 */
- (void)searchPublicGroupWithId:(NSString *)aGroundId
                     completion:(void (^)(EMGroup *aGroup, EMError *aError))aCompletionBlock;

#pragma mark - Create

/*!
 *  \~chinese
 *  创建群组
 *  
 *  同步方法，会阻塞当前线程
 *
 *  @param aSubject        群组名称
 *  @param aDescription    群组描述
 *  @param aInvitees       群组成员（不包括创建者自己）
 *  @param aMessage        邀请消息
 *  @param aSetting        群组属性
 *  @param pError          出错信息
 *
 *  @return    创建的群组
 *
 *  \~english
 *  Create a group
 *
 *  Synchronization method will block the current thread
 *
 *  @param aSubject        Group subject
 *  @param aDescription    Group description
 *  @param aInvitees       Group members, without creater
 *  @param aMessage        Invitation message
 *  @param aSetting        Group options
 *  @param pError          Error
 *
 *  @return    Created group
 */
- (EMGroup *)createGroupWithSubject:(NSString *)aSubject
                        description:(NSString *)aDescription
                           invitees:(NSArray *)aInvitees
                            message:(NSString *)aMessage
                            setting:(EMGroupOptions *)aSetting
                              error:(EMError **)pError;

/*!
 *  \~chinese
 *  创建群组
 *
 *  @param aSubject         群组名称
 *  @param aDescription     群组描述
 *  @param aInvitees        群组成员（不包括创建者自己）
 *  @param aMessage         邀请消息
 *  @param aSetting         群组属性
 *  @param aCompletionBlock 完成的回调
 *
 *
 *  \~english
 *  Create a group
 *
 *  @param aSubject         Group subject
 *  @param aDescription     Group description
 *  @param aInvitees        Group members, without creater
 *  @param aMessage         Invitation message
 *  @param aSetting         Group options
 *  @param aCompletionBlock The callback block of completion
 *
 */
- (void)createGroupWithSubject:(NSString *)aSubject
                   description:(NSString *)aDescription
                      invitees:(NSArray *)aInvitees
                       message:(NSString *)aMessage
                       setting:(EMGroupOptions *)aSetting
                    completion:(void (^)(EMGroup *aGroup, EMError *aError))aCompletionBlock;

#pragma mark - Fetch Info

/*!
 *  \~chinese
 *  获取群组详情，包含群组ID,群组名称，群组描述，群组基本属性，群组Owner, 群组管理员
 *  
 *  同步方法，会阻塞当前线程
 *
 *  @param aGroupId              群组ID
 *  @param pError                错误信息
 *
 *  @return    群组
 *
 *  \~english
 *  Fetch group info，include ID, name, description，setting, owner, admins
 *
 *  Synchronization method will block the current thread
 *
 *  @param aGroupId              Group id
 *  @param pError                Error
 *
 *  @return    Group instance
 */
- (EMGroup *)getGroupSpecificationFromServerWithId:(NSString *)aGroupId
                                             error:(EMError **)pError;

/*!
 *  \~chinese
 *  获取群组详情,包含群组ID,群组名称，群组描述，群组基本属性，群组Owner, 群组管理员
 *
 *  @param aGroupId              群组ID
 *  @param aCompletionBlock      完成的回调
 *
 *
 *  \~english
 *  Fetch group specification, including: ID, name, description, setting, owner, admins
 *
 *  @param aGroupId              Group id
 *  @param aCompletionBlock      The callback block of completion
 *
 */
- (void)getGroupSpecificationFromServerWithId:(NSString *)aGroupId
                                   completion:(void (^)(EMGroup *aGroup, EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  获取群组成员列表
 *
 *  @param aGroupId         群组ID
 *  @param aCursor          游标，，首次调用传空
 *  @param aPageSize        获取多少条
 *  @param pError           错误信息
 *
 *  @return    列表和游标
 *
 *  \~english
 *  Get the list of group members from the server
 *
 *  @param aGroupId         Group id
 *  @param aCursor          Cursor, input nil the first time
 *  @param aPageSize        Page size
 *  @param pError           Error
 *
 *  @return    List and cursor
 *
 */
- (EMCursorResult *)getGroupMemberListFromServerWithId:(NSString *)aGroupId
                                                cursor:(NSString *)aCursor
                                              pageSize:(NSInteger)aPageSize
                                                 error:(EMError **)pError;

/*!
 *  \~chinese
 *  获取群组成员列表
 *
 *  @param aGroupId         群组ID
 *  @param aCursor          游标，首次调用传空
 *  @param aPageSize        获取多少条
 *  @param aCompletionBlock 完成的回调
 *
 *
 *  \~english
 *  Get the list of group members from the server
 *
 *  @param aGroupId         Group id
 *  @param aCursor          Cursor, input nil the first time
 *  @param aPageSize        Page size
 *  @param aCompletionBlock The callback block of completion
 *
 */
- (void)getGroupMemberListFromServerWithId:(NSString *)aGroupId
                                    cursor:(NSString *)aCursor
                                  pageSize:(NSInteger)aPageSize
                                completion:(void (^)(EMCursorResult *aResult, EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  获取群组黑名单列表, 需要owner/admin权限
 *
 *  @param aGroupId         群组ID
 *  @param aPageNum         获取第几页
 *  @param aPageSize        获取多少条
 *  @param pError           错误信息
 *
 *
 *  \~english
 *  Get the blacklist of group from the server, need owner / admin permissions
 *
 *  @param aGroupId         Group id
 *  @param aPageNum         Page number
 *  @param aPageSize        Page size
 *  @param pError           Error
 *
 */
- (NSArray *)getGroupBlacklistFromServerWithId:(NSString *)aGroupId
                                    pageNumber:(NSInteger)aPageNum
                                      pageSize:(NSInteger)aPageSize
                                         error:(EMError **)pError;

/*!
 *  \~chinese
 *  获取群组黑名单列表, 需要owner/admin权限
 *
 *  @param aGroupId         群组ID
 *  @param aPageNum         获取第几页
 *  @param aPageSize        获取多少条
 *  @param aCompletionBlock 完成的回调
 *
 *
 *  \~english
 *  Get group's blacklist, need owner / admin permissions
 *
 *  @param aGroupId         Group id
 *  @param aPageNum         Page number
 *  @param aPageSize        Page size
 *  @param aCompletionBlock The callback block of completion
 *
 */
- (void)getGroupBlacklistFromServerWithId:(NSString *)aGroupId
                               pageNumber:(NSInteger)aPageNum
                                 pageSize:(NSInteger)aPageSize
                               completion:(void (^)(NSArray *aList, EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  获取群组被禁言列表
 *
 *  @param aGroupId         群组ID
 *  @param aPageNum         获取第几页
 *  @param aPageSize        获取多少条
 *  @param pError           错误信息
 *
 *
 *  \~english
 *  Get the mutes of group  from the server
 *
 *  @param aGroupId         Group id
 *  @param aPageNum         Page number
 *  @param aPageSize        Page size
 *  @param pError           Error
 *
 */
- (NSArray *)getGroupMuteListFromServerWithId:(NSString *)aGroupId
                                   pageNumber:(NSInteger)aPageNum
                                     pageSize:(NSInteger)aPageSize
                                        error:(EMError **)pError;

/*!
 *  \~chinese
 *  获取群组被禁言列表
 *
 *  @param aGroupId         群组ID
 *  @param aPageNum         获取第几页
 *  @param aPageSize        获取多少条
 *  @param aCompletionBlock 完成的回调
 *
 *
 *  \~english
 *  Get the mutes of group  from the server
 *
 *  @param aGroupId         Group id
 *  @param aPageNum         Page number
 *  @param aPageSize        Page size
 *  @param aCompletionBlock The callback block of completion
 *
 */
- (void)getGroupMuteListFromServerWithId:(NSString *)aGroupId
                              pageNumber:(NSInteger)aPageNum
                                pageSize:(NSInteger)aPageSize
                              completion:(void (^)(NSArray *aList, EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  获取群共享文件列表
 *
 *  @param aGroupId         群组ID
 *  @param aPageNum         获取第几页
 *  @param aPageSize        获取多少条
 *  @param pError           错误信息
 *
 *  @result     群共享文件列表
 *
 *  \~english
 *  Get the share files of group from the server
 *
 *  @param aGroupId         Group id
 *  @param aPageNum         Page number
 *  @param aPageSize        Page size
 *  @param pError           error
 *
 *  @result    The share files of group
 */
- (NSArray *)getGroupFileListWithId:(NSString *)aGroupId
                         pageNumber:(NSInteger)aPageNum
                           pageSize:(NSInteger)aPageSize
                              error:(EMError **)pError;

/*!
 *  \~chinese
 *  获取群共享文件列表
 *
 *  @param aGroupId         群组ID
 *  @param aPageNum         获取第几页
 *  @param aPageSize        获取多少条
 *  @param aCompletionBlock 完成的回调
 *
 *  \~english
 *  Get the share files of group from the server
 *
 *  @param aGroupId         Group id
 *  @param aPageNum         Page number
 *  @param aPageSize        Page size
 *  @param aCompletionBlock The callback block of completion
 */
- (void)getGroupFileListWithId:(NSString *)aGroupId
                    pageNumber:(NSInteger)aPageNum
                      pageSize:(NSInteger)aPageSize
                    completion:(void (^)(NSArray *aList, EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  获取群公告
 *
 *  @param aGroupId         群组ID
 *  @param pError           错误信息
 *
 *  @result     群声明, 失败返回nil
 *
 *  \~english
 *  Get the announcement of group from the server
 *
 *  @param aGroupId         Group id
 *  @param pError           error
 *
 *  @result    Group Announcement, return nil if fail
 */
- (NSString *)getGroupAnnouncementWithId:(NSString *)aGroupId
                                   error:(EMError **)pError;

/*!
 *  \~chinese
 *  获取群公告
 *
 *  @param aGroupId         群组ID
 *  @param aCompletionBlock 完成的回调
 *
 *
 *  \~english
 *  Get the announcement of group from the server
 *
 *  @param aGroupId         Group id
 *  @param aCompletionBlock The callback block of completion
 *
 */
- (void)getGroupAnnouncementWithId:(NSString *)aGroupId
                        completion:(void (^)(NSString *aAnnouncement, EMError *aError))aCompletionBlock;

#pragma mark - Edit Group

/*!
 *  \~chinese
 *  邀请用户加入群组
 *  
 *  同步方法，会阻塞当前线程
 *
 *  @param aOccupants      被邀请的用户名列表
 *  @param aGroupId        群组ID
 *  @param aWelcomeMessage 欢迎信息
 *  @param pError          错误信息
 *
 *  @result    群组实例, 失败返回nil
 *
 *  \~english
 *  Invite User to join a group
 *
 *  Synchronization method will block the current thread
 *
 *  @param aOccupants      Invited users
 *  @param aGroupId        Group id
 *  @param aWelcomeMessage Welcome message
 *  @param pError          Error
 *
 *  @result    Group instance, return nil if fail
 */
- (EMGroup *)addOccupants:(NSArray *)aOccupants
                  toGroup:(NSString *)aGroupId
           welcomeMessage:(NSString *)aWelcomeMessage
                    error:(EMError **)pError;

/*!
 *  \~chinese
 *  邀请用户加入群组
 *
 *  @param aUsers           被邀请的用户名列表
 *  @param aGroupId         群组ID
 *  @param aMessage         欢迎信息
 *  @param aCompletionBlock 完成的回调
 *
 *
 *  \~english
 *  Invite User to join a group
 *
 *  @param aUsers           Invited users
 *  @param aGroupId         Group id
 *  @param aMessage         Welcome message
 *  @param aCompletionBlock The callback block of completion
 *
 */
- (void)addMembers:(NSArray *)aUsers
           toGroup:(NSString *)aGroupId
           message:(NSString *)aMessage
        completion:(void (^)(EMGroup *aGroup, EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  将群成员移出群组, 需要owner权限
 *  
 *  同步方法，会阻塞当前线程
 *
 *  @param aOccupants 要移出群组的用户列表
 *  @param aGroupId   群组ID
 *  @param pError     错误信息
 *
 *  @result    群组实例
 *
 *  \~english
 *  Remove members from a group, required owner‘s authority
 *
 *  Synchronization method will block the current thread
 *
 *  @param aOccupants Users to be removed
 *  @param aGroupId   Group id
 *  @param pError     Error
 *
 *  @result    Group instance
 */
- (EMGroup *)removeOccupants:(NSArray *)aOccupants
                   fromGroup:(NSString *)aGroupId
                       error:(EMError **)pError;

/*!
 *  \~chinese
 *  将群成员移出群组, 需要owner权限
 *
 *  @param aUsers           要移出群组的用户列表
 *  @param aGroupId         群组ID
 *  @param aCompletionBlock 完成的回调
 *
 *
 *  \~english
 *  Remove members from a group, owner‘s authority is required
 *
 *  @param aUsers           Users to be removed
 *  @param aGroupId         Group id
 *  @param aCompletionBlock The callback block of completion
 *
 */
- (void)removeMembers:(NSArray *)aUsers
            fromGroup:(NSString *)aGroupId
           completion:(void (^)(EMGroup *aGroup, EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  加人到群组黑名单, 需要owner权限
 *  
 *  同步方法，会阻塞当前线程
 *
 *  @param aOccupants 要加入黑名单的用户
 *  @param aGroupId   群组ID
 *  @param pError     错误信息
 *
 *  @result    群组实例
 *
 *  \~english
 *  Add users to group blacklist, required owner‘s authority
 *
 *  Synchronization method will block the current thread
 *
 *  @param aOccupants Users to be added
 *  @param aGroupId   Group id
 *  @param pError     Error
 *
 *  @result    Group instance
 */
- (EMGroup *)blockOccupants:(NSArray *)aOccupants
                  fromGroup:(NSString *)aGroupId
                      error:(EMError **)pError;

/*!
 *  \~chinese
 *  加人到群组黑名单, 需要owner权限
 *
 *  @param aMembers         要加入黑名单的用户
 *  @param aGroupId         群组ID
 *  @param aCompletionBlock 完成的回调
 *
 *
 *  \~english
 *  Add users to group blacklist, owner‘s authority is required
 *
 *  @param aMembers         Users to be added
 *  @param aGroupId         Group id
 *  @param aCompletionBlock The callback block of completion
 *
 */
- (void)blockMembers:(NSArray *)aMembers
           fromGroup:(NSString *)aGroupId
          completion:(void (^)(EMGroup *aGroup, EMError *aError))aCompletionBlock;


/*!
 *  \~chinese
 *  从群组黑名单中减人, 需要owner权限
 *  
 *  同步方法，会阻塞当前线程
 *
 *  @param aOccupants 要从黑名单中移除的用户名列表
 *  @param aGroupId   群组ID
 *  @param pError     错误信息
 *
 *  @result    群组对象
 *
 *  \~english
 *  Remove users from group blacklist, required owner‘s authority
 *
 *  Synchronization method will block the current thread
 *
 *  @param aOccupants Users to be removed
 *  @param aGroupId   Group id
 *  @param pError     Error
 *
 *  @result    Group instance
 */
- (EMGroup *)unblockOccupants:(NSArray *)aOccupants
                     forGroup:(NSString *)aGroupId
                        error:(EMError **)pError;

/*!
 *  \~chinese
 *  从群组黑名单中减人, 需要owner权限
 *
 *  @param aMembers         要从黑名单中移除的用户名列表
 *  @param aGroupId         群组ID
 *  @param aCompletionBlock 完成的回调
 *
 *
 *  \~english
 *  Remove users out of group blacklist, owner‘s authority is required
 *
 *  @param aMembers         Users to be removed
 *  @param aGroupId         Group id
 *  @param aCompletionBlock The callback block of completion
 *
 */
- (void)unblockMembers:(NSArray *)aMembers
             fromGroup:(NSString *)aGroupId
            completion:(void (^)(EMGroup *aGroup, EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  更改群组主题, 需要owner权限
 *  
 *  同步方法，会阻塞当前线程
 *
 *  @param aSubject  新主题
 *  @param aGroupId  群组ID
 *  @param pError    错误信息
 *
 *  @result    群组对象
 *
 *  \~english
 *  Change group subject, owner‘s authority is required
 *
 *  Synchronization method will block the current thread
 *
 *  @param aSubject  New group subject
 *  @param aGroupId  Group id
 *  @param pError    Error
 *
 *  @result    Group instance
 */
- (EMGroup *)changeGroupSubject:(NSString *)aSubject
                       forGroup:(NSString *)aGroupId
                          error:(EMError **)pError;

/*!
 *  \~chinese
 *  更改群组主题, 需要owner权限
 *
 *  @param aSubject         新主题
 *  @param aGroupId         群组ID
 *  @param aCompletionBlock 完成的回调
 *
 *
 *  \~english
 *  Change the group subject, owner‘s authority is required
 *
 *  @param aSubject         New group‘s subject
 *  @param aGroupId         Group id
 *  @param aCompletionBlock The callback block of completion
 *
 */
- (void)updateGroupSubject:(NSString *)aSubject
                  forGroup:(NSString *)aGroupId
                completion:(void (^)(EMGroup *aGroup, EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  更改群组说明信息, 需要owner权限
 *  
 *  同步方法，会阻塞当前线程
 *
 *  @param aDescription 说明信息
 *  @param aGroupId     群组ID
 *  @param pError       错误信息
 *
 *  @result    群组对象
 *
 *  \~english
 *  Change group description, owner‘s authority is required
 *
 *  Synchronization method will block the current thread
 *
 *  @param aDescription New group description
 *  @param aGroupId     Group id
 *  @param pError       Error
 *
 *  @result    Group
 */
- (EMGroup *)changeDescription:(NSString *)aDescription
                      forGroup:(NSString *)aGroupId
                         error:(EMError **)pError;

/*!
 *  \~chinese
 *  更改群组说明信息, 需要owner权限
 *
 *  @param aDescription     说明信息
 *  @param aGroupId         群组ID
 *  @param aCompletionBlock 完成的回调
 *
 *
 *  \~english
 *  Change the group description, owner‘s authority is required
 *
 *  @param aDescription     New group‘s description
 *  @param aGroupId         Group id
 *  @param aCompletionBlock The callback block of completion
 *
 */
- (void)updateDescription:(NSString *)aDescription
                 forGroup:(NSString *)aGroupId
               completion:(void (^)(EMGroup *aGroup, EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  退出群组，owner不能退出群，只能销毁群
 *  
 *  同步方法，会阻塞当前线程
 *
 *  @param aGroupId  群组ID
 *  @param pError    错误信息
 *
 *
 *  \~english
 *  Leave a group, owner can't leave the group, can only destroy the group
 *
 *  Synchronization method will block the current thread
 *
 *  @param aGroupId  Group id
 *  @param pError    Error
 *
 */
- (void)leaveGroup:(NSString *)aGroupId
             error:(EMError **)pError;

/*!
 *  \~chinese
 *  退出群组，owner不能退出群，只能销毁群
 *
 *  @param aGroupId         群组ID
 *  @param aCompletionBlock 完成的回调
 *
 *
 *  \~english
 *  Leave a group, owner can't leave the group, can only destroy the group
 *
 *  @param aGroupId         Group id
 *  @param aCompletionBlock The callback block of completion
 *
 */
- (void)leaveGroup:(NSString *)aGroupId
        completion:(void (^)(EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  解散群组, 需要owner权限
 *  
 *  同步方法，会阻塞当前线程
 *
 *  @param aGroupId  群组ID
 *
 *  @result    错误信息, 成功返回nil
 *
 *  \~english
 *  Destroy a group, owner‘s authority is required
 *
 *  Synchronization method will block the current thread
 *
 *  @param aGroupId  Group id
 *
 *  @result    Error, return nil if success
 */
- (EMError *)destroyGroup:(NSString *)aGroupId;

/*!
 *  \~chinese
 *  解散群组, 需要owner权限
 *
 *  @param aGroupId         群组ID
 *  @param aCompletionBlock 完成的回调
 *
 *  \~english
 *  Destroy a group, owner‘s authority is required
 *
 *  @param aGroupId         Group id
 *  @param aCompletionBlock The callback block of completion
 *
 */
- (void)destroyGroup:(NSString *)aGroupId
    finishCompletion:(void (^)(EMError *aError))aCompletionBlock;


/*!
 *  \~chinese
 *  屏蔽群消息，服务器不再发送此群的消息给用户，owner不能屏蔽群消息
 *  
 *  同步方法，会阻塞当前线程
 *
 *  @param aGroupId   要屏蔽的群ID
 *  @param pError     错误信息
 *
 *  @result           群组实例
 *
 *  \~english
 *  Block group messages, server will blocks the messages from the group, owner can't block the group's message
 *
 *  Synchronization method will block the current thread
 *
 *  @param aGroupId   Group id
 *  @param pError     Error
 *
 *  @result    Group instance
 */
- (EMGroup *)blockGroup:(NSString *)aGroupId
                  error:(EMError **)pError;

/*!
 *  \~chinese
 *  屏蔽群消息，服务器不再发送此群的消息给用户，owner不能屏蔽群消息
 *
 *  @param aGroupId         要屏蔽的群ID
 *  @param aCompletionBlock 完成的回调
 *
 *  \~english
 *  Block group messages, server blocks the messages from the group, owner can't block the group's messages
 *
 *  @param aGroupId         Group id
 *  @param aCompletionBlock The callback block of completion
 *
 */
- (void)blockGroup:(NSString *)aGroupId
        completion:(void (^)(EMGroup *aGroup, EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  取消屏蔽群消息
 *  
 *  同步方法，会阻塞当前线程
 *
 *  @param aGroupId   要取消屏蔽的群ID
 *  @param pError     错误信息
 *
 *  @result    返回群组实例
 *
 *  \~english
 *  Unblock group messages
 *
 *  Synchronization method will block the current thread
 *
 *  @param aGroupId   Group id
 *  @param pError     Error
 *
 *  @result    Group instance
 */
- (EMGroup *)unblockGroup:(NSString *)aGroupId
                    error:(EMError **)pError;

/*!
 *  \~chinese
 *  取消屏蔽群消息
 *
 *  @param aGroupId         要取消屏蔽的群ID
 *  @param aCompletionBlock 完成的回调
 *
 *  \~english
 *  Unblock group message
 *
 *  @param aGroupId         Group id
 *  @param aCompletionBlock The callback block of completion
 *
 */
- (void)unblockGroup:(NSString *)aGroupId
          completion:(void (^)(EMGroup *aGroup, EMError *aError))aCompletionBlock;


/*!
 *  \~chinese
 *  改变群主，需要Owner权限
 *
 *  同步方法，会阻塞当前线程
 *
 *  @param aGroupId   群ID
 *  @param aNewOwner  新群主
 *  @param pError     错误信息
 *
 *  @result    返回群组实例
 *
 *  \~english
 *  Change group owner, need Owner permissions
 *
 *  Synchronization method will block the current thread
 *
 *  @param aGroupId   Group id
 *  @param aNewOwner  New group owner
 *  @param pError     Error
 *
 *  @result    Group instance
 */
- (EMGroup *)updateGroupOwner:(NSString *)aGroupId
                     newOwner:(NSString *)aNewOwner
                        error:(EMError **)pError;

/*!
 *  \~chinese
 *  改变群主，需要Owner权限
 *
 *  @param aGroupId   群ID
 *  @param aNewOwner  新群主
 *  @param aCompletionBlock 完成的回调
 *
 *
 *  \~english
 *  Change group owner, need Owner permissions
 *
 *  @param aGroupId   Group id
 *  @param aNewOwner  New group owner
 *  @param aCompletionBlock The callback block of completion
 *
 */
- (void)updateGroupOwner:(NSString *)aGroupId
                newOwner:(NSString *)aNewOwner
              completion:(void (^)(EMGroup *aGroup, EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  添加群组管理员，需要Owner权限
 *
 *  同步方法，会阻塞当前线程
 *
 *  @param aAdmin     要添加的群组管理员
 *  @param aGroupId   群ID
 *  @param pError     错误信息
 *  @result           返回群组实例
 *
 *  \~english
 *  Add group admin, need Owner permissions
 *
 *  Synchronization method will block the current thread
 *
 *  @param aAdmin     Admin
 *  @param aGroupId   Group id
 *  @param pError     Error
 *  @result           Group instance
 */
- (EMGroup *)addAdmin:(NSString *)aAdmin
              toGroup:(NSString *)aGroupId
                error:(EMError **)pError;

/*!
 *  \~chinese
 *  添加群组管理员，需要Owner权限
 *
 *  @param aAdmin     要添加的群组管理员
 *  @param aGroupId   群ID
 *  @param aCompletionBlock 完成的回调
 *
 *
 *  \~english
 *  Add group admin, need Owner permissions
 *
 *  @param aAdmin     Admin
 *  @param aGroupId   Group id
 *  @param aCompletionBlock The callback block of completion
 *
 */
- (void)addAdmin:(NSString *)aAdmin
         toGroup:(NSString *)aGroupId
      completion:(void (^)(EMGroup *aGroup, EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  移除群组管理员，需要Owner权限
 *
 *  同步方法，会阻塞当前线程
 *
 *  @param aAdmin     要移除的群组管理员
 *  @param aGroupId   群ID
 *  @param pError     错误信息
 *
 *  @result    返回群组实例
 *
 *  \~english
 *  Remove group admin, need Owner permissions
 *
 *  Synchronization method will block the current thread
 *
 *  @param aAdmin     Admin
 *  @param aGroupId   Group id
 *  @param pError     Error
 *
 *  @result    Group instance
 */
- (EMGroup *)removeAdmin:(NSString *)aAdmin
               fromGroup:(NSString *)aGroupId
                   error:(EMError **)pError;

/*!
 *  \~chinese
 *  移除群组管理员，需要Owner权限
 *
 *  @param aAdmin     要移除的群组管理员
 *  @param aGroupId   群ID
 *  @param aCompletionBlock 完成的回调
 *
 *
 *  \~english
 *  Remove group admin, need Owner permissions
 *
 *  @param aAdmin     Admin
 *  @param aGroupId   Group id
 *  @param aCompletionBlock The callback block of completion
 *
 */
- (void)removeAdmin:(NSString *)aAdmin
          fromGroup:(NSString *)aGroupId
         completion:(void (^)(EMGroup *aGroup, EMError *aError))aCompletionBlock;


/*!
 *  \~chinese
 *  将一组成员禁言，需要Owner / Admin权限
 *
 *  同步方法，会阻塞当前线程
 *
 *  @param aMuteMembers         要禁言的成员列表<NSString>
 *  @param aMuteMilliseconds    禁言时长
 *  @param aGroupId             群ID
 *  @param pError               错误信息
 *
 *  @result    返回群组实例
 *
 *  \~english
 *  Mute group members, need Owner / Admin permissions
 *
 *  Synchronization method will block the current thread
 *
 *  @param aMuteMembers         The list of mute, type is <NSString>
 *  @param aMuteMilliseconds    Muted time duration in millisecond
 *  @param aGroupId             Group id
 *  @param pError               Error
 *
 *  @result    Group instance
 */
- (EMGroup *)muteMembers:(NSArray *)aMuteMembers
        muteMilliseconds:(NSInteger)aMuteMilliseconds
               fromGroup:(NSString *)aGroupId
                   error:(EMError **)pError;

/*!
 *  \~chinese
 *  将一组成员禁言，需要Owner / Admin权限
 *
 *  @param aMuteMembers         要禁言的成员列表<NSString>
 *  @param aMuteMilliseconds    禁言时长
 *  @param aGroupId             群ID
 *  @param aCompletionBlock     完成的回调
 *
 *  \~english
 *  Mute group members, need Owner / Admin permissions
 *
 *  Synchronization method will block the current thread
 *
 *  @param aMuteMembers         The list of mute, type is <NSString>
 *  @param aMuteMilliseconds    Muted time duration in millisecond
 *  @param aGroupId             Group id
 *  @param aCompletionBlock     The callback block of completion
 *
 */
- (void)muteMembers:(NSArray *)aMuteMembers
   muteMilliseconds:(NSInteger)aMuteMilliseconds
          fromGroup:(NSString *)aGroupId
         completion:(void (^)(EMGroup *aGroup, EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  解除禁言，需要Owner / Admin权限
 *
 *  同步方法，会阻塞当前线程
 *
 *  @param aMuteMembers     被解除的列表<NSString>
 *  @param aGroupId         群ID
 *  @param pError           错误信息
 *
 *  @result    返回群组实例
 *
 *  \~english
 *  Unmute group members, need Owner / Admin permissions
 *
 *  Synchronization method will block the current thread
 *
 *  @param aMembers         The list of unmute, type is <NSString>
 *  @param aGroupId         Group id
 *  @param pError           Error
 *
 *  @result    Group instance
 */
- (EMGroup *)unmuteMembers:(NSArray *)aMembers
                 fromGroup:(NSString *)aGroupId
                     error:(EMError **)pError;

/*!
 *  \~chinese
 *  解除禁言，需要Owner / Admin权限
 *
 *  @param aMuteMembers     被解除的列表<NSString>
 *  @param aGroupId         群ID
 *  @param aCompletionBlock 完成的回调
 *
 *  \~english
 *  Unmute group members, need Owner / Admin permissions
 *
 *  Synchronization method will block the current thread
 *
 *  @param aMembers         The list of unmute, type is <NSString>
 *  @param aGroupId         Group id
 *  @param aCompletionBlock The callback block of completion
 *
 */
- (void)unmuteMembers:(NSArray *)aMembers
            fromGroup:(NSString *)aGroupId
           completion:(void (^)(EMGroup *aGroup, EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  上传群共享文件
 *
 *  @param aGroupId         群ID
 *  @param aFilePath        文件路径
 *  @param pError           错误信息
 *
 *  @result    群实例
 *
 *  \~english
 *  Upload the share file of group
 *
 *  @param aGroupId         Group id
 *  @param aFilePath        Path of file
 *  @param pError           error
 *
 *  @result    Group instance
 */
- (void)uploadGroupSharedFileWithId:(NSString *)aGroupId
                           filePath:(NSString*)aFilePath
                           progress:(void (^)(int progress))aProgressBlock
                         completion:(void (^)(EMGroupSharedFile *aSharedFile, EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  下载群共享文件
 *
 *  @param aGroupId         群ID
 *  @param aFilePath        文件路径
 *  @param aSharedFileId    共享文件ID
 *  @param aProgressBlock   文件下载进度回调block
 *  @param aCompletionBlock 完成回调block
 *
 *  \~english
 *  Download the share file of group
 *
 *  @param aGroupId         Group id
 *  @param aFilePath        Path of file
 *  @param aSharedFileId    share file id
 *  @param aProgressBlock   The block of attachment upload progress
 *  @param aCompletionBlock The callback block of completion
 */
- (void)downloadGroupSharedFileWithId:(NSString *)aGroupId
                             filePath:(NSString *)aFilePath
                         sharedFileId:(NSString *)aSharedFileId
                             progress:(void (^)(int progress))aProgressBlock
                           completion:(void (^)(EMGroup *aGroup, EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  删除群共享文件
 *
 *  @param aGroupId         群ID
 *  @param aSharedFileId    共享文件ID
 *  @param pError           错误信息
 *
 *  @result    群实例
 *
 *  \~english
 *  Remove the share file of group
 *
 *  Synchronization method will block the current thread
 *
 *  @param aGroupId         Group id
 *  @param aSharedFileId    share file Id
 *  @param pError           error
 *
 *  @result    Group instance
 */
- (EMGroup *)removeGroupSharedFileWithId:(NSString *)aGroupId
                            sharedFileId:(NSString *)aSharedFileId
                                   error:(EMError **)pError;

/*!
 *  \~chinese
 *  删除群共享文件
 *
 *  @param aGroupId         群ID
 *  @param aSharedFileId    共享文件ID
 *  @param aCompletionBlock 完成的回调
 *
 *  \~english
 *  Remove the share file of group
 *
 *  @param aGroupId         Group id
 *  @param aSharedFileId    share file Id
 *  @param aCompletionBlock The callback block of completion
 */
- (void)removeGroupSharedFileWithId:(NSString *)aGroupId
                       sharedFileId:(NSString *)aSharedFileId
                         completion:(void (^)(EMGroup *aGroup, EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  修改群公告，需要Owner / Admin权限
 *
 *  @param aGroupId         群ID
 *  @param aAnnouncement    群公告
 *  @param pError           错误信息
 *
 *  @result    群实例
 *
 *  \~english
 *  Update the announcement of group, need Owner / Admin permissions
 *
 *  Synchronization method will block the current thread
 *
 *  @param aGroupId         Group id
 *  @param aAnnouncement    announcement of group
 *  @param pError           error
 *
 *  @result    Group instance
 */
- (EMGroup *)updateGroupAnnouncementWithId:(NSString *)aGroupId
                              announcement:(NSString *)aAnnouncement
                                     error:(EMError **)pError;

/*!
 *  \~chinese
 *  修改群公告，需要Owner / Admin权限
 *
 *  @param aGroupId         群ID
 *  @param aAnnouncement    群公告
 *  @param aCompletionBlock 完成的回调
 *
 *  \~english
 *  Update the announcement of group, need Owner / Admin permissions
 *
 *  @param aGroupId         Group id
 *  @param aAnnouncement    announcement of group
 *  @param aCompletionBlock The callback block of completion
 *
 */
- (void)updateGroupAnnouncementWithId:(NSString *)aGroupId
                         announcement:(NSString *)aAnnouncement
                           completion:(void (^)(EMGroup *aGroup, EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  修改群扩展信息，需要Owner权限
 *
 *  @param aGroupId         群ID
 *  @param aExt             扩展信息
 *  @param pError           错误信息
 *
 *  @result    群实例
 *
 *  \~english
 *  Update the extended of the group, need Owner
 *
 *  Synchronization method will block the current thread
 *
 *  @param aGroupId         Group id
 *  @param aExt             Extended of the group
 *  @param pError           error
 *
 *  @result    Group instance
 */
- (EMGroup *)updateGroupExtWithId:(NSString *)aGroupId
                              ext:(NSString *)aExt
                            error:(EMError **)pError;

/*!
 *  \~chinese
 *  修改群扩展信息，需要Owner权限
 *
 *  @param aGroupId         群ID
 *  @param aExt             扩展信息
 *  @param aCompletionBlock 完成的回调
 *
 *  \~english
 *  Update the extended of the group, need Owner
 *
 *  @param aGroupId         Group id
 *  @param aExt             Extended of the group
 *  @param aCompletionBlock The callback block of completion
 *
 */
- (void)updateGroupExtWithId:(NSString *)aGroupId
                         ext:(NSString *)aExt
                  completion:(void (^)(EMGroup *aGroup, EMError *aError))aCompletionBlock;

#pragma mark - Edit Public Group

/*!
 *  \~chinese
 *  加入一个公开群组，群类型应该是EMGroupStylePublicOpenJoin
 *  
 *  同步方法，会阻塞当前线程
 *
 *  @param aGroupId 公开群组的ID
 *  @param pError   错误信息
 *
 *  @result    所加入的公开群组
 *
 *  \~english
 *  Join a public group, group style should be EMGroupStylePublicOpenJoin
 *
 *  Synchronization method will block the current thread
 *
 *  @param aGroupId Public group id
 *  @param pError   Error
 *
 *  @result    Joined public group
 */
- (EMGroup *)joinPublicGroup:(NSString *)aGroupId
                       error:(EMError **)pError;

/*!
 *  \~chinese
 *  加入一个公开群组，群类型应该是EMGroupStylePublicOpenJoin
 *
 *  @param aGroupId         公开群组的ID
 *  @param aCompletionBlock 完成的回调
 *
 *  \~english
 *  Join a public group, group style should be EMGroupStylePublicOpenJoin
 *
 *  @param aGroupId         Public group id
 *  @param aCompletionBlock The callback block of completion
 *
 */
- (void)joinPublicGroup:(NSString *)aGroupId
             completion:(void (^)(EMGroup *aGroup, EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  申请加入一个需批准的公开群组，群类型应该是EMGroupStylePublicJoinNeedApproval
 *
 *  同步方法，会阻塞当前线程
 *
 *  @param aGroupId    公开群组的ID
 *  @param aMessage    请求加入的信息
 *  @param pError      错误信息
 *
 *  @result    申请加入的公开群组
 *
 *  \~english
 *  Request to join a public group, group style should be EMGroupStylePublicJoinNeedApproval
 *
 *  Synchronization method will block the current thread
 *
 *  @param aGroupId    Public group id
 *  @param aMessage    Request info
 *  @param pError      Error
 *
 *  @result    Group instance
 */
- (EMGroup *)applyJoinPublicGroup:(NSString *)aGroupId
                          message:(NSString *)aMessage
                            error:(EMError **)pError;

/*!
 *  \~chinese
 *  申请加入一个需批准的公开群组，群类型应该是EMGroupStylePublicJoinNeedApproval
 *
 *  @param aGroupId         公开群组的ID
 *  @param aMessage         请求加入的信息
 *  @param aCompletionBlock 完成的回调
 *
 *
 *  \~english
 *  Request to join a public group, group style should be EMGroupStylePublicJoinNeedApproval
 *
 *  @param aGroupId         Public group id
 *  @param aMessage         Apply info
 *  @param aCompletionBlock The callback block of completion
 *
 */
- (void)requestToJoinPublicGroup:(NSString *)aGroupId
                         message:(NSString *)aMessage
                      completion:(void (^)(EMGroup *aGroup, EMError *aError))aCompletionBlock;

#pragma mark - Application

/*!
 *  \~chinese
 *  批准入群申请, 需要Owner权限
 *  
 *  同步方法，会阻塞当前线程
 *
 *  @param aGroupId   所申请的群组ID
 *  @param aUsername  申请人
 *
 *  @result 错误信息
 *
 *  \~english
 *  Accept a group request, owner‘s authority is required
 *
 *  Synchronization method will block the current thread
 *
 *  @param aGroupId   Group id
 *  @param aUsername  The applicant
 *
 *  @result Error
 */
- (EMError *)acceptJoinApplication:(NSString *)aGroupId
                         applicant:(NSString *)aUsername;

/*!
 *  \~chinese
 *  批准入群申请, 需要Owner权限
 *
 *  @param aGroupId         所申请的群组ID
 *  @param aUsername        申请人
 *  @param aCompletionBlock 完成的回调
 *
 *
 *  \~english
 *  Approve a group request, owner‘s authority is required
 *
 *  @param aGroupId         Group id
 *  @param aUsername        Group request sender
 *  @param aCompletionBlock The callback block of completion
 *
 */
- (void)approveJoinGroupRequest:(NSString *)aGroupId
                         sender:(NSString *)aUsername
                     completion:(void (^)(EMGroup *aGroup, EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  拒绝入群申请, 需要Owner权限
 *
 *  同步方法，会阻塞当前线程
 *
 *  @param aGroupId  被拒绝的群组ID
 *  @param aUsername 申请人
 *  @param aReason   拒绝理由
 *
 *  @result 错误信息
 *
 *  \~english
 *  Decline a group request, owner‘s authority is required
 *
 *  Synchronization method will block the current thread
 *
 *  @param aGroupId  Group id
 *  @param aUsername Group request sender
 *  @param aReason   Decline reason
 *
 *  @result Error
 */
- (EMError *)declineJoinApplication:(NSString *)aGroupId
                          applicant:(NSString *)aUsername
                             reason:(NSString *)aReason;

/*!
 *  \~chinese
 *  拒绝入群申请, 需要Owner权限
 *
 *  @param aGroupId         被拒绝的群组ID
 *  @param aUsername        申请人
 *  @param aReason          拒绝理由
 *  @param aCompletionBlock 完成的回调
 *
 *
 *  \~english
 *  Decline a group request, owner‘s authority is required
 *
 *  @param aGroupId         Group id
 *  @param aUsername        Group request sender
 *  @param aReason          Decline reason
 *  @param aCompletionBlock The callback block of completion
 *
 */
- (void)declineJoinGroupRequest:(NSString *)aGroupId
                         sender:(NSString *)aUsername
                         reason:(NSString *)aReason
                     completion:(void (^)(EMGroup *aGroup, EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  接受入群邀请
 *
 *  同步方法，会阻塞当前线程
 *
 *  @param groupId     接受的群组ID
 *  @param aUsername   邀请者
 *  @param pError      错误信息
 *
 *  @result 接受的群组实例
 *
 *  \~english
 *  Accept a group invitation
 *
 *  Synchronization method will block the current thread
 *
 *  @param aGroupId     Group id
 *  @param aUsername    Inviter
 *  @param pError       Error
 *
 *  @result Joined group instance
 */
- (EMGroup *)acceptInvitationFromGroup:(NSString *)aGroupId
                               inviter:(NSString *)aUsername
                                 error:(EMError **)pError;

/*!
 *  \~chinese
 *  接受入群邀请
 *
 *  @param groupId          接受的群组ID
 *  @param aUsername        邀请者
 *  @param pError           错误信息
 *  @param aCompletionBlock 完成的回调
 *
 *
 *  \~english
 *  Accept a group invitation
 *
 *  @param aGroupId         Group id
 *  @param aUsername        Inviter
 *  @param aCompletionBlock The callback block of completion
 *
 */
- (void)acceptInvitationFromGroup:(NSString *)aGroupId
                          inviter:(NSString *)aUsername
                       completion:(void (^)(EMGroup *aGroup, EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  拒绝入群邀请
 *  
 *  同步方法，会阻塞当前线程
 *
 *  @param aGroupId  被拒绝的群组ID
 *  @param aUsername 邀请人
 *  @param aReason   拒绝理由
 *
 *  @result 错误信息
 *
 *  \~english
 *  Decline a group invitation
 *
 *  Synchronization method will block the current thread
 *
 *  @param aGroupId  Group id
 *  @param aUsername Inviter
 *  @param aReason   Decline reason
 *
 *  @result Error
 */
- (EMError *)declineInvitationFromGroup:(NSString *)aGroupId
                                inviter:(NSString *)aUsername
                                 reason:(NSString *)aReason;

/*!
 *  \~chinese
 *  拒绝入群邀请
 *
 *  @param aGroupId         被拒绝的群组ID
 *  @param aInviter         邀请人
 *  @param aReason          拒绝理由
 *  @param aCompletionBlock 完成的回调
 *
 *
 *  \~english
 *  Decline a group invitation
 *
 *  @param aGroupId         Group id
 *  @param aInviter         Inviter
 *  @param aReason          Decline reason
 *  @param aCompletionBlock The callback block of completion
 *
 */
- (void)declineGroupInvitation:(NSString *)aGroupId
                       inviter:(NSString *)aInviter
                        reason:(NSString *)aReason
                    completion:(void (^)(EMError *aError))aCompletionBlock;

#pragma mark - Apns

/*!
 *  \~chinese
 *  屏蔽/取消屏蔽群组消息的推送
 *  
 *  同步方法，会阻塞当前线程
 *
 *  @param aGroupId    群组ID
 *  @param aIgnore     是否屏蔽
 *
 *  @result 错误信息
 *
 *  \~english
 *  Block/unblock group message‘s push notification
 *
 *  Synchronization method will block the current thread
 *
 *  @param aGroupId     Group id
 *  @param aIsIgnore    Show/ignore push notificatino
 *
 *  @result Error
 */
- (EMError *)ignoreGroupPush:(NSString *)aGroupId
                      ignore:(BOOL)aIsIgnore;


/*!
 *  \~chinese
 *  屏蔽/取消屏蔽群组消息的推送
 *
 *  同步方法，会阻塞当前线程
 *
 *  @param aGroupIDs   群组ID列表
 *  @param aIgnore     是否屏蔽
 *
 *  @result 错误信息
 *
 *  \~english
 *  Block/unblock group message‘s push notification
 *
 *  Synchronization method will block the current thread
 *
 *  @param aGroupIDs    Group ids list
 *  @param aIsIgnore    Show or ignore push notification
 *
 *  @result Error
 */
- (EMError *)ignoreGroupsPush:(NSArray *)aGroupIDs
                       ignore:(BOOL)aIsIgnore;

/*!
 *  \~chinese
 *  屏蔽/取消屏蔽群组消息的推送
 *
 *  @param aGroupId          群组ID
 *  @param aIsEnable         是否允许推送
 *  @param aCompletionBlock  完成的回调
 *
 *
 *  \~english
 *  Block/unblock group message‘s push notification
 *
 *  @param aGroupId          Group id
 *  @param aIsEnable         Whether enable
 *  @param aCompletionBlock  The callback block of completion
 *
 */
- (void)updatePushServiceForGroup:(NSString *)aGroupId
                    isPushEnabled:(BOOL)aIsEnable
                       completion:(void (^)(EMGroup *aGroup, EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  屏蔽/取消屏蔽群组消息的推送
 *
 *  @param aGroupIDs         群组ID列表
 *  @param aIsEnable         是否允许推送
 *  @param aCompletionBlock  完成的回调
 *
 *
 *  \~english
 *  Block/unblock group message‘s push notification
 *
 *  @param aGroupIDs         Group ids list
 *  @param aIsEnable         Whether enable
 *  @param aCompletionBlock  The callback block of completion
 *
 */
- (void)updatePushServiceForGroups:(NSArray *)aGroupIDs
                     isPushEnabled:(BOOL)aIsEnable
                        completion:(void (^)(NSArray *groups, EMError *aError))aCompletionBlock;

#pragma mark - EM_DEPRECATED_IOS 3.3.0

/**
 *  \~chinese
 *  从服务器获取用户所有的群组，成功后更新DB和内存中的群组列表
 *
 *  同步方法，会阻塞当前线程
 *
 *  @param pError  错误信息
 *
 *  @return 群组列表<EMGroup>
 *
 *  \~english
 *  Get all of user's groups from server
 *
 *  Synchronization method will block the current thread
 *
 *  @param pError  Error
 *
 *  @result Group list<EMGroup>
 */
- (NSArray *)getMyGroupsFromServerWithError:(EMError **)pError EM_DEPRECATED_IOS(3_1_0, 3_3_0, "Use -[IEMGroupManager getJoinedGroupsFromServerWithPage:pageSize:error:]");

/**
 *  \~chinese
 *  从服务器获取用户所有的群组，成功后更新DB和内存中的群组列表
 *
 *  @param aCompletionBlock 完成的回调
 *
 *
 *  \~english
 *  Get all of user's groups from server
 *
 *  @param aCompletionBlock The callback block of completion
 *
 */
- (void)getJoinedGroupsFromServerWithCompletion:(void (^)(NSArray *aList, EMError *aError))aCompletionBlock EM_DEPRECATED_IOS(3_1_0, 3_3_0, "Use -[IEMGroupManager getJoinedGroupsFromServerWithPage:pageSize:completion:]");

/*!
 *  \~chinese
 *  获取群组详情
 *
 *  同步方法，会阻塞当前线程
 *
 *  @param aGroupId              群组ID
 *  @param aIncludeMembersList   是否获取成员列表，为YES时，返回200个成员
 *  @param pError                错误信息
 *
 *  @return    群组
 *
 *  \~english
 *  Fetch group info
 *
 *  Synchronization method will block the current thread
 *
 *  @param aGroupId              Group id
 *  @param aIncludeMembersList   Whether to get member list，When YES, returns 200 members
 *  @param pError                Error
 *
 *  @return    Group instance
 */
- (EMGroup *)fetchGroupInfo:(NSString *)aGroupId
         includeMembersList:(BOOL)aIncludeMembersList
                      error:(EMError **)pError EM_DEPRECATED_IOS(3_1_0, 3_3_0, "Use -[IEMGroupManager getGroupSpecificationFromServerWithId:error:]");

/*!
 *  \~chinese
 *  获取群组详情
 *
 *  @param aGroupId              群组ID
 *  @param aIncludeMembersList   是否获取成员列表，为YES时，返回200个成员
 *  @param aCompletionBlock      完成的回调
 *
 *
 *  \~english
 *  Fetch group specification
 *
 *  @param aGroupId              Group id
 *  @param aIncludeMembersList   Whether to get member list，When YES, returns 200 members
 *  @param aCompletionBlock      The callback block of completion
 *
 */
- (void)getGroupSpecificationFromServerByID:(NSString *)aGroupID
                         includeMembersList:(BOOL)aIncludeMembersList
                                 completion:(void (^)(EMGroup *aGroup, EMError *aError))aCompletionBlock EM_DEPRECATED_IOS(3_1_0, 3_3_0, "Use -[IEMGroupManager getGroupSpecificationFromServerWithId:completion:]");

/*!
 *  \~chinese
 *  获取群组黑名单列表, 需要owner权限
 *
 *  同步方法，会阻塞当前线程
 *
 *  @param aGroupId  群组ID
 *  @param pError    错误信息
 *
 *  @return    群组黑名单列表<NSString>
 *
 *  \~english
 *  Get group‘s blacklist, required owner’s authority
 *
 *  Synchronization method will block the current thread
 *
 *  @param aGroupId  Group id
 *  @param pError    Error
 *
 *  @return    Group blacklist<NSString>
 */
- (NSArray *)fetchGroupBansList:(NSString *)aGroupId
                          error:(EMError **)pError EM_DEPRECATED_IOS(3_1_0, 3_3_0, "Use -[IEMGroupManager getGroupBlacklistFromServerWithId:pageNumber:pageSize:error:]");

/*!
 *  \~chinese
 *  获取群组黑名单列表, 需要owner权限
 *
 *  @param aGroupId         群组ID
 *  @param aCompletionBlock 完成的回调
 *
 *
 *  \~english
 *  Get group's blacklist, owner’s authority is required
 *
 *  @param aGroupId         Group id
 *  @param aCompletionBlock The callback block of completion
 *
 */
- (void)getGroupBlackListFromServerByID:(NSString *)aGroupId
                             completion:(void (^)(NSArray *aList, EMError *aError))aCompletionBlock EM_DEPRECATED_IOS(3_1_0, 3_3_0, "Use -[IEMGroupManager getGroupBlacklistFromServerWithId:pageNumber:pageSize:completion:]");

/*!
 *  \~chinese
 *  解散群组, 需要owner权限
 *
 *  同步方法，会阻塞当前线程
 *
 *  @param aGroupId  群组ID
 *  @param pError    错误信息
 *
 *  @result    销毁的群组实例, 失败返回nil
 *
 *  \~english
 *  Destroy a group, owner‘s authority is required
 *
 *  Synchronization method will block the current thread
 *
 *  @param aGroupId  Group id
 *  @param pError    Error
 *
 *  @result    Destroyed group, return nil if failed
 */
- (EMGroup *)destroyGroup:(NSString *)aGroupId
                    error:(EMError **)pError EM_DEPRECATED_IOS(3_1_0, 3_3_0, "Use -[IEMGroupManager destroyGroup:]");

/*!
 *  \~chinese
 *  解散群组, 需要owner权限
 *
 *  @param aGroupId         群组ID
 *  @param aCompletionBlock 完成的回调
 *
 *  \~english
 *  Destroy a group, owner‘s authority is required
 *
 *  @param aGroupId         Group id
 *  @param aCompletionBlock The callback block of completion
 *
 */
- (void)destroyGroup:(NSString *)aGroupId
          completion:(void (^)(EMGroup* aGroup, EMError *aError))aCompletionBlock EM_DEPRECATED_IOS(3_1_0, 3_3_0, "Use -[IEMGroupManager destroyGroup:finishCompletion:]");

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
- (void)addDelegate:(id<EMGroupManagerDelegate>)aDelegate EM_DEPRECATED_IOS(3_1_0, 3_2_2, "Use -[IEMGroupManager addDelegate:delegateQueue:]");

#pragma mark - EM_DEPRECATED_IOS < 3.2.3

/*!
 *  \~chinese
 *  获取所有群组，如果内存中不存在，则先从DB加载
 *
 *  @result 群组列表<EMGroup>
 *
 *  \~english
 *  Get all groups, will load from DB if not exist in memory
 *
 *  @result Group list<EMGroup>
 */
- (NSArray *)getAllGroups __deprecated_msg("Use -getJoinedGroups");

/*!
 *  \~chinese
 *  从数据库加载所有群组，加载后更新内存中的群组列表
 *
 *  @result 群组列表<EMGroup>
 *
 *  \~english
 *  Load all groups from DB, will update group list in memory after loading
 *
 *  @result Group list<EMGroup>
 */
- (NSArray *)loadAllMyGroupsFromDB __deprecated_msg("Use -getJoinedGroups");

/*!
 *  \~chinese
 *  从内存中获取屏蔽了推送的群组ID列表
 *
 *  @result 群组ID列表<NSString>
 *
 *  \~english
 *  Get ID list of groups which block push from memory
 *
 *  @result Group id list<NSString>
 */
- (NSArray *)getAllIgnoredGroupIds __deprecated_msg("Use -getGroupsWithoutPushNotification");

/**
 *  \~chinese
 *  从服务器获取用户所有的群组，成功后更新DB和内存中的群组列表
 *
 *  @param aSuccessBlock    成功的回调
 *  @param aFailureBlock    失败的回调
 *
 *
 *  \~english
 *  Get all of user's groups from server, will update group list in memory and DB after success
 *
 *  @param aSuccessBlock    The callback block of success
 *  @param aFailureBlock    The callback block of failure
 *
 */
- (void)asyncGetMyGroupsFromServer:(void (^)(NSArray *aList))aSuccessBlock
                           failure:(void (^)(EMError *aError))aFailureBlock __deprecated_msg("Use -getJoinedGroupsFromServerWithCompletion:");

/*!
 *  \~chinese
 *  从服务器获取指定范围内的公开群
 *
 *  @param aCursor          获取公开群的cursor，首次调用传空
 *  @param aPageSize        期望返回结果的数量, 如果 < 0 则一次返回所有结果
 *  @param aSuccessBlock    成功的回调
 *  @param aFailureBlock    失败的回调
 *
 *
 *  \~english
 *  Get public groups in the specified range from the server
 *
 *  @param aCursor          Cursor, input nil the first time
 *  @param aPageSize        Expect result count, will return all results if < 0
 *  @param aSuccessBlock    The callback block of success
 *  @param aFailureBlock    The callback block of failure
 *
 */
- (void)asyncGetPublicGroupsFromServerWithCursor:(NSString *)aCursor
                                        pageSize:(NSInteger)aPageSize
                                         success:(void (^)(EMCursorResult *aCursor))aSuccessBlock
                                         failure:(void (^)(EMError *aError))aFailureBlock __deprecated_msg("Use -getPublicGroupsFromServerWithCursor:pageSize:completion:");

/*!
 *  \~chinese
 *  根据群ID搜索公开群
 *
 *  @param aGroundId        群组id
 *  @param aSuccessBlock    成功的回调
 *  @param aFailureBlock    失败的回调
 *
 *
 *  \~english
 *  Search public group with the id
 *
 *  @param aGroundId        Group id
 *  @param aSuccessBlock    The callback block of success
 *  @param aFailureBlock    The callback block of failure
 *
 */
- (void)asyncSearchPublicGroupWithId:(NSString *)aGroundId
                             success:(void (^)(EMGroup *aGroup))aSuccessBlock
                             failure:(void (^)(EMError *aError))aFailureBlock __deprecated_msg("Use -searchPublicGroupWithId:completion:");

/*!
 *  \~chinese
 *  创建群组
 *
 *  @param aSubject         群组名称
 *  @param aDescription     群组描述
 *  @param aInvitees        群组成员（不包括创建者自己）
 *  @param aMessage         邀请消息
 *  @param aSetting         群组属性
 *  @param aSuccessBlock    The callback block of success
 *  @param aFailureBlock    The callback block of failure
 *
 *
 *  \~english
 *  Create a group
 *
 *  @param aSubject         Group subject
 *  @param aDescription     Group description
 *  @param aInvitees        Group members, without creater
 *  @param aMessage         Invitation message
 *  @param aSetting         Group options
 *  @param aSuccessBlock    The callback block of success
 *  @param aFailureBlock    The callback block of failure
 *
 */
- (void)asyncCreateGroupWithSubject:(NSString *)aSubject
                        description:(NSString *)aDescription
                           invitees:(NSArray *)aInvitees
                            message:(NSString *)aMessage
                            setting:(EMGroupOptions *)aSetting
                            success:(void (^)(EMGroup *aGroup))aSuccessBlock
                            failure:(void (^)(EMError *aError))aFailureBlock __deprecated_msg("Use -createGroupWithSubject:description:invitees:message:setting:completion");

/*!
 *  \~chinese
 *  获取群组详情
 *
 *  @param aGroupId              群组ID
 *  @param aIncludeMembersList   是否获取成员列表
 *  @param aSuccessBlock         成功的回调
 *  @param aFailureBlock         失败的回调
 *
 *
 *  \~english
 *  Fetch group info
 *
 *  @param aGroupId              Group id
 *  @param aIncludeMembersList   Whether get member list
 *  @param aSuccessBlock         The callback block of success
 *  @param aFailureBlock         The callback block of failure
 *
 */
- (void)asyncFetchGroupInfo:(NSString *)aGroupId
         includeMembersList:(BOOL)aIncludeMembersList
                    success:(void (^)(EMGroup *aGroup))aSuccessBlock
                    failure:(void (^)(EMError *aError))aFailureBlock __deprecated_msg("Use -getGroupSpecificationFromServerByID:includeMembersList:completion:");

/*!
 *  \~chinese
 *  获取群组黑名单列表, 需要owner权限
 *
 *  @param aGroupId         群组ID
 *  @param aSuccessBlock    成功的回调
 *  @param aFailureBlock    失败的回调
 *
 *
 *  \~english
 *  Get group‘s blacklist, need owner’s authority
 *
 *  @param aGroupId         Group id
 *  @param aSuccessBlock    The callback block of success
 *  @param aFailureBlock    The callback block of failure
 *
 */
- (void)asyncFetchGroupBansList:(NSString *)aGroupId
                        success:(void (^)(NSArray *aList))aSuccessBlock
                        failure:(void (^)(EMError *aError))aFailureBlock  __deprecated_msg("Use -getGroupBlackListFromServerByID:completion:");

/*!
 *  \~chinese
 *  邀请用户加入群组
 *
 *  @param aOccupants       被邀请的用户名列表
 *  @param aGroupId         群组ID
 *  @param aWelcomeMessage  欢迎信息
 *  @param aSuccessBlock    成功的回调
 *  @param aFailureBlock    失败的回调
 *
 *
 *  \~english
 *  Invite User to join a group
 *
 *  @param aOccupants       Invited users
 *  @param aGroupId         Group id
 *  @param aWelcomeMessage  Welcome message
 *  @param aSuccessBlock    The callback block of success
 *  @param aFailureBlock    The callback block of failure
 *
 */
- (void)asyncAddOccupants:(NSArray *)aOccupants
                  toGroup:(NSString *)aGroupId
           welcomeMessage:(NSString *)aWelcomeMessage
                  success:(void (^)(EMGroup *aGroup))aSuccessBlock
                  failure:(void (^)(EMError *aError))aFailureBlock __deprecated_msg("Use -addMembers:toGroup:message:completion:");

/*!
 *  \~chinese
 *  将群成员移出群组, 需要owner权限
 *
 *  @param aOccupants       要移出群组的用户列表
 *  @param aGroupId         群组ID
 *  @param aSuccessBlock    成功的回调
 *  @param aFailureBlock    失败的回调
 *
 *
 *  \~english
 *  Remove members from group, need owner‘s authority
 *
 *  @param aOccupants       Users to be removed
 *  @param aGroupId         Group id
 *  @param aSuccessBlock    The callback block of success
 *  @param aFailureBlock    The callback block of failure
 *
 */
- (void)asyncRemoveOccupants:(NSArray *)aOccupants
                   fromGroup:(NSString *)aGroupId
                     success:(void (^)(EMGroup *aGroup))aSuccessBlock
                     failure:(void (^)(EMError *aError))aFailureBlock __deprecated_msg("Use -removeMembers:fromGroup:completion:");

/*!
 *  \~chinese
 *  加人到群组黑名单, 需要owner权限
 *
 *  @param aOccupants       要加入黑名单的用户
 *  @param aGroupId         群组ID
 *  @param aSuccessBlock    成功的回调
 *  @param aFailureBlock    失败的回调
 *
 *
 *  \~english
 *  Add users to group’s blacklist, need owner‘s authority
 *
 *  @param aOccupants       Users to be added
 *  @param aGroupId         Group id
 *  @param aSuccessBlock    The callback block of success
 *  @param aFailureBlock    The callback block of failure
 *
 */
- (void)asyncBlockOccupants:(NSArray *)aOccupants
                  fromGroup:(NSString *)aGroupId
                    success:(void (^)(EMGroup *aGroup))aSuccessBlock
                    failure:(void (^)(EMError *aError))aFailureBlock __deprecated_msg("Use -blockMembers:fromGroup:completion:");

/*!
 *  \~chinese
 *  从群组黑名单中减人, 需要owner权限
 *
 *  @param aOccupants       要从黑名单中移除的用户名列表
 *  @param aGroupId         群组ID
 *  @param aSuccessBlock    成功的回调
 *  @param aFailureBlock    失败的回调
 *
 *
 *  \~english
 *  Remove users from group‘s blacklist, need owner‘s authority
 *
 *  @param aOccupants       Users to be removed
 *  @param aGroupId         Group id
 *  @param aSuccessBlock    The callback block of success
 *  @param aFailureBlock    The callback block of failure
 *
 */
- (void)asyncUnblockOccupants:(NSArray *)aOccupants
                     forGroup:(NSString *)aGroupId
                      success:(void (^)(EMGroup *aGroup))aSuccessBlock
                      failure:(void (^)(EMError *aError))aFailureBlock __deprecated_msg("Use -unblockMembers:fromGroup:completion:");

/*!
 *  \~chinese
 *  更改群组主题, 需要owner权限
 *
 *  @param aSubject         新主题
 *  @param aGroupId         群组ID
 *  @param aSuccessBlock    成功的回调
 *  @param aFailureBlock    失败的回调
 *
 *
 *  \~english
 *  Change group’s subject, need owner‘s authority
 *
 *  @param aSubject         New group‘s subject
 *  @param aGroupId         Group id
 *  @param aSuccessBlock    The callback block of success
 *  @param aFailureBlock    The callback block of failure
 *
 */
- (void)asyncChangeGroupSubject:(NSString *)aSubject
                       forGroup:(NSString *)aGroupId
                        success:(void (^)(EMGroup *aGroup))aSuccessBlock
                        failure:(void (^)(EMError *aError))aFailureBlock __deprecated_msg("Use -updateGroupSubject:forGroup:completion");

/*!
 *  \~chinese
 *  更改群组说明信息, 需要owner权限
 *
 *  @param aDescription     说明信息
 *  @param aGroupId         群组ID
 *  @param aSuccessBlock    成功的回调
 *  @param aFailureBlock    失败的回调
 *
 *
 *  \~english
 *  Change group’s description, need owner‘s authority
 *
 *  @param aDescription     New group‘s description
 *  @param aGroupId         Group id
 *  @param aSuccessBlock    The callback block of success
 *  @param aFailureBlock    The callback block of failure
 *
 */
- (void)asyncChangeDescription:(NSString *)aDescription
                      forGroup:(NSString *)aGroupId
                       success:(void (^)(EMGroup *aGroup))aSuccessBlock
                       failure:(void (^)(EMError *aError))aFailureBlock __deprecated_msg("Use -updateDescription:forGroup:completion");

/*!
 *  \~chinese
 *  退出群组，owner不能退出群，只能销毁群
 *
 *  @param aGroupId         群组ID
 *  @param aSuccessBlock    成功的回调
 *  @param aFailureBlock    失败的回调
 *
 *
 *  \~english
 *  Leave a group, owner can't leave the group, can only destroy the group
 *
 *  @param aGroupId         Group id
 *  @param aSuccessBlock    The callback block of success
 *  @param aFailureBlock    The callback block of failure
 *
 */
- (void)asyncLeaveGroup:(NSString *)aGroupId
                success:(void (^)(EMGroup *aGroup))aSuccessBlock
                failure:(void (^)(EMError *aError))aFailureBlock __deprecated_msg("Use -leaveGroup:completion");

/*!
 *  \~chinese
 *  解散群组, 需要owner权限
 *
 *  @param aGroupId         群组ID
 *  @param aSuccessBlock    成功的回调
 *  @param aFailureBlock    失败的回调
 *
 *  \~english
 *  Destroy a group, need owner‘s authority
 *
 *  @param aGroupId         Group id
 *  @param aSuccessBlock    The callback block of success
 *  @param aFailureBlock    The callback block of failure
 *
 */
- (void)asyncDestroyGroup:(NSString *)aGroupId
                  success:(void (^)(EMGroup *aGroup))aSuccessBlock
                  failure:(void (^)(EMError *aError))aFailureBlock __deprecated_msg("Use -destroyGroup:completion");

/*!
 *  \~chinese
 *  屏蔽群消息，服务器不再发送此群的消息给用户，owner不能屏蔽群消息
 *
 *  @param aGroupId         要屏蔽的群ID
 *  @param aSuccessBlock    成功的回调
 *  @param aFailureBlock    失败的回调
 *
 *  \~english
 *  Block group’s message, server will blocks the messages of the group to user, owner can't block the group's message
 *
 *  @param aGroupId         Group id
 *  @param aSuccessBlock    The callback block of success
 *  @param aFailureBlock    The callback block of failure
 *
 */
- (void)asyncBlockGroup:(NSString *)aGroupId
                success:(void (^)(EMGroup *aGroup))aSuccessBlock
                failure:(void (^)(EMError *aError))aFailureBlock __deprecated_msg("Use -blockGroup:completion:");

/*!
 *  \~chinese
 *  取消屏蔽群消息
 *
 *  @param aGroupId         要取消屏蔽的群ID
 *  @param aSuccessBlock    成功的回调
 *  @param aFailureBlock    失败的回调
 *
 *  \~english
 *  Unblock group message
 *
 *  @param aGroupId         Group id
 *  @param aSuccessBlock    The callback block of success
 *  @param aFailureBlock    The callback block of failure
 *
 */
- (void)asyncUnblockGroup:(NSString *)aGroupId
                  success:(void (^)(EMGroup *aGroup))aSuccessBlock
                  failure:(void (^)(EMError *aError))aFailureBlock __deprecated_msg("Use -unblockGroup:completion");

/*!
 *  \~chinese
 *  加入一个公开群组，群类型应该是EMGroupStylePublicOpenJoin
 *
 *  @param aGroupId         公开群组的ID
 *  @param aSuccessBlock    成功的回调
 *  @param aFailureBlock    失败的回调
 *
 *  \~english
 *  Join a public group, group style should be EMGroupStylePublicOpenJoin
 *
 *  @param aGroupId         Public group id
 *  @param aSuccessBlock    The callback block of success
 *  @param aFailureBlock    The callback block of failure
 *
 */
- (void)asyncJoinPublicGroup:(NSString *)aGroupId
                     success:(void (^)(EMGroup *aGroup))aSuccessBlock
                     failure:(void (^)(EMError *aError))aFailureBlock __deprecated_msg("Use -joinPublicGroup:completion");

/*!
 *  \~chinese
 *  申请加入一个需批准的公开群组，群类型应该是EMGroupStylePublicJoinNeedApproval
 *
 *  @param aGroupId         公开群组的ID
 *  @param aMessage         请求加入的信息
 *  @param aSuccessBlock    成功的回调
 *  @param aFailureBlock    失败的回调
 *
 *
 *  \~english
 *  Apply to join a public group, group style should be EMGroupStylePublicJoinNeedApproval
 *
 *  @param aGroupId         Public group id
 *  @param aMessage         Apply info
 *  @param aSuccessBlock    The callback block of success
 *  @param aFailureBlock    The callback block of failure
 *
 */
- (void)asyncApplyJoinPublicGroup:(NSString *)aGroupId
                          message:(NSString *)aMessage
                          success:(void (^)(EMGroup *aGroup))aSuccessBlock
                          failure:(void (^)(EMError *aError))aFailureBlock __deprecated_msg("Use -requestToJoinPublicGroup:message:completion:");

/*!
 *  \~chinese
 *  批准入群申请, 需要Owner权限
 *
 *  @param aGroupId         所申请的群组ID
 *  @param aUsername        申请人
 *  @param aSuccessBlock    成功的回调
 *  @param aFailureBlock    失败的回调
 *
 *
 *  \~english
 *  Accept user's application, need owner‘s authority
 *
 *  @param aGroupId         Group id
 *  @param aUsername        The applicant
 *  @param aSuccessBlock    The callback block of success
 *  @param aFailureBlock    The callback block of failure
 *
 */
- (void)asyncAcceptJoinApplication:(NSString *)aGroupId
                         applicant:(NSString *)aUsername
                           success:(void (^)())aSuccessBlock
                           failure:(void (^)(EMError *aError))aFailureBlock __deprecated_msg("Use -approveJoinGroupRequest:sender:completion:");

/*!
 *  \~chinese
 *  拒绝入群申请, 需要Owner权限
 *
 *  @param aGroupId         被拒绝的群组ID
 *  @param aUsername        申请人
 *  @param aReason          拒绝理由
 *  @param aSuccessBlock    成功的回调
 *  @param aFailureBlock    失败的回调
 *
 *
 *  \~english
 *  Decline user's application, need owner‘s authority
 *
 *  @param aGroupId         Group id
 *  @param aUsername        The applicant
 *  @param aReason          Decline reason
 *  @param aSuccessBlock    The callback block of success
 *  @param aFailureBlock    The callback block of failure
 *
 */
- (void)asyncDeclineJoinApplication:(NSString *)aGroupId
                          applicant:(NSString *)aUsername
                             reason:(NSString *)aReason
                            success:(void (^)())aSuccessBlock
                            failure:(void (^)(EMError *aError))aFailureBlock __deprecated_msg("Use -declineJoinGroupRequest:sender:reason:completion:");

/*!
 *  \~chinese
 *  接受入群邀请
 *
 *  @param groupId          接受的群组ID
 *  @param aUsername        邀请者
 *  @param pError           错误信息
 *  @param aSuccessBlock    成功的回调
 *  @param aFailureBlock    失败的回调
 *
 *
 *  \~english
 *  Accept group's invitation
 *
 *  @param groupId          Group id
 *  @param aUsername        Inviter
 *  @param aSuccessBlock    The callback block of success
 *  @param aFailureBlock    The callback block of failure
 *
 */
- (void)asyncAcceptInvitationFromGroup:(NSString *)aGroupId
                               inviter:(NSString *)aUsername
                               success:(void (^)(EMGroup *aGroup))aSuccessBlock
                               failure:(void (^)(EMError *aError))aFailureBlock __deprecated_msg("Use -acceptInvitationFromGroup:inviter:completion");

/*!
 *  \~chinese
 *  拒绝入群邀请
 *
 *  @param aGroupId         被拒绝的群组ID
 *  @param aUsername        邀请人
 *  @param aReason          拒绝理由
 *  @param aSuccessBlock    成功的回调
 *  @param aFailureBlock    失败的回调
 *
 *
 *  \~english
 *  Decline a group invitation
 *
 *  @param aGroupId         Group id
 *  @param aUsername        Inviter
 *  @param aReason          Decline reason
 *  @param aSuccessBlock    The callback block of success
 *  @param aFailureBlock    The callback block of failure
 *
 */
- (void)asyncDeclineInvitationFromGroup:(NSString *)aGroupId
                                inviter:(NSString *)aUsername
                                 reason:(NSString *)aReason
                                success:(void (^)())aSuccessBlock
                                failure:(void (^)(EMError *aError))aFailureBlock __deprecated_msg("Use -declineGroupInvitation:inviter:reason:completion:");

/*!
 *  \~chinese
 *  屏蔽/取消屏蔽群组消息的推送
 *
 *  @param aGroupId          群组ID
 *  @param aIgnore           是否屏蔽
 *  @param aSuccessBlock     成功的回调
 *  @param aFailureBlock     失败的回调
 *
 *
 *  \~english
 *  Block / unblock group message‘s push notification
 *
 *  @param aGroupId          Group id
 *  @param aIgnore           Whether block
 *  @param aSuccessBlock     The callback block of success
 *  @param aFailureBlock     The callback block of failure
 *
 */
- (void)asyncIgnoreGroupPush:(NSString *)aGroupId
                      ignore:(BOOL)aIsIgnore
                     success:(void (^)())aSuccessBlock
                     failure:(void (^)(EMError *aError))aFailureBlock __deprecated_msg("Use -updatePushServiceForGroup:isPushEnabled:completion:");

@end
