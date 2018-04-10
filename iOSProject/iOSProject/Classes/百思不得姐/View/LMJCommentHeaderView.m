//
//  LMJCommentHeaderView.m
//  百思不得姐
//
//  Created by apple on 16/7/25.
//  Copyright © 2016年 NJHu. All rights reserved.
//

#import "LMJCommentHeaderView.h"

@interface LMJCommentHeaderView ()
/** uilabel */
@property (weak, nonatomic) UILabel *label;
@end

@implementation LMJCommentHeaderView

+ (instancetype)commentHeaderViewWithTableView:(UITableView *)tableView
{
    static NSString *const ID = @"headerfooterheader";
    
    LMJCommentHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
    if (header == nil) {
        header = [[LMJCommentHeaderView alloc] initWithReuseIdentifier:ID];
    }
    
    return header;
}

// 在里边添加一个label, 并且设置字体颜色
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithReuseIdentifier:reuseIdentifier])
    {
        self.contentView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        UILabel *label = [[UILabel alloc] init];
        label.textColor = [UIColor darkTextColor];
        [self.contentView addSubview:label];
        
        self.label = label;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.label.frame = self.contentView.bounds;
    self.label.lmj_x = 10;
    self.label.backgroundColor = [UIColor RandomColor];
}

- (void)setTitle:(NSString *)title
{
    _title = title.copy;
    self.label.text = _title;
}

@end
