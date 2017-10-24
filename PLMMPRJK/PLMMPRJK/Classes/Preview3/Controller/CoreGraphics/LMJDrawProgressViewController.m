//
//  LMJDrawProgressViewController.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/10/24.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJDrawProgressViewController.h"

@interface LMJDrawProgressViewController ()
@property (weak, nonatomic) IBOutlet ProgressView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *labelView;
@end

@implementation LMJDrawProgressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (IBAction)progressChange:(UISlider *)sender {
    
    
    // %% = %
    _labelView.text = [NSString stringWithFormat:@"%.2f%%",sender.value * 100];
    
    // 给progressView赋值
    _progressView.progress = sender.value;
    
    // 获取滑块值
    //    NSLog(@"%f",sender.value);
    
}
@end


@implementation ProgressView

- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    
    
    // 重新绘制圆弧
    //    [self drawRect:self.bounds];
    
    // 重绘，系统会先创建与view相关联的上下文，然后再调用drawRect
    [self setNeedsDisplay];
}


// 注意：drawRect不能手动调用，因为图形上下文我们自己创建不了，只能由系统帮我们创建，并且传递给我们

- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    // 创建贝瑟尔路径
    CGFloat radius = rect.size.width * 0.5;
    CGPoint center = CGPointMake(radius, radius);
    
    
    CGFloat endA = -M_PI_2 + _progress * M_PI * 2;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius - 2 startAngle:-M_PI_2 endAngle:endA clockwise:YES];
    
    
    [path stroke];
    
    
}


@end
