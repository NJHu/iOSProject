//
//  NSString+Pinyin.h
//  Snowball
//
//  Created by croath on 11/11/13.
//  Copyright (c) 2013 Snowball. All rights reserved.
//
// https://github.com/croath/NSString-Pinyin
//  the Chinese Pinyin string of the nsstring

#import <Foundation/Foundation.h>

@interface NSString (Pinyin)

- (NSString*)pinyinWithPhoneticSymbol;
- (NSString*)pinyin;
- (NSArray*)pinyinArray;
- (NSString*)pinyinWithoutBlank;
- (NSArray*)pinyinInitialsArray;
- (NSString*)pinyinInitialsString;

@end
