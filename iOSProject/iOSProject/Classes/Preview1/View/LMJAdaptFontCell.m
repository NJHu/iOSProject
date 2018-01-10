//
//  LMJAdaptFontCell.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/4/18.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJAdaptFontCell.h"

//UIKIT_EXTERN const CGFloat KTopSpace;
//UIKIT_EXTERN const CGFloat KLeftSpace;
//UIKIT_EXTERN const CGFloat KRightSpace;
//UIKIT_EXTERN const CGFloat KDateLabelFontSize;
//UIKIT_EXTERN const CGFloat KDateMarginToText;
//UIKIT_EXTERN const CGFloat KTextLabelFontSize;
//UIKIT_EXTERN const CGFloat kBottomSpace;

@interface LMJAdaptFontCell ()

/** <#digest#> */
@property (weak, nonatomic) UILabel *myDateLabel;

/** <#digest#> */
@property (weak, nonatomic) UILabel *myTextLabel;

@end



@implementation LMJAdaptFontCell

+ (instancetype)adaptFontCellWithTableView:(UITableView *)tableView
{
    static NSString *const adaptFontCellID = @"adaptFontCellID";
    
    LMJAdaptFontCell *cell = [tableView dequeueReusableCellWithIdentifier:adaptFontCellID];
    
    if (cell == nil) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:adaptFontCellID];
    }
    
    
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUIOnceLMJAdaptFontCell];
    }
    
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setupUIOnceLMJAdaptFontCell];
}

- (void)setupUIOnceLMJAdaptFontCell
{
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}


- (void)setParagraph:(LMJParagraph *)paragraph
{
    self.myTextLabel.attributedText = paragraph.attWords;
    self.myDateLabel.text = paragraph.date;
}


- (UILabel *)myDateLabel
{
    if(_myDateLabel == nil)
    {
        
        UILabel *label = [[UILabel alloc] init];
        
        [self.contentView addSubview:label];
        
        _myDateLabel = label;
        
        
        label.textColor = [UIColor blackColor];
        
        label.font = AdaptedFontSize(KDateLabelFontSize);
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(KTopSpace);
            make.left.mas_equalTo(KLeftSpace);
            make.right.mas_equalTo(-KRightSpace);
            
        }];
        
    }
  
    return _myDateLabel;
}


- (UILabel *)myTextLabel
{
    if(_myTextLabel == nil)
    {
        
        
        UILabel *label = [[UILabel alloc] init];
        
        [self.contentView addSubview:label];
        
        _myTextLabel = label;
        
        
        label.textColor = [UIColor grayColor];
        
        label.font = AdaptedFontSize(KTextLabelFontSize);
        
        
        label.numberOfLines = 0;
        
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(self.myDateLabel.mas_bottom).offset(KDateMarginToText);
            make.left.mas_equalTo(KLeftSpace);
            make.right.mas_equalTo(-KRightSpace);
            
            
        }];
        
    }
    return _myTextLabel;
}




@end











