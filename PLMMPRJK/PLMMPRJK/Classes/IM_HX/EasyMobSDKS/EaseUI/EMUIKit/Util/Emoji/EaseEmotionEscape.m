/************************************************************
 *  * Hyphenate CONFIDENTIAL
 * __________________
 * Copyright (C) 2016 Hyphenate Inc. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of Hyphenate Inc.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Hyphenate Inc.
 */

#import "EaseEmotionEscape.h"

#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define kEmotionTopMargin -3.0f

@implementation EMTextAttachment
//I want my emoticon has the same size with line's height
- (CGRect)attachmentBoundsForTextContainer:(NSTextContainer *)textContainer proposedLineFragment:(CGRect)lineFrag glyphPosition:(CGPoint)position characterIndex:(NSUInteger)charIndex NS_AVAILABLE_IOS(7_0)
{
    return CGRectMake( 0, kEmotionTopMargin, lineFrag.size.height, lineFrag.size.height);
}

@end

@interface EaseEmotionEscape ()
{
    NSString *_urlPattern;
    NSDictionary *_dict;
}

@end

@implementation EaseEmotionEscape

static EaseEmotionEscape *_sharedInstance = nil;

+ (EaseEmotionEscape *)sharedInstance
{
    if (_sharedInstance == nil)
    {
        @synchronized(self) {
            _sharedInstance = [[EaseEmotionEscape alloc] init];
        }
    }
    return _sharedInstance;
}

+ (NSMutableAttributedString *) attributtedStringFromText:(NSString *) aInputText
{
    return nil;
}

+ (NSAttributedString *) attStringFromTextForChatting:(NSString *) aInputText
{
    return nil;
}

+ (NSAttributedString *) attStringFromTextForInputView:(NSString *) aInputText
{
    return nil;
}

- (NSMutableAttributedString *) attributtedStringFromText:(NSString *) aInputText
{
    if (_urlPattern == nil || _urlPattern.length == 0) {
        NSMutableAttributedString * string = [[ NSMutableAttributedString alloc ] initWithString:aInputText attributes:nil ];
        return string;
    }
    NSString *urlPattern = _urlPattern;
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:urlPattern options:NSRegularExpressionCaseInsensitive error:&error ];
    
    NSArray* matches = [regex matchesInString:aInputText options:NSMatchingReportCompletion range:NSMakeRange(0, [aInputText length])];
    NSMutableAttributedString * string = [[ NSMutableAttributedString alloc ] initWithString:aInputText attributes:nil ];
    
    for (NSTextCheckingResult *match in [matches reverseObjectEnumerator]) {
        NSRange matchRange = [match range];
        NSString *subStr = [aInputText substringWithRange:matchRange];
        
        EMTextAttachment * textAttachment = [[EMTextAttachment alloc ] initWithData:nil ofType:nil];
        textAttachment.imageName = subStr;
        UIImage * emojiImage;
        NSString *emojiName = @"";
        if (_dict) {
            emojiName = [_dict objectForKey:subStr];
        }
        
        if (emojiName == nil || emojiName.length == 0) {
            emojiName = subStr;
        }
        
        emojiImage = [UIImage imageNamed:emojiName];
        
        NSAttributedString * textAttachmentString;
        if (emojiImage) {
            textAttachment.image = emojiImage ;
            textAttachmentString = [NSAttributedString attributedStringWithAttachment:textAttachment];
        }else{
            NSString *str = [self getEmojiTextByKey:subStr];
            if (str != nil) {
                str = [NSString stringWithFormat:@"[%@]", str];
                textAttachmentString = [[NSAttributedString alloc] initWithString:str];
            }else {
                textAttachmentString = [[NSAttributedString alloc] initWithString:@"[表情]"];
            }
        }
        
        if (textAttachment != nil) {
            [string deleteCharactersInRange:matchRange];
            [string insertAttributedString:textAttachmentString atIndex:matchRange.location];
        }
    }
    
    return string;
}

- (NSAttributedString *) attStringFromTextForChatting:(NSString *) aInputText textFont:(UIFont*)font
{
    NSMutableAttributedString * string = [self attributtedStringFromText:aInputText];
//    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    paragraphStyle.lineSpacing = 0.0;
//    [string addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [string length])];
    if (font) {
        [string addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, string.length)];
    }
    return string;
}

- (NSAttributedString *) attStringFromTextForInputView:(NSString *) aInputText textFont:(UIFont*)font
{
    NSMutableAttributedString * string = [self attributtedStringFromText:aInputText];
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    paragraphStyle.lineSpacing = 0.0;
//    [string addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, string.length)];
    if (font) {
        [string addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, string.length)];
    }
    return string;
}

- (NSString*) getEmojiTextByKey:(NSString*) aKey
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *plistPaht = [paths objectAtIndex:0];
    NSString *fileName = [plistPaht stringByAppendingPathComponent:@"EmotionTextMapList.plist"];
    NSMutableDictionary *emojiKeyValue = [[NSMutableDictionary alloc] initWithContentsOfFile: fileName];
    return [emojiKeyValue objectForKey:aKey];
    //    NSLog(@"write data is :%@",writeData);
}

- (NSString*) getEmojiImageNameByKey:(NSString*) aKey
{
    return nil;
}

- (void) setEaseEmotionEscapePattern:(NSString *)pattern
{
    _urlPattern = pattern;
}

- (void) setEaseEmotionEscapeDictionary:(NSDictionary*)dict
{
    _dict = dict;
}

@end