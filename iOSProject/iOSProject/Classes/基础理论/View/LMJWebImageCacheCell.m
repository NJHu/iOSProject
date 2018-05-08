//
//  LMJWebImageCacheCell.m
//  iOSProject
//
//  Created by HuXuPeng on 2018/4/7.
//  Copyright © 2018年 github.com/njhu. All rights reserved.
//

#import "LMJWebImageCacheCell.h"
@interface LMJWebImageCacheCell()

@end

@implementation LMJWebImageCacheCell


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
    self.videoImageView.layer.cornerRadius = 20;
    self.videoImageView.layer.masksToBounds = YES;
}

@end
