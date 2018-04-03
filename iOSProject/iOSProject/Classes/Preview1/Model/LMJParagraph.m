//
//  LMJParagraph.m
//  iOSProject
//
//  Created by HuXuPeng on 2018/1/10.
//  Copyright © 2018年 HuXuPeng. All rights reserved.
//

#import "LMJParagraph.h"

const CGFloat KTopSpace = 10;
const CGFloat KLeftSpace = 15;
const CGFloat KRightSpace = 15;
const CGFloat KDateLabelFontSize = 17;
const CGFloat KDateMarginToText = 10;
const CGFloat KTextLabelFontSize = 15;
const CGFloat kBottomSpace = 10;
@interface LMJParagraph()
{
    NSAttributedString *_attWords;
    CGFloat _height;
}
@end

@implementation LMJParagraph

- (NSAttributedString *)attWords
{
    if(!_attWords)
    {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 4;
        
        NSAttributedString *arrS = [[NSAttributedString alloc] initWithString:self.words attributes:@{NSFontAttributeName : AdaptedFontSize(KTextLabelFontSize), NSParagraphStyleAttributeName : paragraphStyle}];
        
        _attWords = arrS;
    }
    return _attWords;
}

- (CGFloat)height
{
    if(!_height)
    {
        _height += KTopSpace;
        _height += kBottomSpace;
        _height += KDateMarginToText;
        
       _height += [self.attWords boundingRectWithSize:CGSizeMake(kScreenWidth - KLeftSpace - KRightSpace, INFINITY) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.height;
        
        _height += [self.date boundingRectWithSize:CGSizeMake(kScreenWidth - KLeftSpace - KRightSpace, INFINITY) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : AdaptedFontSize(KDateLabelFontSize)} context:nil].size.height;
        
        // 向上取整
        _height = ceilf(_height);
    }
    return _height;
}

@end
