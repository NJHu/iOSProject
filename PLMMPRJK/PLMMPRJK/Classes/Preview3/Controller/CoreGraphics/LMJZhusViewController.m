//
//  LMJZhusViewController.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/10/24.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJZhusViewController.h"

@interface LMJZhusViewController ()

@end

@implementation LMJZhusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self redView];
}

- (Class)drawViewClass
{
    return [BarView class];
}

@end
@implementation BarView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    NSArray *arr = [self arrRandom];
    
    
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat w = 0;
    CGFloat h = 0;
    
    for (int i = 0; i < arr.count; i++) {
        
        w = rect.size.width / (2 * arr.count - 1);
        x = 2 * w * i;
        h = [arr[i] floatValue] / 100.0 * rect.size.height;
        y = rect.size.height - h;
        
        
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(x, y, w, h)];
        
        
        [[self colorRandom] set];
        
        [path fill];
        
        
    }
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self setNeedsDisplay];
}
- (NSArray *)arrRandom
{
    int totoal = 100;
    
    NSMutableArray *arrM = [NSMutableArray array];
    
    int temp = 0; // 30 40 30
    for (int i = 0; i < arc4random_uniform(10) + 1; i++) {
        temp = arc4random_uniform(totoal) + 1;
        
        // 100 1~100
        
        // 随机出来的临时值等于总值，直接退出循环，因为已经把总数分配完毕，没必要在分配。
        
        
        [arrM addObject:@(temp)];
        
        // 解决方式：当随机出来的数等于总数直接退出循环。
        if (temp == totoal) {
            break;
        }
        
        totoal -= temp;
        
    }
    // 100 30 1~100
    // 70 40 0 ~ 69 1 ~ 70
    // 30 25
    // 5
    
    if (totoal) {
        [arrM addObject:@(totoal)];
    }
    
    return arrM;
}

- (UIColor *)colorRandom
{
    // 0 ~ 255 / 255
    // OC:0 ~ 1
    CGFloat r = arc4random_uniform(256) / 255.0;
    CGFloat g = arc4random_uniform(256) / 255.0;
    CGFloat b = arc4random_uniform(256) / 255.0;
    return [UIColor colorWithRed:r green:g blue:b alpha:1];
    
}



@end
