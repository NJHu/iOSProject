//
//  dateTimeHelper.m
//  MobileProject
//
//  Created by wujunyang on 16/7/20.
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#import "dateTimeHelper.h"

@implementation dateTimeHelper

+ (NSString *)htcTimeToLocationStr:(NSDate*)curDate
{
    if (curDate==nil) {
        return @"";
    }
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *fixString = [dateFormatter stringFromDate:curDate];
    return fixString;
}

@end
