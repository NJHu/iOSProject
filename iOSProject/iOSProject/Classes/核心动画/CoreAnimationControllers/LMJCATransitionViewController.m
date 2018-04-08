//
//  LMJCATransitionViewController.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/10/23.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJCATransitionViewController.h"

@interface LMJCATransitionViewController ()

/** <#digest#> */
@property (strong, nonatomic) UIImageView *imageView;

@end

@implementation LMJCATransitionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    static int i = 2;
    
    // 转场代码
    if (i == 4) {
        i = 1;
    }
    // 加载图片名称
    NSString *imageN = [NSString stringWithFormat:@"CATransition%d.png",i];
    
    self.imageView.image = [UIImage imageNamed:imageN];
    
    i++;
    
    // 转场动画
    CATransition *anim = [CATransition animation];
    
    anim.type = @"pageCurl";
    
    anim.duration = 2;
    
    [_imageView.layer addAnimation:anim forKey:nil];
    
}

- (UIImageView *)imageView
{
    if(!_imageView)
    {
        _imageView = [[UIImageView alloc] init];
        [self.view addSubview:_imageView];
        
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.insets(UIEdgeInsetsMake(90, 20, 20, 20));
        }];
    }
    return _imageView;
}

@end
