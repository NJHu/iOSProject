//
//  UIView+LMJNjHuFrame.h
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/4/29.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (LMJNjHuFrame)

@property (nonatomic) CGFloat lmj_x;        ///< Shortcut for frame.origin.x.
@property (nonatomic) CGFloat lmj_y;         ///< Shortcut for frame.origin.y
@property (nonatomic) CGFloat lmj_right;       ///< Shortcut for frame.origin.x + frame.size.width
@property (nonatomic) CGFloat lmj_bottom;      ///< Shortcut for frame.origin.y + frame.size.height
@property (nonatomic) CGFloat lmj_width;       ///< Shortcut for frame.size.width.
@property (nonatomic) CGFloat lmj_height;      ///< Shortcut for frame.size.height.
@property (nonatomic) CGFloat lmj_centerX;     ///< Shortcut for center.x
@property (nonatomic) CGFloat lmj_centerY;     ///< Shortcut for center.y
@property (nonatomic) CGPoint lmj_origin;      ///< Shortcut for frame.origin.
@property (nonatomic) CGSize  lmj_size;        ///< Shortcut for frame.size.

@end
