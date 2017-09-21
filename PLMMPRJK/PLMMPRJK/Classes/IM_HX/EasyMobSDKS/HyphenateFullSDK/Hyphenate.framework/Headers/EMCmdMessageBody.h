/*!
 *  \~chinese
 *  @header EMCmdMessageBody.h
 *  @abstract 命令消息体
 *  @author Hyphenate
 *  @version 3.00
 *
 *  \~english
 *  @header EMCmdMessageBody.h
 *  @abstract Command message body
 *  @author Hyphenate
 *  @version 3.00
 */

#import <Foundation/Foundation.h>

#import "EMMessageBody.h"

/*!
 *  \~chinese 
 *  命令消息体
 *
 *  \~english
 *  Command message body
 */
@interface EMCmdMessageBody : EMMessageBody

/*!
 *  \~chinese
 *  命令内容
 *
 *  \~english
 *  Command content
 */
@property (nonatomic, copy) NSString *action;

/*!
 *  \~chinese
 *  命令参数，只是为了兼容老版本，应该使用EMMessage的扩展属性来代替
 *
 *  \~english
 *  Command parameters, only compatible with old sdk versions. For SDK version 3.0+, use EMMessage's ext property instead
 */
@property (nonatomic, copy) NSArray *params;

/*!
 *  \~chinese
 *  初始化命令消息体
 *  用户自己定义的字符串，接收到后，解析出自己定义的字符串，就知道某件事情发过来了。
 *  ex. 用户要做位置共享，这里的字符串就可以是"loc",解析出"loc"后，就知道这条消息是位置共享的消息了，之后其他信息可以放到.ext属性中去解析。
 *  ex. 用户如果需要做”阅后即焚“功能，这里就可以自己写一个字符串，如”Snap“，之后.ext里带上要删除的messageid，接收方收到后，就可以删除对应的message，到达阅后即焚的效果
 *
 *  @param aAction  命令内容
 *  
 *  @result 命令消息体实例
 *
 *  \~english
 *  Construct command message body
 *  Developer self-defined command string that can be used for specifing custom action/command.
 *  ex. Share a location: mark the action with "location" string, then the parser knows that it's a command message about location sharing and find more attributes stored in extension property .ext.
 *  ex. Self-destructive message like Snapchat: mark the action ”selfDestructive“ and add the messageId of the message to be destruct and expiration time as part of .ext
 *
 *  @param aAction  Self-defined command string content
 *
 *  @result Instance of command message body
 */
- (instancetype)initWithAction:(NSString *)aAction;

@end
