//
//  ZJContentView.m
//  ZJScrollPageView
//
//  Created by jasnig on 16/5/6.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//

#import "ZJContentView.h"
#import "ZJScrollSegmentView.h"
#import "UIViewController+ZJScrollPageController.h"

typedef NS_ENUM(NSInteger, ZJScrollPageControllerScrollDirection) {
    ZJScrollPageControllerScrollDirectionNone,
    ZJScrollPageControllerScrollDirectionLeft,
    ZJScrollPageControllerScrollDirectionRight
};

@interface ZJContentView ()<UIScrollViewDelegate, UIGestureRecognizerDelegate> {
    CGFloat   _oldOffSetX;
    BOOL _isLoadFirstView;
//    BOOL _isAnimating;
}
/** 避免循环引用*/
@property (weak, nonatomic) ZJScrollSegmentView *segmentView;


// 父类 用于处理添加子控制器  使用weak避免循环引用
@property (weak, nonatomic) UIViewController *parentViewController;
// 当这个属性设置为YES的时候 就不用处理 scrollView滚动的计算
@property (assign, nonatomic) BOOL forbidTouchToAdjustPosition;
@property (assign, nonatomic) NSInteger itemsCount;
// 所有的子控制器
@property (strong, nonatomic) NSMutableDictionary<NSString *, UIViewController<ZJScrollPageViewChildVcDelegate> *> *childVcsDic;
// 当前控制器
@property (strong, nonatomic) UIViewController<ZJScrollPageViewChildVcDelegate> *currentChildVc;

/// 如果类似cell缓存一样, 虽然创建的控制器少了, 但是每个页面每次都要重新加载数据, 否则显示的内容就会出错, 貌似还不如每个页面创建一个控制器好
//@property (strong, nonatomic) NSCache *cacheChildVcs;

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIView *currentView;
@property (strong, nonatomic) UIView *oldView;
@property (assign, nonatomic) NSInteger currentIndex;
@property (assign, nonatomic) NSInteger oldIndex;
@property (assign, nonatomic) ZJScrollPageControllerScrollDirection scrollDirection;

@end

@implementation ZJContentView
#define cellID @"cellID"

static NSString *const kContentOffsetOffKey = @"contentOffset";
#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame segmentView:(ZJScrollSegmentView *)segmentView parentViewController:(UIViewController *)parentViewController delegate:(id<ZJScrollPageViewDelegate>) delegate {
    
    if (self = [super initWithFrame:frame]) {
        self.segmentView = segmentView;
        self.delegate = delegate;
        self.parentViewController = parentViewController;

        [self commonInit];
        [self addNotification];
    }
    return self;
}

- (void)commonInit {
    
    _oldIndex = -1;
    _currentIndex = -1;
    _oldOffSetX = 0.0f;
    _forbidTouchToAdjustPosition = NO;
    _isLoadFirstView = YES;
    if ([_delegate respondsToSelector:@selector(numberOfChildViewControllers)]) {
        self.itemsCount = [_delegate numberOfChildViewControllers];
    }
    [self addSubview:self.scrollView];
    
    [self setCurrentIndex:0 andScrollDirection:ZJScrollPageControllerScrollDirectionNone];

    if (self.parentViewController.parentViewController && [self.parentViewController.parentViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navi = (UINavigationController *)self.parentViewController.parentViewController;
        
        if (navi.interactivePopGestureRecognizer) {
            navi.interactivePopGestureRecognizer.delegate = self;
            [self.scrollView.panGestureRecognizer requireGestureRecognizerToFail:navi.interactivePopGestureRecognizer];
        }
    }
}

- (void)addNotification {

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveMemoryWarningHander:) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
}

- (void)receiveMemoryWarningHander:(NSNotificationCenter *)noti {
    
    __weak typeof(self) weakSelf = self;
    [_childVcsDic enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, UIViewController<ZJScrollPageViewChildVcDelegate> * _Nonnull childVc, BOOL * _Nonnull stop) {
        __strong typeof(self) strongSelf = weakSelf;

        if (childVc != strongSelf.currentChildVc) {
            [_childVcsDic removeObjectForKey:key];
            [ZJContentView removeChildVc:childVc];
        }

    }];

}

- (void)dealloc {
    self.parentViewController = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
#if DEBUG
    NSLog(@"ZJContentView---销毁");
#endif
}

#pragma mark - public helper

/** 给外界可以设置ContentOffSet的方法 */
- (void)setContentOffSet:(CGPoint)offset animated:(BOOL)animated {
    self.forbidTouchToAdjustPosition = YES;
    
    NSInteger currentIndex = offset.x/self.scrollView.bounds.size.width;
    _oldIndex = _currentIndex;
    [self setCurrentIndex:currentIndex andScrollDirection:ZJScrollPageControllerScrollDirectionNone];
    
    if (animated) {
        CGFloat delta = offset.x - self.scrollView.contentOffset.x;
        NSInteger page = fabs(delta)/self.scrollView.bounds.size.width;
        if (page>=2) {// 需要滚动两页以上的时候, 跳过中间页的动画
            
            __weak typeof(self) weakself = self;
            dispatch_async(dispatch_get_main_queue(), ^{
                __strong typeof(weakself) strongSelf = weakself;
                if (strongSelf) {
                    [strongSelf.scrollView setContentOffset:offset animated:NO];
                    [self didAppearWithIndex:currentIndex];
                    [self didDisappearWithIndex:_oldIndex];
                }
            });
        }
        else {
            [self.scrollView setContentOffset:offset animated:animated];
            [self didAppearWithIndex:currentIndex];
            [self didDisappearWithIndex:_oldIndex];

        }
    }
    else {
        [self.scrollView setContentOffset:offset animated:animated];
        [self didAppearWithIndex:currentIndex];
        [self didDisappearWithIndex:_oldIndex];

 
    }
    
}

/** 给外界刷新视图的方法 */
- (void)reload {
    
    [self.childVcsDic enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, UIViewController<ZJScrollPageViewChildVcDelegate> * _Nonnull childVc, BOOL * _Nonnull stop) {
        [ZJContentView removeChildVc:childVc];
        childVc = nil;

    }];
    self.childVcsDic = nil;
    [self.scrollView removeFromSuperview];
    self.scrollView = nil;
    [self commonInit];
}

+ (void)removeChildVc:(UIViewController *)childVc {
    [childVc willMoveToParentViewController:nil];
    [childVc.view removeFromSuperview];
    [childVc removeFromParentViewController];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.forbidTouchToAdjustPosition) {// first or last
        return;
    }
    
    if (scrollView.contentOffset.x <= 0) {
        [self contentViewDidMoveFromIndex:0 toIndex:0 progress:1.0];
        return;

    }
    if (scrollView.contentOffset.x >= scrollView.contentSize.width - scrollView.bounds.size.width) {
        [self contentViewDidMoveFromIndex:_itemsCount-1 toIndex:_itemsCount-1 progress:1.0];
        return;

    }
    
    CGFloat tempProgress = scrollView.contentOffset.x / self.bounds.size.width;
    NSInteger tempIndex = (NSInteger)tempProgress;
    CGFloat progress = tempProgress - floor(tempProgress);
    CGFloat deltaX = scrollView.contentOffset.x - _oldOffSetX;
    
    if (deltaX > 0 && (deltaX != scrollView.bounds.size.width)) {// 向右
        _oldIndex = tempIndex;
        NSInteger tempCurrentIndex = tempIndex + 1;
        
        [self setCurrentIndex:tempCurrentIndex andScrollDirection:ZJScrollPageControllerScrollDirectionRight];

    }
    else if (deltaX < 0) {
        progress = 1.0 - progress;

         _oldIndex = tempIndex + 1;
        
         [self setCurrentIndex:tempIndex andScrollDirection:ZJScrollPageControllerScrollDirectionLeft];

    }
    else {
         return;
    }

    NSLog(@"%f------%ld----%ld------", progress, _oldIndex, _currentIndex);
    
    [self contentViewDidMoveFromIndex:_oldIndex toIndex:_currentIndex progress:progress];

}

/** 滚动减速完成时再更新title的位置 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger currentIndex = (scrollView.contentOffset.x / self.bounds.size.width);
    if (_scrollDirection == ZJScrollPageControllerScrollDirectionNone && !_forbidTouchToAdjustPosition) { // 开启bounds 在第一页和最后一页快速松开手又接触滑动的时候 会不合理的被调用这个代理方法 ---- 其实这个时候并没有在松开手的情况下减速完成
        return;
    }
    [self contentViewDidMoveFromIndex:currentIndex toIndex:currentIndex progress:1.0];
    // 调整title
    [self adjustSegmentTitleOffsetToCurrentIndex:currentIndex];

    if (scrollView.contentOffset.x == _oldOffSetX) {// 滚动未完成

        [self didAppearWithIndex:currentIndex];
        [self didDisappearWithIndex:_currentIndex];
    }
    else {
        [self didAppearWithIndex:_currentIndex];
        [self didDisappearWithIndex:_oldIndex];
    }
    // 重置_currentIndex 不触发set方法
    _currentIndex = currentIndex;
    _scrollDirection = ZJScrollPageControllerScrollDirectionNone;

}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _oldOffSetX = scrollView.contentOffset.x;
    self.forbidTouchToAdjustPosition = NO;
    _scrollDirection = ZJScrollPageControllerScrollDirectionNone;
    
}


#pragma mark - private helper
- (void)contentViewDidMoveFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex progress:(CGFloat)progress {
    if(self.segmentView) {
        [self.segmentView adjustUIWithProgress:progress oldIndex:fromIndex currentIndex:toIndex];
    }
}

- (void)adjustSegmentTitleOffsetToCurrentIndex:(NSInteger)index {
    if(self.segmentView) {
        [self.segmentView adjustTitleOffSetToCurrentIndex:index];
    }
    
}

- (void)willAppearWithIndex:(NSInteger)index {
    UIViewController<ZJScrollPageViewChildVcDelegate> *controller = [self.childVcsDic valueForKey:[NSString stringWithFormat:@"%ld", index]];
    if (controller) {
        if ([controller respondsToSelector:@selector(zj_viewWillAppearForIndex:)]) {
            [controller zj_viewWillAppearForIndex:index];
        }
        
        if (_delegate && [_delegate respondsToSelector:@selector(scrollPageController:childViewControllWillAppear:forIndex:)]) {
            [_delegate scrollPageController:self.parentViewController childViewControllWillAppear:controller forIndex:index];
        }
    }
    
    
}

- (void)didAppearWithIndex:(NSInteger)index {
    UIViewController<ZJScrollPageViewChildVcDelegate> *controller = [self.childVcsDic valueForKey:[NSString stringWithFormat:@"%ld", index]];
    if (controller) {
        if ([controller respondsToSelector:@selector(zj_viewDidAppearForIndex:)]) {
            [controller zj_viewDidAppearForIndex:index];
        }
        
        if (_delegate && [_delegate respondsToSelector:@selector(scrollPageController:childViewControllDidAppear:forIndex:)]) {
            [_delegate scrollPageController:self.parentViewController childViewControllDidAppear:controller forIndex:index];
        }
    }
    
    
    
}

- (void)willDisappearWithIndex:(NSInteger)index {
    UIViewController<ZJScrollPageViewChildVcDelegate> *controller = [self.childVcsDic valueForKey:[NSString stringWithFormat:@"%ld", index]];
    if (controller) {
        if ([controller respondsToSelector:@selector(zj_viewWillDisappearForIndex:)]) {
            [controller zj_viewWillDisappearForIndex:index];
        }
        if (_delegate && [_delegate respondsToSelector:@selector(scrollPageController:childViewControllWillDisappear:forIndex:)]) {
            [_delegate scrollPageController:self.parentViewController childViewControllWillDisappear:controller forIndex:index];
        }
    }
    
}
- (void)didDisappearWithIndex:(NSInteger)index {
    UIViewController<ZJScrollPageViewChildVcDelegate> *controller = [self.childVcsDic valueForKey:[NSString stringWithFormat:@"%ld", index]];
    if (controller) {
        if ([controller respondsToSelector:@selector(zj_viewDidDisappearForIndex:)]) {
            [controller zj_viewDidDisappearForIndex:index];
        }
        if (_delegate && [_delegate respondsToSelector:@selector(scrollPageController:childViewControllDidDisappear:forIndex:)]) {
            [_delegate scrollPageController:self.parentViewController childViewControllDidDisappear:controller forIndex:index];
        }
    }
}


- (void)setCurrentIndex:(NSInteger)currentIndex andScrollDirection:(ZJScrollPageControllerScrollDirection)scrollDirection {
    if (currentIndex != _currentIndex) {
        
//        NSLog(@"current -- %ld   _current ---- %ld _oldIndex --- %ld", currentIndex, _currentIndex, _oldIndex);
        [self setupSubviewsWithCurrentIndex:currentIndex oldIndex:_oldIndex];

        if (scrollDirection != ZJScrollPageControllerScrollDirectionNone) {
            // 打开右边, 但是未松手又返回了打开左边
            // 打开左边, 但是未松手又返回了打开右边
            [self didDisappearWithIndex:_currentIndex];

        }
        [self willAppearWithIndex:currentIndex];
        [self willDisappearWithIndex:_oldIndex];
        if (_isLoadFirstView) { // 加载第一个controller的时候 同时出发didAppear
            [self didAppearWithIndex:currentIndex];
            _isLoadFirstView = NO;
        }
        
        _scrollDirection = scrollDirection;
        _currentIndex = currentIndex;

//        NSLog(@"%@",self.scrollView.subviews);
    }
    
}

- (void)setupSubviewsWithCurrentIndex:(NSInteger)currentIndex oldIndex:(NSInteger)oldIndex {
    UIViewController<ZJScrollPageViewChildVcDelegate> *currentController = [self.childVcsDic valueForKey:[NSString stringWithFormat:@"%ld", (long)currentIndex]];
    
    if (_delegate && [_delegate respondsToSelector:@selector(childViewController:forIndex:)]) {
        if (currentController == nil) {
            currentController = [_delegate childViewController:nil forIndex:currentIndex];
            [self.childVcsDic setValue:currentController forKey:[NSString stringWithFormat:@"%ld", (long)currentIndex]];
        } else {
            [_delegate childViewController:currentController forIndex:currentIndex];
        }
    } else {
        NSAssert(NO, @"必须设置代理和实现代理方法");
    }

    if ([currentController isKindOfClass:[UINavigationController class]]) {
        NSAssert(NO, @"不要添加UINavigationController包装后的子控制器");
        
    }
    
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    
    // 添加currentController
    if (currentController.zj_scrollViewController != self.parentViewController) {
        [self.parentViewController addChildViewController:currentController];
    }
    [self.currentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.currentView.frame = CGRectMake(currentIndex*width, 0, width, height);
    [self.currentView addSubview:currentController.view];
    [_currentChildVc didMoveToParentViewController:self.parentViewController];
    
    UIViewController *oldController = [self.childVcsDic valueForKey:[NSString stringWithFormat:@"%ld", (long)_oldIndex]];
    // 添加oldController
    if (oldController) {

        [self.oldView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        self.oldView.frame = CGRectMake(oldIndex*width, 0, width, height);
        [self.oldView addSubview:oldController.view];
        [oldController didMoveToParentViewController:self.parentViewController];
    }
    
    [self setNeedsLayout];
}



#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (self.parentViewController.parentViewController && [self.parentViewController.parentViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navi = (UINavigationController *)self.parentViewController.parentViewController;
        
        if (navi.visibleViewController == self.parentViewController) {// 当显示的是ScrollPageView的时候 只在第一个tag处执行pop手势
            
            return self.scrollView.contentOffset.x == 0;
        } else {
            return [super gestureRecognizerShouldBegin:gestureRecognizer];
        }
    }
    return [super gestureRecognizerShouldBegin:gestureRecognizer];
}


#pragma mark - getter --- setter
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];

        self.currentView = [[UIView alloc] init];
        self.oldView = [[UIView alloc] init];
        scrollView.delegate = self;
        [scrollView addSubview:self.currentView];
        [scrollView addSubview:self.oldView];
        
        scrollView.pagingEnabled = YES;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.bounces = self.segmentView.segmentStyle.isContentViewBounces;
        scrollView.scrollEnabled = self.segmentView.segmentStyle.isScrollContentView;
        scrollView.contentSize = CGSizeMake(self.itemsCount*self.bounds.size.width, self.bounds.size.height);
        
        _scrollView = scrollView;
    }
    return _scrollView;
}

- (NSMutableDictionary<NSString *,UIViewController<ZJScrollPageViewChildVcDelegate> *> *)childVcsDic {
    if (!_childVcsDic) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        _childVcsDic = dic;
    }
    return _childVcsDic;
}

@end
