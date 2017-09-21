/*!
 *  \~chinese
 *  @header EMTextMessageBody.h
 *  @abstract 文本消息体
 *  @author Hyphenate
 *  @version 3.00
 *
 *  \~english
 *  @header EMTextMessageBody.h
 *  @abstract Text message body
 *  @author Hyphenate
 *  @version 3.00
 */

#import <Foundation/Foundation.h>

#import "EMMessageBody.h"

/*!
 *  \~chinese 
 *  文本消息体
 *
 *  \~english 
 *  Text message body
 */
@interface EMTextMessageBody : EMMessageBody

/*!
 *  \~chinese 
 *  文本内容
 *
 *  \~english 
 *  Text content
 */
@property (nonatomic, copy, readonly) NSString *text;

/*!
 *  \~chinese 
 *  初始化文本消息体
 *
 *  @param aText   文本内容
 *  
 *  @result 文本消息体实例
 *
 *  \~english
 *  Initialize a text message body instance
 *
 *  @param aText   Text content
 *
 *  @result Text message body instance
 */
- (instancetype)initWithText:(NSString *)aText;

@end
