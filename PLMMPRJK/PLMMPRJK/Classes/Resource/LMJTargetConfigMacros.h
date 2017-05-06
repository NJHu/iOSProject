//
//  LMJMPTargetConfigMacros.h
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/4/6.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#ifndef LMJMPTargetConfigMacros_h
#define LMJMPTargetConfigMacros_h





#ifdef DEBUG

static const int ddLogLevel = DDLogLevelVerbose;

//输出转换成DDLog
#define NSLog(...) DDLogVerbose(__VA_ARGS__)

#define NSLogFunc NSLog(@"=====Begin==========\n FILE: %@\n FUNC: %s\n LINE: %d\n", [NSString stringWithUTF8String:__FILE__].lastPathComponent, __PRETTY_FUNCTION__, __LINE__)

#else

static const int ddLogLevel = DDLogLevelWarning;

//输出转换成DDLog
#define NSLog(...) DDLogVerbose(__VA_ARGS__)

#define NSLogFunc

#endif




#endif /* LMJMPTargetConfigMacros_h */
