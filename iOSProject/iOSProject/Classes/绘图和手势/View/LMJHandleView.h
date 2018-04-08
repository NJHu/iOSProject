//
//  LMJHandleView.h
//  DrawingBoard-2
//
//  Created by apple on 16/6/10.
//  Copyright © 2016年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

//typedef void(^LMJHandleViewImageBlock)(UIImage *image);

/**
 手势训练
 */
@interface LMJHandleView : UIView

@property (nonatomic, strong) void(^imageBlock)(UIImage *image) ;
@property (nonatomic, strong) UIImage *image;

@end
