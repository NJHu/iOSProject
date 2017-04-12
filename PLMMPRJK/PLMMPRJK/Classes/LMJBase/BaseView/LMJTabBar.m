//
//  LMJTabBar.m
//  CFP
//
//  Created by NJHu on 16/7/17.
//  Copyright © 2016年 . All rights reserved.
//

#import "LMJTabBar.h"

@interface LMJTabBar ()

/** 中间的发布按钮 */
@property (weak, nonatomic) UIButton *publishButton;

@end

@implementation LMJTabBar
/**
 *  设置中间的按钮, 并且布局子控件
 */


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupTabBarUIOnce];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setupTabBarUIOnce];
}

- (void)setupTabBarUIOnce
{
    
    [self setBackgroundImage:[[UIImage imageNamed:@"tabbar-light"] stretchableImageWithLeftCapWidth:1 topCapHeight:1]];
}




- (UIButton *)publishButton
{
    if(_publishButton == nil)
    {
        /**
         *  添加中间的按钮
         */
        UIButton *publishButton = [UIButton buttonWithType:UIButtonTypeCustom];
        //        publishButton.backgroundColor = [UIColor redColor];
        [self addSubview:publishButton];
        
        _publishButton = publishButton;
        
                [publishButton setBackgroundImage:[UIImage imageNamed:@"tabBar_publish_icon"] forState:UIControlStateNormal];
        
                [publishButton setBackgroundImage:[UIImage imageNamed:@"tabBar_publish_click_icon"] forState:UIControlStateHighlighted];
        
        [publishButton addTarget:self action:@selector(publishShow) forControlEvents:UIControlEventTouchUpInside];
        
        [publishButton sizeToFit];
    }
    return _publishButton;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat buttonX = 0;
    CGFloat buttonY = 0;
    
    CGFloat buttonW = self.width / (self.items.count + 1);
    CGFloat buttonH = self.height;
    
    NSInteger index = 0;
    
    /**
     *  设置UITabBarButton
     */
    for (UIView *button in self.subviews)
    {
        if([button isKindOfClass:NSClassFromString(@"UITabBarButton")])
        {
            buttonX = buttonW * (index > 1 ? (index + 1) : index);
            button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
            index++;
        }
    }
    
    
    
    /**
     *  设置中间按钮的尺寸和位置
     */
    
    //    self.publishButton.bounds = CGRectMake(0, 0, self.publishButton.currentBackgroundImage.size.width, self.publishButton.currentBackgroundImage.size.height);
    
    //    self.publishButton.size = self.publishButton.currentBackgroundImage.size;
    
    
    // 注意设置center
    self.publishButton.center = CGPointMake(self.width / 2, self.height/2);
    
}

// 转到发布界面
- (void)publishShow
{
//    [[CFPGuideManager sharedManager] guideToPublish];
}

/**
 *  发通知给lmjtopicVc, 点击了tabar
 *
 *  @param selectedItem 选中了哪个item
 */
- (void)setSelectedItem:(UITabBarItem *)selectedItem
{
    [super setSelectedItem:selectedItem];
    
    
    //    NSDictionary *info = @{
    //                           LMJTabBarControllerDidSelectedIndex : @([self.items indexOfObject:selectedItem])
    //                           };
    //
    //    [LMJNotiDefaultCenter postNotificationName:LMJTabBarControllerDidSelectedNotification object:nil userInfo:info];
    
}





+ (void)initialize
{
    UITabBarItem *item = [UITabBarItem appearanceWhenContainedInInstancesOfClasses:@[[self class]]];
    
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} forState:UIControlStateSelected];
    
    /**
     *  一次性设置tababr上边按钮的字体颜色和选中的字体颜色
     */
    // 通过appearance统一设置所有UITabBarItem的文字属性
    //    // 后面带有UI_APPEARANCE_SELECTOR的方法, 都可以通过appearance对象来统一设置
    //
    //    NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
    //    dictM[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    //    dictM[NSForegroundColorAttributeName] = [UIColor colorWithRed:0.541 green:0.529 blue:0.529 alpha:1.000];
    //
    //    [item setTitleTextAttributes:dictM forState:UIControlStateNormal];
    //
    //
    //    NSMutableDictionary *selectedDictM = [NSMutableDictionary dictionary];
    //    selectedDictM[NSFontAttributeName] = dictM[NSFontAttributeName];
    //    selectedDictM[NSForegroundColorAttributeName] = [UIColor colorWithWhite:0.251 alpha:1.000];
    //
    //    [item setTitleTextAttributes:selectedDictM forState:UIControlStateSelected];
    
    // 选中的颜色, 不能决定状态和字体
    //    tabBar.tintColor = [UIColor redColor];
    
    //    /**
    //     *  设置底部条的背景图片
    //     */
    //    UITabBar *tabBar = [UITabBar appearanceWhenContainedIn:self, nil];
    //    tabBar.backgroundColor = [UIColor clearColor];
    //
    //    [tabBar setBackgroundImage:[UIImage imageStrechedWithImageName:@"tabbar-light"]];
    
    
}


@end
