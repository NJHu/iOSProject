//
//  UIViewController+TopBarMessage.h
//  DXTopBarMessageView
//
//  Created by xiekw on 14-3-17.
//  Copyright (c) 2014年 xiekw. All rights reserved.
//

///通知显示的2种模式
typedef enum {
    
    TopBarMessageModeOverlay = 0,   //视图不下移
    
    TopBarMessageModeResize,        //视图下移
    
}TopBarMessageMode;


#import <UIKit/UIKit.h>

@interface TopWarningView : UIView

@property (nonatomic, strong) NSString *warningText;
@property (nonatomic, strong) UIImageView *iconIgv;
@property (nonatomic, copy) dispatch_block_t tapHandler;
@property (nonatomic, assign) float dimissDelay;
@property (nonatomic, strong) UILabel *label;

@property (nonatomic, assign) TopBarMessageMode mode;


- (void)resetViews;
- (void)dismiss;

@end

///============================================================

@interface UIViewController (TopBarMessage)

//@property (nonatomic, strong) TopWarningView *topV;

/**
 *  Set the global default apperance of the top message, may be the appdelegate class is a good place to setup
 *
 *  @param apperance the top bar view config, the whole version will be @{kDXTopBarBackgroundColor:[UIColor blueColor], kDXTopBarTextColor : [UIColor yellowColor], kDXTopBarIcon : [UIImage imageNamed:@"icon.png"], kDXTopBarTextFont : [UIFont boldSystemFontOfSize:15.0]}
 */
+ (void)setTopMessageDefaultApperance:(NSDictionary *)apperance;

/**
 *  show the message with config on the top bar, note the config won't change the default top message apperance, this is the setTopMessageDefaultApperance: does.
 *
 *  @param message    the text to show
 *  @param config     the top bar view config, the whole version will be @{kDXTopBarBackgroundColor:[UIColor blueColor], kDXTopBarTextColor : [UIColor yellowColor], kDXTopBarIcon : [UIImage imageNamed:@"icon.png"], kDXTopBarTextFont : [UIFont boldSystemFontOfSize:15.0]}
 *  @param delay      time to dismiss. delay = 0 meaning don't dismiss
 *  @param tapHandler the tap handler
 *  
 *  说明 : delay = 0的时候不会自动消失,需要手动隐藏
 */
//- (void)showTopMessage:(NSString *)message topBarConfig:(NSDictionary *)config dismissDelay:(float)delay withTapBlock:(dispatch_block_t)tapHandler;
- (void)showTopMessage:(NSString *)message topBarConfig:(NSDictionary *)config mode:(TopBarMessageMode)messageMode dismissDelay:(float)delay withTapBlock:(dispatch_block_t)tapHandler;

/**
 *  Default style message something like Instagram does
 *
 *  @param message message to tell
 */
- (void)showTopMessage:(NSString *)message;

/**
 *  隐藏弹出视图
 */
- (void)dismissTopMessage;

@end

extern NSString * const kDXTopBarBackgroundColor;
extern NSString * const kDXTopBarTextColor;
extern NSString * const kDXTopBarTextFont;
extern NSString * const kDXTopBarIcon;
