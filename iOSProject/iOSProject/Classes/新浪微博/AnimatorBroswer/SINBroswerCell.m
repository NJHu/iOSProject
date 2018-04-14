//
//  SINBroswerCell.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/6/23.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "SINBroswerCell.h"

@interface SINBroswerCell ()<UIScrollViewDelegate, UIScrollViewAccessibilityDelegate>
@property (weak, nonatomic) UIScrollView *scrollView;
@end

@implementation SINBroswerCell

- (void)setupUIOnce
{
    self.contentView.backgroundColor = self.scrollView.backgroundColor = [UIColor clearColor];
}


- (void)setImageDict:(SINDictURL *)imageDict
{
    _imageDict = imageDict;
    LMJWeak(self);
    [self.imageView sd_setImageWithURL:imageDict.bmiddle_pic placeholderImage:[UIImage imageNamed:@"empty_picture"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image && !error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [weakself updateImageViewWithImage:image isNeedUpdateImageViewRect:YES];

                [self.imageView sd_setImageWithURL:imageDict.original_pic placeholderImage:image options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSizen, NSURL *targetUrl) {
                    
                } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    if (image && !error) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [weakself updateImageViewWithImage:image isNeedUpdateImageViewRect:NO];
                        });
                    }
                }];
            });
        }
    }];
}



- (void)updateImageViewWithImage:(UIImage *)image isNeedUpdateImageViewRect:(BOOL)isNeedUpdateImageViewRect {
    self.imageView.image = image;
    if (isNeedUpdateImageViewRect) {
        CGFloat imageViewY = 0;
        CGFloat imageWidth = image.size.width;
        CGFloat imageHeight = image.size.height;
        CGFloat fitWidth = kScreenWidth;
        CGFloat fitHeight = fitWidth * imageHeight / imageWidth;
        if (fitHeight < kScreenHeight) {
            imageViewY = (kScreenHeight - fitHeight) * 0.5;
        }
        self.imageView.frame = CGRectMake(0, imageViewY, fitWidth, fitHeight);
        self.scrollView.contentSize = CGSizeMake(fitWidth, fitHeight);
    }
}


#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}


#pragma mark - getter

- (UIScrollView *)scrollView
{
    if(_scrollView == nil)
    {
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        [self.contentView addSubview:scrollView];
        _scrollView = scrollView;
        [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.insets(UIEdgeInsetsMake(0, 0, 0, 10));
        }];
        scrollView.delegate = self;
        scrollView.maximumZoomScale = 2;
        scrollView.minimumZoomScale = 1;
    }
    return _scrollView;
}

- (UIImageView *)imageView
{
    if(_imageView == nil)
    {
        UIImageView *imageView = [[UIImageView alloc] init];
        [self.scrollView addSubview:imageView];
        _imageView = imageView;
        
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.userInteractionEnabled = YES;
    }
    return _imageView;
}



#pragma mark - base
- (void)layoutSubviews
{
    [super layoutSubviews];
    
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



@end
