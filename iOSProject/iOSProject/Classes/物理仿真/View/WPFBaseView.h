//
//  WPFBaseView.h
//  02-多物理仿真
//
//  Created by 王鹏飞 on 16/1/9.
//  Copyright © 2016年 王鹏飞. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WPFBaseView : UIView

/**  方块视图  */
@property (nonatomic, weak) UIImageView *boxView;

/**  仿真者  */
@property (nonatomic, strong) UIDynamicAnimator *animator;

@end
