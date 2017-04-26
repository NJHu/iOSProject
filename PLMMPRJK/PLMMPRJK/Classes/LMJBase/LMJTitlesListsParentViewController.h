//
//  LMJTitlesListsParentViewController.h
//  GoMeYWLC
//
//  Created by NJHu on 2017/1/17.
//  Copyright © 2017年 NJHu. All rights reserved.
//



@interface LMJTitlesListsParentViewController : LMJBaseViewController

// 改变子控制器的title, 即可改变title
- (void)addChildViewControllers;

// 子类实现即可定制下边的标题颜色和字体
/** 正常情况下的颜色, 默认LMJHexAlpaColor(@"#646464 100%"); */
- (UIColor *)titleBtnNormalColor;

/** 选中的颜色, 默认 LMJHexAlpaColor(@"#13A5B5 100%"); */
- (UIColor *)titleBtnSelectedColor;

/** 标题的字体, 默认14 */
- (UIFont *)titleBtnFont;

@end
