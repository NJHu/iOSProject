/*!
 *  \~chinese
 *  @header EMLocationMessageBody.h
 *  @abstract 位置消息体
 *  @author Hyphenate
 *  @version 3.00
 *
 *  \~english
 *  @header EMLocationMessageBody.h
 *  @abstract Location message body
 *  @author Hyphenate
 *  @version 3.00
 */

#import <Foundation/Foundation.h>

#import "EMMessageBody.h"

/*!
 *  \~chinese
 *  位置消息体
 *
 *  \~english
 *  Location message body
 */
@interface EMLocationMessageBody : EMMessageBody

/*!
 *  \~chinese
 *  纬度
 *
 *  \~english
 *  Location latitude
 */
@property (nonatomic) double latitude;

/*!
 *  \~chinese
 *  经度
 *
 *  \~english
 *  Loctaion longitude
 */
@property (nonatomic) double longitude;

/*!
 *  \~chinese
 *  地址信息
 *
 *  \~english
 *  Address
 */
@property (nonatomic, copy) NSString *address;

/*!
 *  \~chinese
 *  初始化位置消息体
 *
 *  @param aLatitude   纬度
 *  @param aLongitude  经度
 *  @param aAddress    地理位置信息
 *  
 *  @result 位置消息体实例
 *
 *  \~english
 *  Initialize a location message body instance
 *
 *  @param aLatitude   Latitude
 *  @param aLongitude  Longitude
 *  @param aAddress    Address
 *
 *  @result Location message body instance
 */
- (instancetype)initWithLatitude:(double)aLatitude
                       longitude:(double)aLongitude
                         address:(NSString *)aAddress;

@end
