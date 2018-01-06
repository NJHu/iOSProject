//
//  QQLrcCell.m
//  QQMusic
//
//  Created by Apple on 16/5/18.
//  Copyright © 2016年 KeenLeung. All rights reserved.
//

#import "QQLrcCell.h"
#import "QQLrcLabel.h"

static NSString * const reuseId = @"lrcCell";

@interface QQLrcCell()

@property (weak, nonatomic) IBOutlet QQLrcLabel *lrcContentLabel;

@end

@implementation QQLrcCell

#pragma mark --------------------------
#pragma mark 重写 set

/** 给子控件赋值*/
- (void)setLrcModel:(QQLrcModel *)lrcModel{
    _lrcModel = lrcModel;
    
    self.lrcContentLabel.text = lrcModel.lrcStr;
}

/** 设置播放进度*/
- (void)setProgress:(CGFloat)progress{
    
    _progress = progress;
    
    self.lrcContentLabel.progress = progress;
}


#pragma mark --------------------------
#pragma mark 创建
+ (instancetype)cellWithTable:(UITableView *)tableView{
    
    QQLrcCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"QQLrcCell" owner:nil options:nil].firstObject;
    }
    
    return cell;
}


@end
