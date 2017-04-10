//
//  NSMutableString+Ruby.h
//  NSString+Ruby
//
//  Created by @thingsdoer on 27/06/2013.
//  Copyright (c) 2013 ZD. All rights reserved.
//
//https://github.com/zdavison/NSString-Ruby
#import <Foundation/Foundation.h>
#import "NSString+Ruby.h"

@interface NSMutableString (Ruby)

//Ruby Methods
-(NSString*)capitalizeInPlace;
-(NSString*)chompInPlace;
-(NSString*)chompInPlace:(NSString*)string;
-(NSString*)chopInPlace;
-(NSString*)deleteInPlace:(NSString*)first, ...;
-(NSString*)lowercaseInPlace;
-(NSString*)substituteAllInPlace:(NSDictionary *)subDictionary;
-(NSString*)substituteAllInPlace:(NSString *)pattern with:(NSString *)sub;
-(NSString*)leftStripInPlace;
-(NSString*)reverseInPlace;
-(NSString*)rightStripInPlace;
-(NSString*)squeezeInPlace;
-(NSString*)squeezeInPlace:(NSString *)pattern;
-(NSString*)stripInPlace;
-(NSString*)substituteFirstInPlace:(NSString *)pattern with:(NSString *)sub;
-(NSString*)substituteLastInPlace:(NSString *)pattern with:(NSString *)sub;
-(NSString*)swapcaseInPlace;
-(NSString*)uppercaseInPlace;

@end
