//
//  LMJUpLoadImageCell.h
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/5/4.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import <UIKit/UIKit.h>


@class MPImageItemModel;

@interface LMJUpLoadImageCell : UICollectionViewCell

/** <#digest#> */
@property (nonatomic, copy) void(^blankTap)();

/** <#digest#> */
@property (nonatomic, copy) void(^imageTap)(MPImageItemModel *imageItem);

/** <#digest#> */
@property (nonatomic, copy) void(^deleteImageTap)(MPImageItemModel *imageItem);


/** <#digest#> */
@property (nonatomic, strong) MPImageItemModel *imageItem;


@end
