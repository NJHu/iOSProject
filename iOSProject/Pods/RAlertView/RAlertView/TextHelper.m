//
//  TextHelper.m
//  RAlert
//
//  Created by roycms on 2016/11/26.
//  Copyright © 2016年 roycms. All rights reserved.
//

#import "TextHelper.h"


@implementation TextHelper

+ (NSMutableAttributedString *)attributedStringForString:(NSString *)str lineSpacing:(CGFloat)lineSpacing{
    
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:str];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpacing];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [str length])];
    return attributedString;
}

@end
