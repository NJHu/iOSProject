//
//  LMJUploadImageProgressCell.h
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/5/5.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import <UIKit/UIKit.h>



/**
 主要使用 KVO 实现
 */
@class MPImageItemModel;
@interface LMJUploadImageProgressCell : UICollectionViewCell

/** <#digest#> */
@property (nonatomic, copy) void(^blankTap)();

/** <#digest#> */
@property (nonatomic, copy) void(^imageTap)(MPImageItemModel *imageItem);

/** <#digest#> */
@property (nonatomic, copy) void(^deleteImageTap)(MPImageItemModel *imageItem);

/**
 主要使用 KVO 实现
 */

/** <#digest#> */
@property (nonatomic, strong) MPImageItemModel *imageItem;

@end
