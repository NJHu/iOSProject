//
//  MenuPopOverView.h
//  SearchBar
//
//  Created by Camel Yang on 4/1/14.
//  Copyright (c) 2014 camelcc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MenuPopOverView;

@protocol MenuPopOverViewDelegate <NSObject>
@optional
- (void)popoverView:(MenuPopOverView *)popoverView didSelectItemAtIndex:(NSInteger)index;
- (void)popoverViewDidDismiss:(MenuPopOverView *)popoverView;

@end

@interface MenuPopOverView : UIView

@property (nonatomic, copy) UIColor *popOverBackgroundColor;
@property (nonatomic, copy) UIColor *popOverHighlightedColor;
@property (nonatomic, copy) UIColor *popOverSelectedColor;
@property (nonatomic, copy) UIColor *popOverDividerColor;
@property (nonatomic, copy) UIColor *popOverBorderColor;
@property (nonatomic, copy) UIColor *popOverTextColor;
@property (nonatomic, copy) UIColor *popOverHighlightedTextColor;
@property (nonatomic, copy) UIColor *popOverSelectedTextColor;

@property (weak, nonatomic) id<MenuPopOverViewDelegate> delegate;

- (void)presentPopoverFromRect:(CGRect)rect inView:(UIView *)view withStrings:(NSArray *)stringArray;
- (void)presentPopoverFromRect:(CGRect)rect inView:(UIView *)view withStrings:(NSArray *)stringArray selectedIndex:(NSInteger)selectedIndex;

@end
