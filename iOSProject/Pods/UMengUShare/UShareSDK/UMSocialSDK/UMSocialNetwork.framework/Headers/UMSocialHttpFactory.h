

#import <Foundation/Foundation.h>
#import "UMSocialTaskConfig.h"


@interface UMSocialHttpFactory : NSObject

/**
 *  创建一个NSMutableURLRequest的对象
 *
 *  @param method         @see UMSocialHttpMethodType
 *  @param path           base path 如: http://www.umeng.com
 *  @param pathParameters 加入到path后面的键值对
 *  @param bodyParameters 加入到body的键值对
 *  @param headers        加入的http的header的键值对
 *
 *  @return @see NSMutableURLRequest
 */
+ (NSMutableURLRequest *)makeRequestWithMethod:(UMSocialHttpMethodType)method
                                          path:(NSString *)path
                                pathParameters:(NSDictionary *)pathParameters
                                bodyParameters:(NSDictionary *)bodyParameters
                                       headers:(NSDictionary *)headers;

@end
