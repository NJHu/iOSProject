//
//  LMJHorizontalFlowLayout.h
//  瀑布流完善接口
//
//  Created by apple on 16/7/31.
//  Copyright © 2016年 NJHu. All rights reserved.
//

#import <UIKit/UIKit.h>


@class LMJHorizontalFlowLayout;


@protocol LMJHorizontalFlowLayoutDelegate <NSObject>

@required
/**
 *  要求实现
 *
 *  @param waterflowLayout 哪个布局需要代理返回高度
 *  @param  indexPath          对应的cell, 的indexPath, 但是indexPath.section == 0
 *  @param itemHeight           layout内部计算的高度
 *
 *  @return 需要代理高度对应的cell的高度
 */
- (CGFloat)waterflowLayout:(LMJHorizontalFlowLayout *)waterflowLayout widthForItemAtIndexPath:(NSIndexPath *)indexPath itemHeight:(CGFloat)itemHeight;
@optional

/**
 *  需要显示的行数, 默认3
 */
- (NSInteger)waterflowLayoutOfLines:(LMJHorizontalFlowLayout *)waterflowLayout;
/**
 *  竖直方向的间距, 默认10
 */
- (CGFloat)waterflowLayouOftMarginBetweenColumns:(LMJHorizontalFlowLayout *)waterflowLayout;
/**
 *  水平方向的间距, 默认10
 */
- (CGFloat)waterflowLayoutOfMarginBetweenLines:(LMJHorizontalFlowLayout *)waterflowLayout;

/**
 *  距离collectionView四周的间距, 默认{10, 10, 10, 10}
 */
- (UIEdgeInsets)waterflowLayoutOfEdgeInsets:(LMJHorizontalFlowLayout *)waterflowLayout;


@end



@interface LMJHorizontalFlowLayout : UICollectionViewLayout

/** layout的代理 */
@property (weak, nonatomic) id<LMJHorizontalFlowLayoutDelegate> delegate;
@end
