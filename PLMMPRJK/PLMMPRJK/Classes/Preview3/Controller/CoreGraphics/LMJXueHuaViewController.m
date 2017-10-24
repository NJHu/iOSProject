//
//  LMJXueHuaViewController.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/10/24.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJXueHuaViewController.h"

@interface LMJXueHuaViewController ()

@end

@implementation LMJXueHuaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self redView];
    
    
    self.redView.backgroundColor = [UIColor blackColor];
}

- (Class)drawViewClass
{
    return [DrawSnowView class];
    
}

@end

static CGFloat _snowY = 0;
@implementation DrawSnowView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    
    // 如果以后想绘制东西到view上面，必须在drawRect方法里面，不管有没有手动获取到上下文
    
    // 修改雪花y值
    UIImage *image =  [UIImage imageNamed:@"雪花.png"];
    
    [image drawAtPoint:CGPointMake(50, _snowY)];
    
    _snowY += 5;
    
    if (_snowY > rect.size.height) {
        _snowY = 0;
    }
    
}

// 如果在绘图的时候需要用到定时器，通常

// NSTimer很少用于绘图，因为调度优先级比较低，并不会准时调用

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupUIOnce];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setupUIOnce];
}

- (void)setupUIOnce
{
    
    // 创建定时器
    //    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timeChange) userInfo:nil repeats:YES];
    CADisplayLink *link = [CADisplayLink displayLinkWithTarget:self selector:@selector(timeChange)];
    
    // 添加主运行循环
    [link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
}

// CADisplayLink:每次屏幕刷新的时候就会调用，屏幕一般一秒刷新60次

// 1秒 2次
static int count = 0;
- (void)timeChange
{
    //    count++;
    //    if (count % 30) {// 一秒钟调用2次
    //
    //    }
    
    
    // 注意：这个方法并不会马上调用drawRect,其实这个方法只是给当前控件添加刷新的标记，等下一次屏幕刷新的时候才会调用drawRect
    [self setNeedsDisplay];
    
    
    
}


@end
