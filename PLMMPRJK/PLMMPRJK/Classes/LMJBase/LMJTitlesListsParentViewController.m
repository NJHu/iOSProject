//
//  LMJTitlesListsParentViewController.m
//  GoMeYWLC
//
//  Created by NJHu on 2017/1/17.
//  Copyright © 2017年 NJHu. All rights reserved.
//

#import "LMJTitlesListsParentViewController.h"
#import "LMJTitleListChildViewController.h"

@interface LMJTitlesListsParentViewController ()<UIScrollViewDelegate>

/** <#digest#> */
@property (weak, nonatomic) UIButton *selectedBtn;

/** <#digest#> */
@property (weak, nonatomic) UIView *indicatorView;

/** <#digest#> */
@property (weak, nonatomic) UIScrollView *contentScrollView;

/** <#digest#> */
@property (weak, nonatomic) UIView *titlesView;

/** 所有的标题按钮 */
@property (strong, nonatomic) NSMutableArray<UIButton *> *titleBtns;

@end

@implementation LMJTitlesListsParentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    

    // 添加自控制器
    [self addChildViewControllers];
    // 监听子控制器的标题变化, 改变标题
    [self observerChildViewControllersTitlesChange];
    
    // 设置标题栏
    [self setupTitlesView];
    
    // 添加内容滚动器
    [self addContentScrollView];
    
    
    // 设置精华的导航条
    [self setupTitlesListsParentViewUI];
}


- (void)setupTitlesView
{
    CGFloat LMJTitlesViewInEssenceHeight = LMJTitlesListsParentViewControllerTitleHeight;
    
    // 添加整体的view
    UIView *titlesView = [[UIView alloc] init];
    [self.view addSubview:titlesView];
    self.titlesView = titlesView;
    
    titlesView.lmj_x = 0;
    titlesView.lmj_y = 64;
    
    titlesView.lmj_width = self.view.lmj_width;
    titlesView.lmj_height = LMJTitlesViewInEssenceHeight;
    titlesView.backgroundColor = [UIColor whiteColor];
    
    [self addButtonsInTitleswView:titlesView];
    
    [self addIndicatorViewInTitleswView:titlesView];
}


// 选中了第一个
- (void)addButtonsInTitleswView:(UIView *)titlesView
{
    CGFloat buttonW = titlesView.lmj_width / self.childViewControllers.count;
    
    CGFloat buttonY = 0;
    
    CGFloat buttonContentTopMargin = 10;
    
    CGFloat buttonH = titlesView.lmj_height;
    
    CGFloat buttonX = 0;

    
    for (NSInteger i = 0; i < self.childViewControllers.count; i++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [titlesView addSubview:btn];
        [self.titleBtns addObject:btn];
        btn.tag = i;
        
        [btn setTitle:self.childViewControllers[i].title forState:UIControlStateNormal];
        [btn setTitleColor:self.titleBtnNormalColor forState:UIControlStateNormal];
        
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        
        [btn setTitleColor:self.titleBtnSelectedColor forState:UIControlStateDisabled];
        
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(buttonContentTopMargin, 0, 0, 0)];
        
        btn.titleLabel.font = self.titleBtnFont;
        
        buttonX = i * buttonW;
        btn.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        
        [btn addTarget:self action:@selector(selectTitle:) forControlEvents:UIControlEventTouchUpInside];
        
        // 处理选中哪一个状态的cell
        if(i == 0)
        {
            [btn.titleLabel sizeToFit];
            self.selectedBtn = btn;
        }
        
        
    }
}

- (void)addIndicatorViewInTitleswView:(UIView *)titlesView
{
    UIView *indicatorView = [[UIView alloc] init];
    
    [titlesView addSubview:indicatorView];
    self.indicatorView = indicatorView;
    
    indicatorView.backgroundColor = self.titleBtnSelectedColor;
    
    indicatorView.lmj_height = 2;
    indicatorView.lmj_y = titlesView.lmj_height - indicatorView.lmj_height;
}


- (void)selectTitle:(UIButton *)btn
{
    self.selectedBtn.enabled = YES;
    btn.enabled = NO;
    self.selectedBtn = btn;
    
//     指示器缓慢移动汇过去
    [UIView animateWithDuration:0.15 animations:^{
        
        self.indicatorView.lmj_width = self.selectedBtn.titleLabel.lmj_width;
        
        CGPoint center = self.indicatorView.center;
        center.x = self.selectedBtn.center.x;
        self.indicatorView.center = center;
    }];
    
    CGPoint contentScrollViewContentOffset = self.contentScrollView.contentOffset;
    
    contentScrollViewContentOffset.x = self.selectedBtn.tag * self.contentScrollView.lmj_width;
    
    // 设置完后才会调用, 如果指没有变, 是不会调用的
    self.contentScrollView.contentOffset = contentScrollViewContentOffset;
    
    [self scrollViewDidEndScrollingAnimation:self.contentScrollView];
    
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x / scrollView.lmj_width;
    
    UIViewController *vc = self.childViewControllers[index];
    
    // 如果已经加载到contentScrollView上边的时候, 就不用再加了
    if(vc.view.superview) return;
    
    vc.view.lmj_x = index * scrollView.lmj_width;
    
    [self.contentScrollView addSubview:vc.view];
    
}


/**
 *获得当前的索引,根据索引找到titlesview里边的button, 调用selectTitle:
 */

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = 1.0 * scrollView.contentOffset.x / scrollView.lmj_width;
    
    [self selectTitle:self.titleBtns[index]];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetX = (scrollView.contentOffset.x);
    
    CGFloat offsetXScale = offsetX / (scrollView.contentSize.width);
    
    offsetXScale = (offsetXScale >= 0) ? offsetXScale : 0;
    
    
    CGFloat indicatorIngoreCenterX = self.titleBtns.firstObject.center.x;
    
    CGFloat indicatorMaxCenterX = self.titleBtns.lastObject.center.x;
    
    CGFloat indicatorDistance = self.titlesView.lmj_width;
    
    CGFloat centerX = indicatorIngoreCenterX + indicatorDistance * offsetXScale;
    
    if (centerX > indicatorMaxCenterX) {
        centerX = indicatorMaxCenterX;
    }
    
//    self.indicatorView.centerX = centerX;
    self.indicatorView.lmj_x = (centerX - self.indicatorView.lmj_width * 0.5);
    /*
    CGFloat redNomal = 0;
    CGFloat greenNomal = 0;
    CGFloat blueNomal = 0;
    CGFloat alphaNormal = 0;
    
    [self.titleBtnNormalColor getRed:&redNomal green:&greenNomal blue:&blueNomal alpha:&alphaNormal];
    
    CGFloat redSelected = 0;
    CGFloat greenSelected = 0;
    CGFloat blueSelected = 0;
    CGFloat alphaSelected = 0;
    
    [self.titleBtnSelectedColor getRed:&redSelected green:&greenSelected blue:&blueSelected alpha:&alphaSelected];
    
    
    CGFloat red = redNomal + (redSelected - redNomal) * offsetXScale;
    CGFloat green = greenNomal + (greenSelected - greenNomal) * offsetXScale;
    CGFloat blue = blueNomal + (blueSelected - blueNomal) * offsetXScale;
    */
    
    NSInteger selectedIndex = offsetXScale * self.titleBtns.count + 0.5;
    
    if (selectedIndex > (self.titleBtns.count - 1)) {
        return;
    }

    [self.titleBtns enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (selectedIndex == idx) {
            obj.enabled = NO;
        }else
        {
            obj.enabled = YES;
        }
        
    }];
    

    
}


- (void)addContentScrollView
{
    // 自己设置内边距
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIScrollView *contentScrollView = [[UIScrollView alloc] initWithFrame:Main_Screen_Bounds];
    [self.view insertSubview:contentScrollView atIndex:0];
    self.contentScrollView = contentScrollView;
    contentScrollView.delegate = self;
    
    // 设置contentScrollView的属性
    contentScrollView.contentSize = CGSizeMake(contentScrollView.lmj_width * self.childViewControllers.count, 0);
    contentScrollView.showsHorizontalScrollIndicator = NO;
    contentScrollView.pagingEnabled = YES;
    
}


/**
 *  添加子控制器
 */
- (void)addChildViewControllers
{
    NSAssert(0, @"子类必须实现, 例子如下");
    
    [self addChildViewController:[[LMJTitleListChildCollectionViewController alloc] initWithTitle:@"控制器1"]];[self addChildViewController:[[LMJTitleListChildCollectionViewController alloc] initWithTitle:@"控制器2"]];
    [self addChildViewController:[[LMJTitleListChildCollectionViewController alloc] initWithTitle:@"控制器3"]];
}

/**
 *  选中第一个btn后让指示器移动过去
 */

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.indicatorView.lmj_width = self.selectedBtn.titleLabel.lmj_width;

    
    CGPoint center = self.indicatorView.center;
    center.x = self.selectedBtn.center.x;
    self.indicatorView.center = center;
    
    [self scrollViewDidEndDecelerating:self.contentScrollView];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}


- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}


/**
 *  设置精华的导航条
 */
- (void)setupTitlesListsParentViewUI
{
    
    // 设置背景颜色
    
}

- (NSMutableArray<UIButton *> *)titleBtns
{
    if(_titleBtns == nil)
    {
        _titleBtns = [NSMutableArray array];
    }
    return _titleBtns;
}

- (void)observerChildViewControllersTitlesChange
{
    LMJWeakSelf(self);
    [self.childViewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        [obj addObserverBlockForKeyPath:LMJKeyPath(obj, title) block:^(id  _Nonnull obj, id  _Nullable oldVal, id  _Nullable newVal) {
           
            [weakself.titleBtns[idx] setTitle:newVal forState:UIControlStateNormal];
            
        }];
        
    }];
}

- (void)dealloc
{
    [self.childViewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [obj removeObserverBlocksForKeyPath:LMJKeyPath(obj, title)];
        
    }];
}

/** 正常情况下的颜色 */
- (UIColor *)titleBtnNormalColor
{
    return LMJHexColor(646464);
}

/** 选中的颜色 */
- (UIColor *)titleBtnSelectedColor
{
    return LMJHexColor(13A5B5);
}


/** 标题的字体 */
- (UIFont *)titleBtnFont
{
    return [UIFont systemFontOfSize:14];
}


@end
