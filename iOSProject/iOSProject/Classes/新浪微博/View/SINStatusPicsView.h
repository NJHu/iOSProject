//
//  SINStatusPicsView.h
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/6/22.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SINStatusViewModel;
@interface SINStatusPicsView : UIView

@property (nonatomic, strong) SINStatusViewModel *statusViewModel;

@end


@interface SINStatusPicsViewCell : UICollectionViewCell

@property (weak, nonatomic) UIImageView *imageView;

@end
