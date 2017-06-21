//
//  SINStatusViewModel.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/6/21.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "SINStatusViewModel.h"
#import "SINStatus.h"

#import "SINUser.h"

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

- (CGFloat)cellHeight
{
    if (_cellHeight == 0) {
        
//        10 + 50 + 10 + text + pics + tooBar + 10
        
        const CGFloat headerHeight = margin + 50;
        _cellHeight += headerHeight;
        
        _cellHeight += margin;
        _cellHeight += self.sin_textPostLayout.textBoundingSize.height;
        
        _cellHeight += margin;
        
//        _cellHeight += pics
//        _cellHeight += margin
        
        
        _cellHeight += 32.5; // tooBar
        _cellHeight += margin;
    }
    return _cellHeight;
}


- (YYTextLayout *)sin_textPostLayout
{
    if(_sin_textPostLayout == nil && !LMJIsEmpty(self.status.text))
    {
        
//        LMJWeakSelf(self);
        NSMutableAttributedString *postTextM = [[NSMutableAttributedString alloc] initWithString:self.status.text];
        CGSize textSize = CGSizeMake(Main_Screen_Width - 2 * margin, INFINITY);
        
        /*
        [self.status.text enumerateObjectsUsingBlock:^(BSJTopicTopComent * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSMutableAttributedString *oneCmt = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@: %@", idx ? @"\n" : @"",obj.user.username, obj.content]];
            
            oneCmt.lineSpacing = 4.0;
            oneCmt.font = [UIFont systemFontOfSize:13];
            oneCmt.color = [UIColor darkGrayColor];
            oneCmt.backgroundColor = [UIColor redColor];
            
            NSRange highRange = NSMakeRange(0, obj.user.username.length + 1);
            
            [oneCmt setTextHighlightRange:highRange color:[UIColor blueColor] backgroundColor:[UIColor yellowColor] userInfo:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
                
                
                !weakself.topCmtClick ?: weakself.topCmtClick(obj.user, obj);
                
            } longPressAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
                
                
                
                
            }];
            
            
            [cmtsM appendAttributedString:oneCmt];
            
            
        }];
        */
        
        
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

@end
