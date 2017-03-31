//
//  GeTuiExtSdk.h
//  GtExtensionSdk
//
//  Created by gexin on 16/9/14.
//  Copyright © 2016年 getui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UserNotifications/UserNotifications.h>

@interface GeTuiExtSdk : NSObject

/**
 *  统计APNs到达情况
 */
+ (void)handelNotificationServiceRequest:(UNNotificationRequest *) request withComplete:(void (^)(void))completeBlock;


@end
