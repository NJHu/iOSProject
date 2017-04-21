//
//  LMJCollectionViewController.h
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/4/11.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJBaseViewController.h"
#import "LMJElementsFlowLayout.h"
#import "LMJVerticalFlowLayout.h"
#import "LMJHorizontalFlowLayout.h"


@class LMJCollectionViewController;
@protocol LMJCollectionViewControllerDataSource <NSObject>

@required
// 需要返回对应的布局
- (UICollectionViewLayout *)collectionViewController:(LMJCollectionViewController *)collectionViewController layoutForCollectionView:(UICollectionView *)collectionView;

@end

@interface LMJCollectionViewController : LMJBaseViewController <UICollectionViewDelegate, UICollectionViewDataSource, LMJCollectionViewControllerDataSource>

/** <#digest#> */
@property (weak, nonatomic) UICollectionView *collectionView;

@end
