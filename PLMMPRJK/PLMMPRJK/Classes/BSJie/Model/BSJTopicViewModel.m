//
//  BSJTopicViewModel.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/5/18.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "BSJTopicViewModel.h"

@implementation BSJTopicViewModel


+ (instancetype)viewModelWithTopic:(BSJTopic *)topic
{
    BSJTopicViewModel *viewModel = [[self alloc] init];
    viewModel.topic = topic;
    
    return viewModel;
}



- (void)setTopic:(BSJTopic *)topic
{
    _topic = topic;
    
    // 1, 计算文字的高度
    const CGFloat contentTextWidth = Main_Screen_Width - 10 * 2 - 5 * 2;
    CGSize aSize = CGSizeMake(contentTextWidth, INFINITY);
    CGFloat contentTextHeight = [topic.text boundingRectWithSize:aSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : AdaptedFontSize(16)} context:nil].size.height;
    
    
    
    
    //|-10-|-10-|-Header50-|-10-|-content-|-10-|-botBar44-|
    self.cellHeight = 10 + 10 + 50 + 10 + contentTextHeight + 10 + 44;
    
}

@end
