//
//  LMJElementsFlowLayout.h
//  瀑布流完善接口
//
//  Created by apple on 16/7/31.
//  Copyright © 2016年 NJHu. All rights reserved.
//

#import <UIKit/UIKit.h>


@class LMJElementsFlowLayout;


@protocol LMJElementsFlowLayoutDelegate <NSObject>

@required
/**
 *  要求实现
 *
 *  @param waterflowLayout 哪个布局需要代理返回大小
 *  @param  indexPath          对应的cell, 的indexPath, 但是indexPath.section == 0
 *
 *  @return 需要代理高度对应的cell的高度
 */
- (CGSize)waterflowLayout:(LMJElementsFlowLayout *)waterflowLayout heightForItemAtIndexPath:(NSIndexPath *)indexPath;



@optional

/**
 *  竖直方向的间距, 默认10
 */
- (CGFloat)waterflowLayouOftMarginBetweenColumns:(LMJElementsFlowLayout *)waterflowLayout;
/**
 *  水平方向的间距, 默认10
 */
- (CGFloat)waterflowLayoutOfMarginBetweenLines:(LMJElementsFlowLayout *)waterflowLayout;

/**
 *  距离collectionView四周的间距, 默认10, 顶部是20
 */
- (UIEdgeInsets)waterflowLayoutOfEdgeInsets:(LMJElementsFlowLayout *)waterflowLayout;


@end


@interface LMJElementsFlowLayout : UICollectionViewLayout

/** layout的代理 */
@property (weak, nonatomic) id<LMJElementsFlowLayoutDelegate> delegate;
@end
