//
//  LMJLineFlowLayout.m
//  自定义流水布局-22
//
//  Created by apple on 16/7/30.
//  Copyright © 2016年 NJHu. All rights reserved.
//

#import "LMJLineFlowLayout.h"

@implementation LMJLineFlowLayout

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

- (void)prepareLayout
{
    [super prepareLayout];
    
//    NSLog(@"lllllllllllllllllllllllllllllllllllll");
        self.itemSize = CGSizeMake(140, 140);
        
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        self.minimumInteritemSpacing = 500;
//        self.minimumLineSpacing = 44;
        
        CGFloat inset = self.collectionView.frame.size.width - self.itemSize.width;
        
        self.sectionInset = UIEdgeInsetsMake(0, inset/2, 0, inset/2);
        

}


- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray *attrbArray = [super layoutAttributesForElementsInRect:rect];
    
    CGFloat collectionViewCenterX = self.collectionView.contentOffset.x + self.collectionView.frame.size.width/2;
    
    for (UICollectionViewLayoutAttributes *atrbs in attrbArray) {
        
        CGFloat delta = ABS(atrbs.center.x - collectionViewCenterX);
        
        CGFloat scale = 1.05 - delta / self.collectionView.frame.size.width;
        
        atrbs.transform3D = CATransform3DMakeScale(scale, scale, scale);
//        atrbs.transform3D = CATransform3DRotate(atrbs.transform3D, scale * M_PI_4, 0.5, 0.5, 0.5);
        
    }
    
    
    
    return attrbArray;
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    
    NSArray *atrbs = [self layoutAttributesForElementsInRect:CGRectMake(proposedContentOffset.x, proposedContentOffset.y, self.collectionView.frame.size.width, self.collectionView.frame.size.height)];
    
    CGFloat collectionCenterX = proposedContentOffset.x + self.collectionView.frame.size.width/2;
    
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

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *atrbs = [super layoutAttributesForItemAtIndexPath:indexPath];
    
//    CGFloat collectionViewCenterX = self.collectionView.contentOffset.x + self.collectionView.frame.size.width/2;
//
//    CGFloat delta = ABS(atrbs.center.x - collectionViewCenterX);
//
//    CGFloat scale = 1.05 - delta / self.collectionView.frame.size.width;
//
//    atrbs.transform3D = CATransform3DMakeScale(scale, scale, scale);
    
    
    return atrbs;
}

@end
