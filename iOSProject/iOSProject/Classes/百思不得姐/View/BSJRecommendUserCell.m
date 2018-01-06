//
//  BSJRecommendUserCell.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/5/14.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "BSJRecommendUserCell.h"
#import "BSJRecommendUser.h"


@interface BSJRecommendUserCell ()

@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *fansCountLabel;

@end

@implementation BSJRecommendUserCell

static NSString *const categoryID = @"user";

+ (instancetype)userCellWithTableView:(UITableView *)tableView
{
    BSJRecommendUserCell *userCell = [tableView dequeueReusableCellWithIdentifier:categoryID];
    
    if(userCell == nil)
    {
        userCell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
    }
    
    return userCell;
}

/**
 *  设置数据
 *
 *  @param category 模型数据
 */
- (void)setUser:(BSJRecommendUser *)user
{
    _user = user;
    
    self.screenNameLabel.text = user.screen_name;
    
    if(user.fans_count < 10000)
    {
        self.fansCountLabel.text = [NSString stringWithFormat:@"粉丝: %zd", user.fans_count];
    }
    else
    {
        self.fansCountLabel.text = [NSString stringWithFormat:@"粉丝: %.1f万", user.fans_count / 10000.0];
    }
    
    [self.headerImageView sd_setImageWithURL:user.header placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
    
}

- (IBAction)clickAttention:(UIButton *)sender {
    
    NSLogFunc;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
}
@end
