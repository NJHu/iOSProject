//
//  EMDefine.h
//  HyphenateSDK
//
//  Created by dhc on 15/12/4.
//  Copyright © 2015年 Hyphenate.com. All rights reserved.
//

#ifndef EMDefine_h
#define EMDefine_h

#define kRegistedDeviceToken @"emRegistedDeviceToken"
#define kBindDeviceToken @"emDeviceToken"

#define kUsername @"emUsername"
#define kPassword @"emPassword"
#define kAutoLogin @"emAutoLogin"

#if DEBUG
#define EMRACKeyword autoreleasepool {}
#else
#define EMRACKeyword try {} @catch (...) {}
#endif

/*!
 @property
 @brief
 
 id obj1 = [[NSObject alloc] init];
 
 @EMWeakObject(obj1);
 
 dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    @EMStrongObject(obj1);
 });

 */
#define EMWeakObject(object) \
    EMRACKeyword \
    __attribute__((objc_ownership(weak))) __typeof__(object) self_weak_ = (object);

#define EMStrongObject(object) \
    EMRACKeyword \
    __attribute__((objc_ownership(strong))) __typeof__(object) object = self_weak_;


#endif /* EMDefine_h */
