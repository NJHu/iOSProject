//
//  LMJCountDownCell.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/5/5.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJCountDownCell.h"

@implementation LMJCountDownCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier]) {
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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    
}


- (void)setCountDownModel:(LMJCountDownModel *)countDownModel
{
    [_countDownModel removeObserverBlocks];
    
    _countDownModel = countDownModel;
    
    self.imageView.image = countDownModel.pruductImage;
    self.textLabel.text = countDownModel.productName;
    
    self.userInteractionEnabled = !(countDownModel.date <= CFAbsoluteTimeGetCurrent());
    
    self.detailTextLabel.text = [self timeStr:countDownModel.date];
    
    LMJWeakSelf(self);
    [countDownModel addObserverBlockForKeyPath:LMJKeyPath(countDownModel, date) block:^(id  _Nonnull obj, id  _Nullable oldVal, id  _Nullable newVal) {
        
        weakself.detailTextLabel.text = [weakself timeStr:[newVal doubleValue]];
        weakself.userInteractionEnabled = !([newVal doubleValue] <= CFAbsoluteTimeGetCurrent());
        
    }];
    
}


- (NSString *)timeStr:(NSTimeInterval)totalSeconds
{
    
//    NSDateFormatter *fmt = [NSDateFormatter dateFormatterWithFormat:@"HH:mm:ss"];
    
    NSInteger lastTimeSeconds = totalSeconds - CFAbsoluteTimeGetCurrent();
    
    if (lastTimeSeconds <= 0) {
        return @"当前产品已经秒拍结束";
    }
    
    NSInteger h = lastTimeSeconds / 3600;
    NSInteger m = (lastTimeSeconds % 3600) / 60;
    NSInteger s = lastTimeSeconds % 60;
    
    
    return [NSString stringWithFormat:@"%02zd : %02zd : %02zd", h, m, s];
}


- (void)dealloc
{
    NSLog(@"%@, %s",self, __func__);
}

@end
