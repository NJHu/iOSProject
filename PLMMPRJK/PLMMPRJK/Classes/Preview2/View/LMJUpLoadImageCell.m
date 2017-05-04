//
//  LMJUpLoadImageCell.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/5/4.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJUpLoadImageCell.h"
#import "MPImageItemModel.h"

@interface LMJUpLoadImageCell ()

/** <#digest#> */
@property (weak, nonatomic) UIImageView *picImageView;

/** <#digest#> */
@property (weak, nonatomic) UIButton *deleteButton;

@end

@implementation LMJUpLoadImageCell


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

    [_imageItem removeObserver:self forKeyPath:LMJKeyPath(_imageItem, thumbnailImage)];
    
    _imageItem = imageItem;
    
    self.picImageView.hidden = !imageItem;
    self.deleteButton.hidden = !imageItem;
    
    self.picImageView.image = imageItem.thumbnailImage;
    
    
    [imageItem addObserver:self forKeyPath:LMJKeyPath(imageItem, thumbnailImage) options:NSKeyValueObservingOptionNew context:nil];
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    MPImageItemModel *imageItem = object;
    
    self.picImageView.image = imageItem.thumbnailImage;
    
    
}

- (void)dealloc
{
    [_imageItem removeObserver:self forKeyPath:LMJKeyPath(_imageItem, thumbnailImage)];
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



@end













