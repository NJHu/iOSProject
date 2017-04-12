//
//  LMJCollectionViewController.h
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/4/11.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJBaseViewController.h"
#import "LMJWaterflowLayout.h"

@interface LMJCollectionViewController : LMJBaseViewController <UICollectionViewDelegate, UICollectionViewDataSource, LMJWaterflowLayoutDelegate>

/** <#digest#> */
@property (weak, nonatomic) UICollectionView *collectionView;

@end
