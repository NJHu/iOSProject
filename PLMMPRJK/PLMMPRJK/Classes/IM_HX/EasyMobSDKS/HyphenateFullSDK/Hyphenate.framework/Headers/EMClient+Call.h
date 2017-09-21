/*!
 *  \~chinese
 *  @header EMClient+Call.h
 *  @abstract Client的实时通讯扩展
 *  @author Hyphenate
 *  @version 3.00
 *
 *  \~english
 *  @header EMClient+Call.h
 *  @abstract Client call extension
 *  @author Hyphenate
 *  @version 3.00
 */

#import "EMClient.h"

#import "IEMCallManager.h"

@interface EMClient (Call)

/*!
 *  \~chinese 
 *  实时通讯模块
 *
 *  \~english 
 *  call module
 */
@property (strong, nonatomic, readonly) id<IEMCallManager> callManager;

@end
