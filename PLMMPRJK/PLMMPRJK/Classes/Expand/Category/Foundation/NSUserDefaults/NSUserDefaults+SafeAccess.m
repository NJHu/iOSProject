//
//  NSUserDefaults+SafeAccess.m
//  iOS-Categories (https://github.com/shaojiankui/iOS-Categories)
//
//  Created by Jakey on 15/5/23.
//  Copyright (c) 2015年 www.skyfox.org. All rights reserved.
//

#import "NSUserDefaults+SafeAccess.h"

@implementation NSUserDefaults (SafeAccess)
+ (NSString *)stringForKey:(NSString *)defaultName {
    return [[NSUserDefaults standardUserDefaults] stringForKey:defaultName];
}

+ (NSArray *)arrayForKey:(NSString *)defaultName {
    return [[NSUserDefaults standardUserDefaults] arrayForKey:defaultName];
}

+ (NSDictionary *)dictionaryForKey:(NSString *)defaultName {
    return [[NSUserDefaults standardUserDefaults] dictionaryForKey:defaultName];
}

+ (NSData *)dataForKey:(NSString *)defaultName {
    return [[NSUserDefaults standardUserDefaults] dataForKey:defaultName];
}

+ (NSArray *)stringArrayForKey:(NSString *)defaultName {
    return [[NSUserDefaults standardUserDefaults] stringArrayForKey:defaultName];
}

+ (NSInteger)integerForKey:(NSString *)defaultName {
    return [[NSUserDefaults standardUserDefaults] integerForKey:defaultName];
}

+ (float)floatForKey:(NSString *)defaultName {
    return [[NSUserDefaults standardUserDefaults] floatForKey:defaultName];
}

+ (double)doubleForKey:(NSString *)defaultName {
    return [[NSUserDefaults standardUserDefaults] doubleForKey:defaultName];
}

+ (BOOL)boolForKey:(NSString *)defaultName {
    return [[NSUserDefaults standardUserDefaults] boolForKey:defaultName];
}

+ (NSURL *)URLForKey:(NSString *)defaultName {
    return [[NSUserDefaults standardUserDefaults] URLForKey:defaultName];
}

#pragma mark - WRITE FOR STANDARD

+ (void)setObject:(id)value forKey:(NSString *)defaultName {
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:defaultName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - READ ARCHIVE FOR STANDARD

+ (id)arcObjectForKey:(NSString *)defaultName {
    return [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:defaultName]];
}

#pragma mark - WRITE ARCHIVE FOR STANDARD

+ (void)setArcObject:(id)value forKey:(NSString *)defaultName {
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:value] forKey:defaultName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
