/*!
 *  \~chinese
 *  @header EMSDKFull.h
 *  @abstract 包含实时通讯模块的SDK的头文件
 *  @author Hyphenate
 *  @version 3.00
 *
 *  \~english
 *  @header EMSDKFull.h
 *  @abstract Headers of SDK contains call module
 *  @author Hyphenate
 *  @version 3.00
 */

#ifndef EMSDKFull_h
#define EMSDKFull_h

#if TARGET_OS_IPHONE

#import "EMClient.h"
#import "EMClientDelegate.h"

#import "EMClient+Call.h"
#import "EMCallOptions.h"
#import "EMCallSession.h"

#else

#import <Hyphenate/EMClient.h>
#import <Hyphenate/EMClientDelegate.h>

#import <Hyphenate/EMClient+Call.h>
#import <Hyphenate/EMCallOptions.h>
#import <Hyphenate/EMCallSession.h>

#endif


#endif /* EMSDKFull_h */
