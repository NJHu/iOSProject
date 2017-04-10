//
//  NSDate+InternetDateTime.m
//  MWFeedParser
//
//  Created by Michael Waterfall on 07/10/2010.
//  Copyright 2010 Michael Waterfall. All rights reserved.
//

#import "NSDate+InternetDateTime.h"

// Always keep the formatter around as they're expensive to instantiate
static NSDateFormatter *_internetDateTimeFormatter = nil;

// Good info on internet dates here:
// http://developer.apple.com/iphone/library/qa/qa2010/qa1480.html
@implementation NSDate (InternetDateTime)

// Instantiate single date formatter
+ (NSDateFormatter *)internetDateTimeFormatter {
    @synchronized(self) {
        if (!_internetDateTimeFormatter) {
            NSLocale *en_US_POSIX = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
            _internetDateTimeFormatter = [[NSDateFormatter alloc] init];
            [_internetDateTimeFormatter setLocale:en_US_POSIX];
            [_internetDateTimeFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        }
    }
    return _internetDateTimeFormatter;
}

// Get a date from a string - hint can be used to speed up
+ (NSDate *)dateFromInternetDateTimeString:(NSString *)dateString formatHint:(DateFormatHint)hint {
     // Keep dateString around a while (for thread-safety)
	NSDate *date = nil;
    if (dateString) {
        if (hint != DateFormatHintRFC3339) {
            // Try RFC822 first
            date = [NSDate dateFromRFC822String:dateString];
            if (!date) date = [NSDate dateFromRFC3339String:dateString];
        } else {
            // Try RFC3339 first
            date = [NSDate dateFromRFC3339String:dateString];
            if (!date) date = [NSDate dateFromRFC822String:dateString];
        }
    }
     // Finished with date string
	return date;
}

// See http://www.faqs.org/rfcs/rfc822.html
+ (NSDate *)dateFromRFC822String:(NSString *)dateString {
     // Keep dateString around a while (for thread-safety)
    NSDate *date = nil;
    if (dateString) {
        NSDateFormatter *dateFormatter = [NSDate internetDateTimeFormatter];
        @synchronized(dateFormatter) {

            // Process
            NSString *RFC822String = [[NSString stringWithString:dateString] uppercaseString];
            if ([RFC822String rangeOfString:@","].location != NSNotFound) {
                if (!date) { // Sun, 19 May 2002 15:21:36 GMT
                    [dateFormatter setDateFormat:@"EEE, d MMM yyyy HH:mm:ss zzz"]; 
                    date = [dateFormatter dateFromString:RFC822String];
                }
                if (!date) { // Sun, 19 May 2002 15:21 GMT
                    [dateFormatter setDateFormat:@"EEE, d MMM yyyy HH:mm zzz"]; 
                    date = [dateFormatter dateFromString:RFC822String];
                }
                if (!date) { // Sun, 19 May 2002 15:21:36
                    [dateFormatter setDateFormat:@"EEE, d MMM yyyy HH:mm:ss"]; 
                    date = [dateFormatter dateFromString:RFC822String];
                }
                if (!date) { // Sun, 19 May 2002 15:21
                    [dateFormatter setDateFormat:@"EEE, d MMM yyyy HH:mm"]; 
                    date = [dateFormatter dateFromString:RFC822String];
                }
            } else {
                if (!date) { // 19 May 2002 15:21:36 GMT
                    [dateFormatter setDateFormat:@"d MMM yyyy HH:mm:ss zzz"]; 
                    date = [dateFormatter dateFromString:RFC822String];
                }
                if (!date) { // 19 May 2002 15:21 GMT
                    [dateFormatter setDateFormat:@"d MMM yyyy HH:mm zzz"]; 
                    date = [dateFormatter dateFromString:RFC822String];
                }
                if (!date) { // 19 May 2002 15:21:36
                    [dateFormatter setDateFormat:@"d MMM yyyy HH:mm:ss"]; 
                    date = [dateFormatter dateFromString:RFC822String];
                }
                if (!date) { // 19 May 2002 15:21
                    [dateFormatter setDateFormat:@"d MMM yyyy HH:mm"]; 
                    date = [dateFormatter dateFromString:RFC822String];
                }
            }
            if (!date) NSLog(@"Could not parse RFC822 date: \"%@\" Possible invalid format.", dateString);
            
        }
    }
     // Finished with date string
    return date;
}

// See http://www.faqs.org/rfcs/rfc3339.html
+ (NSDate *)dateFromRFC3339String:(NSString *)dateString {
     // Keep dateString around a while (for thread-safety)
    NSDate *date = nil;
    if (dateString) {
        NSDateFormatter *dateFormatter = [NSDate internetDateTimeFormatter];
        @synchronized(dateFormatter) {
            
            // Process date
            NSString *RFC3339String = [[NSString stringWithString:dateString] uppercaseString];
            RFC3339String = [RFC3339String stringByReplacingOccurrencesOfString:@"Z" withString:@"-0000"];
            // Remove colon in timezone as it breaks NSDateFormatter in iOS 4+.
            // - see https://devforums.apple.com/thread/45837
            if (RFC3339String.length > 20) {
                RFC3339String = [RFC3339String stringByReplacingOccurrencesOfString:@":" 
                                                                         withString:@"" 
                                                                            options:0
                                                                              range:NSMakeRange(20, RFC3339String.length-20)];
            }
            if (!date) { // 1996-12-19T16:39:57-0800
                [dateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ssZZZ"]; 
                date = [dateFormatter dateFromString:RFC3339String];
            }
            if (!date) { // 1937-01-01T12:00:27.87+0020
                [dateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSSZZZ"]; 
                date = [dateFormatter dateFromString:RFC3339String];
            }
            if (!date) { // 1937-01-01T12:00:27
                [dateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss"]; 
                date = [dateFormatter dateFromString:RFC3339String];
            }
            if(!date) //  2013-04-05 14:06:00
            {
                [dateFormatter setDateFormat:@"yyyy'-'MM'-'dd HH':'mm':'ss"];
                date = [dateFormatter dateFromString:RFC3339String];
            }
            if (!date) NSLog(@"Could not parse RFC3339 date: \"%@\" Possible invalid format.", dateString);
            
        }
    }
     // Finished with date string
	return date;
}

@end
