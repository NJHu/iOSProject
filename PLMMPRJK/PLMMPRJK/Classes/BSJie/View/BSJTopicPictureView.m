//
//  BSJTopicPictureView.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/5/23.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "BSJTopicPictureView.h"
#import "BSJTopicViewModel.h"
#import <M13ProgressViewRing.h>
#import "BSJPictureShowViewController.h"



@interface BSJTopicPictureView ()

/** <#digest#> */
@property (weak, nonatomic) UIImageView *pictureImageView;

/** <#digest#> */
@property (weak, nonatomic) M13ProgressViewRing *ringProgressView;

/** <#digest#> */
@property (weak, nonatomic) UIImageView *gifImageView;

/** <#digest#> */
@property (weak, nonatomic) UIButton *seeBigPictureButton;

@end

@implementation BSJTopicPictureView



- (void)setupUIOnce
{
    
    self.pictureImageView.contentMode = UIViewContentModeScaleToFill;
    
    self.clipsToBounds = YES;
    
    self.backgroundColor = [UIColor groupTableViewBackgroundColor];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    
    UIImage *logo = [UIImage imageNamed:@"imageBackground"];
    
    [logo drawAtPoint:CGPointMake((rect.size.width - logo.size.width) * 0.5, 5)];
}


- (void)setTopicViewModel:(BSJTopicViewModel *)topicViewModel
{
    _topicViewModel = topicViewModel;
    
    
    /*
     self.ringProgressView.hidden = (topicViewModel.downloadPictureProgress >= 1);
     
     [self.ringProgressView setProgress:topicViewModel.downloadPictureProgress animated:NO];
     
     LMJWeakSelf(self);
     [self.pictureImageView lmj_setImageWithURL:topicViewModel.topic.largePicture thumbnailImageURL:topicViewModel.topic.smallPicture placeholderImage:nil options:SDWebImageTransformAnimatedImage progress:^(NSInteger receivedSize, NSInteger expectedSize) {
     
     //关键步骤
     topicViewModel.downloadPictureProgress = (CGFloat)receivedSize / expectedSize;
     
     // 关键步骤
     [weakself.ringProgressView setProgress:weakself.topicViewModel.downloadPictureProgress animated:NO];
     
     
     } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
     
     if (error || !weakself.topicViewModel.isBigPicture || weakself.topicViewModel.topic.isGif || !image || weakself.topicViewModel != topicViewModel) { // 关键步骤,
     return ;
     }
     
     CGFloat w = weakself.topicViewModel.topic.width;
     CGFloat h = weakself.topicViewModel.pictureFrame.size.height / weakself.topicViewModel.pictureFrame.size.width * w;
     
     weakself.pictureImageView.image = [image imageByCropToRect:CGRectMake(0, 0, w, h)];
     
     }];
     */
    
    // 1, gif
    self.gifImageView.hidden = !topicViewModel.topic.isGif;
    
    // 2, 查看大图
    self.seeBigPictureButton.hidden = !topicViewModel.isBigPicture;
    
    // 3, 处理进度,
    // 3.1 隐藏
    self.ringProgressView.hidden = (topicViewModel.downloadPictureProgress >= 1);
    
    // 3.2刷新进度立马
    [self.ringProgressView setProgress:topicViewModel.downloadPictureProgress animated:NO];
    
    [self.pictureImageView lmj_setImageWithURL:topicViewModel.topic.largePicture thumbnailImageURL:topicViewModel.topic.smallPicture placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
        // 3.3储存 "每个模型" 的进度
        topicViewModel.downloadPictureProgress = (CGFloat)receivedSize / expectedSize;
        
        
        // 3.4给每个cell对应的模型进度赋值
        [self.ringProgressView setProgress:self.topicViewModel.downloadPictureProgress animated:NO];
        
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        // 4, 处理大图, 必须是当前的模型
        if (!image || error || !self.topicViewModel.isBigPicture || self.topicViewModel.topic.isGif  || self.topicViewModel != topicViewModel) {
            
            return ;
            
        }
        
        // 4.1 裁剪
        // 只要设置图片就会调用
        // 控制隐藏, 当是当前的模型的时候才隐藏
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            UIGraphicsBeginImageContextWithOptions(self.topicViewModel.pictureFrame.size, NO, 0);
            
            CGFloat w = self.topicViewModel.pictureFrame.size.width;
            
            
            CGFloat h = w * self.topicViewModel.topic.height / self.topicViewModel.topic.width;
            
            
            [image drawInRect:CGRectMake(0, 0, w, h)];
            
            UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
            
            UIGraphicsEndImageContext();
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                self.pictureImageView.image = newImage;
                
            });
            
        });
        
    }];
    
}

- (UIImageView *)pictureImageView
{
    if(_pictureImageView == nil)
    {
        UIImageView *pictureImageView = [[UIImageView alloc] init];
        [self addSubview:pictureImageView];
        _pictureImageView = pictureImageView;
        
        [pictureImageView makeConstraints:^(MASConstraintMaker *make) {
            
            make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        
        pictureImageView.userInteractionEnabled = YES;
        
        LMJWeakSelf(self);
        [pictureImageView addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
            
            BSJPictureShowViewController *showPicVc = [[BSJPictureShowViewController alloc] init];
            showPicVc.topicViewModel = weakself.topicViewModel;
//            @property (nonatomic,retain) UIViewController *popUpViewController;
//            @property (nonatomic,assign) CGPoint popUpOffset;               //相对于弹出位置的偏移
//            @property (nonatomic,assign) CGSize popUpViewSize;              //弹出视图的大小
//            @property (nonatomic,assign) DDPopUpPosition popUpPosition;     //弹出视图的位置
//            @property (nonatomic,assign) BOOL dismissWhenTouchBackground;   //是否允许点击背景dismiss
//            @property (nonatomic,copy) DismissCallback dismissCallback;
            
            
            showPicVc.popUpViewSize = Main_Screen_Bounds.size;
            
            [weakself.viewController showPopUpViewController:showPicVc animationType:DDPopUpAnimationTypeFade];
            
        }];
        
    }
    return _pictureImageView;
}



- (M13ProgressViewRing *)ringProgressView
{
    if(_ringProgressView == nil)
    {
        M13ProgressViewRing *ringProgressView = [[M13ProgressViewRing alloc] init];
        [self insertSubview:ringProgressView belowSubview:self.pictureImageView];
        _ringProgressView = ringProgressView;
        
        
        /**@name Appearance*/
        /**The primary color of the `M13ProgressView`.*/
        //        @property (nonatomic, retain) UIColor *primaryColor;
        //        *The secondary color of the `M13ProgressView`.
        //        @property (nonatomic, retain) UIColor *secondaryColor;
        //
        //        *@name Properties
        //        *Wether or not the progress view is indeterminate.
        //        @property (nonatomic, assign) BOOL indeterminate;
        //        *The durations of animations in seconds.
        //        @property (nonatomic, assign) CGFloat animationDuration;
        
        
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


- (UIImageView *)gifImageView
{
    if(_gifImageView == nil)
    {
        UIImageView *gifImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common-gif"]];
        [self.pictureImageView addSubview:gifImageView];
        _gifImageView = gifImageView;
        
        [gifImageView makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.left.offset(0);
            
        }];
        
    }
    return _gifImageView;
}
- (UIButton *)seeBigPictureButton
{
    if(_seeBigPictureButton == nil)
    {
        UIButton *btn = [[UIButton alloc] init];
        [self.pictureImageView addSubview:btn];
        _seeBigPictureButton = btn;
        
        [btn setBackgroundImage:[UIImage imageNamed:@"see-big-picture-background"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"see-big-picture"] forState:UIControlStateNormal];
        
        [btn setTitle:@"查看大图" forState:UIControlStateNormal];
        
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [btn makeConstraints:^(MASConstraintMaker *make) {
            
            make.bottom.left.right.offset(0);
            make.height.equalTo(34);
            
        }];
        
        btn.userInteractionEnabled = NO;
        
    }
    return _seeBigPictureButton;
}



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
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self setNeedsDisplay];
}

@end
