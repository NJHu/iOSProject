/*!	
 *  \~chinese
 *  @header   EMOptions+PrivateDeploy.h
 *  @abstract SDK私有部署属性
 *  @author   Hyphenate
 *  @version  3.0
 *
 *  \~english
 *  @header   EMOptions+PrivateDeploy.h
 *  @abstract SDK setting options of private deployment
 *  @author   Hyphenate
 *  @version  3.0
 */

#import "EMOptions.h"

@interface EMOptions (PrivateDeploy)

/*!
 *  \~chinese 
 *  是否允许使用DNS, 默认为YES
 *
 *  只能在[EMClient initializeSDKWithOptions:]中设置，不能在程序运行过程中动态修改。
 *
 *  \~english
 *  Whether to allow using DNS, default is YES
 *
 *  Can only be set when initializing the SDK [EMClient initializeSDKWithOptions:], cannot be altered in runtime
 */
@property (nonatomic, assign) BOOL enableDnsConfig;

/*!
 *  \~chinese 
 *  IM服务器端口
 *
 *  enableDnsConfig为NO时有效。只能在[EMClient initializeSDKWithOptions:]中设置，不能在程序运行过程中动态修改
 *
 *  \~english
 *  IM server port
 *
 *  chatPort is Only effective when isDNSEnabled is NO. 
 *  Can only be set when initializing the SDK with [EMClient initializeSDKWithOptions:], cannot be altered in runtime
 */
@property (nonatomic, assign) int chatPort;

/*!
 *  \~chinese 
 *  IM服务器地址
 *
 *  enableDnsConfig为NO时生效。只能在[EMClient initializeSDKWithOptions:]中设置，不能在程序运行过程中动态修改
 *
 *  \~english
 *  IM server
 *
 *  chatServer is Only effective when isDNSEnabled is NO. Can only be set when initializing the SDK with [EMClient initializeSDKWithOptions:], cannot be altered in runtime
 */
@property (nonatomic, copy) NSString *chatServer;

/*!
 *  \~chinese 
 *  REST服务器地址
 *
 *  enableDnsConfig为NO时生效。只能在[EMClient initializeSDKWithOptions:]中设置，不能在程序运行过程中动态修改
 *
 *  \~english
 *  REST server
 *
 *  restServer Only effective when isDNSEnabled is NO. Can only be set when initializing the SDK with [EMClient initializeSDKWithOptions:], cannot be altered in runtime
 */
@property (nonatomic, copy) NSString *restServer;

@end
