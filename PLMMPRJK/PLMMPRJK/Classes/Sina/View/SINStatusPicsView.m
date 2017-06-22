//
//  SINStatusPicsView.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/6/22.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "SINStatusPicsView.h"
#import "SINStatusViewModel.h"
#import "SINDictURL.h"

@interface SINStatusPicsView ()<UICollectionViewDelegate, UICollectionViewDataSource, LMJVerticalFlowLayoutDelegate>

/** <#digest#> */
@property (weak, nonatomic) UICollectionView *collectionView;

@end

@implementation SINStatusPicsView



- (void)setupUIOnce
{
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class])];
    
    self.backgroundColor = [UIColor RandomColor];
    self.collectionView.backgroundColor = [UIColor RandomColor];
    
}

- (void)setStatusViewModel:(SINStatusViewModel *)statusViewModel
{
    _statusViewModel = statusViewModel;
    
    [self.collectionView reloadData];
}


#pragma mark - <UICollectionViewDelegate, UICollectionViewDataSource,

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.statusViewModel.status.pic_urls.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class]) forIndexPath:indexPath];
    
    cell.contentView.layer.contentMode = UIViewContentModeScaleAspectFill;
    cell.contentView.layer.masksToBounds = YES;
    
    [cell.contentView.layer setImageURL:self.statusViewModel.status.pic_urls[indexPath.item].bmiddle_pic];
    
    
    return cell;
}


#pragma mark - layoutDeledate
/**
 *  要求实现
 *
 *  @param waterflowLayout 哪个布局需要代理返回高度
 *  @param  indexPath          对应的cell, 的indexPath, 但是indexPath.section == 0
 *  @param width           layout内部计算的宽度
 *
 *  @return 需要代理高度对应的cell的高度
 */
- (CGFloat)waterflowLayout:(LMJVerticalFlowLayout *)waterflowLayout collectionView:(UICollectionView *)collectionView heightForItemAtIndexPath:(NSIndexPath *)indexPath itemWidth:(CGFloat)itemWidth
{
    return self.statusViewModel.sin_statusPicsViewModel.itemHeight;
}


/**
 *  需要显示的列数, 默认3
 */
- (NSInteger)waterflowLayout:(LMJVerticalFlowLayout *)waterflowLayout columnsInCollectionView:(UICollectionView *)collectionView
{
    return self.statusViewModel.sin_statusPicsViewModel.cols;
}
/**
 *  列间距, 默认10
 */
- (CGFloat)waterflowLayout:(LMJVerticalFlowLayout *)waterflowLayout columnsMarginInCollectionView:(UICollectionView *)collectionView
{
    return 5;
}
/**
 *  行间距, 默认10
 */
- (CGFloat)waterflowLayout:(LMJVerticalFlowLayout *)waterflowLayout collectionView:(UICollectionView *)collectionView linesMarginForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return 5;
}

/**
 *  距离collectionView四周的间距, 默认{20, 10, 10, 10}
 */
- (UIEdgeInsets)waterflowLayout:(LMJVerticalFlowLayout *)waterflowLayout edgeInsetsInCollectionView:(UICollectionView *)collectionView
{
    return UIEdgeInsetsZero;
}



#pragma mark - getter

- (UICollectionView *)collectionView
{
    if(_collectionView == nil)
    {
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:[UICollectionViewFlowLayout new]];
        
        [self addSubview:collectionView];
        _collectionView = collectionView;
        
        UICollectionViewLayout *myLayout = [[LMJVerticalFlowLayout alloc] initWithDelegate:self];
        
        collectionView.collectionViewLayout = myLayout;
        
        collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        collectionView.dataSource = self;
        collectionView.delegate = self;
        collectionView.scrollEnabled = NO;
        
        [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.edges.insets(UIEdgeInsetsZero);
        }];
        
    }
    return _collectionView;
}


#pragma mark - base

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupUIOnce];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setupUIOnce];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
}


@end
