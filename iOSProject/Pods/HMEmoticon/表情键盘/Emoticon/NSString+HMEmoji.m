//
//  NSString+HMEmoji.m
//  表情键盘
//
//  Created by 刘凡 on 16/3/4.
//  Copyright © 2016年 itcast. All rights reserved.
//

#import "NSString+HMEmoji.h"

#define EmojiCodeToSymbol(c) ((((0x808080F0 | (c & 0x3F000) >> 4) | (c & 0xFC0) << 10) | (c & 0x1C0000) << 18) | (c & 0x3F) << 24)

@implementation NSString (HMEmoji)

+ (NSString *)hm_emojiWithIntCode:(unsigned int)intCode {
    unsigned int symbol = EmojiCodeToSymbol(intCode);
    NSString *string = [[NSString alloc] initWithBytes:&symbol length:sizeof(symbol) encoding:NSUTF8StringEncoding];
    
    if (string == nil) {
        string = [NSString stringWithFormat:@"%C", (unichar)intCode];
    }
    return string;
}

+ (NSString *)hm_emojiWithStringCode:(NSString *)stringCode {
    
    NSScanner *scanner = [[NSScanner alloc] initWithString:stringCode];
    
    unsigned int intCode = 0;
    [scanner scanHexInt:&intCode];
    
    return [self hm_emojiWithIntCode:intCode];
}

- (NSString *)hm_emoji {
    return [NSString hm_emojiWithStringCode:self];
}

@end
