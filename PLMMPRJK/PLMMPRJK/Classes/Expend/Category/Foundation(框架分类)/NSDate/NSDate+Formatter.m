//
//  NSDate+Formatter.m
//  iOS-Categories (https://github.com/shaojiankui/iOS-Categories)
//
//  Created by Jakey on 15/5/23.
//  Copyright (c) 2015年 www.skyfox.org. All rights reserved.
//

#import "NSDate+Formatter.h"

@implementation NSDate (Formatter)
+(NSDateFormatter *)formatter {
    
    static NSDateFormatter *formatter = nil;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        [formatter setDoesRelativeDateFormatting:YES];
    });
    
    return formatter;
}

+(NSDateFormatter *)formatterWithoutTime {
    
    static NSDateFormatter *formatterWithoutTime = nil;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        formatterWithoutTime = [[NSDate formatter] copy];
        [formatterWithoutTime setTimeStyle:NSDateFormatterNoStyle];
    });
    
    return formatterWithoutTime;
}

+(NSDateFormatter *)formatterWithoutDate {
    
    static NSDateFormatter *formatterWithoutDate = nil;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        formatterWithoutDate = [[NSDate formatter] copy];
        [formatterWithoutDate setDateStyle:NSDateFormatterNoStyle];
    });
    
    return formatterWithoutDate;
}

#pragma mark -
#pragma mark Formatter with date & time
-(NSString *)formatWithUTCTimeZone {
    return [self formatWithTimeZoneOffset:0];
}

-(NSString *)formatWithLocalTimeZone {
    return [self formatWithTimeZone:[NSTimeZone localTimeZone]];
}

-(NSString *)formatWithTimeZoneOffset:(NSTimeInterval)offset {
    return [self formatWithTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:offset]];
}

-(NSString *)formatWithTimeZone:(NSTimeZone *)timezone {
    NSDateFormatter *formatter = [NSDate formatter];
    [formatter setTimeZone:timezone];
    return [formatter stringFromDate:self];
}

#pragma mark -
#pragma mark Formatter without time
-(NSString *)formatWithUTCTimeZoneWithoutTime {
    return [self formatWithTimeZoneOffsetWithoutTime:0];
}

-(NSString *)formatWithLocalTimeZoneWithoutTime {
    return [self formatWithTimeZoneWithoutTime:[NSTimeZone localTimeZone]];
}

-(NSString *)formatWithTimeZoneOffsetWithoutTime:(NSTimeInterval)offset {
    return [self formatWithTimeZoneWithoutTime:[NSTimeZone timeZoneForSecondsFromGMT:offset]];
}

-(NSString *)formatWithTimeZoneWithoutTime:(NSTimeZone *)timezone {
    NSDateFormatter *formatter = [NSDate formatterWithoutTime];
    [formatter setTimeZone:timezone];
    return [formatter stringFromDate:self];
}

#pragma mark -
#pragma mark Formatter without date
-(NSString *)formatWithUTCWithoutDate {
    return [self formatTimeWithTimeZone:0];
}
-(NSString *)formatWithLocalTimeWithoutDate {
    return [self formatTimeWithTimeZone:[NSTimeZone localTimeZone]];
}

-(NSString *)formatWithTimeZoneOffsetWithoutDate:(NSTimeInterval)offset {
    return [self formatTimeWithTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:offset]];
}

-(NSString *)formatTimeWithTimeZone:(NSTimeZone *)timezone {
    NSDateFormatter *formatter = [NSDate formatterWithoutDate];
    [formatter setTimeZone:timezone];
    return [formatter stringFromDate:self];
}
#pragma mark -
#pragma mark Formatter  date
+ (NSString *)currentDateStringWithFormat:(NSString *)format
{
    NSDate *chosenDate = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    NSString *date = [formatter stringFromDate:chosenDate];
    return date;
}
+ (NSDate *)dateWithSecondsFromNow:(NSInteger)seconds {
    NSDate *date = [NSDate date];
    NSDateComponents *components = [NSDateComponents new];
    [components setSecond:seconds];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *dateSecondsAgo = [calendar dateByAddingComponents:components toDate:date options:0];
    return dateSecondsAgo;
}

+ (NSDate *)dateWithYear:(NSInteger)year month:(NSUInteger)month day:(NSUInteger)day {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setYear:year];
    [components setMonth:month];
    [components setDay:day];
    return [calendar dateFromComponents:components];
}
- (NSString *)dateWithFormat:(NSString *)format
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    NSString *date = [formatter stringFromDate:self];
    return date;
}
@end
