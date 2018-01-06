//
//  LMJAdaptFontCell.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/4/18.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJAdaptFontCell.h"

@interface LMJAdaptFontCell ()

/** <#digest#> */
@property (weak, nonatomic) UILabel *myDateLabel;

/** <#digest#> */
@property (weak, nonatomic) UILabel *myTextLabel;

@end




static const CGFloat KTopSpace=10;
static const CGFloat KLeftSpace=15;
static const CGFloat KTextLabelFontSize=15;
static const CGFloat KDateLabelFontSize=17;

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


- (void)setData:(NSMutableDictionary *)dict text:(NSString *)text date:(NSString *)date
{
    self.myTextLabel.attributedText = [self.class getTextAtt:text];
    self.myDateLabel.text = date;
    
    if ([dict[text] integerValue] == 0) {
        
        [self layoutIfNeeded];
        
        dict[text] = @(self.myTextLabel.lmj_y + AdaptedHeight(KTopSpace) + [self.myTextLabel.attributedText boundingRectWithSize:CGSizeMake(kScreenWidth - KLeftSpace * 2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.height);
    }
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
            
            make.top.mas_equalTo(AdaptedHeight(KTopSpace));
            make.left.mas_equalTo(KLeftSpace);
            make.right.mas_equalTo(-KLeftSpace);
            
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
            
            make.top.mas_equalTo(self.myDateLabel.mas_bottom).offset(AdaptedHeight(KTopSpace));
            make.left.mas_equalTo(KLeftSpace);
            make.right.mas_equalTo(-KLeftSpace);
            
            
        }];
        
    }
    return _myTextLabel;
}


+ (NSAttributedString *)getTextAtt:(NSString *)text
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 4;
    
    NSAttributedString *arrS = [[NSAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName : AdaptedFontSize(KTextLabelFontSize), NSParagraphStyleAttributeName : paragraphStyle}];
    
    return arrS;
    
}


@end











