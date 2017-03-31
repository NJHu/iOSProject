//
//  UIViewController+DDPopUpViewController.h
//  appStroreDDReaderHD
//
//  Created by Sun chongyang on 14-1-17.
//  Copyright (c) 2014年 dangdang.com. All rights reserved.
//
//*****************************************************************

//*****************************************************************

#import <UIKit/UIKit.h>

#if __has_feature(objc_arc)
    #define DDAutorelease( expression )     expression
    #define DDRelease( expression )
    #define DDRetain( expression )          expression
#else
    #define DDAutorelease( expression )     [expression autorelease]
    #define DDRelease( expression )         [expression release]
    #define DDRetain( expression )          [expression retain]
#endif

/*
 * 弹出视图的位置
 */
typedef NS_ENUM(NSInteger, DDPopUpPosition){
    DDPopUpPositionCenter = 0,//default
    DDPopUpPositionTop,
    DDPopUpPositionFullScreen,
    DDPopUpPositionLeft,
    DDPopUpPositionRight
};

/*
 * 弹出视图的动画方式
 */
typedef NS_ENUM(NSInteger, DDPopUpAnimationType){
    DDPopUpAnimationTypeNone,
    DDPopUpAnimationTypeSlideVertical,  //默认的动画类型，从屏幕底部向上滑出
    DDPopUpAnimationTypeFade,           //渐现渐隐
    DDPopUpAnimationTypeSlideLTR,       //从屏幕左边向右滑出
    DDPopUpAnimationTypeSlideRTL        //从屏幕右边向左滑出
};

UIKIT_EXTERN NSTimeInterval const kPopupModalAnimationDuration;

typedef void(^DismissCallback)(void);

@class DDPopUpContainerViewController;

@interface UIViewController (DDPopUpViewController)<UINavigationControllerDelegate>

@property (nonatomic,retain) UIViewController *popUpViewController;
@property (nonatomic,assign) CGPoint popUpOffset;               //相对于弹出位置的偏移
@property (nonatomic,assign) CGSize popUpViewSize;              //弹出视图的大小
@property (nonatomic,assign) DDPopUpPosition popUpPosition;     //弹出视图的位置
@property (nonatomic,assign) BOOL dismissWhenTouchBackground;   //是否允许点击背景dismiss
@property (nonatomic,copy) DismissCallback dismissCallback;


+ (void)dismissCurrentShowingPopUpViewControllers;

//use defalut animationType && dismissWhenTouchBackground = YES
- (void)showPopUpViewController:(UIViewController *)popUpViewController;
//dismissWhenTouchBackground = YES
- (void)showPopUpViewController:(UIViewController *)popUpViewController  animationType:(DDPopUpAnimationType)animationType;

- (void)showPopUpViewController:(UIViewController *)popUpViewController  animationType:(DDPopUpAnimationType)animationType dismissWhenTouchBackground:(BOOL)dismissWhenTouchBackground;

//use defalut popup animationType
- (void)dismissPopUpViewController;
- (void)dismissPopUpViewController:(DDPopUpAnimationType)animationType;
- (void)dismissPopUpViewController:(DDPopUpAnimationType)animationType completion:(void (^)(void))completion;

@end

@interface DDPopUpContainerViewController : UIViewController

@property (nonatomic,assign) UIViewController *presentingPopupController;
@property (nonatomic,retain) UIButton *backgroundButton;

@end