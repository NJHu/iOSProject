//
//  BSJTopicCell.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/5/19.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "BSJTopicCell.h"
#import "BSJTopicPictureView.h"

@interface BSJTopicCell ()

/**
 头像
 */
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;

/**
 是否是新浪会员
 */
@property (weak, nonatomic) IBOutlet UIImageView *isSinaVipImageView;

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


/** 展示图片的控件 */
@property (weak, nonatomic) BSJTopicPictureView *pictureView;

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
    
    // Model
    [self.headerImageView sd_setImageWithURL:topicViewModel.topic.profile_image placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
    
    self.screenNameLabel.text = topicViewModel.topic.name;
    
    self.creatTimeLabel.text = topicViewModel.topic.create_time;
    
    self.contentTextLabel.text = topicViewModel.topic.text;
    
    self.isSinaVipImageView.hidden = !topicViewModel.topic.isSina_v;
    
    
    // ViewModel
    [self.dingBtn setTitle:topicViewModel.zanCount forState:UIControlStateNormal];
    [self.caiBtn setTitle:topicViewModel.caiCount forState:UIControlStateNormal];
    [self.repostBtn setTitle:topicViewModel.repostCount forState:UIControlStateNormal];
    [self.commentBtn setTitle:topicViewModel.commentCount forState:UIControlStateNormal];
    
    
    self.pictureView.topicViewModel = topicViewModel;
    
    self.pictureView.frame = topicViewModel.pictureFrame;
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

- (IBAction)topRightClick:(UIButton *)sender {
}


#pragma mark - getter

- (BSJTopicPictureView *)pictureView
{
    if(_pictureView == nil)
    {
        BSJTopicPictureView *pictureView = [[BSJTopicPictureView alloc] init];
        [self.contentView addSubview:pictureView];
        _pictureView = pictureView;
    }
    return _pictureView;
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
