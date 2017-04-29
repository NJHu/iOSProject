//
//  NSMutableString+Ruby.m
//  NSString+Ruby
//
//  Created by @thingsdoer on 27/06/2013.
//  Copyright (c) 2013 ZD. All rights reserved.
//

/* Ruby -> Obj-C Equivalents
 
 #capitalize!     capitalizeInPlace
 #chomp!          chompInPlace
                  chompInPlace:
 #chop!           chopInPlace
 #delete!         deleteInPlace:
 #downcase!       lowercaseStringInPlace
 #gsub!           substituteAllInPlace:
                  substituteAllInPlace:pattern
 #lstrip!         leftStripInPlace
 #reverse!        reverseInPlace
 #rstrip!         rightStripInPlace
 #squeeze!        squeezeInPlace
                  squeezeInPlace:
 #strip!          stripInPlace
 #sub!            substituteFirstInPlace:
                  substituteLastInPlace:
 #swapcase!       swapcaseInPlace
 #upcase!         uppercaseInPlace
 
 */

#import "NSMutableString+Ruby.h"

@interface NSString(RubyPrivate)

NSString* _stringRepresentationOf(id<Concatenatable> object);
-(NSString*)_delete:(NSString*)first remaining:(va_list)args;

@end

@implementation NSMutableString (Ruby)

-(NSString*)capitalizeInPlace{
  NSString *oldString = [NSString stringWithString:self];
  [self setString:[self capitalizedString]];
  if([oldString isEqualToString:self]){
    return nil;
  }else{
    return self;
  }
}

-(NSString*)chompInPlace{
  NSString *oldString = [NSString stringWithString:self];
  [self setString:[self chomp]];
  if([oldString isEqualToString:self]){
    return nil;
  }else{
    return self;
  }
}

-(NSString*)chompInPlace:(NSString*)string{
  NSString *oldString = [NSString stringWithString:self];
  [self setString:[self chomp:string]];
  if([oldString isEqualToString:self]){
    return nil;
  }else{
    return self;
  }
}

-(NSString*)chopInPlace{
  [self setString:[self chop]];
  return self;
}

-(NSString*)deleteInPlace:(NSString*)first, ...{
  NSString *oldString = [NSString stringWithString:self];
  va_list args;
  va_start(args, first);
  [self setString:[self _delete:first remaining:args]];
  va_end(args);
  if([oldString isEqualToString:self]){
    return nil;
  }else{
    return self;
  }
}

-(NSString*)lowercaseInPlace{
  NSString *oldString = [NSString stringWithString:self];
  [self setString:[self lowercaseString]];
  if([oldString isEqualToString:self]){
    return nil;
  }else{
    return self;
  }
}

-(NSString*)substituteAllInPlace:(NSDictionary *)subDictionary{
  NSString *oldString = [NSString stringWithString:self];
  [self setString:[self substituteAll:subDictionary]];
  if([oldString isEqualToString:self]){
    return nil;
  }else{
    return self;
  }
}

-(NSString*)substituteAllInPlace:(NSString *)pattern with:(NSString *)sub{
  NSString *oldString = [NSString stringWithString:self];
  [self setString:[self substituteAll:pattern with:sub]];
  if([oldString isEqualToString:self]){
    return nil;
  }else{
    return self;
  }
}

-(NSString*)leftStripInPlace{
  NSString *oldString = [NSString stringWithString:self];
  [self setString:[self leftStrip]];
  if([oldString isEqualToString:self]){
    return nil;
  }else{
    return self;
  }
}

-(NSString*)reverseInPlace{
  NSString *oldString = [NSString stringWithString:self];
  [self setString:[self reverse]];
  if([oldString isEqualToString:self]){
    return nil;
  }else{
    return self;
  }
}

-(NSString*)rightStripInPlace{
  NSString *oldString = [NSString stringWithString:self];
  [self setString:[self rightStrip]];
  if([oldString isEqualToString:self]){
    return nil;
  }else{
    return self;
  }
}

-(NSString*)squeezeInPlace{
  NSString *oldString = [NSString stringWithString:self];
  [self setString:[self squeeze]];
  if([oldString isEqualToString:self]){
    return nil;
  }else{
    return self;
  }
}

-(NSString*)squeezeInPlace:(NSString *)pattern{
  NSString *oldString = [NSString stringWithString:self];
  [self setString:[self squeeze:pattern]];
  if([oldString isEqualToString:self]){
    return nil;
  }else{
    return self;
  }
}

-(NSString*)stripInPlace{
  NSString *oldString = [NSString stringWithString:self];
  [self setString:[self strip]];
  if([oldString isEqualToString:self]){
    return nil;
  }else{
    return self;
  }
}

-(NSString*)substituteFirstInPlace:(NSString *)pattern with:(NSString *)sub{
  NSString *oldString = [NSString stringWithString:self];
  [self setString:[self substituteFirst:pattern with:sub]];
  if([oldString isEqualToString:self]){
    return nil;
  }else{
    return self;
  }
}

-(NSString*)substituteLastInPlace:(NSString *)pattern with:(NSString *)sub{
  NSString *oldString = [NSString stringWithString:self];
  [self setString:[self substituteLast:pattern with:sub]];
  if([oldString isEqualToString:self]){
    return nil;
  }else{
    return self;
  }
}

-(NSString*)swapcaseInPlace{
  NSString *oldString = [NSString stringWithString:self];
  [self setString:[self swapcase]];
  if([oldString isEqualToString:self]){
    return nil;
  }else{
    return self;
  }
}

-(NSString*)uppercaseInPlace{
  NSString *oldString = [NSString stringWithString:self];
  [self setString:[self uppercaseString]];
  if([oldString isEqualToString:self]){
    return nil;
  }else{
    return self;
  }
}

@end
