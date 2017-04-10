//
//  QBAssetsCollectionViewCell.m
//  QBImagePickerController
//
//  Created by Tanaka Katsuma on 2013/12/31.
//  Copyright (c) 2013年 Katsuma Tanaka. All rights reserved.
//

#import "QBAssetsCollectionViewCell.h"

// Views
#import "QBAssetsCollectionOverlayView.h"
#import "QBAssetsCollectionVideoIndicatorView.h"

@interface QBAssetsCollectionViewCell ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) QBAssetsCollectionOverlayView *overlayView;
@property (nonatomic, strong) QBAssetsCollectionVideoIndicatorView *videoIndicatorView;

@property (nonatomic, strong) UIImage *blankImage;

@end

@implementation QBAssetsCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.showsOverlayViewWhenSelected = YES;
        
        // Create a image view
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
        imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        [self.contentView addSubview:imageView];
        self.imageView = imageView;
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    // Show/hide overlay view
    if (selected && self.showsOverlayViewWhenSelected) {
        [self showOverlayView];
    } else {
        [self hideOverlayView];
    }
}


#pragma mark - Overlay View

- (void)showOverlayView
{
    [self hideOverlayView];
    
    QBAssetsCollectionOverlayView *overlayView = [[QBAssetsCollectionOverlayView alloc] initWithFrame:self.contentView.bounds];
    overlayView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self.contentView addSubview:overlayView];
    self.overlayView = overlayView;
}

- (void)hideOverlayView
{
    if (self.overlayView) {
        [self.overlayView removeFromSuperview];
        self.overlayView = nil;
    }
}


#pragma mark - Video Indicator View

- (void)showVideoIndicatorView
{
    CGFloat height = 19.0;
    CGRect frame = CGRectMake(0, CGRectGetHeight(self.bounds) - height, CGRectGetWidth(self.bounds), height);
    QBAssetsCollectionVideoIndicatorView *videoIndicatorView = [[QBAssetsCollectionVideoIndicatorView alloc] initWithFrame:frame];
    videoIndicatorView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    videoIndicatorView.duration = [[self.asset valueForProperty:ALAssetPropertyDuration] doubleValue];
    
    [self.contentView addSubview:videoIndicatorView];
    self.videoIndicatorView = videoIndicatorView;
}

- (void)hideVideoIndicatorView
{
    if (self.videoIndicatorView) {
        [self.videoIndicatorView removeFromSuperview];
        self.videoIndicatorView = nil;
    }
}


#pragma mark - Accessors

- (void)setAsset:(ALAsset *)asset
{
    _asset = asset;
    
    // Update view
    CGImageRef thumbnailImageRef = [asset thumbnail];
    
    if (thumbnailImageRef) {
        self.imageView.image = [UIImage imageWithCGImage:thumbnailImageRef];
    } else {
        self.imageView.image = [self blankImage];
    }
    
    // Show video indicator if the asset is video
    if ([[asset valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypeVideo]) {
        [self showVideoIndicatorView];
    } else {
        [self hideVideoIndicatorView];
    }
}

- (UIImage *)blankImage
{
    if (_blankImage == nil) {
        CGSize size = CGSizeMake(100.0, 100.0);
        UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
        
        [[UIColor colorWithWhite:(240.0 / 255.0) alpha:1.0] setFill];
        UIRectFill(CGRectMake(0, 0, size.width, size.height));
        
        _blankImage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
    }
    
    return _blankImage;
}

@end
