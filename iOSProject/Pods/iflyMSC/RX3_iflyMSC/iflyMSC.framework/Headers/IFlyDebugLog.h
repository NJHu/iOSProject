//
//  IFlyDebugLog.h
//  MSC

//  description: 程序中的log处理类

//  Created by ypzhao on 12-11-22.
//  Copyright (c) 2012年 iflytek. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 *  调试信息
 */
@interface IFlyDebugLog : NSObject

/*!
 *  打印调试信息
 *
 *  @param format -[in] 要打印的内容格式
 *  @param ...    -[in] 要打印的内容
 */
+ (void) showLog:(NSString *)format, ...;

/*!
 *  将log写入文件中
 */
+ (void) writeLog;

/*!
 *  设置是否显示log
 *
 *  @param showLog YES:显示；NO:不显示
 */
+ (void) setShowLog:(BOOL) showLog;
@end
