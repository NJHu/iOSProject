//
//  NSString+Score.h
//
//  Created by Nicholas Bruning on 5/12/11.
//  Copyright (c) 2011 Involved Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
enum{
    NSStringScoreOptionNone                         = 1 << 0,
    NSStringScoreOptionFavorSmallerWords            = 1 << 1,
    NSStringScoreOptionReducedLongStringPenalty     = 1 << 2
};

typedef NSUInteger NSStringScoreOption;

//模糊匹配字符串 查找某两个字符串的相似程度
@interface NSString (Score)

- (CGFloat) scoreAgainst:(NSString *)otherString;
- (CGFloat) scoreAgainst:(NSString *)otherString fuzziness:(NSNumber *)fuzziness;
- (CGFloat) scoreAgainst:(NSString *)otherString fuzziness:(NSNumber *)fuzziness options:(NSStringScoreOption)options;

@end
