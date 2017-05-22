//
//  BSJTopicCell.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/5/19.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "BSJTopicCell.h"

@interface BSJTopicCell ()

/**
 头像
 */
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;

/**
 昵称
 */
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;

/**
 发表时间
 */
@property (weak, nonatomic) IBOutlet UILabel *creatTimeLabel;

/**
 内容 text
 */
@property (weak, nonatomic) IBOutlet UILabel *contentTextLabel;

/**
 顶的按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *dingBtn;
@property (weak, nonatomic) IBOutlet UIButton *caiBtn;
@property (weak, nonatomic) IBOutlet UIButton *repostBtn;
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;

@end

@implementation BSJTopicCell

- (void)setupBSJTopicCellUIOnce
{
    self.contentTextLabel.font = AdaptedFontSize(16);
    
    self.headerImageView.layer.cornerRadius = 25;
    self.headerImageView.layer.masksToBounds = YES;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setTopicViewModel:(BSJTopicViewModel *)topicViewModel
{
    _topicViewModel = topicViewModel;
    
    [self.headerImageView sd_setImageWithURL:topicViewModel.topic.profile_image placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
    
    self.screenNameLabel.text = topicViewModel.topic.name;
    
    self.creatTimeLabel.text = topicViewModel.topic.create_time;
    
    self.contentTextLabel.text = topicViewModel.topic.text;
}




#pragma mark - action
- (IBAction)dingButtonClick:(UIButton *)sender {
}
- (IBAction)caiButtonClick:(UIButton *)sender {
}

- (IBAction)repostButtonClick:(UIButton *)sender {
}
- (IBAction)commentButtonClick:(UIButton *)sender {
}

+ (instancetype)topicCellWithTableView:(UITableView *)tableView
{
    
    BSJTopicCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
    
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self.class) owner:nil options:nil].lastObject;
    }
    
    
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupBSJTopicCellUIOnce];
    }
    
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setupBSJTopicCellUIOnce];
}
@end
