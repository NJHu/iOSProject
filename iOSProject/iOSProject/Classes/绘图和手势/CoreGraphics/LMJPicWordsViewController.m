//
//  LMJPicWordsViewController.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/10/24.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJPicWordsViewController.h"

@implementation LMJPicWordsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 加载图片
    UIImage *image = [UIImage imageNamed:@"CATransition3.png"];
    
    // 0.获取上下文，之前的上下文都是在view的drawRect方法中获取（跟View相关联的上下文layer上下文）
    // 目前我们需要绘制图片到新的图片上，因此需要用到位图上下文
    
    // 怎么获取位图上下文,注意位图上下文的获取方式跟layer上下文不一样。位图上下文需要我们手动创建。
    // 开启一个位图上下文，注意位图上下文跟view无关联，所以不需要在drawRect.
    // size:位图上下文的尺寸（新图片的尺寸）
    // opaque: 不透明度 YES：不透明 NO:透明，通常我们一般都弄透明的上下文
    // scale:通常不需要缩放上下文，取值为0，表示不缩放
    UIGraphicsBeginImageContextWithOptions(self.redView.lmj_size, NO, 0);
    
    //  // 1.获取上下文(位图上下文)
    //  CGContextRef ctx = UIGraphicsGetCurrentContext();
    //
    //  // 2.描述路径
    //  CGContextMoveToPoint(ctx, 50, 50);
    //
    //  CGContextAddLineToPoint(ctx, 200, 200);
    //
    //  CGContextSetLineWidth(ctx, 10);
    //
    //  [[UIColor redColor] set];
    //
    //  // 3.渲染上下文
    //  CGContextStrokePath(ctx);
    
    
    //  UIBezierPath *path =[UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 300, 300)];
    //
    //  [[UIColor redColor] set];
    //  [path stroke];
    
    // 1.绘制原生的图片
    [image drawInRect:self.redView.bounds];
    
    // 2.给原生的图片添加文字
    NSString *str = @"给原生的图片添加文字给原生的图片添加文字";
    
    // 创建字典属性
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSForegroundColorAttributeName] = [UIColor redColor];
    dict[NSFontAttributeName] = [UIFont systemFontOfSize:20];
    
    [str drawAtPoint:CGPointMake(200, 528) withAttributes:dict];
    
    // 3.生成一张图片给我们,从上下文中获取图片
    UIImage *imageWater = UIGraphicsGetImageFromCurrentImageContext();
    
    // 4.关闭上下文
    UIGraphicsEndImageContext();
    
    self.redView.layer.contents = (__bridge id _Nullable)(imageWater.CGImage);
}




@end
