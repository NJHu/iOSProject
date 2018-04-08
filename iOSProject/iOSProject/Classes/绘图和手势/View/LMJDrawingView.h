//
//  LMJDrawingView.h
//  DrawingBoard-2
//
//  Created by apple on 16/6/10.
//  Copyright © 2016年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LMJDrawingView : UIView

/** <#digest#> */
@property (nonatomic, strong) UIImage *image;

@property (nonatomic, strong) UIColor *lineColor;

/** <#digest#> */
@property (assign, nonatomic) CGFloat lineWidth;

- (void)clearAll;

- (void)undo;

@end
