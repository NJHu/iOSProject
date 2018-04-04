//
//  LMJCircleLayout.h
//  自定义流水布局-22
//
//  Created by apple on 16/7/30.
//  Copyright © 2016年 NJHu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LMJCircleLayout;

@protocol LMJCircleLayoutDelegate <NSObject>
@optional
/**
 返回 item 的大小, 默认 64
 */
- (CGSize)circleLayout:(LMJCircleLayout *)circleLayout collectionView:(UICollectionView *)collectionView sizeForItemAtIndexPath:(NSIndexPath *)indexPath;

/**
 返回 item 对应的半径 , 默认120
 */
- (CGFloat)circleLayout:(LMJCircleLayout *)circleLayout collectionView:(UICollectionView *)collectionView radiusForItemAtIndexPath:(NSIndexPath *)indexPath;
@end

@interface LMJCircleLayout : UICollectionViewLayout

- (instancetype)initWithDelegate:(id<LMJCircleLayoutDelegate>)delegate;

+ (instancetype)circleLayoutWithDelegate:(id<LMJCircleLayoutDelegate>)delegate;

@end
