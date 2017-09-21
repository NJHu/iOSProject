/*!
 *  \~chinese
 *  @header EMDeviceConfig.h
 *  @abstract 已登录设备的信息
 *  @author Hyphenate
 *  @version 3.00
 *
 *  \~english
 *  @header EMDeviceConfig.h
 *  @abstract The info of logged in device
 *  @author Hyphenate
 *  @version 3.00
 */

#import <Foundation/Foundation.h>

@interface EMDeviceConfig : NSObject

/*!
 *  \~chinese
 *  设备资源描述
 *
 *  \~english
 *  Device resources
 */
@property (nonatomic, readonly) NSString *resource;

/*!
 *  \~chinese
 *  设备的UUID
 *
 *  \~english
 *  Device UUID
 */
@property (nonatomic, readonly) NSString *deviceUUID;

/*!
 *  \~chinese
 *  设备名称
 *
 *  \~english
 *  Device name
 */
@property (nonatomic, readonly) NSString *deviceName;

@end
