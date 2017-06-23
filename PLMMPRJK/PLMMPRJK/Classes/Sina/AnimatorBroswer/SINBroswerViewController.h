//
//  SINBroswerViewController.h
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/6/23.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJCollectionViewController.h"
#import "SINDictURL.h"
#import "SINBroswerAnimator.h"

@interface SINBroswerViewController : LMJCollectionViewController<SINBroswerAnimatorDismissDelegate>

/** <#digest#> */
@property (nonatomic, strong) NSIndexPath *startIndexPath;


/** <#digest#> */
@property (nonatomic, strong) NSArray<SINDictURL *> *imageUrls;

@end
