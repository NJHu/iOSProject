//
//  BSJMeSquareCell.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/6/16.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "BSJMeSquareCell.h"


@interface BSJMeSquareCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation BSJMeSquareCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
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

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
}


- (void)setMeSquare:(BSJMeSquare *)meSquare
{
    _meSquare = meSquare;
    
    [self.iconImageView sd_setImageWithURL:meSquare.icon];
    self.nameLabel.text = meSquare.name;
}

@end
