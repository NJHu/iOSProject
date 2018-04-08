//
//  LMJScreenShotViewController.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/10/24.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJScreenShotViewController.h"

@interface LMJScreenShotViewController ()

@end

@implementation LMJScreenShotViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // 生成一张新的图片
    UIImage *image =  [LMJScreenShotViewController imageWithCaputureView:[UIApplication sharedApplication].delegate.window];
    
    UIImageView *imv = [[UIImageView alloc] initWithImage:image];
    [self.view addSubview:imv];
    imv.frame = CGRectMake(0, 80, 300, 500);
    
    // image转data
    // compressionQuality： 图片质量 1:最高质量
//    NSData *data = UIImageJPEGRepresentation(image,1);
//    [data writeToFile:@"/Users/huxupeng/Desktop/view.png" atomically:YES];
}

+ (UIImage *)imageWithCaputureView:(UIView *)view
{
    // 开启位图上下文
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 0);
    
    // 获取上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 把控件上的图层渲染到上下文,layer只能渲染
    [view.layer renderInContext:ctx];
    
    // 生成一张图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    // 关闭上下文
    UIGraphicsEndImageContext();
    
    return image;
}

@end
