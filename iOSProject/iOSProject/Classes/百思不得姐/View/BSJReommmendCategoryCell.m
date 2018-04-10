//
//  BSJReommmendCategoryCell.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/5/14.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "BSJReommmendCategoryCell.h"


@interface BSJReommmendCategoryCell ()
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UIView *indicatorView;

@end

@implementation BSJReommmendCategoryCell

+ (instancetype)reommmendCategoryCellWithTableView:(UITableView *)tableView {
    
    BSJReommmendCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
    if (cell == nil) {
        cell = [NSBundle.mainBundle loadNibNamed:NSStringFromClass(self.class) owner:nil options:nil].lastObject;
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUIOnce];
    }
    
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setupUIOnce];
}

- (void)setupUIOnce
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
}


- (void)setCategory:(BSJRecommendCategory *)category
{
    _category = category;
    self.categoryLabel.text = category.name;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.indicatorView.hidden = !selected;
}

@end
