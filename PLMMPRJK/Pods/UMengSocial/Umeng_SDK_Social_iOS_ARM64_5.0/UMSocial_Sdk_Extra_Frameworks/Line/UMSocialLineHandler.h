//
//  UMSocialLineHandler.h
//  SocialSDK
//
//  Created by Gavin Ye on 8/21/14.
//  Copyright (c) 2014 Umeng. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    UMSocialLineMessageTypeText,
    UMSocialLineMessageTypeImage,
}UMSocialLineMessageType;

@interface UMSocialLineHandler : NSObject

+(void)openLineShare:(UMSocialLineMessageType)messageType;
@end
