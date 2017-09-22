#import <Foundation/Foundation.h>

@interface VSingleton : NSObject

+ (void)createSharedInstance:(VSingleton **)singleton;

@end
