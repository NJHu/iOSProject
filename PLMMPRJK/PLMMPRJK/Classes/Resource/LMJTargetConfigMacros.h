//
//  LMJMPTargetConfigMacros.h
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/4/6.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#ifndef LMJMPTargetConfigMacros_h
#define LMJMPTargetConfigMacros_h
#ifdef __OBJC__

/**
 *  调试模式======================================
 */
#ifdef DEBUG


#define LMJLog(fmt, ...) NSLog((@"=====Begin==========\n FILE: %@\n FUNC: %s\n LINE: %d\n " fmt), [NSString stringWithUTF8String:__FILE__].lastPathComponent, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

/**
 *  打印函数
 */
#define LMJLogFunc LMJLog(@"\n")


#else

#define LMJLog(fmt, ...)
#define LMJLogFunc

#endif




#ifdef DEBUG

static const int ddLogLevel = DDLogLevelVerbose;

#else

static const int ddLogLevel = DDLogLevelWarning;

#endif






#endif
#endif /* LMJMPTargetConfigMacros_h */
