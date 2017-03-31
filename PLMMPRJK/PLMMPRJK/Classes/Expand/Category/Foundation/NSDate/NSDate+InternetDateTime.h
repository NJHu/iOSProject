//
//  NSDate+InternetDateTime.h
//  MWFeedParser
//
//  Created by Michael Waterfall on 07/10/2010.
//  Copyright 2010 Michael Waterfall. All rights reserved.
//

#import <Foundation/Foundation.h>

// Formatting hints
typedef enum {
    DateFormatHintNone, 
    DateFormatHintRFC822, 
    DateFormatHintRFC3339
} DateFormatHint;

// A category to parse internet date & time strings
@interface NSDate (InternetDateTime)

// Get date from RFC3339 or RFC822 string
// - A format/specification hint can be used to speed up, 
//   otherwise both will be attempted in order to get a date
+ (NSDate *)dateFromInternetDateTimeString:(NSString *)dateString 
                                formatHint:(DateFormatHint)hint;

// Get date from a string using a specific date specification
+ (NSDate *)dateFromRFC3339String:(NSString *)dateString;
+ (NSDate *)dateFromRFC822String:(NSString *)dateString;

@end
