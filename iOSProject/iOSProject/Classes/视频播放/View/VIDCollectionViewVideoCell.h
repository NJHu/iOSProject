//
//  VIDCollectionViewVideoCell.h
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/9/23.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZFVideoModel.h"

@interface VIDCollectionViewVideoCell : UICollectionViewCell




@property (weak, nonatomic  ) IBOutlet UIImageView          *picView;

+ (instancetype)videoCellWithCollectionView:(UICollectionView *)collectionView forIndexPath:(NSIndexPath *)indexPath;

/** model */
@property (nonatomic, strong) ZFVideoModel                  *model;
/** 播放按钮block */
@property (nonatomic, copy  ) void(^playBlock)(UIButton *btn);

@end
