//
//  BSJTopicVideoView.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/5/24.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "BSJTopicVideoView.h"
#import "BSJTopicViewModel.h"
#import <M13ProgressViewRing.h>
#import "VIDMoviePlayerViewController.h"

@interface BSJTopicVideoView ()
/** <#digest#> */
@property (weak, nonatomic) UIImageView *pictureImageView;

/** <#digest#> */
@property (weak, nonatomic) M13ProgressViewRing *ringProgressView;

/** <#digest#> */
@property (weak, nonatomic) UILabel *voicePlayCountLabel;

/** <#digest#> */
@property (weak, nonatomic) UILabel *voiceLengthLabel;

/** <#digest#> */
@property (weak, nonatomic) UIButton *voicePlayButton;

@end

@implementation BSJTopicVideoView

- (void)setupUIOnce
{
    
    self.pictureImageView.contentMode = UIViewContentModeScaleToFill;
    
    self.clipsToBounds = YES;
    
    self.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.voicePlayButton.enabled = YES;
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
    
    
    
    // 1, playcount
    self.voicePlayCountLabel.text = [NSString stringWithFormat:@"%zd播放", topicViewModel.topic.playfcount];
    
    
    // 2, length
    self.voiceLengthLabel.text = topicViewModel.playLength;
    
    
    // 3, 处理进度,
    // 3.1 隐藏
    self.ringProgressView.hidden = (topicViewModel.downloadPictureProgress >= 1);
    
    // 3.2刷新进度立马
    [self.ringProgressView setProgress:topicViewModel.downloadPictureProgress animated:NO];
    
    [self.pictureImageView lmj_setImageWithURL:topicViewModel.topic.largePicture thumbnailImageURL:topicViewModel.topic.smallPicture placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL *targetUrl) {
        
        // 3.3储存 "每个模型" 的进度
        topicViewModel.downloadPictureProgress = (CGFloat)receivedSize / expectedSize;
        
        
        // 3.4给每个cell对应的模型进度赋值
        [self.ringProgressView setProgress:self.topicViewModel.downloadPictureProgress animated:NO];
        
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        
        
    }];
    
}



#pragma mark - getter

- (UILabel *)voiceLengthLabel
{
    if(_voiceLengthLabel == nil)
    {
        UILabel *voiceLengthLabel = [[UILabel alloc] init];
        [self.pictureImageView addSubview:voiceLengthLabel];
        _voiceLengthLabel = voiceLengthLabel;
        
        voiceLengthLabel.textColor = [UIColor whiteColor];
        voiceLengthLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        
        voiceLengthLabel.font = [UIFont systemFontOfSize:12];
        
        [voiceLengthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.bottom.offset(0);
            
        }];
        
    }
    return _voiceLengthLabel;
}


- (UILabel *)voicePlayCountLabel
{
    if(_voicePlayCountLabel == nil)
    {
        UILabel *voicePlayCountLabel = [[UILabel alloc] init];
        [self.pictureImageView addSubview:voicePlayCountLabel];
        _voicePlayCountLabel = voicePlayCountLabel;
        
        voicePlayCountLabel.textColor = [UIColor whiteColor];
        voicePlayCountLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        
        voicePlayCountLabel.font = [UIFont systemFontOfSize:12];
        
        [voicePlayCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.top.offset(0);
            
        }];
        
    }
    return _voicePlayCountLabel;
}

- (UIImageView *)pictureImageView
{
    if(_pictureImageView == nil)
    {
        UIImageView *pictureImageView = [[UIImageView alloc] init];
        [self addSubview:pictureImageView];
        _pictureImageView = pictureImageView;
        pictureImageView.userInteractionEnabled = YES;
        
        [pictureImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 0, 0, 0));
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
        
        
        
        ringProgressView.backgroundRingWidth = 5;
        ringProgressView.progressRingWidth = 5;
        ringProgressView.showPercentage = YES;
        ringProgressView.primaryColor = [UIColor redColor];
        ringProgressView.secondaryColor = [UIColor yellowColor];
        
        [ringProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.center.centerOffset(CGPointZero);
            make.size.mas_equalTo(CGSizeMake(80, 80));
        }];
        
    }
    return _ringProgressView;
}


- (UIButton *)voicePlayButton
{
    if(_voicePlayButton == nil)
    {
        UIButton *btn = [[UIButton alloc] init];
        [self.pictureImageView addSubview:btn];
        _voicePlayButton = btn;
        

        [btn setImage:[UIImage imageNamed:@"video-play"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"playButtonPause"] forState:UIControlStateSelected];
        
        
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.center.centerOffset(CGPointZero);
            
        }];
        
        [btn addTarget:self action:@selector(playVideo:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _voicePlayButton;
}





- (void)playVideo:(UIButton *)btn
{
    VIDMoviePlayerViewController *playerVc = [[VIDMoviePlayerViewController alloc] init];
    playerVc.videoURL = self.topicViewModel.topic.videoUrl.absoluteString;
    [self.viewController.navigationController pushViewController:playerVc animated:YES];
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
