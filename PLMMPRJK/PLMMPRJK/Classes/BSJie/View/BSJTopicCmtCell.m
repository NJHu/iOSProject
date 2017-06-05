//
//  BSJTopicCmtCell.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/6/4.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "BSJTopicCmtCell.h"
#import "BSJUser.h"

@interface BSJTopicCmtCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UIButton *sexButton;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *cmtContentLabel;

@end

@implementation BSJTopicCmtCell


+ (instancetype)cmtCellWithTableView:(UITableView *)tableView
{
    
    BSJTopicCmtCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
    
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self.class) owner:nil options:nil].lastObject;
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
    
}


- (void)setCmt:(BSJComment *)cmt
{
    _cmt = cmt;
    
//    /** id */
//    @property (nonatomic, copy) NSString *ID;
//    /** 评论内容 */
//    @property (nonatomic, copy) NSString *content;
//    
//    
//    /** 点赞数 */
//    @property (copy, nonatomic) NSString *like_count;
//    
//    
//    /** 用户 */
//    @property (nonatomic, strong) BSJUser *user;
//    
//    /** 评论时间 */
//    @property (nonatomic, copy) NSString *ctime;
//    
//    /** 语音评论时长 */
//    @property (nonatomic, copy) NSString *voicetime;
//    
//    /** 语音评论url */
////    @property (nonatomic, copy) NSString *voiceurl;
    
    [self.headerImageView sd_setImageWithURL:cmt.user.profile_image placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
    
    switch (cmt.user.sexSex) {
        case BSJUserSexMale:
        {
            self.sexButton.selected = NO;
        }
            break;
            
        case BSJUserSexFemale:
        {
            self.sexButton.selected = YES;
        }
            break;
    }
    
    self.userName.text = cmt.user.username.copy;
    
    self.cmtContentLabel.text = cmt.content;
    
    
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    
}

- (IBAction)dingClick:(id)sender {
}

@end
