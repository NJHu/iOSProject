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
//    self.textLabel.text = countDownModel.productName;
    
    self.userInteractionEnabled = !(countDownModel.date <= CFAbsoluteTimeGetCurrent());
    
    self.textLabel.text = [NSString stringWithFormat:@"%lu", (NSUInteger)countDownModel.date];
}




@end
