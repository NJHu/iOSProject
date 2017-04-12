//
//  LMJWaterflowLayout.m
//  瀑布流完善接口
//
//  Created by apple on 16/7/31.
//  Copyright © 2016年 NJHu. All rights reserved.
//
#import "LMJWaterflowLayout.h"

static const NSInteger LMJ_Columns_ = 3;
static const CGFloat LMJ_XMargin_ = 10;
static const CGFloat LMJ_YMargin_ = 10;
static const UIEdgeInsets LMJ_EdgeInsets_ = {20, 10, 10, 10};

@interface LMJWaterflowLayout()

/** 所有的cell的attrbts */
@property (nonatomic, strong) NSMutableArray *lmj_AtrbsArray;

/** 每一列的最后的高度 */
@property (nonatomic, strong) NSMutableArray *lmj_ColumnsHeightArray;

- (NSInteger)columns;

- (CGFloat)xMargin;

- (CGFloat)yMargin;

- (UIEdgeInsets)edgeInsets;

@end

@implementation LMJWaterflowLayout



/**
 *  刷新布局的时候回重新调用
 */
- (void)prepareLayout
{
    [super prepareLayout];
    
    //如果重新刷新就需要移除之前存储的高度
    [self.lmj_ColumnsHeightArray removeAllObjects];
    
    //复赋值以顶部的高度, 并且根据列数
    for (NSInteger i = 0; i < self.columns; i++) {
        
        [self.lmj_ColumnsHeightArray addObject:@(self.edgeInsets.top)];
    }
    
    // 移除以前计算的cells的attrbs
    [self.lmj_AtrbsArray removeAllObjects];
    
    // 并且重新计算, 每个cell对应的atrbs, 保存到数组
    for (NSInteger i = 0; i < [self.collectionView numberOfItemsInSection:0]; i++)
    {
        [self.lmj_AtrbsArray addObject:[self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]]];
    }
    
    

}


/**
 *在这里边所处每个cell对应的位置和大小
 */
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *atrbs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    CGFloat w = 1.0 * (self.collectionView.frame.size.width - self.edgeInsets.left - self.edgeInsets.right - self.xMargin * (self.columns - 1)) / self.columns;
    
    // 高度由外界决定, 外界必须实现这个方法
    CGFloat h = [self.delegate waterflowLayout:self heightForItemAtIndexPath:indexPath itemWidth:w];
    
    // 拿到最后的高度最小的那一列, 假设第0列最小
    NSInteger indexCol = 0;
    CGFloat minColH = [self.lmj_ColumnsHeightArray[indexCol] doubleValue];
    
    for (NSInteger i = 1; i < self.lmj_ColumnsHeightArray.count; i++)
    {
        CGFloat colH = [self.lmj_ColumnsHeightArray[i] doubleValue];
        if(minColH > colH)
        {
            minColH = colH;
            indexCol = i;
        }
    }
    
    
    CGFloat x = self.edgeInsets.left + (self.xMargin + w) * indexCol;
    
    CGFloat y = ((minColH == self.edgeInsets.top) ? minColH : (minColH + self.yMargin));
    
    // 赋值frame
    atrbs.frame = CGRectMake(x, y, w, h);
    
    // 覆盖添加完后那一列;的最新高度
    self.lmj_ColumnsHeightArray[indexCol] = @(CGRectGetMaxY(atrbs.frame));
    
    return atrbs;
}


- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return self.lmj_AtrbsArray;
}


- (CGSize)collectionViewContentSize
{
    CGFloat maxColH = [self.lmj_ColumnsHeightArray[0] doubleValue];
    
    for (NSInteger i = 1; i < self.lmj_ColumnsHeightArray.count; i++)
    {
        CGFloat colH = [self.lmj_ColumnsHeightArray[i] doubleValue];
        if(maxColH < colH)
        {
            maxColH = colH;
        }
    }
    
    return CGSizeMake(self.collectionView.frame.size.width, maxColH + self.edgeInsets.bottom);
}


- (NSMutableArray *)lmj_AtrbsArray
{
    if(_lmj_AtrbsArray == nil)
    {
        _lmj_AtrbsArray = [NSMutableArray array];
    }
    return _lmj_AtrbsArray;
}

- (NSMutableArray *)lmj_ColumnsHeightArray
{
    if(_lmj_ColumnsHeightArray == nil)
    {
        _lmj_ColumnsHeightArray = [NSMutableArray array];
    }
    return _lmj_ColumnsHeightArray;
}

- (NSInteger)columns
{
    if([self.delegate respondsToSelector:@selector(waterflowLayoutOfColumns:)])
    {
        return [self.delegate waterflowLayoutOfColumns:self];
    }
    else
    {
        return LMJ_Columns_;
    }
}

- (CGFloat)xMargin
{
    if([self.delegate respondsToSelector:@selector(waterflowLayouOftMarginBetweenColumns:)])
    {
        return [self.delegate waterflowLayouOftMarginBetweenColumns:self];
    }
    else
    {
        return LMJ_XMargin_;
    }
}

- (CGFloat)yMargin
{
    if([self.delegate respondsToSelector:@selector(waterflowLayoutOfMarginBetweenLines:)])
    {
        return [self.delegate waterflowLayoutOfMarginBetweenLines:self];
    }else
    {
        return LMJ_YMargin_;
    }
}

- (UIEdgeInsets)edgeInsets
{
    if([self.delegate respondsToSelector:@selector(waterflowLayoutOfEdgeInsets:)])
    {
        return [self.delegate waterflowLayoutOfEdgeInsets:self];
    }
    else
    {
        return LMJ_EdgeInsets_;
    }
}

@end
