//
//  ZJCustomLabel.h
//  ZJScrollPageView
//
//  Created by jasnig on 16/5/6.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZJSegmentStyle.h"
@interface ZJTitleView : UIView
@property (assign, nonatomic) CGFloat currentTransformSx;

@property (assign, nonatomic) TitleImagePosition imagePosition;

@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) UIColor *textColor;
@property (strong, nonatomic) UIFont *font;
@property (assign, nonatomic, getter=isSelected) BOOL selected;
/** 代理方法中推荐只设置下面的属性, 当然上面的属性设置也会有效, 不过建议上面的设置在style里面设置 */
@property (strong, nonatomic) UIImage *normalImage;
@property (strong, nonatomic) UIImage *selectedImage;

@property (strong, nonatomic, readonly) UIImageView *imageView;
@property (strong, nonatomic, readonly) UILabel *label;
- (CGFloat)titleViewWidth;
- (void)adjustSubviewFrame;
@end
