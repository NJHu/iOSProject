//
//  LxGridViewFlowLayout.m
//  LxGridView
//

#import "LxGridView.h"


static CGFloat const PRESS_TO_MOVE_MIN_DURATION = 0.1;
static CGFloat const MIN_PRESS_TO_BEGIN_EDITING_DURATION = 0.6;

CG_INLINE CGPoint CGPointOffset(CGPoint point, CGFloat dx, CGFloat dy)
{
    return CGPointMake(point.x + dx, point.y + dy);
}

@interface LxGridViewFlowLayout () <UIGestureRecognizerDelegate>

@property (nonatomic,readonly) id<LxGridViewDataSource> dataSource;
@property (nonatomic,readonly) id<LxGridViewDelegateFlowLayout> delegate;
@property (nonatomic,assign) BOOL editing;

@end

@implementation LxGridViewFlowLayout
{
    UILongPressGestureRecognizer * _longPressGestureRecognizer;
    UIPanGestureRecognizer * _panGestureRecognizer;
    NSIndexPath * _movingItemIndexPath;
    UIView * _beingMovedPromptView;
    CGPoint _sourceItemCollectionViewCellCenter;
    
    CADisplayLink * _displayLink;
    CFTimeInterval _remainSecondsToBeginEditing;
}

#pragma mark - setup

- (void)dealloc
{
    [_displayLink invalidate];
    
    [self removeGestureRecognizers];
    [self removeObserver:self forKeyPath:@stringify(collectionView)];
}

- (instancetype)init
{
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    if (self = [super initWithCoder:coder]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    [self addObserver:self forKeyPath:@stringify(collectionView) options:NSKeyValueObservingOptionNew context:nil];
}

- (void)addGestureRecognizers
{
    self.collectionView.userInteractionEnabled = YES;
    
    _longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressGestureRecognizerTriggerd:)];
    _longPressGestureRecognizer.cancelsTouchesInView = NO;
    _longPressGestureRecognizer.minimumPressDuration = PRESS_TO_MOVE_MIN_DURATION;
    _longPressGestureRecognizer.delegate = self;
    
    for (UIGestureRecognizer * gestureRecognizer in self.collectionView.gestureRecognizers) {
        if ([gestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]]) {
            [gestureRecognizer requireGestureRecognizerToFail:_longPressGestureRecognizer];
        }
    }
    
    [self.collectionView addGestureRecognizer:_longPressGestureRecognizer];
    
    _panGestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGestureRecognizerTriggerd:)];
    _panGestureRecognizer.delegate = self;
    [self.collectionView addGestureRecognizer:_panGestureRecognizer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
}

- (void)removeGestureRecognizers
{
    if (_longPressGestureRecognizer) {
        if (_longPressGestureRecognizer.view) {
            [_longPressGestureRecognizer.view removeGestureRecognizer:_longPressGestureRecognizer];
        }
        _longPressGestureRecognizer = nil;
    }
    
    if (_panGestureRecognizer) {
        if (_panGestureRecognizer.view) {
            [_panGestureRecognizer.view removeGestureRecognizer:_panGestureRecognizer];
        }
        _panGestureRecognizer = nil;
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
}

#pragma mark - getter and setter implementation

- (id<LxGridViewDataSource>)dataSource
{
    return (id<LxGridViewDataSource>)self.collectionView.dataSource;
}

- (id<LxGridViewDelegateFlowLayout>)delegate
{
    return (id<LxGridViewDelegateFlowLayout>)self.collectionView.delegate;
}

- (void)setEditing:(BOOL)editing
{
    NSCAssert([self.collectionView isKindOfClass:[LxGridView class]] || self.collectionView == nil, @"LxGridViewFlowLayout: Must use LxGridView as your collectionView class!");
    LxGridView * gridView = (LxGridView *)self.collectionView;
    gridView.editing = editing;
}

- (BOOL)editing
{
    NSCAssert([self.collectionView isKindOfClass:[LxGridView class]] || self.collectionView == nil, @"LxGridViewFlowLayout: Must use LxGridView as your collectionView class!");
    LxGridView * gridView = (LxGridView *)self.collectionView;
    return gridView.editing;
}

#pragma mark - override UICollectionViewLayout methods

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray * layoutAttributesForElementsInRect = [super layoutAttributesForElementsInRect:rect];
    
    for (UICollectionViewLayoutAttributes * layoutAttributes in layoutAttributesForElementsInRect) {
        
        if (layoutAttributes.representedElementCategory == UICollectionElementCategoryCell) {
            layoutAttributes.hidden = [layoutAttributes.indexPath isEqual:_movingItemIndexPath];
        }
    }
    return layoutAttributesForElementsInRect;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes * layoutAttributes = [super layoutAttributesForItemAtIndexPath:indexPath];
    if (layoutAttributes.representedElementCategory == UICollectionElementCategoryCell) {
        layoutAttributes.hidden = [layoutAttributes.indexPath isEqual:_movingItemIndexPath];
    }
    return layoutAttributes;
}

#pragma mark - gesture

- (void)setPanGestureRecognizerEnable:(BOOL)panGestureRecognizerEnable
{
    _panGestureRecognizer.enabled = panGestureRecognizerEnable;
}

- (BOOL)panGestureRecognizerEnable
{
    return _panGestureRecognizer.enabled;
}

- (void)longPressGestureRecognizerTriggerd:(UILongPressGestureRecognizer *)longPress
{
    switch (longPress.state) {
        case UIGestureRecognizerStatePossible:
            break;
        case UIGestureRecognizerStateBegan:
        {
            if (_displayLink == nil) {
                _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkTriggered:)];
                _displayLink.frameInterval = 6;
                [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
                
                _remainSecondsToBeginEditing = MIN_PRESS_TO_BEGIN_EDITING_DURATION;
            }
            
            if (self.editing == NO) {
                return;
            }
            
            _movingItemIndexPath = [self.collectionView indexPathForItemAtPoint:[longPress locationInView:self.collectionView]];
            
            if ([self.dataSource respondsToSelector:@selector(collectionView:canMoveItemAtIndexPath:)] && [self.dataSource collectionView:self.collectionView canMoveItemAtIndexPath:_movingItemIndexPath] == NO) {
                _movingItemIndexPath = nil;
                return;
            }
            
            if ([self.delegate respondsToSelector:@selector(collectionView:layout:willBeginDraggingItemAtIndexPath:)]) {
                [self.delegate collectionView:self.collectionView layout:self willBeginDraggingItemAtIndexPath:_movingItemIndexPath];
            }
            
            UICollectionViewCell * sourceCollectionViewCell = [self.collectionView cellForItemAtIndexPath:_movingItemIndexPath];
            NSCAssert([sourceCollectionViewCell isKindOfClass:[LxGridViewCell class]] || sourceCollectionViewCell == nil, @"LxGridViewFlowLayout: Must use LxGridViewCell as your collectionViewCell class!");
            LxGridViewCell * sourceGridViewCell = (LxGridViewCell *)sourceCollectionViewCell;
            
            _beingMovedPromptView = [[UIView alloc]initWithFrame:CGRectOffset(sourceCollectionViewCell.frame, -LxGridView_DELETE_RADIUS, -LxGridView_DELETE_RADIUS)];
            
            sourceCollectionViewCell.highlighted = YES;
            UIView * highlightedSnapshotView = [sourceGridViewCell snapshotView];
            highlightedSnapshotView.frame = sourceGridViewCell.bounds;
            highlightedSnapshotView.alpha = 1;

            sourceCollectionViewCell.highlighted = NO;
            UIView * snapshotView = [sourceGridViewCell snapshotView];
            snapshotView.frame = sourceGridViewCell.bounds;
            snapshotView.alpha = 0;
            
            [_beingMovedPromptView addSubview:snapshotView];
            [_beingMovedPromptView addSubview:highlightedSnapshotView];
            [self.collectionView addSubview:_beingMovedPromptView];
            
            static NSString * const kVibrateAnimation = @stringify(kVibrateAnimation);
            static CGFloat const VIBRATE_DURATION = 0.1;
            static CGFloat const VIBRATE_RADIAN = M_PI / 96;
            
            CABasicAnimation * vibrateAnimation = [CABasicAnimation animationWithKeyPath:@stringify(transform.rotation.z)];
            vibrateAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            vibrateAnimation.fromValue = @(- VIBRATE_RADIAN);
            vibrateAnimation.toValue = @(VIBRATE_RADIAN);
            vibrateAnimation.autoreverses = YES;
            vibrateAnimation.duration = VIBRATE_DURATION;
            vibrateAnimation.repeatCount = CGFLOAT_MAX;
            [_beingMovedPromptView.layer addAnimation:vibrateAnimation forKey:kVibrateAnimation];
            
            _sourceItemCollectionViewCellCenter = sourceCollectionViewCell.center;
            
            typeof(self) __weak weakSelf = self;
            [UIView animateWithDuration:0
                                  delay:0
                                options:UIViewAnimationOptionBeginFromCurrentState
                             animations:^{

                                 typeof(self) __strong strongSelf = weakSelf;
                                 if (strongSelf) {
                                     highlightedSnapshotView.alpha = 0;
                                     snapshotView.alpha = 1;
                                 }
                             }
                             completion:^(BOOL finished) {
                                 
                                 typeof(self) __strong strongSelf = weakSelf;
                                 if (strongSelf) {
                                     [highlightedSnapshotView removeFromSuperview];
                                     
                                     if ([strongSelf.delegate respondsToSelector:@selector(collectionView:layout:didBeginDraggingItemAtIndexPath:)]) {
                                         [strongSelf.delegate collectionView:strongSelf.collectionView layout:strongSelf didBeginDraggingItemAtIndexPath:_movingItemIndexPath];
                                     }
                                 }
                             }];
            [self invalidateLayout];
        }
            break;
        case UIGestureRecognizerStateChanged:
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        {
            [_displayLink invalidate];
            _displayLink = nil;
            
            NSIndexPath * movingItemIndexPath = _movingItemIndexPath;
            
            if (movingItemIndexPath) {
                if ([self.delegate respondsToSelector:@selector(collectionView:layout:willEndDraggingItemAtIndexPath:)]) {
                    [self.delegate collectionView:self.collectionView layout:self willEndDraggingItemAtIndexPath:movingItemIndexPath];
                }
                
                _movingItemIndexPath = nil;
                _sourceItemCollectionViewCellCenter = CGPointZero;
                
                UICollectionViewLayoutAttributes * movingItemCollectionViewLayoutAttributes = [self layoutAttributesForItemAtIndexPath:movingItemIndexPath];
                
                _longPressGestureRecognizer.enabled = NO;
                
                typeof(self) __weak weakSelf = self;
                [UIView animateWithDuration:0
                                      delay:0
                                    options:UIViewAnimationOptionBeginFromCurrentState
                                 animations:^{
                                     typeof(self) __strong strongSelf = weakSelf;
                                     if (strongSelf) {
                                         _beingMovedPromptView.center = movingItemCollectionViewLayoutAttributes.center;
                                     }
                                 }
                                 completion:^(BOOL finished) {

                                     _longPressGestureRecognizer.enabled = YES;
                                     
                                     typeof(self) __strong strongSelf = weakSelf;
                                     if (strongSelf) {
                                         [_beingMovedPromptView removeFromSuperview];
                                         _beingMovedPromptView = nil;
                                         [strongSelf invalidateLayout];
                                         
                                         if ([strongSelf.delegate respondsToSelector:@selector(collectionView:layout:didEndDraggingItemAtIndexPath:)]) {
                                             [strongSelf.delegate collectionView:strongSelf.collectionView layout:strongSelf didEndDraggingItemAtIndexPath:movingItemIndexPath];
                                         }
                                     }
                                 }];
            }
        }
            break;
        case UIGestureRecognizerStateFailed:
            break;
        default:
            break;
    }
}

- (void)panGestureRecognizerTriggerd:(UIPanGestureRecognizer *)pan
{
    switch (pan.state) {
        case UIGestureRecognizerStatePossible:
            break;
        case UIGestureRecognizerStateBegan:
        case UIGestureRecognizerStateChanged:
        {
            CGPoint panTranslation = [pan translationInView:self.collectionView];
            _beingMovedPromptView.center = CGPointOffset(_sourceItemCollectionViewCellCenter, panTranslation.x, panTranslation.y);
            
            NSIndexPath * sourceIndexPath = _movingItemIndexPath;
            NSIndexPath * destinationIndexPath = [self.collectionView indexPathForItemAtPoint:_beingMovedPromptView.center];
            
            if ((destinationIndexPath == nil) || [destinationIndexPath isEqual:sourceIndexPath]) {
                return;
            }
            if ([self.dataSource respondsToSelector:@selector(collectionView:itemAtIndexPath:canMoveToIndexPath:)] && [self.dataSource collectionView:self.collectionView itemAtIndexPath:sourceIndexPath canMoveToIndexPath:destinationIndexPath] == NO) {
                return;
            }
            
            if ([self.dataSource respondsToSelector:@selector(collectionView:itemAtIndexPath:willMoveToIndexPath:)]) {
                [self.dataSource collectionView:self.collectionView itemAtIndexPath:sourceIndexPath willMoveToIndexPath:destinationIndexPath];
            }
            
            _movingItemIndexPath = destinationIndexPath;
            
            typeof(self) __weak weakSelf = self;
            [self.collectionView performBatchUpdates:^{
                typeof(self) __strong strongSelf = weakSelf;
                if (strongSelf) {
                    [strongSelf.collectionView deleteItemsAtIndexPaths:@[sourceIndexPath]];
                    [strongSelf.collectionView insertItemsAtIndexPaths:@[destinationIndexPath]];
                }
            } completion:^(BOOL finished) {
                typeof(self) __strong strongSelf = weakSelf;
                if ([strongSelf.dataSource respondsToSelector:@selector(collectionView:itemAtIndexPath:didMoveToIndexPath:)]) {
                    [strongSelf.dataSource collectionView:strongSelf.collectionView itemAtIndexPath:sourceIndexPath didMoveToIndexPath:destinationIndexPath];
                }
            }];
        }
            break;
        case UIGestureRecognizerStateEnded:
            break;
        case UIGestureRecognizerStateCancelled:
            break;
        case UIGestureRecognizerStateFailed:
            break;
        default:
            break;
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ([_panGestureRecognizer isEqual:gestureRecognizer] && self.editing) {
        return _movingItemIndexPath != nil;
    }
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    //  only _longPressGestureRecognizer and _panGestureRecognizer can recognize simultaneously
    if ([_longPressGestureRecognizer isEqual:gestureRecognizer]) {
        return [_panGestureRecognizer isEqual:otherGestureRecognizer];
    }
    if ([_panGestureRecognizer isEqual:gestureRecognizer]) {
        return [_longPressGestureRecognizer isEqual:otherGestureRecognizer];
    }
    return NO;
}

#pragma mark - displayLink

- (void)displayLinkTriggered:(CADisplayLink *)displayLink
{
    if (_remainSecondsToBeginEditing <= 0) {
        
        self.editing = YES;
        [_displayLink invalidate];
        _displayLink = nil;
    }
    
    _remainSecondsToBeginEditing = _remainSecondsToBeginEditing - 0.1;
}

#pragma mark - KVO and notification

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@stringify(collectionView)]) {
        if (self.collectionView) {
            [self addGestureRecognizers];
        }
        else {
            [self removeGestureRecognizers];
        }
    }
}

- (void)applicationWillResignActive:(NSNotification *)notificaiton
{
    _panGestureRecognizer.enabled = NO;
    _panGestureRecognizer.enabled = YES;
}

@end
