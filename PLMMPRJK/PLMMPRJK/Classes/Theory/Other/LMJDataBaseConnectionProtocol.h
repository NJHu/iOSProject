

#import <Foundation/Foundation.h>



@protocol LMJDataBaseConnectionProtocol <NSObject>

@optional

- (void)suspend;

@required

- (void)start;

- (void)end;


@end
