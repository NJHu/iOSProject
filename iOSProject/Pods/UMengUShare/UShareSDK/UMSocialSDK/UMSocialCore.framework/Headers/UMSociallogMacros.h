//
//  UMSociallogMacros.h
//  UMSocialCore
//
//  Created by 张军华 on 16/9/7.
//  Copyright © 2016年 张军华. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 *  设置全局的日志等级
 *
 *  @param levelString 日志分级字符串 @see UMSocialLogClosedString,UMSocialLogErrorString,UMSocialLogWarnString,UMSocialLogInfoString,UMSocialLogDebugString,UMSocialLogVerboseString
 *  @discuss 普通用户可以设置UMSocialLogClosedString，UMSocialLogErrorString，UMSocialLogWarnString，UMSocialLogInfoString，UMSocialLogDebugString的字符串，如果设置UMSocialLogVerboseString的时候，如果不是本库的开发者，是降低其等级到UMSocialLogDebugString
 */
FOUNDATION_EXPORT void setGlobalLogLevelString(NSString* levelString);
FOUNDATION_EXPORT NSString* getGlobalLogLevelString();

FOUNDATION_EXPORT NSString* const UMSocialLogClosedLevelString;
FOUNDATION_EXPORT NSString* const UMSocialLogErrorLevelString;
FOUNDATION_EXPORT NSString* const UMSocialLogWarnLevelString;
FOUNDATION_EXPORT NSString* const UMSocialLogInfoLevelString;
FOUNDATION_EXPORT NSString* const UMSocialLogDebugLevelString;
FOUNDATION_EXPORT NSString* const UMSocialLogVerboseLevelString;


/**
 *  根据等级打印日志
 *
 *  @param flagString  控制打印分级的标志字符串 
 *  @see  below  UMSocialLogClosedFlagString...and so on
 *  @param file        打印日志的文件
 *  @param function    打印日志的函数
 *  @param line        打印的日志的行数
 *  @param format      需要打印的日志格式内容
 *  @param ...         可变参数
 *  @dicuss 本库不需要直接调用，可以用简易函数宏 @see UMSocialLogError,UMSocialLogWarn,UMSocialLogInfo,UMSocialLogDebug
 */
FOUNDATION_EXPORT void UMSocialLog(NSString* flagString,const char* file,const char* function,NSUInteger line,NSString *format, ...) NS_FORMAT_FUNCTION(5,6);

FOUNDATION_EXPORT NSString* const UMSocialLogErrorFlagString;
FOUNDATION_EXPORT NSString* const UMSocialLogWarnFlagString;
FOUNDATION_EXPORT NSString* const UMSocialLogInfoFlagString;
FOUNDATION_EXPORT NSString* const UMSocialLogDebugFlagString;
FOUNDATION_EXPORT NSString* const UMSocialLogVerboseFlagString;

//简易函数类似于系统的NSLog函数,线程安全
#define UMSocialLogError(format, ...)   UMSocialLog(UMSocialLogErrorFlagString,__FILE__,__PRETTY_FUNCTION__,__LINE__,format,##__VA_ARGS__)
#define UMSocialLogWarn(format, ...)    UMSocialLog(UMSocialLogWarnFlagString,__FILE__,__PRETTY_FUNCTION__,__LINE__,format,##__VA_ARGS__)
#define UMSocialLogInfo(format, ...)    UMSocialLog(UMSocialLogInfoFlagString,__FILE__,__PRETTY_FUNCTION__,__LINE__,format,##__VA_ARGS__)
#define UMSocialLogDebug(format, ...)   UMSocialLog(UMSocialLogDebugFlagString,__FILE__,__PRETTY_FUNCTION__,__LINE__,format,##__VA_ARGS__)
#define UMSocialLogVerbose(format, ...) UMSocialLog(UMSocialLogVerboseFlagString,__FILE__,__PRETTY_FUNCTION__,__LINE__,format,##__VA_ARGS__)


//日志国际化的相关的函数和宏
FOUNDATION_EXPORT NSString* UMSocialLogWithLocalizedKey(NSString* key);
#define UMSocialLogLocalizedString(key) UMSocialLogWithLocalizedKey(key)


