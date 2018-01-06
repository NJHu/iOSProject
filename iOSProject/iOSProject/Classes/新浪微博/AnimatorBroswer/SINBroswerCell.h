//
//  SINBroswerCell.h
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/6/23.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SINDictURL.h"

@interface SINBroswerCell : UICollectionViewCell

/** <#digest#> */
@property (nonatomic, strong) SINDictURL *imageDict;

/** <#digest#> */
@property (weak, nonatomic) UIImageView *imageView;

@end
