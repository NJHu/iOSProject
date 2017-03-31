//
//  NSString+Matcher.h
//  Whyd
//
//  Created by Damien Romito on 29/01/15.
//  Copyright (c) 2015 Damien Romito. All rights reserved.
//
//https://github.com/damienromito/NSString-Matcher
#import <Foundation/Foundation.h>
@interface NSString(Matcher)
- (NSArray *)matchWithRegex:(NSString *)regex;
- (NSString *)matchWithRegex:(NSString *)regex atIndex:(NSUInteger)index;
- (NSString *)firstMatchedGroupWithRegex:(NSString *)regex;
- (NSTextCheckingResult *)firstMatchedResultWithRegex:(NSString *)regex;
@end