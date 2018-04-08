//
//  LMJPiesViewController.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/10/24.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJPiesViewController.h"

@interface LMJPiesViewController ()

@end

@implementation LMJPiesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view makeToast:@"点击扇形!!" duration:3 position:CSToastPositionCenter];
}
@end



@implementation PieView

- (NSArray *)arrRandom {
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

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    NSArray *arr = [self arrRandom];
    CGFloat radius = rect.size.width * 0.5;
    CGPoint center = CGPointMake(radius, radius);
    
    CGFloat startA = 0;
    CGFloat angle = 0;
    CGFloat endA = 0;
    
    for (int i = 0; i < arr.count; i++) {
        startA = endA;
        angle = [arr[i] integerValue] / 100.0 * M_PI * 2;
        endA = startA + angle;
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startA endAngle:endA clockwise:YES];
        [path addLineToPoint:center];
        [[UIColor RandomColor] set];
        [path fill];
    }
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self setNeedsDisplay];
}

/*
 - (void)draw
 {
 CGFloat radius = self.bounds.size.width * 0.5;
 CGPoint center = CGPointMake(radius, radius);
 
 
 CGFloat startA = 0;
 CGFloat angle = 0;
 CGFloat endA = 0;
 
 
 // 第一个扇形
 angle = 25 / 100.0 * M_PI * 2;
 endA = startA + angle;
 UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startA endAngle:endA clockwise:YES];
 
 // 添加一根线到圆心
 [path addLineToPoint:center];
 
 // 描边和填充通用
 [[UIColor redColor] set];
 
 [path fill];
 
 // 第二个扇形
 startA = endA;
 angle = 25 / 100.0 * M_PI * 2;
 endA = startA + angle;
 UIBezierPath *path1 = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startA endAngle:endA clockwise:YES];
 
 // 添加一根线到圆心
 [path1 addLineToPoint:center];
 
 // 描边和填充通用
 [[UIColor greenColor] set];
 
 [path1 fill];
 
 // 第二个扇形
 startA = endA;
 angle = 50 / 100.0 * M_PI * 2;
 endA = startA + angle;
 UIBezierPath *path2 = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startA endAngle:endA clockwise:YES];
 
 // 添加一根线到圆心
 [path2 addLineToPoint:center];
 
 // 描边和填充通用
 [[UIColor blueColor] set];
 
 [path2 fill];
 
 }
 */

@end
