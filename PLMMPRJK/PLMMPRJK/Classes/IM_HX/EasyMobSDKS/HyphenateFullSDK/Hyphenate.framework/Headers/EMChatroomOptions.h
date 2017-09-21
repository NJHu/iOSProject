//
//  EMChatroomOptions.h
//  HyphenateSDK
//
//  Created by XieYajie on 09/01/2017.
//  Copyright © 2017 easemob.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EMChatroomOptions : NSObject

/*!
 *  \~chinese
 *  聊天室的最大成员数(3 - 2000，默认是200)
 *
 *  \~english
 *  The max chat room capacity (3-2000, the default is 200)
 */
@property (nonatomic) NSInteger maxUsersCount;

@end
