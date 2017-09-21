//
//  EMCallBuilderDelegate.h
//  HyphenateSDK
//
//  Created by XieYajie on 26/10/2016.
//  Copyright © 2016 easemob.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "EMCallRemoteView.h"

@protocol EMCallBuilderDelegate <NSObject>

@optional

- (void)callRemoteOffline:(NSString *)aRemoteName;

@end
