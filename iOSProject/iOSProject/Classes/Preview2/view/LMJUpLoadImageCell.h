//
//  LMJUpLoadImageCell.h
//  iOSProject
//
//  Created by HuXuPeng on 2017/12/31.
//  Copyright © 2017年 HuXuPeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LMJUpLoadImageCell : UICollectionViewCell

/** <#digest#> */
@property (nonatomic, strong) UIImage *photoImage;

/** <#digest#> */
@property (nonatomic, copy) void(^deletePhotoClick)(UIImage *photoImage);

/** <#digest#> */
@property (nonatomic, copy) void(^addPhotoClick)(LMJUpLoadImageCell *uploadImageCell);

/** <#digest#> */
@property (nonatomic, assign) CGFloat uploadProgress;

@end
