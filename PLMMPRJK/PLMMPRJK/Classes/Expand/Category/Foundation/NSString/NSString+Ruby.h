//
//  NSString+Ruby.h
//
//  Created by Zachary Davison on 30/10/2012.
//  Copyright (c) 2012 ZD. All rights reserved.
//

//https://github.com/zdavison/NSString-Ruby

#import <Foundation/Foundation.h>

#pragma mark - Categories

@protocol Concatenatable <NSObject>
@end

@interface NSNumber(Ruby) <Concatenatable>
@end

@interface NSString(Ruby) <Concatenatable>

//Operator-likes
-(NSString*):(NSObject*)concat, ...;
-(NSString*)x:(NSInteger )mult;

//Shorthand Accessors
-(NSString*):(NSInteger )loc :(NSInteger )len;
-(NSString*):(NSInteger )start :(char*)shorthand :(NSInteger )end;

//Ruby Methods
-(void)bytes:(void(^)(unichar))block;
- (NSString*)center:(NSInteger )amount;
- (NSString*)center:(NSInteger )amount with:(NSString*)padString;
-(void)chars:(void(^)(unichar))block;
-(NSString*)chomp;
-(NSString*)chomp:(NSString*)string;
-(NSString*)chop;
-(NSString*)chr;
-(void)codePoints:(void(^)(NSInteger ))block;
- (NSString*)concat:(id)concat;
-(NSInteger)count:(NSString*)setString, ...;
-(NSString*)delete:(NSString*)first, ...;
-(BOOL)endsWith:(NSString*)first,...;
-(long)hex;
-(BOOL)includes:(NSString*)include;
-(NSInteger)index:(NSString*)pattern;
-(NSInteger)index:(NSString*)pattern offset:(NSInteger )offset;
-(NSString*)insert:(NSInteger)index string:(NSString*)string;
-(NSString*)inspect;
-(BOOL)isASCII;
-(BOOL)isEmpty;
-(NSInteger)lastIndex:(NSString*)pattern;
-(NSInteger)lastIndex:(NSString*)pattern offset:(NSInteger )offset;
-(NSString*)leftJustify:(NSInteger )amount;
-(NSString*)leftJustify:(NSInteger )amount with:(NSString*)padString;
-(NSString*)leftStrip;
-(void)lines:(void(^)(NSString*))block;
-(void)lines:(void(^)(NSString*))block separator:(NSString*)separator;
-(NSArray*)match:(NSString*)pattern;
-(NSArray*)match:(NSString*)pattern offset:(NSInteger )offset;
-(NSInteger)occurencesOf:(NSString*)subString;
-(long)octal;
-(NSInteger )ordinal;
-(NSArray*)partition:(NSString*)pattern;
-(NSString*)prepend:(NSString*)prefix;
-(NSRange)range;
-(NSString*)reverse;
-(NSInteger)rightIndex:(NSString*)pattern;
-(NSInteger)rightIndex:(NSString*)pattern offset:(NSInteger )offset;
-(NSString*)rightJustify:(NSInteger )amount;
-(NSString*)rightJustify:(NSInteger )amount with:(NSString*)padString;
-(NSArray*)rightPartition:(NSString*)pattern;
-(NSString*)rightStrip;
- (NSArray*)scan:(NSString*)pattern;
- (BOOL)startsWith:(NSString*)first,...;
- (NSString*)strip;
- (NSArray*)split;
- (NSArray*)split:(NSString*)pattern;
- (NSArray*)split:(NSString*)pattern limit:(NSInteger )limit;
- (NSString*)squeeze;
- (NSString*)squeeze:(NSString*)pattern;
- (NSString*)substituteFirst:(NSString*)pattern with:(NSString*)sub;
- (NSString*)substituteLast:(NSString*)pattern with:(NSString*)sub;
-(NSString*)substituteAll:(NSDictionary*)subDictionary;
-(NSString*)substituteAll:(NSString*)pattern with:(NSString*)sub;
-(NSInteger )sum;
-(NSInteger )sum:(NSInteger )bit;
-(NSString*)swapcase;

//Subscript Protocol
-(id)objectAtIndexedSubscript:(NSUInteger)index;
-(id)objectForKeyedSubscript:(id)key;

@end
