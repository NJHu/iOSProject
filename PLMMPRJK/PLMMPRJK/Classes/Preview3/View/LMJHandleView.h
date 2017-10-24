//
//  LMJHandleView.h
//  DrawingBoard-2
//
//  Created by apple on 16/6/10.
//  Copyright © 2016年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^LMJHandleViewImageBlock)(UIImage *image);
@interface LMJHandleView : UIView

@property (nonatomic, strong) LMJHandleViewImageBlock imageBlock;
@property (nonatomic, strong) UIImage *image;

@end
