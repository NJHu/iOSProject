//
//  BSJPictureShowViewController.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/6/1.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "BSJPictureShowViewController.h"
#import "BSJTopicViewModel.h"
#import <M13ProgressViewRing.h>

@interface BSJPictureShowViewController ()<UIScrollViewDelegate>
/** <#digest#> */
@property (weak, nonatomic) UIImageView *pictureImageView;

/** <#digest#> */
@property (weak, nonatomic) M13ProgressViewRing *ringProgressView;

/** <#digest#> */
@property (weak, nonatomic) UIScrollView *scrollView;

/** <#digest#> */
@property (weak, nonatomic) UIButton *backButton;


@end

@implementation BSJPictureShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    LMJWeakSelf(self);
    [self.view addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
        
        [weakself dismissPopUpViewController:DDPopUpAnimationTypeFade];
    }];
    
    // 3, 处理进度,
    // 3.1 隐藏
    
    // 3.2刷新进度立马
    [self.ringProgressView setProgress:self.topicViewModel.downloadPictureProgress animated:NO];
    
    self.ringProgressView.hidden = self.topicViewModel.downloadPictureProgress >= 1;
    
    [self.pictureImageView lmj_setImageWithURL:self.topicViewModel.topic.largePicture thumbnailImageURL:self.topicViewModel.topic.smallPicture placeholderImage:nil options:SDWebImageTransformAnimatedImage progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
        // 3.3储存 "每个模型" 的进度
        self.topicViewModel.downloadPictureProgress = (CGFloat)receivedSize / expectedSize;
        
        
        // 3.4给每个cell对应的模型进度赋值
        [self.ringProgressView setProgress:self.topicViewModel.downloadPictureProgress animated:NO];
        
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        
        self.ringProgressView.hidden = self.topicViewModel.downloadPictureProgress >= 1;
        
    }];
    
    
    
    CGFloat picWidth = Main_Screen_Width;
    CGFloat picHeight = picWidth * self.topicViewModel.topic.height / self.topicViewModel.topic.width;
    
    if (picHeight <= Main_Screen_Height) {
        
        self.pictureImageView.frame = CGRectMake(0, (Main_Screen_Height - picHeight) * 0.5, Main_Screen_Width, picHeight);
        

    }else
    {
        self.pictureImageView.frame = CGRectMake(0, 0, Main_Screen_Width, picHeight);
        

    }
    
    self.scrollView.contentSize = CGSizeMake(Main_Screen_Width, picHeight);
    
    [self backButton];
}


#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.pictureImageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    if (self.pictureImageView.lmj_height < Main_Screen_Height) {
        
        self.pictureImageView.lmj_centerY = Main_Screen_Height * 0.5;
    }
    
}

- (UIImageView *)pictureImageView
{
    if(_pictureImageView == nil)
    {
        UIImageView *pictureImageView = [[UIImageView alloc] init];
        [self.scrollView addSubview:pictureImageView];
        _pictureImageView = pictureImageView;
        pictureImageView.userInteractionEnabled = YES;
        pictureImageView.contentMode = UIViewContentModeScaleToFill;
    }
    return _pictureImageView;
}


- (UIScrollView *)scrollView
{
    if(_scrollView == nil)
    {
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        [self.view addSubview:scrollView];
        _scrollView = scrollView;
        [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.edges.insets(UIEdgeInsetsZero);
        }];
        scrollView.delegate = self;
        scrollView.minimumZoomScale = 1;
        scrollView.maximumZoomScale = 2;
    }
    return _scrollView;
}


- (UIButton *)backButton
{
    if(_backButton == nil)
    {
        
        UIButton *btn = [UIButton new];
        [self.view addSubview:btn];
        _backButton = btn;
        
        [btn setTitle:@"返回" forState: UIControlStateNormal];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.left.offset (20);
            make.size.mas_equalTo(CGSizeMake(44, 44));
        }];
        
        LMJWeakSelf(self);
        [btn addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
            
            [weakself dismissPopUpViewController:DDPopUpAnimationTypeFade];
        }];
    }
    return _backButton;
}


- (M13ProgressViewRing *)ringProgressView
{
    if(_ringProgressView == nil)
    {
        M13ProgressViewRing *ringProgressView = [[M13ProgressViewRing alloc] init];
        [self.view insertSubview:ringProgressView atIndex:0];
        _ringProgressView = ringProgressView;
        
        
        
        ringProgressView.backgroundRingWidth = 5;
        ringProgressView.progressRingWidth = 5;
        ringProgressView.showPercentage = YES;
        ringProgressView.primaryColor = [UIColor redColor];
        ringProgressView.secondaryColor = [UIColor yellowColor];
        
        [ringProgressView makeConstraints:^(MASConstraintMaker *make) {
            
            make.center.centerOffset(CGPointZero);
            make.size.equalTo(CGSizeMake(80, 80));
        }];
        
    }
    return _ringProgressView;
}


- (UIStatusBarStyle)navUIBaseViewControllerPreferStatusBarStyle:(LMJNavUIBaseViewController *)navUIBaseViewController
{
    return UIStatusBarStyleLightContent;
}


@end
