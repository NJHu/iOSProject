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

#else

static const int ddLogLevel = DDLogLevelWarning;

#endif



#ifdef DEBUG

//输出转换成DDLog
#define NSLog(...) DDLogVerbose(__VA_ARGS__)
#define Log(...) DDLogVerbose(__VA_ARGS__)

#else   //其它环境

//输出转换成DDLog
#define NSLog(...) DDLogVerbose(__VA_ARGS__)
#define Log(...) DDLogVerbose(__VA_ARGS__)

#endif




/**
 *  调试模式======================================
 */
#ifdef DEBUG


#define LMJLog(fmt, ...) NSLog((@"=====Begin==========\n FILE: %@\n FUNC: %s\n LINE: %d\n " fmt), [NSString stringWithUTF8String:__FILE__].lastPathComponent, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)


//#define Log(fmt, ...) NSLog((@"=====Begin==========\n FILE: %@\n FUNC: %s\n LINE: %d\n " fmt), [NSString stringWithUTF8String:__FILE__].lastPathComponent, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

/**
 *  打印函数
 */
#define LMJLogFunc LMJLog(@"\n");

/**
 *  打印函数
 */
#define LogFunc Log(@"\n");


#else

#define LMJLog(fmt, ...)
#define LMJLogFunc
#define Log(fmt, ...)
#define LogFunc

#endif


#endif /* LMJMPTargetConfigMacros_h */
