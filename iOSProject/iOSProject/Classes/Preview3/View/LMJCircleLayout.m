//
//  LMJCircleLayout.m
//  自定义流水布局-22
//
//  Created by apple on 16/7/30.
//  Copyright © 2016年 NJHu. All rights reserved.
//

#import "LMJCircleLayout.h"

@interface LMJCircleLayout ()
/** <#digest#> */
@property (nonatomic, strong) NSMutableArray *atrbsArray;
@end

@implementation LMJCircleLayout

- (NSMutableArray *)atrbsArray
{
    if(_atrbsArray == nil)
    {
        _atrbsArray = [NSMutableArray array];
    }
    return _atrbsArray;
}

- (void)prepareLayout
{
    [super prepareLayout];
    
    [self.atrbsArray removeAllObjects];
    
    NSUInteger count = [self.collectionView numberOfItemsInSection:0];
    
    for (NSInteger i = 0; i < count; i++) {
        
        UICollectionViewLayoutAttributes *atrb = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        
        [self.atrbsArray addObject:atrb];
    }
    
}


- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return self.atrbsArray;
}


- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *newAtrb = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    CGSize size = CGSizeMake(62, 62);
    
    
    CGPoint oCenter =  CGPointMake(self.collectionView.frame.size.width/2, self.collectionView.frame.size.height/2);
    
    
    CGFloat angle = M_PI * 2 / [self.collectionView numberOfItemsInSection:0] * indexPath.item;
    
    
    CGFloat radius = 100;
    
    CGFloat realX = oCenter.x + sin(angle) * radius;
    CGFloat realY = oCenter.y - cos(angle) * radius;
    
    
    
    newAtrb.size = size;
    
    
    if([self.collectionView numberOfItemsInSection:0] == 1)
    {
        newAtrb.center = oCenter;
    }
    else
    {
        
        newAtrb.center = CGPointMake(realX, realY);
    }
    
    return newAtrb;
}


- (CGSize)collectionViewContentSize
{
    return self.collectionView.frame.size;
}



@end
