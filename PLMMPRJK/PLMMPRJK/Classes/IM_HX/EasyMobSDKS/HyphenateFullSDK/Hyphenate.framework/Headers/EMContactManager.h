//
//  EMContactManager.h
//  HyphenateSDK
//
//  Created by dhc on 15/11/9.
//  Copyright © 2015年 hyphenate.com. All rights reserved.
//

#import "EMManager.h"

#include "emchatclient.h"
#include "emcontactmanager_interface.h"

#import "IEMContactManager.h"
#import "EMContactManagerListener.h"

@interface EMContactManager : EMManager<IEMContactManager>
{
    emsdk::EMContactManagerListener *contactListener_;
}

@property (strong, nonatomic, readonly) EMMulticastDelegate<EMContactManagerDelegate> *delegates;

- (void)removeContactListener;

@end
