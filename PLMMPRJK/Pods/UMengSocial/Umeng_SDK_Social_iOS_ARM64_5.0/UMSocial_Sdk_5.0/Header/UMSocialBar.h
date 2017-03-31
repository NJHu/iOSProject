//
//  UMSocialBar.h
//  SocialSDK
//
//  Created by yeahugo on 13-7-2.
//  Copyright (c) 2013年 Umeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UMSocialSnsPlatformManager.h"
#import "UMSocialControllerServiceComment.h"

/**
 分享
 */
extern NSString *const UMSocialShare;

/**
 喜欢
 */
extern NSString *const UMSocialLike;

/**
 评论
 */
extern NSString *const UMSocialComment;

/**
 个人中心
 */
extern NSString *const UMSocialAccount;


typedef void (^ClickHandler)(void);


/**
 代表平台或者功能的按钮
 */
@interface UMSocialButton : UIButton

/**
 点击按钮之后的响应事件
 */
@property (nonatomic, copy)   ClickHandler clickHandler;

/**
 当前`<UMSocialUIDelegate>`对象,此对象可以获取到授权完成，关闭页面等状态，详情看`UMSocialUIDelegate`的定义
 */
@property (nonatomic, assign) id <UMSocialUIDelegate> socialUIDelegate;

/**
 按钮名称
 */
@property (nonatomic, copy) NSString *buttonName;

/**
 按钮初始化方法
 
 @param buttonName 按钮类型，可以指定`UMSocialShare`,`UMSocialComment`，`UMSocialLike`、`UMSocialAccount`分别代表分享、评论、喜欢、个人中心
 或者`UMShareToSina`、`UMShareToTencent`等代表各个微博平台
 
 @param socialData 数据对象，如果是评论或者喜欢，代表不同的评论、喜欢对象。可以传nil，使用默认数据对象
 
 @param controller 分享编辑页面、评论页面等将弹到的UIViewController对象
 
 */
-(id)initWithButtonName:(NSString *)buttonName
             socialData:(UMSocialData *)socialData
             controller:(UIViewController *)controller;

/**
按钮初始化方法

@param buttonName 按钮类型，可以指定`UMSocialShare`,`UMSocialComment`，`UMSocialLike`、`UMSocialAccount`分别代表分享、评论、喜欢、个人中心
或者`UMShareToSina`、`UMShareToTencent`等代表各个微博平台

@param controllerService UMSocialControllerService对象，如果是评论或者喜欢，代表不同的评论、喜欢对象。可以传nil，使用默认数据对象

@param controller 分享编辑页面、评论页面等将弹到的UIViewController对象

*/
-(id)initWithButtonName:(NSString *)buttonName
      controllerService:(UMSocialControllerServiceComment *)controllerService
             controller:(UIViewController *)controller;

@end

/**
 社会化操作栏，默认集成了评论、喜欢、分享、个人中心等功能。
 你可以根据你的需求对操作栏上的各个按钮进行定制，方法是修改barButtons数组。
 */
@interface UMSocialBar : UIView

/**
 代表操作栏上所有按钮的数组，数组的元素是UMSocialButton对象。
 
 你可以增加自定义的按钮，例如
 
 ```
    UMSocialButton *customButton = [[UMSocialButton alloc] initWithButtonType:@"custom" socialData:nil controller:nil];
        customButton.clickHandler = ^(){
        NSLog(@"click !!");
    };
    [customButton setImage:[UIImage imageNamed:@"icon"] forState:UIControlStateNormal];
    [_socialBar.barButtons addObject:customButton];
 ```
 
 你可以删除指定的按钮

 ```
    [_socialBar.barButtons removeObjectAtIndex:1];
 ```

 可以修改指定按钮

 ```
    UMSocialButton *socialButton1 =  [_socialBar.barButtons objectAtIndex:1];
    socialButton1.clickHandler = ^(){
        NSLog(@"click!!");
    };
 ```
 */
@property (nonatomic, retain) NSMutableArray *barButtons;

/**
 `UMSocialData`对象，可以通过该对象设置分享内嵌文字、图片，获取分享数等属性
 */
@property (nonatomic, retain) UMSocialData *socialData;

/**
 当前`<UMSocialUIDelegate>`对象,此对象可以获取到授权完成，关闭页面等状态，详情看`UMSocialUIDelegate`的定义
 */
@property (nonatomic, assign) id <UMSocialUIDelegate> socialUIDelegate;

/**
 初始化方法
 
 @param socialData 标识不同分享对象
 
 @param viewController 分享编辑页面等弹出到的UIViewController对象
 */
- (id)initWithUMSocialData:(UMSocialData *)socialData
        withViewController:(UIViewController *)viewController;

/**
 更新操作栏的数字
 
 */
- (void)updateButtonNumber;

/*
 从线上获取分享、评论、喜欢等个数，更新按钮文字
 
 */
- (void)requestUpdateButtonNumber;

@end
