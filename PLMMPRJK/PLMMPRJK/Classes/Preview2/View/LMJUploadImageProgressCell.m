//
//  LMJUpLoadImageCell.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/5/4.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJUploadImageProgressCell.h"
#import "MPImageItemModel.h"
#import <M13ProgressViewPie.h>

@interface LMJUploadImageProgressCell ()

/** <#digest#> */
@property (weak, nonatomic) UIImageView *picImageView;

/** <#digest#> */
@property (weak, nonatomic) UIButton *deleteButton;

/** <#digest#> */
@property (weak, nonatomic) M13ProgressViewPie *progressView;

@end

@implementation LMJUploadImageProgressCell


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

- (void)setupUIOnce
{
    self.contentView.layer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"btn_addPicture_BgImage"].CGImage);
    
    LMJWeakSelf(self);
    [self.contentView addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
        
        !weakself.blankTap ?: weakself.blankTap();
        
    }];
    
}


#pragma mark - setter
- (void)setImageItem:(MPImageItemModel *)imageItem
{
    [_imageItem removeObserverBlocks];
    
    _imageItem = imageItem;
    
    if (!imageItem) {
        
        self.picImageView.hidden = YES;
        self.deleteButton.hidden = YES;
        
        self.progressView.hidden = YES;
        
        return;
        
    }else
    {
        self.picImageView.image = imageItem.thumbnailImage;
        
        switch (imageItem.uploadState) {
            case MPImageUploadStateInit:
            {
                self.picImageView.hidden = NO;
                self.deleteButton.hidden = NO;
                self.progressView.hidden = YES;
                
                [self addObserver];
            }
                break;
            case MPImageUploadStateIng:
            {
                
                self.picImageView.hidden = NO;
                self.deleteButton.hidden = YES;
                self.progressView.hidden = NO;
                
                [self.progressView setProgress:self.imageItem.uploadProgress animated:YES];
                
                [self addObserver];
            }
                break;
            case MPImageUploadStateSuccess:
            {
                self.picImageView.hidden = NO;
                self.deleteButton.hidden = YES;
                self.progressView.hidden = YES;
                
                
            }
                break;
            case MPImageUploadStateFail:
            {
                self.picImageView.hidden = NO;
                self.deleteButton.hidden = NO;
                self.progressView.hidden = YES;
            }
                break;
                
            default:
                break;
        }
        
        
        
    }
    
    
    
}

- (void)addObserver
{
    
    
    LMJWeakSelf(self);
    [self.imageItem addObserverBlockForKeyPath:LMJKeyPath(self.imageItem, thumbnailImage) block:^(id  _Nonnull obj, id  _Nullable oldVal, id  _Nullable newVal) {
        
        weakself.picImageView.image = (UIImage *)newVal;
    }];
    
    [self.imageItem addObserverBlockForKeyPath:LMJKeyPath(self.imageItem, uploadState) block:^(id  _Nonnull obj, id  _Nullable oldVal, id  _Nullable newVal) {
        
        
        switch (weakself.imageItem.uploadState) {
            case MPImageUploadStateInit:
            {
                weakself.picImageView.hidden = NO;
                weakself.deleteButton.hidden = NO;
                weakself.progressView.hidden = YES;
                
            }
                break;
            case MPImageUploadStateIng:
            {
                
                weakself.picImageView.hidden = NO;
                weakself.deleteButton.hidden = YES;
                weakself.progressView.hidden = NO;
                
                [weakself.progressView setProgress:weakself.imageItem.uploadProgress animated:YES];
                
            }
                break;
            case MPImageUploadStateSuccess:
            {
                weakself.picImageView.hidden = NO;
                weakself.deleteButton.hidden = YES;
                weakself.progressView.hidden = YES;
                
                
            }
                break;
            case MPImageUploadStateFail:
            {
                weakself.picImageView.hidden = NO;
                weakself.deleteButton.hidden = NO;
                weakself.progressView.hidden = YES;
            }
                break;
                
            default:
                break;
        }
        
        
    }];
    
    
    [self.imageItem addObserverBlockForKeyPath:LMJKeyPath(self.imageItem, uploadProgress) block:^(id  _Nonnull obj, id  _Nullable oldVal, id  _Nullable newVal) {
        
        [weakself.progressView setProgress:[newVal doubleValue] animated:YES];
        
    }];
    
}


- (void)dealloc
{
    [_imageItem removeObserverBlocks];
}

#pragma mark - action
- (void)deleteClick:(UIButton *)btn
{
    !self.deleteImageTap ?: self.deleteImageTap(self.imageItem);
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
}


#pragma mark - getter

- (UIImageView *)picImageView
{
    if(_picImageView == nil)
    {
        UIImageView *imageView = [[UIImageView alloc] init];
        
        [self.contentView addSubview:imageView];
        
        
        _picImageView = imageView;
        
        imageView.userInteractionEnabled = YES;
        
        [imageView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        
        LMJWeakSelf(self);
        [imageView addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
            
            !weakself.imageTap ?: weakself.imageTap(weakself.imageItem);
        }];
    }
    return _picImageView;
}


- (UIButton *)deleteButton
{
    if(_deleteButton == nil)
    {
        UIButton *btn = [[UIButton alloc] init];
        [self.picImageView addSubview:btn];
        _deleteButton = btn;
        
        [btn setImage:[UIImage imageNamed:@"btn_right_delete_image"] forState:UIControlStateNormal];
        
        [btn addTarget:self action:@selector(deleteClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [btn sizeToFit];
        
        [btn makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.offset(5);
            make.right.offset(-5);
            
        }];
        
    }
    return _deleteButton;
}


- (M13ProgressViewPie *)progressView
{
    if(_progressView == nil)
    {
        M13ProgressViewPie *progressView = [[M13ProgressViewPie alloc]initWithFrame:CGRectZero];
        [self.picImageView addSubview:progressView];
        _progressView = progressView;
        
        
        
        
        progressView.primaryColor=[UIColor whiteColor];
        progressView.secondaryColor=[UIColor grayColor];
        
        [progressView makeConstraints:^(MASConstraintMaker *make) {
            
            make.center.offset(0);
            make.size.equalTo(CGSizeMake(44, 44));
            
        }];
        
        
    }
    return _progressView;
}




@end













