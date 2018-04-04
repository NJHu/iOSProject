//
//  LMJLineFlowLayout.m
//  自定义流水布局-22
//
//  Created by apple on 16/7/30.
//  Copyright © 2016年 NJHu. All rights reserved.
//

#import "LMJLineFlowLayout.h"
static const CGSize LMJ_itemSize_ = {140, 140};

@interface LMJLineFlowLayout ()

@end

@implementation LMJLineFlowLayout

//判定为布局需要被无效化并重新计算的时候,布局对象会被询问以提供新的布局。
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

//系统在准备对item进行布局前会调用这个方法,我们重写这个方法之后可以在方法里面预先设置好需要用到的变量属
- (void)prepareLayout
{
    [super prepareLayout];
    CGFloat inset = self.collectionView.frame.size.width - self.itemSize.width;
    self.sectionInset = UIEdgeInsetsMake(0, inset * 0.5, 0, inset * 0.5);
}


//为所有item返回一个layout attributes数组，数组中元素的类型为UICollectionViewLayoutAttributes。UICollectionViewLayoutAttributes记录了一个layout的位置、大小、透明度等信息
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray<UICollectionViewLayoutAttributes *> *attrbArray = [super layoutAttributesForElementsInRect:rect];
    
    CGFloat collectionViewCenterX = self.collectionView.contentOffset.x + self.collectionView.frame.size.width * 0.5;
    
    [attrbArray enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        CGFloat delta = ABS(obj.center.x - collectionViewCenterX);
        
        CGFloat scale = 1.05 - delta / self.collectionView.frame.size.width;
        
        obj.transform3D = CATransform3DMakeScale(scale, scale, scale);
        
//        obj.transform3D = CATransform3DRotate(obj.transform3D, scale * M_PI_4, 0.5, 0.5, 0.5);
        
    }];
    return attrbArray;
}


/**
 停下来停最大的
 */
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    NSArray *atrbs = [self layoutAttributesForElementsInRect:CGRectMake(proposedContentOffset.x, proposedContentOffset.y, self.collectionView.frame.size.width, self.collectionView.frame.size.height)];

    CGFloat collectionCenterX = proposedContentOffset.x + self.collectionView.frame.size.width * 0.5;

   __block CGFloat minDelta = MAXFLOAT;

    [atrbs enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes * _Nonnull atrb, NSUInteger idx, BOOL * _Nonnull stop) {

        if(ABS(minDelta) > ABS(atrb.center.x - collectionCenterX))
        {
            minDelta = atrb.center.x - collectionCenterX;
        }
    }];

    proposedContentOffset.x += minDelta;

    return proposedContentOffset;
}

//为一个特定的item返回layout attribute。注意，返回的attribute仅使用cell，不包括supplementary view和decoration view
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *atrbs = [super layoutAttributesForItemAtIndexPath:indexPath];
    return atrbs;
}


#pragma mark - LMJLineFlowLayoutDelegate

- (id<LMJLineFlowLayoutDelegate>)delegate
{
    return (id<LMJLineFlowLayoutDelegate>)self.collectionView.dataSource;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.minimumInteritemSpacing = MAXFLOAT;
        self.itemSize = LMJ_itemSize_;
    }
    return self;
}

- (instancetype)initWithDelegate:(id<LMJLineFlowLayoutDelegate>)delegate
{
    if (self = [self init]) {
    }
    return self;
}

+ (instancetype)lineLayoutWithDelegate:(id<LMJLineFlowLayoutDelegate>)delegate
{
    return [[self alloc] initWithDelegate:delegate];
}

@end
