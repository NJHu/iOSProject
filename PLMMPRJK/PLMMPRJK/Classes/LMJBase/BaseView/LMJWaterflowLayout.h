//
//  LMJWaterflowLayout.h
//  瀑布流完善接口
//
//  Created by apple on 16/7/31.
//  Copyright © 2016年 NJHu. All rights reserved.
//

#import <UIKit/UIKit.h>


@class LMJWaterflowLayout;


@protocol LMJWaterflowLayoutDelegate <NSObject>

@required
/**
 *  要求实现
 *
 *  @param waterflowLayout 哪个布局需要代理返回高度
 *  @param  indexPath          对应的cell, 的indexPath, 但是indexPath.section == 0
 *  @param width           layout内部计算的宽度
 *
 *  @return 需要代理高度对应的cell的高度
 */
- (CGFloat)waterflowLayout:(LMJWaterflowLayout *)waterflowLayout heightForItemAtIndexPath:(NSIndexPath *)indexPath itemWidth:(CGFloat)itemWidth;

@optional

/**
 *  需要显示的列数, 默认3
 */
- (NSInteger)waterflowLayoutOfColumns:(LMJWaterflowLayout *)waterflowLayout;
/**
 *  竖直方向的间距, 默认10
 */
- (CGFloat)waterflowLayouOftMarginBetweenColumns:(LMJWaterflowLayout *)waterflowLayout;
/**
 *  水平方向的间距, 默认10
 */
- (CGFloat)waterflowLayoutOfMarginBetweenLines:(LMJWaterflowLayout *)waterflowLayout;

/**
 *  距离collectionView四周的间距, 默认10
 */
- (UIEdgeInsets)waterflowLayoutOfEdgeInsets:(LMJWaterflowLayout *)waterflowLayout;


@end


@interface LMJWaterflowLayout : UICollectionViewLayout

/** layout的代理 */
@property (weak, nonatomic) id<LMJWaterflowLayoutDelegate> delegate;
@end
