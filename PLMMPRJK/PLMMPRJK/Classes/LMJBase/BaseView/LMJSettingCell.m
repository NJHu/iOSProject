//
//  LMJSettingCell.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/4/11.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJSettingCell.h"


@interface LMJSettingCell ()

@end

@implementation LMJSettingCell

static NSString *const ID = @"cellSetting";
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

}

- (void)changeUI
{

    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
}



@end
