//
//  BSJTopicViewModel.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/5/18.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "BSJTopicViewModel.h"

/**
 屏幕的距离
 */
const CGFloat BSJCellScreenMargin = 5;
/**
 四周的间距
 */
const CGFloat BSJCellEdageMargin = 10;
/*
 头像的高度
 */
const CGFloat BSJCellHeaderSize = 50;
/*
 * 底部条的高度
 */
const CGFloat BSJCellBottomBarHeight = 35;
/*
 最大的图片的高度
 */
const CGFloat BSJCellContentImageMaxHeight = 1000.0;
/*
 超出最大高度后的高度
 */
const CGFloat BSJCellContentImageBreakHeight = 250;

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
    
    [self handleUIData];
    
    // 1, 计算文字的高度
    const CGFloat contentTextWidth = Main_Screen_Width - BSJCellScreenMargin * 2 - BSJCellEdageMargin * 2;
    
    CGSize aSize = CGSizeMake(contentTextWidth, INFINITY);
    CGFloat contentTextHeight = [topic.text boundingRectWithSize:aSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : AdaptedFontSize(16)} context:nil].size.height;
    
    
    //|-10-|-10-|-Header50-|-10-|-content-|-10-|-bottomBar44-|
    _cellHeight += (10 + 10 + BSJCellHeaderSize + 10) + contentTextHeight + 10 + BSJCellBottomBarHeight;
    
    
    // 2计算图片的高度, 不是段子就用图片
    if (topic.type != BSJTopicViewControllerTypeWord) {
      
        CGFloat pictureHeight = contentTextWidth * topic.height / topic.width;
        
        if (pictureHeight > BSJCellContentImageMaxHeight) {
            pictureHeight = BSJCellContentImageBreakHeight;
            
            self.isBigPicture = YES;
        }
        
        
        _pictureFrame = CGRectMake(BSJCellScreenMargin + BSJCellEdageMargin, 10 + 10 + BSJCellHeaderSize + 10 + contentTextHeight + 10, contentTextWidth, pictureHeight);
        
        _cellHeight += pictureHeight + 10;
        
    }
    
    
    
    
}


- (void)handleUIData
{
    self.zanCount = [self countFormat:self.topic.ding];
    
    self.caiCount = [self countFormat:self.topic.cai];
    
    self.repostCount = [self countFormat:self.topic.repost];
    
    self.commentCount = [self countFormat:self.topic.comment];
    
}



- (NSString *)countFormat:(NSInteger)count
{
    
    if (count > 10000) {
        return [NSString stringWithFormat:@"%0.1f万", count / 10000.0];
    }
    
    return [NSString stringWithFormat:@"%zd", count];
    
}

@end
