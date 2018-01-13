//
//  LMJCollectionViewController.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/4/11.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJCollectionViewController.h"

@interface LMJCollectionViewController ()<LMJVerticalFlowLayoutDelegate>


@end

@implementation LMJCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self setupBaseLMJCollectionViewControllerUI];
    
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class])];
}

- (void)setupBaseLMJCollectionViewControllerUI
{
    
    self.collectionView.backgroundColor = self.view.backgroundColor;
    
    
    if ([self.parentViewController isKindOfClass:[UINavigationController class]]) {
        
        if ([self respondsToSelector:@selector(lmjNavigationHeight:)]) {
            
            self.collectionView.contentInset  = UIEdgeInsetsMake([self lmjNavigationHeight:nil], 0, 0, 0);
        }
    }
    
    
}

#pragma mark - delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 100;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class]) forIndexPath:indexPath];
    
    cell.contentView.backgroundColor = [UIColor yellowColor];
    
    cell.contentView.clipsToBounds = YES;
    if (![cell.contentView viewWithTag:100]) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        label.tag = 100;
        label.textColor = [UIColor redColor];
        label.font = [UIFont boldSystemFontOfSize:17];
        [cell.contentView addSubview:label];
    }
    
    UILabel *label = [cell.contentView viewWithTag:100];
    
    label.text = [NSString stringWithFormat:@"%zd", indexPath.item];
    
    
    return cell;
}

#pragma mark - scrollDeleggate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    UIEdgeInsets contentInset = self.collectionView.contentInset;
    contentInset.bottom -= self.collectionView.mj_footer.lmj_height;
    self.collectionView.scrollIndicatorInsets = contentInset;
    
    [self.view endEditing:YES];
}

- (UICollectionView *)collectionView
{
    if(_collectionView == nil)
    {
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:[UICollectionViewFlowLayout new]];
        [self.view addSubview:collectionView];
        _collectionView = collectionView;
        
        UICollectionViewLayout *myLayout = [self collectionViewController:self layoutForCollectionView:collectionView];
        
        collectionView.collectionViewLayout = myLayout;
        
        collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        collectionView.dataSource = self;
        collectionView.delegate = self;
        
    }
    return _collectionView;
}


#pragma mark - LMJCollectionViewControllerDataSource
- (UICollectionViewLayout *)collectionViewController:(LMJCollectionViewController *)collectionViewController layoutForCollectionView:(UICollectionView *)collectionView
{
    
    LMJVerticalFlowLayout *myLayout = [[LMJVerticalFlowLayout alloc] initWithDelegate:self];
    
    return myLayout;
}


#pragma mark - LMJVerticalFlowLayoutDelegate

- (CGFloat)waterflowLayout:(LMJVerticalFlowLayout *)waterflowLayout collectionView:(UICollectionView *)collectionView heightForItemAtIndexPath:(NSIndexPath *)indexPath itemWidth:(CGFloat)itemWidth
{
    return itemWidth * (arc4random() % 4 + 1);
}


@end
