//
//  SINBroswerViewController.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/6/23.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "SINBroswerViewController.h"
#import "SINBroswerCell.h"
#import "UIView+GestureCallback.h"

@interface SINBroswerViewController ()<LMJHorizontalFlowLayoutDelegate>

@end

@implementation SINBroswerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.modalPresentationCapturesStatusBarAppearance = YES;
    self.view.backgroundColor = self.collectionView.backgroundColor = [UIColor blackColor];
    self.collectionView.pagingEnabled = YES;
    LMJWeak(self);
    [self.collectionView addTapGestureRecognizer:^(UITapGestureRecognizer *recognizer, NSString *gestureId) {
        [weakself dismissViewControllerAnimated:YES completion:nil];
    }];
    [self.collectionView registerClass:[SINBroswerCell class] forCellWithReuseIdentifier:NSStringFromClass([SINBroswerCell class])];
    self.collectionView.lmj_width += 10;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    CGFloat pageWidth = self.collectionView.frame.size.width;
    CGFloat offsetY = self.collectionView.contentOffset.y;
    CGFloat offsetX = self.startIndexPath.item * pageWidth;
    CGPoint offset = CGPointMake(offsetX,offsetY);
    [self.collectionView setContentOffset:offset animated:NO];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark - collectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.imageUrls.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SINBroswerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([SINBroswerCell class]) forIndexPath:indexPath];
    cell.imageDict = self.imageUrls[indexPath.item];
    return cell;
}



#pragma mark - SINBroswerAnimatorDismissDelegate

- (CGRect)startRectWithBroswerAnimator:(SINBroswerAnimator *)broswerAnimator {
    SINBroswerCell *currentCell = (SINBroswerCell *)self.collectionView.visibleCells.firstObject;
    return [currentCell convertRect:currentCell.imageView.frame toView:[UIApplication sharedApplication].keyWindow];
}

- (UIImageView *)startImageViewWithBroswerAnimator:(SINBroswerAnimator *)broswerAnimator {
    SINBroswerCell *currentCell = (SINBroswerCell *)self.collectionView.visibleCells.firstObject;
    
    UIImageView *startImage = [[UIImageView alloc] init];
    startImage.contentMode = UIViewContentModeScaleAspectFill;
    startImage.image = currentCell.imageView.image;
    startImage.clipsToBounds = YES;
    return startImage;
}

- (NSIndexPath *)currentIndexPathWithBroswerAnimator:(SINBroswerAnimator *)broswerAnimator {
    return self.collectionView.indexPathsForVisibleItems.firstObject;
}


#pragma mark - layout
- (UICollectionViewLayout *)collectionViewController:(LMJCollectionViewController *)collectionViewController layoutForCollectionView:(UICollectionView *)collectionView {
    return [LMJHorizontalFlowLayout flowLayoutWithDelegate:self];
}


/**
 *  要求实现
 *
 *  @param waterflowLayout 哪个布局需要代理返回高度
 *  @param  indexPath          对应的cell, 的indexPath, 但是indexPath.section == 0
 *  @param itemHeight           layout内部计算的高度
 *
 *  @return 需要代理高度对应的cell的高度
 */
- (CGFloat)waterflowLayout:(LMJHorizontalFlowLayout *)waterflowLayout collectionView:(UICollectionView *)collectionView widthForItemAtIndexPath:(NSIndexPath *)indexPath itemHeight:(CGFloat)itemHeight
{
    return self.collectionView.lmj_width;
}


/**
 *  需要显示的行数, 默认3
 */
- (NSInteger)waterflowLayout:(LMJHorizontalFlowLayout *)waterflowLayout linesInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
/**
 *  列间距, 默认10
 */
- (CGFloat)waterflowLayout:(LMJHorizontalFlowLayout *)waterflowLayout collectionView:(UICollectionView *)collectionView columnsMarginForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return 0;
}
/**
 *  行间距, 默认10
 */
- (CGFloat)waterflowLayout:(LMJHorizontalFlowLayout *)waterflowLayout linesMarginInCollectionView:(UICollectionView *)collectionView
{
    return 0;
}

/**
 *  距离collectionView四周的间距, 默认{10, 10, 10, 10}
 */
- (UIEdgeInsets)waterflowLayout:(LMJHorizontalFlowLayout *)waterflowLayout edgeInsetsInCollectionView:(UICollectionView *)collectionView
{
    return UIEdgeInsetsZero;
}

@end
