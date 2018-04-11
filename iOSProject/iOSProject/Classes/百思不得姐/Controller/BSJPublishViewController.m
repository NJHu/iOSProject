//
//  BSJPublishViewController.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/5/11.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "BSJPublishViewController.h"
#import "BSJPublishWordViewController.h"

@interface BSJPublishViewController ()
/** <#digest#> */
@property (weak, nonatomic) UIImageView *sloganImageView;

/** <#digest#> */
@property (nonatomic, strong) NSMutableArray<UIButton *> *publishButtons;

/** <#digest#> */
@property (weak, nonatomic) UIButton *closeButton;

@end

@implementation BSJPublishViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    self.view.layer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"shareBottomBackground"].CGImage);
    
    [self closeButton];
    [self sloganImageView];
    [self publishButtons];
}

- (void)publish:(UIButton *)btn
{
    [self presentViewController:[[LMJNavigationController alloc] initWithRootViewController:[[BSJPublishWordViewController alloc] init]] animated:YES completion:nil];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        self.sloganImageView.transform = CGAffineTransformIdentity;
        
    } completion:^(BOOL finished) {
        
        [self.publishButtons enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [UIView animateWithDuration:0.5 delay:0.2 * idx usingSpringWithDamping:0.4 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                obj.transform = CGAffineTransformIdentity;
            } completion:nil];
        }];
    }];
}

- (UIImageView *)sloganImageView
{
    if(_sloganImageView == nil)
    {
        UIImageView *sloganImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"app_slogan"]];
        sloganImageView.backgroundColor = [UIColor redColor];
        sloganImageView.transform = CGAffineTransformMakeTranslation(0, -kScreenHeight);
        [self.view addSubview:sloganImageView];
        _sloganImageView = sloganImageView;
        
        
        [sloganImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.offset(0);

            make.top.offset(self.view.lmj_height * 0.2);
            
        }];
        
    }
    return _sloganImageView;
}


- (NSMutableArray<UIButton *> *)publishButtons
{
    if(_publishButtons == nil)
    {
        NSMutableArray<UIButton *> *publishButtons = [NSMutableArray array];
        _publishButtons = publishButtons;
        
        NSArray<NSString *> *imageStrs = @[@"publish-audio", @"publish-offline", @"publish-picture", @"publish-review", @"publish-text", @"publish-video"];
        
        NSArray<NSString *> *titles = @[@"发声音", @"离线下载", @"发图片", @"审帖", @"发段子", @"发视频"];
        
        [imageStrs enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            UIButton *btn = [[UIButton alloc] init];
            [publishButtons addObject:btn];
            [self.view addSubview:btn];
            btn.tag = idx;
            
            btn.transform = CGAffineTransformMakeTranslation(0, -kScreenHeight);
            [btn setImage:[UIImage imageNamed:obj] forState:UIControlStateNormal];
            
            [btn addTarget:self action:@selector(publish:) forControlEvents:UIControlEventTouchUpInside];
            
            [btn setTitle:titles[idx] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            btn.imageView.contentMode = UIViewContentModeCenter;
            btn.titleLabel.textAlignment = NSTextAlignmentCenter;
            
            [btn.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                
                make.top.left.right.offset(0);
                make.height.mas_equalTo(btn.imageView.mas_width);
                
            }];
            
            [btn.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                
                make.top.equalTo(btn.imageView.mas_bottom);
                make.bottom.left.right.offset(0);
                
            }];
            
        }];
        
        
        [[publishButtons objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 3)]] mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:10 leadSpacing:10 tailSpacing:10];
        [[publishButtons objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(3, 3)]] mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:10 leadSpacing:10 tailSpacing:10];
        

        
        [[publishButtons objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 3)]] mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.sloganImageView.mas_bottom).offset(40);
            make.height.equalTo(publishButtons.firstObject.mas_width).multipliedBy(1.2);
            
        }];
        
        [[publishButtons objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(3, 3)]] mas_makeConstraints:^(MASConstraintMaker *make) {
            
            
            make.top.equalTo(publishButtons.firstObject.mas_bottom).offset(40);
            make.height.equalTo(publishButtons.firstObject.mas_width).multipliedBy(1.2);
            
        }];
        
        
    }
    return _publishButtons;
}

- (UIButton *)closeButton
{
    if(_closeButton == nil)
    {
        UIButton *btn = [[UIButton alloc] init];
        [self.view addSubview:btn];
        _closeButton = btn;
        
        [btn setTitle:@"Close" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor greenColor];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.offset(0);
            make.top.offset([UIApplication sharedApplication].statusBarFrame.size.height);
            make.size.mas_equalTo(CGSizeMake(100, 44));
            
        }];
        
        [btn addTarget:self action:@selector(closePage) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _closeButton;
}

- (void)closePage
{
//    [self dismissPopUpViewController:DDPopUpAnimationTypeNone];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
/*
app_slogan.png

publish-audio.png

publish-offline.png

publish-picture.png

publish-review.png

publish-text.png

publish-video.png

*/
@end
