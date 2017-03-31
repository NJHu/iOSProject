//
//  UMSocialWhatsappHandler.h
//  SocialSDK
//
//  Created by Gavin Ye on 8/21/14.
//  Copyright (c) 2014 Umeng. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    UMSocialWhatsappMessageTypeText,
    UMSocialWhatsappMessageTypeImage,
}UMSocialWhatsappMessageType;

@interface UMSocialWhatsappHandler : NSObject

+(void)openWhatsapp:(UMSocialWhatsappMessageType)messageType;

@end
