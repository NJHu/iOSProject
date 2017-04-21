//
//  LMJVerticalFlowLayout.h
//  瀑布流完善接口
//
//  Created by apple on 16/7/31.
//  Copyright © 2016年 NJHu. All rights reserved.
//

#import <UIKit/UIKit.h>


@class LMJVerticalFlowLayout;


@protocol LMJVerticalFlowLayoutDelegate <NSObject>

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
- (CGFloat)waterflowLayout:(LMJVerticalFlowLayout *)waterflowLayout collectionView:(UICollectionView *)collectionView heightForItemAtIndexPath:(NSIndexPath *)indexPath itemWidth:(CGFloat)itemWidth;
@optional

/**
 *  需要显示的列数, 默认3
 */
- (NSInteger)waterflowLayout:(LMJVerticalFlowLayout *)waterflowLayout columnsInCollectionView:(UICollectionView *)collectionView;
/**
 *  列间距, 默认10
 */
- (CGFloat)waterflowLayout:(LMJVerticalFlowLayout *)waterflowLayout columnsMarginInCollectionView:(UICollectionView *)collectionView;
/**
 *  行间距, 默认10
 */
- (CGFloat)waterflowLayout:(LMJVerticalFlowLayout *)waterflowLayout collectionView:(UICollectionView *)collectionView linesMarginForItemAtIndexPath:(NSIndexPath *)indexPath;

/**
 *  距离collectionView四周的间距, 默认{20, 10, 10, 10}
 */
- (UIEdgeInsets)waterflowLayout:(LMJVerticalFlowLayout *)waterflowLayout edgeInsetsInCollectionView:(UICollectionView *)collectionView;


@end



@interface LMJVerticalFlowLayout : UICollectionViewLayout

/** layout的代理 */
- (instancetype)initWithDelegate:(id<LMJVerticalFlowLayoutDelegate>)delegate;

+ (instancetype)flowLayoutWithDelegate:(id<LMJVerticalFlowLayoutDelegate>)delegate;

@end
