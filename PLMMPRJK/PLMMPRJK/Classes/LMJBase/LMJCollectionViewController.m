//
//  LMJCollectionViewController.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/4/11.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJCollectionViewController.h"

@interface LMJCollectionViewController ()


@end

@implementation LMJCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    [self setupBaseCFPCollectionViewControllerUI];
}

- (void)setupBaseCFPCollectionViewControllerUI
{
    
    self.collectionView.backgroundColor = self.view.backgroundColor;
    
    
    if ([self.parentViewController isKindOfClass:[UINavigationController class]]) {
        
        self.collectionView.contentInset  = UIEdgeInsetsMake(64, 0, 0, 0);
        
        if ([self respondsToSelector:@selector(lmjNavigationHeight:)]) {
            
            self.collectionView.contentInset  = UIEdgeInsetsMake([self lmjNavigationHeight:nil], 0, 0, 0);
        }
    }
    
    
}

#pragma mark - delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [UICollectionViewCell new];
}

#pragma mark - scrollDeleggate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.collectionView.scrollIndicatorInsets = self.collectionView.contentInset;
    [self.view endEditing:YES];
}

- (UICollectionView *)collectionView
{
    if(_collectionView == nil)
    {
        LMJWaterflowLayout *myLayout = [[LMJWaterflowLayout alloc] init];
        
        myLayout.delegate = self;
        
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:myLayout];
        [self.view addSubview:collectionView];
        _collectionView = collectionView;
        
        collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        collectionView.dataSource = self;
        collectionView.delegate = self;
        
    }
    return _collectionView;
}


#pragma mark - LMJWaterflowLayoutDelegate
- (CGFloat)waterflowLayout:(LMJWaterflowLayout *)waterflowLayout heightForItemAtIndexPath:(NSIndexPath *)indexPath itemWidth:(CGFloat)itemWidth
{
    // 默认
    
//    NSAssert(0, @"子类必须重载%s", __FUNCTION__);
    
    return 100;
}

@end
