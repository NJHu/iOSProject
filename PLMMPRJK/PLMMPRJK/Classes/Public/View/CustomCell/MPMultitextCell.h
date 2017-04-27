//
//  MPMultitextCell.h
//  MobileProject  多行输入框效果 值为空时有提示
//
//  Created by wujunyang on 16/8/19.
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIPlaceHolderTextView.h"

@interface MPMultitextCell : UITableViewCell<UITextViewDelegate>

//字体大小
@property(nonatomic,assign)CGFloat placeFontSize;

@property (nonatomic,copy) void(^textValueChangedBlock)(NSString* text);

//返回行高
+ (CGFloat)cellHeight;

/**
 *  @author wujunyang, 16-08-19 10:08:34
 *
 *  @brief  <#Description#>
 *
 *  @param cellTitle  标题
 *  @param textValue  值
 *  @param blankvalue 空值时的提示语
 *  @param isShowLine 是否显示下划线
 */
-(void)setCellDataKey:(NSString *)cellTitle textValue:(NSString *)textValue blankValue:(NSString *)blankvalue showLine:(BOOL)isShowLine;

//焦点事件
-(BOOL)becomeFirstResponder;

-(BOOL)resignFirstResponder;


@end
