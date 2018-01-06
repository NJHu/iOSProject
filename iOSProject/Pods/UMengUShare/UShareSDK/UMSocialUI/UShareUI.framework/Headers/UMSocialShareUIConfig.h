//
//  UMSocialShareUIConfig.h
//  UMSocialSDK
//
//  Created by 张军华 on 16/11/7.
//  Copyright © 2016年 UMeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <UMSocialCore/UMSocialCore.h>
#import "UMSocialUIUtility.h"

@class UMSocialSharePageGroupViewConfig;
@class UMSocialShareContainerConfig;
@class UMSocialShareTitleViewConfig;
@class UMSocialSharePageScrollViewConfig;
@class UMSocialSharePageControlConfig;
@class UMSocialShareCancelControlConfig;
@class UMSocialSharePageControl;
@class UMSocialSharePageScrollView;
@class UMSocialPlatformItemViewConfig;

typedef void(^UMSocialSharePlatformSelectionBlock)(UMSocialPlatformType platformType,NSDictionary* userInfo);


/**
 *  分享面板的代码，目前只提供显示,隐藏和指定父窗口
 */
@protocol UMSocialShareMenuViewDelegate <NSObject>
@optional
/**
 *  分享面板显示的回调
 */
- (void)UMSocialShareMenuViewDidAppear;

/**
 *  分享面板的消失的回调
 */
- (void)UMSocialShareMenuViewDidDisappear;

/**
 *  返回分享面板的父窗口,用于嵌入在父窗口上显示
 *
 *  @param defaultSuperView 默认加载的父窗口
 *
 *  @return 返回实际的父窗口
 *  @note 返回的view应该是全屏的view，方便分享面板来布局。
 *  @note 如果用户要替换成自己的ParentView，需要保证该view能覆盖到navigationbar和statusbar
 *  @note 当前分享面板已经是在window上,如果需要切换就重写此协议，如果不需要改变父窗口则不需要重写此协议
 */
- (UIView*)UMSocialParentView:(UIView*)defaultSuperView;
@end


/**
 *  点击平台的代理
 */
@protocol UMSocialHandlePlatformTypeDelegate <NSObject>

@optional

/**
 *  点击分享面板的回调
 *
 *  @param platformType 平台类型 @see UMSocialPlatformType
 *  @param userInfo     点击对应平台类型附带的userinfo,字典类型可为nil
 */
- (void)handlePlatformType:(UMSocialPlatformType)platformType withUserInfo:(NSDictionary*)userInfo;

@end


/**
 *  滑动分页scrollview的代理
 */
@protocol UMSocialHandlePlatformTypeDelegate;

@protocol UMSocialSharePageScrollViewDelegate <NSObject>

@optional

/**
 *  滑动分页scrollview的代理
 *
 *  @param sharePageScrollView UMSocialSharePageScrollView的对象
 *  @param numberOfPages       当前的分页总数
 *  @param currentPage         当前页的index
 */
- (void)handleSocialSharePageScrollView:(UMSocialSharePageScrollView *)sharePageScrollView
                      withNumberOfPages:(NSInteger)numberOfPages
                        withCurrentPage:(NSInteger)currentPage;


@end

/**
 *  点击pageControl的事件的代理
 */
@protocol UMSocialSharePageControlDelegate <NSObject>

@optional
- (void)handleSocialSharePageControl:(UMSocialSharePageControl*)sharePageControl withNewPage:(NSInteger)newPage;

@end

typedef NS_ENUM(NSUInteger, UMSocialSharePageGroupViewPositionType){
    UMSocialSharePageGroupViewPositionType_Bottom,//显示在底部
    UMSocialSharePageGroupViewPositionType_Middle,//显示在中间
};

typedef NS_ENUM(NSUInteger, UMSocialPlatformItemViewBackgroudType){
    UMSocialPlatformItemViewBackgroudType_None,//有图片，没有圆背景，
    UMSocialPlatformItemViewBackgroudType_IconAndBGRadius,//有图片，圆背景，
    UMSocialPlatformItemViewBackgroudType_IconAndBGRoundAndSuperRadius,//有图片，圆角背景，
};

/**
 *  分享面板的配置类
 */
@interface UMSocialShareUIConfig : NSObject

+(UMSocialShareUIConfig*)shareInstance;

@property(nonatomic,readwrite,strong)UMSocialSharePageGroupViewConfig*          sharePageGroupViewConfig;
@property(nonatomic,readwrite,strong)UMSocialShareContainerConfig*              shareContainerConfig;
@property(nonatomic,readwrite,strong)UMSocialShareTitleViewConfig*              shareTitleViewConfig;
@property(nonatomic,readwrite,strong)UMSocialSharePageScrollViewConfig*         sharePageScrollViewConfig;
@property(nonatomic,readwrite,strong)UMSocialPlatformItemViewConfig*            sharePlatformItemViewConfig;
@property(nonatomic,readwrite,strong)UMSocialSharePageControlConfig*            sharePageControlConfig;
@property(nonatomic,readwrite,strong)UMSocialShareCancelControlConfig*          shareCancelControlConfig;

@end


/**
 *  ShareMenuSelection的配置类
 */
@interface UMSocialSharePageGroupViewConfig : NSObject

@property(nonatomic,readwrite,strong)UIColor*   sharePageGroupViewBackgroundColor;//背景颜色

@property(nonatomic,readwrite,strong)UIColor*   sharePageGroupViewMaskColor;//分享菜单整个背景
@property(nonatomic,readwrite,assign)CGFloat    sharePageGroupViewMaskViewAlpha;//分享菜单整个背景的Alpha

@property (nonatomic,readwrite,assign)UMSocialSharePageGroupViewPositionType   sharePageGroupViewPostionType;//分享面板类的位置@see UMSocialSharePageGroupViewPositionType

@end

/**
 * ShareContainer的配置类
 */
@interface UMSocialShareContainerConfig : NSObject

@property(nonatomic,readwrite,assign)CGFloat shareContainerMarginTop;//相对父view的上边距
@property(nonatomic,readwrite,assign)CGFloat shareContainerMarginBottom;//相对父view的下边距
@property(nonatomic,readwrite,assign)CGFloat shareContainerMarginLeft;//相对父view的左边距
@property(nonatomic,readwrite,assign)CGFloat shareContainerMarginRight;//相对父view的右边距
@property(nonatomic,readwrite,assign)CGFloat shareContainerMarginLeftForMid;//相对父view的左边距如果sharePageGroupViewPostionType为UMSocialSharePageGroupViewPositionType_Middle的时候
@property(nonatomic,readwrite,assign)CGFloat shareContainerMarginRightForMid;//相对父view的右边距相对父view的左边距如果sharePageGroupViewPostionType为UMSocialSharePageGroupViewPositionType_Middle的时候

@property(nonatomic,readwrite,assign)CGFloat shareContainerCornerRadius;//圆角
@property(nonatomic,readwrite,strong)UIColor* shareContainerBackgroundColor;//背景色

//设置ShareContainer左右渐变显示的参数
@property(nonatomic,readwrite,assign)BOOL     isShareContainerHaveGradient;//是否开启渐变当滑动到边缘的时候
@property(nonatomic,readwrite,strong)UIColor* shareContainerGradientStartColor;//渐变开始的颜色
@property(nonatomic,readwrite,strong)UIColor* shareContainerGradientEndColor;//渐变结束的颜色
@property(nonatomic,readwrite,assign)CGFloat shareContainerGradientLeftWidth;//左边的渐变宽度
@property(nonatomic,readwrite,assign)CGFloat shareContainerGradientRightWidth;//右边的渐变宽度

@end

/**
 *  ShareTitleView的配置类
 */
@interface UMSocialShareTitleViewConfig : NSObject

@property(nonatomic,readwrite,assign)BOOL isShow;//是否显示

@property(nonatomic,readwrite,strong)NSString* shareTitleViewTitleString;//标题的文字
@property(nonatomic,readwrite,strong)UIFont* shareTitleViewFont;//字体
@property(nonatomic,readwrite,strong)UIColor* shareTitleViewTitleColor;//文字颜色
//shareContainerPaddingLeft
@property(nonatomic,readwrite,strong)UIColor* shareTitleViewBackgroundColor;//背景颜色

@property(nonatomic,readwrite,assign)CGFloat shareTitleViewPaddingTop;//title的内边距top
@property(nonatomic,readwrite,assign)CGFloat shareTitleViewPaddingBottom;//title的内边距Bottom



@end

/**
 *  ShareScrollView的配置类
 */
@interface UMSocialSharePageScrollViewConfig : NSObject

@property(nonatomic,readwrite,strong)UIColor* shareScrollViewBackgroundColor;//shareScrollView背景色

@property(nonatomic,readwrite,assign)CGFloat shareScrollViewPageRowSpace;//每页的行间距
@property(nonatomic,readwrite,assign)CGFloat shareScrollViewPageColumnSpace;//每页的列间距(在设置了shareScrollViewPageMaxItemWidth后，列间距会变化一般设置只是估算每行的容纳的item的个数)
@property(nonatomic,readwrite,assign)CGFloat shareScrollViewPageMarginLeft; //每页的左边距
@property(nonatomic,readwrite,assign)CGFloat shareScrollViewPageMarginRight; //每页的右边距
@property(nonatomic,readwrite,assign)CGFloat shareScrollViewPageMarginTop; //每页的上边距
@property(nonatomic,readwrite,assign)CGFloat shareScrollViewPageMarginBottom; //每页的下边距

@property(nonatomic,readwrite,assign)CGFloat shareScrollViewPadingLeft; //ScrollView的Left外边距(相对与父窗口)
@property(nonatomic,readwrite,assign)CGFloat shareScrollViewPadingRight; //ScrollView的Right外边距(相对与父窗口)
@property(nonatomic,readwrite,assign)CGFloat shareScrollViewPadingTop; //ScrollView的Top边距(相对与父窗口)
@property(nonatomic,readwrite,assign)CGFloat shareScrollViewPadingBottom; //ScrollView的Bottom边距(相对与父窗口)

@property(nonatomic,readwrite,assign)CGFloat shareScrollViewPageMaxItemWidth; //每页Items的最大宽度
@property(nonatomic,readwrite,assign)CGFloat shareScrollViewPageMaxItemHeight; //每页Items的最大高度

@property(nonatomic,readwrite,assign)CGFloat shareScrollViewPageMaxItemBGWidth; //每页Item内部icon下背景的宽度与shareScrollViewPageMaxItemWidth相同
@property(nonatomic,readwrite,assign)CGFloat shareScrollViewPageMaxItemBGHeight; //每页Item内部icon下背景的高度与shareScrollViewPageMaxItemBGWidth相同
@property(nonatomic,readwrite,assign)CGFloat shareScrollViewPageMaxItemIconWidth; //每页Item内部icon下宽度
@property(nonatomic,readwrite,assign)CGFloat shareScrollViewPageMaxItemIconHeight; //每页Item内部icon下高度
@property(nonatomic,readwrite,assign)CGFloat shareScrollViewPageMaxItemSpaceBetweenIconAndName; //每页Item背景和icon的上下间距
@property(nonatomic,readwrite,assign)CGFloat shareScrollViewPageMaxItemNameHeight; //每页Item的name的高度
@property(nonatomic,readwrite,assign)CGFloat shareScrollViewPageMaxItemNameWidth; //每页Item的name的宽度，和shareScrollViewPageMaxItemBGWidth一样

@property(nonatomic,readwrite,strong)UIColor* shareScrollViewPageBGColor; //每页的背景颜色

@property(nonatomic,readwrite,assign)UMSocialPlatformItemViewBackgroudType shareScrollViewPageItemStyleType;//@see UMSocialPlatformItemViewBackgroudType

@property(nonatomic,readwrite,assign)CGFloat shareScrollViewPageMaxRowCountForPortraitAndBottom; //每页显示最大的行(在底部显示手机处于肖像模式)
@property(nonatomic,readwrite,assign)CGFloat shareScrollViewPageMaxColumnCountForPortraitAndBottom; //每页显示最大的列(在底部显示手机处于肖像模式)

@property(nonatomic,readwrite,assign)CGFloat shareScrollViewPageMaxRowCountForLandscapeAndBottom; //每页显示最大的行(在底部显示手机处于风景模式)
@property(nonatomic,readwrite,assign)CGFloat shareScrollViewPageMaxColumnCountForLandscapeAndBottom; //每页显示最大的列(在底部显示手机处于风景模式)

@property(nonatomic,readwrite,assign)CGFloat shareScrollViewPageMaxRowCountForPortraitAndMid; //每页显示最大的行(在中间显示手机处于肖像模式)
@property(nonatomic,readwrite,assign)CGFloat shareScrollViewPageMaxColumnCountForPortraitAndMid; //每页显示最大的列(在中间显示手机处于肖像模式)

@property(nonatomic,readwrite,assign)CGFloat shareScrollViewPageMaxRowCountForLandscapeAndMid; //每页显示最大的行(在中间显示手机处于风景模式)
@property(nonatomic,readwrite,assign)CGFloat shareScrollViewPageMaxColumnCountForLandscapeAndMid; //每页显示最大的列(在中间显示手机处于风景模式)


@end

/**
 *  每个page内Item的配置类
 */
@interface UMSocialPlatformItemViewConfig : NSObject

@property(nonatomic,readwrite,strong)UIColor* sharePlatformItemViewBGRadiusColor; //有圆角背景时的颜色
@property(nonatomic,readwrite,strong)UIColor* sharePlatformItemViewBGRadiusColorPressed;//有圆角背景时的按下颜色

@property(nonatomic,readwrite,strong)UIColor* sharePlatformItemViewPlatformNameColor;//平台的颜色

@end

/**
 *  SharePageControl的配置类
 */
@interface UMSocialSharePageControlConfig : NSObject

@property(nonatomic,readwrite,assign)BOOL isShow;//是否显示

@property(nonatomic,readwrite,strong)UIColor*  sharePageControlPageIndicatorTintColor;//指示器颜色
@property(nonatomic,readwrite,strong)UIColor*  sharePageControlCurrentPageIndicatorTintColor;//当前的页的颜色
@property(nonatomic,readwrite,assign)BOOL      sharePageControlHidesForSinglePage;//为一页是会隐藏
@property(nonatomic,readwrite,strong)UIColor*  sharePageControlBackgroundColor;//背景色

@end

/**
 *  ShareCancelControl的配置类
 */
@interface UMSocialShareCancelControlConfig : NSObject

@property(nonatomic,readwrite,assign)BOOL isShow;//是否显示

@property(nonatomic,readwrite,strong)NSString* shareCancelControlText;//相对父view的左边距
@property(nonatomic,readwrite,strong)UIColor* shareCancelControlTextColor;//文字颜色
@property(nonatomic,readwrite,strong)UIFont* shareCancelControlTextFont;//文字字体
@property(nonatomic,readwrite,strong)UIColor* shareCancelControlBackgroundColor;//背景颜色;
@property(nonatomic,readwrite,strong)UIColor* shareCancelControlBackgroundColorPressed;//点击时的按下颜色

@end





