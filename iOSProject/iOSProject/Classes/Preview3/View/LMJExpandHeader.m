//
//  LMJExpandHeader.m
//

#import "LMJExpandHeader.h"

@interface LMJExpandHeader ()

/** <#digest#> */
@property (weak, nonatomic) UIScrollView *scrollView;

/** <#digest#> */
@property (weak, nonatomic) UIView *expandView;

/** <#digest#> */
@property (assign, nonatomic) CGFloat expandHeight;

/** <#digest#> */
@property (assign, nonatomic) CGFloat originTop;

@end


@implementation LMJExpandHeader

- (void)dealloc{
    NSLog(@"");
    [self removeObserver];
}

+ (instancetype)expandWithScrollView:(UIScrollView*)scrollView expandView:(UIView*)expandView{
    LMJExpandHeader *expandHeader = [LMJExpandHeader new];
    [expandHeader expandWithScrollView:scrollView expandView:expandView];
    return expandHeader;
}

- (void)expandWithScrollView:(UIScrollView*)scrollView expandView:(UIView*)expandView{
    
    _scrollView = scrollView;
    _expandView = expandView;
    _expandHeight = CGRectGetHeight(expandView.frame);
    
    [_scrollView insertSubview:expandView atIndex:0];
    
    UIEdgeInsets edgeInsets = _scrollView.contentInset;
    _originTop = edgeInsets.top;
    
    edgeInsets.top += _expandHeight;
    _scrollView.contentInset = edgeInsets;
    [_scrollView setContentOffset:CGPointMake(0, -edgeInsets.top)];
    
    
    //使View可以伸展效果  重要属性
    _expandView.contentMode = UIViewContentModeScaleAspectFill;
    _expandView.clipsToBounds = YES;
    [self reSizeView];
    
    [_scrollView addObserver:self forKeyPath:LMJKeyPath(_scrollView, contentOffset) options:NSKeyValueObservingOptionNew context:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeObserver) name:LMJTableViewControllerDeallocNotification object:_scrollView.viewController];
}

- (void)removeObserver
{
    if (_scrollView) {
        [_scrollView removeObserver:self forKeyPath:LMJKeyPath(_scrollView, contentOffset)];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:LMJTableViewControllerDeallocNotification object:_scrollView.viewController];
        _scrollView = nil;
    }
    _expandView = nil;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:LMJKeyPath(_scrollView, contentOffset)] && object == _scrollView) {
        [self scrollViewDidScroll:_scrollView];
    }
}

/**
 *  监听scrollViewDidScroll方法
 *
 *  @param scrollView
 */
- (void)scrollViewDidScroll:(UIScrollView*)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    if(offsetY < (_expandHeight + _originTop) * -1) {
        CGRect currentFrame = _expandView.frame;
        currentFrame.origin.y = offsetY + _originTop;
        currentFrame.size.height = -1*(offsetY + _originTop);
        _expandView.frame = currentFrame;
    }
}

- (void)reSizeView{
    //重置_expandView位置
    [_expandView setFrame:CGRectMake(0, -1*(_expandHeight), CGRectGetWidth(_expandView.frame), _expandHeight)];
}

- (UIView *)headerView
{
    return _expandView;
}

@end
