//
//  MPTitleAndPromptCell.h
//  MobileProject 左边标题 右边当为空时显示色较浅的提示语 有值时显示内容
//
//  Created by wujunyang on 16/8/19.
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MPTitleAndPromptCellType)
{
    MPTitleAndPromptCellTypeInput = 0,
    MPTitleAndPromptCellTypeSelect
};


@interface MPTitleAndPromptCell : UITableViewCell

/**
 *  @author wujunyang, 16-08-19 10:08:15
 *
 *  @brief  左边标题 右边当为空时显示色较浅的提示语 有值时显示内容
 *
 *  @param curkey     左边标题
 *  @param curvalue   右边内容
 *  @param blankvalue 提示语
 *  @param showLine   是否显示下划线
 *  @param cellType   CELL的类型
 */
-(void)setCellDataKey:(NSString *)curkey curValue:(NSString *)curvalue blankValue:(NSString *)blankvalue isShowLine:(BOOL)showLine cellType:(MPTitleAndPromptCellType)cellType;

@end
