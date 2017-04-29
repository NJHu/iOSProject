//
//  UITextField+Extension.m
//  MobileProject
//
//  Created by wujunyang on 16/7/13.
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#import "UITextField+Extension.h"

@implementation UITextField (Extension)

- (NSRange)selectedRange {
    UITextPosition* beginning = self.beginningOfDocument;
    
    UITextRange* selectedRange = self.selectedTextRange;
    UITextPosition* selectionStart = selectedRange.start;
    UITextPosition* selectionEnd = selectedRange.end;
    
    const NSInteger location = [self offsetFromPosition:beginning toPosition:selectionStart];
    const NSInteger length = [self offsetFromPosition:selectionStart toPosition:selectionEnd];
    
    return NSMakeRange(location, length);
}

- (void)setSelectedRange:(NSRange)range {
    UITextPosition* beginning = self.beginningOfDocument;
    
    UITextPosition* startPosition = [self positionFromPosition:beginning offset:range.location];
    UITextPosition* endPosition = [self positionFromPosition:beginning offset:range.location + range.length];
    UITextRange* selectionRange = [self textRangeFromPosition:startPosition toPosition:endPosition];
    
    [self setSelectedTextRange:selectionRange];
}

/**
 *  设置空格插入的位置
 *
 *  @param insertPosition <#insertPosition description#>
 */
- (void)insertWhitSpaceInsertPosition:(NSArray *)insertPosition replacementString:(NSString *)string textlength:(NSInteger)length {
    if ([string isEqualToString:@""]) {
        [self deleteBackward];
    }
    if (self.text.length > length) {
        return;
    }
    if (![string isEqualToString:@""]) {
        [self insertText:string];
    }
    
    // 判断光标位置
    NSRange range = [self selectedRange];
    NSUInteger targetCursorPosition = range.location;
    // 移除空格
    NSString *removeNonDigits = [self removeWhitespaceCharacter:self.text andPreserveCursorPosition:&targetCursorPosition];
    // 插入空格
    NSString *phoneNumberWithSpaces = [self insertWhitespaceCharacter:removeNonDigits andPreserveCursorPosition:&targetCursorPosition insertPosition:insertPosition];
    // 重新赋值
    self.text = phoneNumberWithSpaces;
    // 设置光标位置
    NSRange sRange = NSMakeRange(targetCursorPosition, range.length);
    [self setSelectedRange:sRange];
}

/**
 *  插入空格
 *
 *  @param string         <#string description#>
 *  @param cursorPosition <#cursorPosition description#>
 *  @param insertPosition 分隔位置，数组全部传递数字
 *
 *  @return <#return value description#>
 */
- (NSString *)insertWhitespaceCharacter:(NSString *)string andPreserveCursorPosition:(NSUInteger *)cursorPosition insertPosition:(NSArray *)insertPosition {
    NSMutableString *stringWithAddedSpaces = [NSMutableString new];
    NSUInteger cursorPositionInSpacelessString = *cursorPosition;
    for (NSUInteger i = 0; i < string.length; i++) {
        [insertPosition enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (i == [obj integerValue]) {
                [stringWithAddedSpaces appendString:@" "];
                if(i<cursorPositionInSpacelessString) {
                    (*cursorPosition)++;
                }
            }
        }];
        
        unichar characterToAdd = [string characterAtIndex:i];
        NSString *stringToAdd = [NSString stringWithCharacters:&characterToAdd length:1];
        [stringWithAddedSpaces appendString:stringToAdd];
    }
    return stringWithAddedSpaces;
}

/**
 *  移除空格
 *
 *  @param string         <#string description#>
 *  @param cursorPosition <#cursorPosition description#>
 *
 *  @return <#return value description#>
 */
- (NSString *)removeWhitespaceCharacter:(NSString *)string andPreserveCursorPosition:(NSUInteger *)cursorPosition {
    NSUInteger originalCursorPosition =*cursorPosition;
    NSMutableString *digitsOnlyString = [NSMutableString new];
    for (NSUInteger i = 0; i < string.length; i++) {
        unichar characterToAdd = [string characterAtIndex:i];
        if(![[NSCharacterSet whitespaceCharacterSet] characterIsMember:characterToAdd]) {
            NSString *stringToAdd = [NSString stringWithCharacters:&characterToAdd length:1];
            [digitsOnlyString appendString:stringToAdd];
        }
        else {
            if(i < originalCursorPosition) {
                (*cursorPosition)--;
            }
        }
    }
    return digitsOnlyString;
}


@end
