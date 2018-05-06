//
//  LMJCountDownCell.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/5/5.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJCountDownCell.h"

@implementation LMJCountDownCell

- (void)setCountDownModel:(LMJCountDownModel *)countDownModel
{
    _countDownModel = countDownModel;
    self.imageView.image = countDownModel.pruductImage;
    
    self.userInteractionEnabled = (countDownModel.date <= 0);
    
    self.textLabel.text = [NSString stringWithFormat:@"%.0lf", countDownModel.date];
    
    self.textLabel.text = countDownModel.date <= 0 ? @"End" : [NSString stringWithFormat:@"%zd", (NSUInteger)countDownModel.date];
}




@end
