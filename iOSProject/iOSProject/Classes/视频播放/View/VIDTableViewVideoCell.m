//
//  VIDTableViewVideoCell.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/9/22.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "VIDTableViewVideoCell.h"

@interface VIDTableViewVideoCell ()



@property (weak, nonatomic  ) IBOutlet UILabel              *titleLabel;
@property (nonatomic, weak) IBOutlet UIButton                      *playBtn;

@end

@implementation VIDTableViewVideoCell

+ (instancetype)videoCellWithTableView:(UITableView *)tableView
{
    
    VIDTableViewVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
    
    if (cell == nil) {
        
        @try {
            
            cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self.class) owner:nil options:nil].lastObject;
            
        } @catch (NSException *exception) {
            
            NSLog(@"%@", exception);
            
        } @finally {
            
            if (cell == nil) {
                cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass(self)];
            }
            
        }
        
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
    
    self.picView.tag = 1032;
    self.picView.userInteractionEnabled = YES;
    [self.picView addSubview:self.playBtn];
}


- (void)setModel:(ZFVideoModel *)model {
    _model = model;
    [self.picView sd_setImageWithURL:[NSURL URLWithString:model.coverForFeed] placeholderImage:[UIImage imageWithColor:[UIColor RandomColor]]];
    
    self.titleLabel.text = model.title;
}

- (IBAction)play:(UIButton *)sender {
    if (self.playBlock) {
        self.playBlock(sender);
    }
}

@end
