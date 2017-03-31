//
//  MPIconAndTitleCell.m
//  MobileProject
//
//  Created by wujunyang on 16/8/19.
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#import "MPIconAndTitleCell.h"

@interface MPIconAndTitleCell()
@property(strong,nonatomic)UIImageView *titleIconImageView;
@property(strong,nonatomic)UILabel *titleLabel;
@property(strong,nonatomic)UIView *lineView;
@end

static const CGFloat left_Space=15;
static const CGFloat kIconSize=25;

@implementation MPIconAndTitleCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.backgroundColor = [UIColor whiteColor];
        [self layoutView];
    }
    return self;
}

-(void)layoutView
{
    if (self.titleIconImageView==nil) {
        self.titleIconImageView=[[UIImageView alloc]init];
        [self.contentView addSubview:self.titleIconImageView];
        [self.titleIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(left_Space);
            make.centerY.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(AdaptedWidth(kIconSize), AdaptedHeight(kIconSize)));
        }];
    }
    
    if (self.titleLabel==nil) {
        self.titleLabel=[[UILabel alloc]init];
        self.titleLabel.font=AdaptedFontSize(15);
        self.titleLabel.textColor=HEXCOLOR(0x333333);
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.titleIconImageView.right).offset(15);
            make.right.mas_equalTo(0);
            make.centerY.mas_equalTo(0);
            make.height.mas_equalTo(AdaptedHeight(20));
        }];
    }
    
    
    if (self.lineView==nil) {
        self.lineView=[[UIView alloc]init];
        self.lineView.hidden=YES;
        self.lineView.backgroundColor = COLOR_UNDER_LINE;
        [self.contentView addSubview:self.lineView];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(left_Space);
            make.right.mas_equalTo(self).offset(0);
            make.bottom.equalTo(0);
            make.height.mas_equalTo(0.5);
        }];
    }
}

-(void)configCellIconName:(NSString *)iconName cellTitle:(NSString *)cellTitle showLine:(BOOL)isShowLine
{
    self.titleIconImageView.image=[UIImage imageNamed:iconName];
    self.titleLabel.text=cellTitle;
    self.lineView.hidden=!isShowLine;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


@end
