//
//  LMJSettingCell.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/4/11.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJSettingCell.h"
#import "LMJWordItem.h"
#import "LMJWordArrowItem.h"
#import "LMJItemSection.h"


@interface LMJSettingCell ()

@end

@implementation LMJSettingCell

static NSString *const ID = @"LMJSettingCell";
+ (instancetype)cellWithTableView:(UITableView *)tableView andCellStyle:(UITableViewCellStyle)style
{
    LMJSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil)
    {
        cell = [[self alloc] initWithStyle:style reuseIdentifier:ID];
    }
    
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setupBaseSettingCellUI];
    }
    
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setupBaseSettingCellUI];
}


- (void)setupBaseSettingCellUI
{

}

- (void)setItem:(LMJWordItem *)item
{
    _item = item;
    
    [self fillData];
    
    [self changeUI];
}

- (void)fillData
{
    self.textLabel.text = self.item.title;
    self.detailTextLabel.text = self.item.subTitle;
    self.imageView.image = self.item.image;
}

- (void)changeUI
{
    self.textLabel.font = self.item.titleFont;
    self.textLabel.textColor = self.item.titleColor;
    
    self.detailTextLabel.font = self.item.subTitleFont;
    self.detailTextLabel.textColor = self.item.subTitleColor;
    
    if ([self.item isKindOfClass:[LMJWordArrowItem class]]) {
        
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    }else
    {
        self.accessoryType = UITableViewCellAccessoryNone;
    }
    
    if (self.item.itemOperation || [self.item isKindOfClass:[LMJWordArrowItem class]]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
        
    }else
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
}



@end
