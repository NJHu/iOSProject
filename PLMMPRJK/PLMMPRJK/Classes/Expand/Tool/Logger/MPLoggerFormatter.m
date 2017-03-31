//
//  MPLoggerFormatter.m
//  MobileProject
//
//  Created by wujunyang on 16/6/20.
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#import "MPLoggerFormatter.h"
#import "NSDate+Utilities.h"

@implementation MPLoggerFormatter


- (NSString *)formatLogMessage:(DDLogMessage *)logMessage {
    
    NSString *logLevel = nil;
    switch (logMessage.flag) {
        case DDLogFlagError:
            logLevel = @"[ERROR]";
            break;
        case DDLogFlagWarning:
            logLevel = @"[WARN]";
            break;
        case DDLogFlagInfo:
            logLevel = @"[INFO]";
            break;
        case DDLogFlagDebug:
            logLevel = @"[DEBUG]";
            break;
        default:
            logLevel = @"[VBOSE]";
            break;
    }
    
    NSString *formatStr
    = [NSString stringWithFormat:@"%@ %@ [%@][line %ld] %@ %@", logLevel, [logMessage.timestamp stringWithFormat:@"yyyy-MM-dd HH:mm:ss.S"], logMessage.fileName, logMessage.line, logMessage.function, logMessage.message];
    return formatStr;
}
@end
