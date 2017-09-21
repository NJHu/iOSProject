/*!
 *  \~chinese
 *  @header EMError.h
 *  @abstract SDK定义的错误
 *  @author Hyphenate
 *  @version 3.00
 *
 *  \~english
 *  @header EMError.h
 *  @abstract SDK defined error
 *  @author Hyphenate
 *  @version 3.00
 */

#import <Foundation/Foundation.h>

#import "EMErrorCode.h"

/*!
 *  \~chinese 
 *  SDK定义的错误
 *
 *  \~english 
 *  SDK defined error
 */
@interface EMError : NSObject

/*!
 *  \~chinese 
 *  错误码
 *
 *  \~english 
 *  Error code
 */
@property (nonatomic) EMErrorCode code;

/*!
 *  \~chinese 
 *  错误描述
 *
 *  \~english 
 *  Error description
 */
@property (nonatomic, copy) NSString *errorDescription;


#pragma mark - Internal SDK

/*!
 *  \~chinese 
 *  初始化错误实例
 *
 *  @param aDescription  错误描述
 *  @param aCode         错误码
 *
 *  @result 错误实例
 *
 *  \~english
 *  Initialize an error instance
 *
 *  @param aDescription  Error description
 *  @param aCode         Error code
 *
 *  @result Error instance
 */
- (instancetype)initWithDescription:(NSString *)aDescription
                               code:(EMErrorCode)aCode;

/*!
 *  \~chinese 
 *  创建错误实例
 *
 *  @param aDescription  错误描述
 *  @param aCode         错误码
 *
 *  @result 对象实例
 *
 *  \~english
 *  Create a error instance
 *
 *  @param aDescription  Error description
 *  @param aCode         Error code
 *
 *  @result Error instance
 */
+ (instancetype)errorWithDescription:(NSString *)aDescription
                                code:(EMErrorCode)aCode;

@end
