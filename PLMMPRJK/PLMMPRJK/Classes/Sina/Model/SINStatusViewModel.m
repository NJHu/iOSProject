//
//  SINStatusViewModel.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/6/21.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "SINStatusViewModel.h"
#import "SINStatus.h"
#import "SINDictURL.h"
#import "SINUser.h"
#import <HMEmoticonManager.h>

static const CGFloat margin = 10.0;

@implementation SINStatusViewModel


+ (instancetype)statusModelWithStatus:(SINStatus *)status
{
    SINStatusViewModel *model = [[self alloc] init];
    model.status = status;
    
    return model;
}

- (void)setStatus:(SINStatus *)status
{
    _status = status;
    
}


- (SINStatusViewModel *)sin_retweetStatusViewModel
{
    if (!_sin_retweetStatusViewModel && self.status.retweeted_status.text.length) {
        
        _sin_retweetStatusViewModel = [SINStatusViewModel statusModelWithStatus:self.status.retweeted_status];
    }
    
    return _sin_retweetStatusViewModel;
}

- (CGFloat)cellHeight
{
    if (_cellHeight == 0) {
        
        //        10 + 50 + 10 + text + pics + tooBar + 10
        
        const CGFloat headerHeight = margin + 50;
        _cellHeight += headerHeight;
        
        _cellHeight += margin;
        _cellHeight += self.sin_textPostLayout.textBoundingSize.height;
        
        _cellHeight += margin;
        
        // 图片内容
        if (self.status.pic_urls.count) {
            _cellHeight += self.sin_statusPicsViewModel.picsViewSize.height;
            _cellHeight += margin;
        }
        // 转发
        if (self.sin_retweetStatusViewModel) {
            
            _cellHeight += margin;
            
            _cellHeight += self.sin_retweetStatusViewModel.sin_textPostLayout.textBoundingSize.height;
            
            _cellHeight += margin;
            
            if (self.sin_retweetStatusViewModel.status.pic_urls.count) {
                _cellHeight += self.sin_retweetStatusViewModel.sin_statusPicsViewModel.picsViewSize.height;
                
                _cellHeight += margin;
                
            }

            
            _cellHeight += margin;
            
        }
        
        
        _cellHeight += 32.5; // tooBar
        _cellHeight += margin;
        
    NSLog(@"H------>>>>%f", _cellHeight);
    }
    
    NSLog(@"HHH------>>>>%f", _cellHeight);
    return _cellHeight;
}


- (YYTextLayout *)sin_textPostLayout
{
    if(_sin_textPostLayout == nil && !LMJIsEmpty(self.status.text))
    {
        
        //        LMJWeakSelf(self);
        NSMutableAttributedString *postTextM = [[NSMutableAttributedString alloc] initWithAttributedString:[[HMEmoticonManager sharedManager] emoticonStringWithString:self.status.text font:[UIFont systemFontOfSize:AdaptedWidth(15)] textColor:UIColor.blackColor]];
        
        CGSize textSize = CGSizeMake(Main_Screen_Width - 2 * margin, INFINITY);
        
        
        
        postTextM.lineSpacing = 4.0;
        postTextM.font = [UIFont systemFontOfSize:AdaptedWidth(15)];
        postTextM.color = [UIColor blackColor];
        postTextM.backgroundColor = [UIColor redColor];
        //        cmtsM.paragraphSpacing = 7.0;
        
        
        YYTextLayout *sin_textPostLayout = [YYTextLayout layoutWithContainerSize:textSize text:postTextM];
        
        _sin_textPostLayout = sin_textPostLayout;
        
        
    }
    return _sin_textPostLayout;
}

- (UIImage *)sin_mbrankImage
{
    if(_sin_mbrankImage == nil)
    {
        /** vip的等级
         ///如理VIP等级
         if user.mbrank > 0 && user.mbrank < 7
         {
         vipImage_lmj = UIImage(named: "common_icon_membership_level\(user.mbrank)")
         }
         */
        _sin_mbrankImage = [UIImage imageNamed:[NSString stringWithFormat:@"common_icon_membership_level%@", self.status.user.mbrank]];
    }
    return _sin_mbrankImage;
}

- (UIImage *)sin_verified_typeImage
{
    if(_sin_verified_typeImage == nil)
    {
        /** 认证类型. -1表示没有认证, 0表示个人认证,
         
         ///处理认证加v的图片
         switch user.verified_type
         {
         case 0:
         verifiedTypeImage_lmj = UIImage(named: "avatar_vip")?.mjGetVertifiedImage()
         case 2, 3, 5:
         verifiedTypeImage_lmj = UIImage(named: "avatar_enterprise_vip")?.mjGetVertifiedImage()
         case 220:
         verifiedTypeImage_lmj = UIImage(named: "avatar_grassroot")?.mjGetVertifiedImage()
         default:
         verifiedTypeImage_lmj = nil
         }
         */
        
        switch (self.status.user.verified_type) {
            case 0:
                
                self.sin_verified_typeImage = [UIImage imageNamed:@"avatar_vip"];
                
                break;
            case 2:
            case 3:
            case 5:
                
                self.sin_verified_typeImage = [UIImage imageNamed:@"avatar_enterprise_vip"];
                break;
                
            case 220:
                self.sin_verified_typeImage = [UIImage imageNamed:@"avatar_grassroot"];
                break;
                
            default:
                
                break;
        }
        
    }
    return _sin_verified_typeImage;
}


- (NSString *)sin_source
{
    if(_sin_source == nil)
    {
        
        NSString *htmlString = self.status.source;
        NSMutableAttributedString *attrM = [[NSMutableAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType} documentAttributes:nil error:nil];
        
        
        attrM.font = [UIFont systemFontOfSize:AdaptedWidth(11)];
        
        
        _sin_source = attrM.string;
        
    }
    return _sin_source;
}


- (NSString *)sin_creatTime
{
    return [self formatCreatTime].copy;
}



- (NSString *)formatCreatTime
{
    NSDate *creatDate = [NSDate dateWithString:self.status.created_at format:@"EEE MM dd HH:mm:ss Z yyyy" timeZone:[NSTimeZone systemTimeZone] locale:[NSLocale localeWithLocaleIdentifier:@"en"]];
    
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
        
    }else if ([creatDate isThisYear])
    {
        fmt.dateFormat = @"MM-dd HH:mm:ss";
        
        return [fmt stringFromDate:creatDate];
    }else
    {
        fmt.dateFormat = @"yyyy MM-dd HH:mm:ss";
        
        return [fmt stringFromDate:creatDate];
    }
    
}

- (NSString *)sin_cmtCount
{
    if(_sin_cmtCount == nil)
    {
        
        
        _sin_cmtCount = [self countFormat: self.status.comments_count];
        
        if (SNCompare(_sin_cmtCount, @"0") == LMJDD) {
            
            _sin_cmtCount = @"评论";
        }
        
    }
    return _sin_cmtCount;
}


- (NSString *)sin_dingCount
{
    if(_sin_dingCount == nil)
    {
        _sin_dingCount = [self countFormat:self.status.attitudes_count];
        
        if (SNCompare(_sin_dingCount, @"0") == LMJDD) {
            
            _sin_dingCount = @"顶";
        }
    }
    return _sin_dingCount;
}


- (NSString *)sin_repostCount
{
    if(_sin_repostCount == nil)
    {
        _sin_repostCount = [self countFormat:self.status.reposts_count];
        
        if (SNCompare(_sin_repostCount, @"0") == LMJDD) {
            
            _sin_repostCount = @"顶";
        }
    }
    return _sin_repostCount;
}

- (NSString *)countFormat:(NSInteger)count
{
    
    if (count > 1000) {
        return [NSString stringWithFormat:@"%0.1f千", count / 1000.0];
    }
    
    return [NSString stringWithFormat:@"%zd", count];
    
}

- (SINStatusPicsViewModel)sin_statusPicsViewModel
{
    if (_sin_statusPicsViewModel.cols == 0 && self.status.pic_urls.count) {
        
        CGSize picsViewSize = CGSizeZero;
        NSInteger cols = 0;
        NSInteger lines = 0;
        CGFloat itemWidth = 0;
        CGFloat itemHeight = 0;
        
        CGFloat maxWidth = Main_Screen_Width - 2 * margin;
        CGFloat maxHeight = 200;
        CGFloat itemMargin = 5;
        
        if (self.status.pic_urls.count == 0) {
            
            
        }else if (self.status.pic_urls.count == 1) {
            
            CGSize imageSize = self.status.pic_urls.firstObject.picSize;
            
            if (imageSize.width <= maxWidth) {
                
                picsViewSize.width = imageSize.width;
                
            }else
            {
                picsViewSize.width = maxWidth;
            }
            
            if (picsViewSize.width < maxHeight) {
                picsViewSize.width = maxHeight;
            }
            
            
            CGFloat imageShowHeight = picsViewSize.width * imageSize.height / imageSize.width;
            
            if (imageShowHeight > maxHeight) {
                imageShowHeight = maxHeight;
            }
            
            picsViewSize.height = imageShowHeight;
            
            cols = 1;
            lines = 1;
            itemWidth = picsViewSize.width;
            itemHeight = picsViewSize.height;
            
            
        }else if (self.status.pic_urls.count == 4) {
            
            itemWidth = (maxWidth - 2 * itemMargin) / 3.0;
            itemHeight = itemWidth;
            cols = 2;
            lines = 2;
            
            picsViewSize = CGSizeMake(2 * itemWidth + itemMargin, 2 * itemWidth + itemMargin);
            
            
            
        }else
        {
            itemWidth = (Main_Screen_Width - 2 * margin - 2 * itemMargin) / 3.0;
            itemHeight = itemWidth;
            cols = 3;
            lines = (self.status.pic_urls.count + 2) / 3;
            
            
            picsViewSize = CGSizeMake(maxWidth, (itemHeight + itemMargin) * lines - itemMargin);
            
        }
        
        
        _sin_statusPicsViewModel = SINStatusPicsViewModelMake(picsViewSize, cols, lines, itemWidth, itemHeight);
    }
    
    
    return _sin_statusPicsViewModel;
}



@end















