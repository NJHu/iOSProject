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
#define BSJCellContentImageBreakHeight (kScreenWidth - BSJCellScreenMargin * 2 - BSJCellEdageMargin * 2);

@implementation BSJTopicViewModel


+ (instancetype)viewModelWithTopic:(BSJTopic *)topic
{
    BSJTopicViewModel *viewModel = [[self alloc] init];
    viewModel.topic = topic;
    if (topic.topCmts.firstObject) {
        NSLog(@"%@", topic.topCmts.firstObject.content);
    }
    
    return viewModel;
}



- (void)setTopic:(BSJTopic *)topic
{
    _topic = topic;
    
    [self handleUIData];
    
    // 1, 计算文字的高度
    const CGFloat contentTextWidth = kScreenWidth - BSJCellScreenMargin * 2 - BSJCellEdageMargin * 2;
    CGSize aSize = CGSizeMake(contentTextWidth, MAXFLOAT);
    
    CGFloat contentTextHeight = [topic.text boundingRectWithSize:aSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : AdaptedFontSize(16)} context:nil].size.height;
    
    //|-10-|-10-|-Header50-|-10-|-content-|-10-|-bottomBar44-|
    _cellHeight += (10 + 10 + BSJCellHeaderSize + 10) + contentTextHeight + 10 + BSJCellBottomBarHeight;
    
    
    // 2计算图片的高度, 不是段子就用图片
    if (topic.type != BSJTopicTypeWords) {
      
        CGFloat pictureHeight = contentTextWidth * topic.height / topic.width;
        
        if (pictureHeight > BSJCellContentImageMaxHeight) {
            pictureHeight = BSJCellContentImageBreakHeight;
            self.isBigPicture = YES;
        }
        
        _pictureFrame = CGRectMake(BSJCellScreenMargin + BSJCellEdageMargin, 10 + 10 + BSJCellHeaderSize + 10 + contentTextHeight + 10, contentTextWidth, pictureHeight);
        
        _cellHeight += pictureHeight + 10;
    }
    
    
    // 热门评论 5 + 10 + 10 + 10 () + 10 + 10 + 5, font = 13
    if (self.topic.topCmts.count) {
        // 测试显示更多评论
        // 测试, 模仿微信朋友圈
        self.topic.topCmts.firstObject.content = [self.topic.topCmts.firstObject.content stringByAppendingString:@"添加更多文字, 添加更多文字, 添加更多文字, 添加更多文字, 添加更多文字"];
            [self.topic.topCmts addObject:self.topic.topCmts.firstObject];
            [self.topic.topCmts addObject:self.topic.topCmts.firstObject];
            [self.topic.topCmts addObject:self.topic.topCmts.firstObject];
            [self.topic.topCmts addObject:self.topic.topCmts.firstObject];

        _cellHeight += self.topCmtLayout.textBoundingSize.height + 20 + 10;
    }
    
}


- (YYTextLayout *)topCmtLayout
{
    if(_topCmtLayout == nil)
    {
        if (self.topic.topCmts.count == 0) {
            return nil;
        }
        
        LMJWeak(self);
        NSMutableAttributedString *cmtsM = [[NSMutableAttributedString alloc] init];
        CGSize cmtSize = CGSizeMake(kScreenWidth - (5 + 10 + 10 + 10 + 10 + 10 + 5), MAXFLOAT);
        
        // 遍历添加评论
        [self.topic.topCmts enumerateObjectsUsingBlock:^(BSJTopicTopComent * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            // 创建一个评论...
            NSMutableAttributedString *oneCmt = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@: %@", obj.user.username, obj.content]];
            
            oneCmt.yy_lineSpacing = 3.0;
            oneCmt.yy_font = [UIFont systemFontOfSize:13];
            oneCmt.yy_color = [UIColor darkGrayColor];
            oneCmt.yy_backgroundColor = [UIColor redColor];
            
            NSRange highRange = NSMakeRange(0, obj.user.username.length + 1);
            
            [oneCmt yy_setTextHighlightRange:highRange color:[UIColor blueColor] backgroundColor:[UIColor yellowColor] userInfo:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
                
                !weakself.topCmtClick ?: weakself.topCmtClick(obj.user, obj);
                
            } longPressAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
                
                !weakself.topCmtClick ?: weakself.topCmtClick(obj.user, obj);
                
            }];
            
            // 添加一个评论...
            [cmtsM appendAttributedString:oneCmt];
            [cmtsM yy_appendString:@"\n"];
        }];
        
        cmtsM.yy_paragraphSpacing = 7.0;
        
        YYTextLayout *topCmtLayout = [YYTextLayout layoutWithContainerSize:cmtSize text:cmtsM];
        _topCmtLayout = topCmtLayout;
    }
    return _topCmtLayout;
}



- (void)handleUIData
{
    self.zanCount = [self countFormat:self.topic.ding];
    
    self.caiCount = [self countFormat:self.topic.cai];
    
    self.repostCount = [self countFormat:self.topic.repost];
    
    self.commentCount = [self countFormat:self.topic.comment];
    
//    voicetime, voicetime
    if (self.topic.videotime) {
        self.playLength = [NSString stringWithFormat:@"%02zd:%02zd", (NSInteger)(self.topic.videotime) / 60, (NSInteger)(self.topic.videotime) % 60];
    }else if (self.topic.voicetime) {
        self.playLength = [NSString stringWithFormat:@"%02zd:%02zd", (NSInteger)(self.topic.voicetime) / 60, (NSInteger)(self.topic.voicetime) % 60];
    }
    
    self.creatTime = [self formatCreatTime];
}

- (NSString *)formatCreatTime
{
    NSDate *creatDate = [NSDate dateWithString:self.topic.create_time format:@"yyyy-MM-dd HH:mm:ss"];
    
    //    NSDateComponents *cmps = [NSDate dateFromStringDate:_created_at withDateStrFormat:LMJDateStringFormat toDate:[NSDate date]];
    
    
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    NSDateComponents *cmps = [[NSCalendar currentCalendar] components:unit fromDate:creatDate toDate:[NSDate date] options:NSCalendarWrapComponents];
    
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    
    if(creatDate.isToday && fabs([creatDate timeIntervalSinceNow]) < 60.0)
    {
        return @"刚刚";
        
    }else if (creatDate.isToday && fabs([creatDate timeIntervalSinceNow]) < 3600.0)
    {
        return [NSString stringWithFormat:@"%zd分钟前", cmps.minute];
        
    }else if ([creatDate isToday])
    {
        return [NSString stringWithFormat:@"%zd小时前", cmps.hour];
        
    }else if ([creatDate isYesterday])
    {
        fmt.dateFormat = @"昨天 HH:mm:ss";
        return [fmt stringFromDate:creatDate];
        
    }else if (cmps.year == [[NSDate date] year])
    {
        fmt.dateFormat = @"MM-dd HH:mm:ss";
        
        return [fmt stringFromDate:creatDate];
    }else
    {
        return self.topic.create_time;
    }
}


- (NSString *)countFormat:(NSInteger)count
{
    if (count > 10000) {
        return [NSString stringWithFormat:@"%0.1f万", count / 10000.0];
    }
    return [NSString stringWithFormat:@"%zd", count];
}

@end



/*
 
 
 // 3, 高亮和点击的
 
 CGSize bSize = CGSizeMake(kScreenWidth - 20, INFINITY);
 
 NSString *bAllString = @"点击高亮点击高亮, 点击高亮点击高亮, 点击高亮点击高亮, 点击高亮点击高亮, DDDDDDD 点击高亮点击高亮";
 
 
 NSString *bHighlightedString = @"DDDDDDD";
 
 NSRange bRange = [bAllString rangeOfString:bHighlightedString];
 
 
 NSMutableAttributedString *bAttStrM = [[NSMutableAttributedString alloc] initWithString:bAllString];
 
 bAttStrM.lineSpacing = 4;
 bAttStrM.font = SYSTEMFONT(20);
 bAttStrM.backgroundColor = [UIColor whiteColor];
 bAttStrM.color = [UIColor blackColor];
 
 
 [bAttStrM setTextHighlightRange:bRange color:[UIColor redColor] backgroundColor:[UIColor yellowColor] userInfo:@{@"a" : @"b"} tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
 
 NSLog(@"%@", containerView);
 NSLog(@"%@", text);
 NSLog(@"%@", NSStringFromRange(range));
 NSLog(@"%@", NSStringFromCGRect(rect));
 
 } longPressAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
 
 NSLog(@"%@", containerView);
 NSLog(@"%@", text);
 NSLog(@"%@", NSStringFromRange(range));
 NSLog(@"%@", NSStringFromCGRect(rect));
 }];
 
 YYTextLayout *bLayout = [YYTextLayout layoutWithContainerSize:bSize text:bAttStrM];
 
 YYLabel *bLabel = [[YYLabel alloc] init];
 
 bLabel.frame = CGRectMake(10, aLabel.lmj_bottom + 10, bLayout.textBoundingSize.width, bLayout.textBoundingSize.height);
 
 bLabel.textLayout = bLayout;
 
 [self.view addSubview:bLabel];
 
 */


