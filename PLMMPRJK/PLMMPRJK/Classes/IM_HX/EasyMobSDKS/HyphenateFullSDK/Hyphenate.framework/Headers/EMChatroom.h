/*!
 *  \~chinese
 *  @header EMChatroom.h
 *  @abstract 聊天室
 *  @author Hyphenate
 *  @version 3.00
 *
 *  \~english
 *  @header EMChatroom.h
 *  @abstract Chatroom
 *  @author Hyphenate
 *  @version 3.00
 */

#import <Foundation/Foundation.h>

#import "EMCommonDefs.h"

/*!
 *  \~chinese
 *  聊天室成员类型
 *
 *  \~english
 *  Chat room permission type
 */
typedef enum{
    EMChatroomPermissionTypeNone   = -1,    /*! \~chinese 未知 \~english Unknown */
    EMChatroomPermissionTypeMember = 0,     /*! \~chinese 普通成员 \~english Normal member */
    EMChatroomPermissionTypeAdmin,          /*! \~chinese 聊天室管理员 \~english Chatroom admin */
    EMChatroomPermissionTypeOwner,          /*! \~chinese 聊天室拥有者 \~english Chatroom owner  */
}EMChatroomPermissionType;


/*!
 *  \~chinese 
 *  聊天室
 *
 *  \~english 
 *  Chat room object
 */
@interface EMChatroom : NSObject

/*!
 *  \~chinese 
 *  聊天室ID
 *
 *  \~english 
 *  Chat room id
 */
@property (nonatomic, copy, readonly) NSString *chatroomId;

/*!
 *  \~chinese
 *  聊天室的主题
 *
 *  \~english 
 *  Subject of chat room
 */
@property (nonatomic, copy, readonly) NSString *subject;

/*!
 *  \~chinese 
 *  聊天室的描述
 *
 *  \~english 
 *  Description of chat room
 */
@property (nonatomic, copy, readonly) NSString *description;

/*!
 *  \~chinese
 *  聊天室的所有者，需要获取聊天室详情
 *
 *  聊天室的所有者只有一人
 *
 *  \~english
 *  Owner of the chat room. Only one owner per chat room. 
 */
@property (nonatomic, copy, readonly) NSString *owner;

/*!
 *  \~chinese
 *  聊天室的公告，需要获取聊天室公告
 *
 *  \~english
 *  Announcement of chat room
 */
@property (nonatomic, copy, readonly) NSString *announcement;

/*!
 *  \~chinese
 *  聊天室的管理者，拥有聊天室的最高权限，需要获取聊天室详情
 *
 *
 *  \~english
 *  Admins of the chatroom
 *
 */
@property (nonatomic, copy, readonly) NSArray *adminList;

/*!
 *  \~chinese
 *  聊天室的成员列表，需要通过分页获取聊天室成员列表接口加载
 *
 *  \~english
 *  List of members in the chat room
 */
@property (nonatomic, copy, readonly) NSArray *memberList;

/*!
 *  \~chinese
 *  聊天室的黑名单，需要先调用获取聊天室黑名单方法
 *
 *  需要owner权限才能查看，非owner返回nil
 *
 *  \~english
 *  Chatroom‘s blacklist of blocked users
 *
 *  Need owner's authority to access, return nil if user is not the chatroom owner.
 */
@property (nonatomic, strong, readonly) NSArray *blacklist;

/*!
 *  \~chinese
 *  聊天室的被禁言列表<NSString>
 *
 *  需要owner权限才能查看，非owner返回nil
 *
 *  \~english
 *  List of muted members<NSString>
 *
 *  Need owner's authority to access, return nil if user is not the chatroom owner.
 */
@property (nonatomic, strong, readonly) NSArray *muteList;

/*!
 *  \~chinese
 *  当前登录账号的聊天室成员类型
 *
 *  \~english
 *  The chatroom membership type of the current login account
 */
@property (nonatomic, readonly) EMChatroomPermissionType permissionType;

/*!
 *  \~chinese
 *  聊天室的最大人数，如果没有获取聊天室详情将返回0
 *
 *  \~english
 *  The capacity of the chat room
 */
@property (nonatomic, readonly) NSInteger maxOccupantsCount;

/*!
 *  \~chinese
 *  聊天室的当前人数，如果没有获取聊天室详情将返回0
 *
 *  \~english
 *  The total number of members in the chat room
 */
@property (nonatomic, readonly) NSInteger occupantsCount;

/*!
 *  \~chinese
 *  获取聊天室实例
 *
 *  @param aChatroomId   聊天室ID
 *
 *  @result 聊天室实例
 *
 *  \~english
 *  Construct a chatroom instance with chatroom id
 *
 *  @param aChatroomId   Chatroom id
 *
 *  @result Chatroom instance
 */
+ (instancetype)chatroomWithId:(NSString *)aChatroomId;

#pragma mark - EM_DEPRECATED_IOS 3.3.0

/*!
 *  \~chinese
 *  聊天室的成员列表，需要获取聊天室详情
 *
 *  \~english
 *  List of members in the chat room
 */
@property (nonatomic, copy, readonly) NSArray *members EM_DEPRECATED_IOS(3_1_0, 3_3_0, "Use -memberList");

/*!
 *  \~chinese
 *  聊天室的当前人数，如果没有获取聊天室详情将返回0
 *
 *  \~english
 *  The total number of members in the chat room
 */
@property (nonatomic, readonly) NSInteger membersCount EM_DEPRECATED_IOS(3_1_0, 3_3_0, "Use -occupantsCount");

/*!
 *  \~chinese
 *  聊天室的最大人数，如果没有获取聊天室详情将返回0
 *
 *  \~english
 *  The capacity of the chat room
 */
@property (nonatomic, readonly) NSInteger maxMembersCount EM_DEPRECATED_IOS(3_1_0, 3_3_0, "Use -maxOccupantsCount");

#pragma mark - EM_DEPRECATED_IOS < 3.2.3

/*!
 *  \~chinese
 *  聊天室的成员列表，需要获取聊天室详情
 *
 *  \~english
 *  List of members in the chat room
 */
@property (nonatomic, copy, readonly) NSArray *occupants __deprecated_msg("Use - members");

/*!
 *  \~chinese
 *  初始化聊天室实例
 *
 *  请使用[+chatroomWithId:]方法
 *
 *  @result nil
 *
 *  \~english
 *  Initialize chatroom instance
 *
 *  Please use [+chatroomWithId:]
 *
 *  @result nil
 */
- (instancetype)init __deprecated_msg("Use +chatroomWithId:");

@end
