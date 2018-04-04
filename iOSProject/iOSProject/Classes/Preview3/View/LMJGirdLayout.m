//
//  LMJGirdLayout.m
//  自定义流水布局-22
//
//  Created by apple on 16/7/30.
//  Copyright © 2016年 NJHu. All rights reserved.
//

#import "LMJGirdLayout.h"
#define LMJXX(x) floorf(x)
#define LMJXS(s) ceilf(s)

@interface LMJGirdLayout ()
/** 所有的模型数据 */
@property (nonatomic, strong) NSMutableArray<UICollectionViewLayoutAttributes *> *array;
@end

@implementation LMJGirdLayout


- (NSMutableArray *)array
{
    if(_array == nil)
    {
        _array = [NSMutableArray array];
    }
    return _array;
}

- (void)prepareLayout
{
    [super prepareLayout];
    
    NSLog(@"------------------");
    [self.array removeAllObjects];
    
    NSUInteger count = [self.collectionView numberOfItemsInSection:0];
    
    for (NSInteger i = 0; i < count; i++) {
        UICollectionViewLayoutAttributes *atrb = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        [self.array addObject:atrb];
    }
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger i = indexPath.item;
    
    UICollectionViewLayoutAttributes *atrb = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
    
    CGFloat width = LMJXX(self.collectionView.frame.size.width * 0.5);
    
    CGFloat height = width;
    
    CGFloat x = 0;
    CGFloat y = 0;
    
    if(i == 0)
    {
        x = 0;
        y = 0;
    }else if (i == 1)
    {
        x = width;
        y = 0;
        height = width / 2;
    }else if (i == 2)
    {
        x = width;
        y = height / 2;
        height = width / 2;
    }else if (i == 3)
    {
        x = 0;
        y = height;
        height = width / 2;
    }else if (i == 4)
    {
        x = 0;
        y = height + height / 2;
        height = width/2;
    }else if (i == 5)
    {
        x = width;
        y = height;
    }else
    {
        
        UICollectionViewLayoutAttributes *lastAtrb = self.array[i - 6];
        x = lastAtrb.frame.origin.x;
        y = lastAtrb.frame.origin.y + height * 2;
        width = lastAtrb.frame.size.width;
        height = lastAtrb.frame.size.height;
    }
    
    atrb.frame = CGRectMake(x, y, width, height);
    
    return atrb;
}
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return self.array;
}

- (CGSize)collectionViewContentSize
{
    UICollectionViewLayoutAttributes *lastAtrb = self.array.lastObject;
    UICollectionViewLayoutAttributes *preLastAtrb = self.array[self.array.count - 2];
    
    return CGSizeMake(0, MAX(CGRectGetMaxY(lastAtrb.frame), CGRectGetMaxY(preLastAtrb.frame)));
}
@end
