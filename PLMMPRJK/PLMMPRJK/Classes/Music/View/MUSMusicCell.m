//
//  MUSMusicCell.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/9/27.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "MUSMusicCell.h"

@implementation MUSMusicCell



- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
    self.imageView.lmj_size = CGSizeMake(44, 44);
    
    self.imageView.lmj_y = (self.lmj_height - self.imageView.lmj_height) * 0.5;
}

@end
