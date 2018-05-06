//
//  LMJFingerLockViewController.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/10/24.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJFingerLockViewController.h"

@interface LMJFingerLockViewController ()

@end

@implementation LMJFingerLockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.redView.backgroundColor = [[UIColor greenColor] colorWithAlphaComponent:0.4];
    self.redView.lmj_height = self.redView.lmj_width;
}

- (Class)drawViewClass
{
    return [LMJLockView class];
}

@end



@interface LMJLockView ()

@property (nonatomic, strong) NSMutableArray<UIButton *> *selectedBtns;

@property (assign, nonatomic) CGPoint curP;

@end

@implementation LMJLockView

- (void)pan:(UIPanGestureRecognizer *)sender
{
    self.curP = [sender locationInView:self];
    NSArray<UIButton *> *btns = self.subviews;
    
    for (UIButton *btn in btns) {
        if(CGRectContainsPoint(btn.frame, self.curP) && !btn.isSelected)
        {
            btn.selected = YES;
            [self.selectedBtns addObject:btn];
        }
    }
    
    if(sender.state == UIGestureRecognizerStateEnded)
    {
        NSMutableString *strM = [NSMutableString string];
        
        for (UIButton *btn in self.selectedBtns) {
            [strM appendFormat:@"%zd", btn.tag];
        }
        
        NSLog(@"%@", strM);
        [self makeToast:[NSString stringWithFormat:@"拖拽顺序%@", strM] duration:3 position:CSToastPositionCenter];
        
        [self.selectedBtns makeObjectsPerformSelector:@selector(setSelected:) withObject:nil];
        
        [self.selectedBtns removeAllObjects];
    }
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    if(self.selectedBtns.count == 0) return;
    
    NSUInteger count = self.selectedBtns.count;
    UIBezierPath *bezier = [UIBezierPath bezierPath];
    for (int i = 0; i < count; i++)
    {
        UIButton *btn = self.selectedBtns[i];
        if(i == 0)
        {
            [bezier moveToPoint:btn.center];
        }
        else
        {
            [bezier addLineToPoint:btn.center];
        }
    }
    
    [bezier addLineToPoint:self.curP];
    
    [[UIColor greenColor] set];
    bezier.lineCapStyle = kCGLineCapRound;
    bezier.lineJoinStyle = kCGLineJoinRound;
    bezier.lineWidth = 10;
    
    [bezier stroke];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupOnce];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setupOnce];
}

- (void)setupOnce
{
    // 添加手势
    UIPanGestureRecognizer *panGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self addGestureRecognizer:panGR];
    
    NSUInteger count = 9;
    
    for (NSUInteger i = 0; i < count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i;
        btn.userInteractionEnabled = NO;
        [btn setImage:[UIImage imageNamed:@"gesture_node_normal"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"gesture_node_highlighted"] forState:UIControlStateSelected];
        [self addSubview:btn];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    UIImage *image = [UIImage imageNamed:@"gesture_node_normal"];
    NSUInteger cols = 3;
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat w = image.size.width;
    CGFloat h = image.size.height;
    CGFloat margin = (self.frame.size.width - cols * w) / (cols + 1);
    
    NSArray<UIButton *> *btns = self.subviews;
    for (NSUInteger i = 0; i < btns.count; i++) {
        x = margin + (i % cols) * (w + margin);
        y = margin + (i / cols) * (h + margin);
        btns[i].frame = CGRectMake(x, y, w, h);
    }
}
- (NSMutableArray *)selectedBtns
{
    if(_selectedBtns == nil)
    {
        _selectedBtns = [NSMutableArray array];
    }
    return _selectedBtns;
}
@end
