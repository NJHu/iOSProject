//
//  SINStatusRetweetView.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/6/28.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "SINStatusRetweetView.h"
#import "SINStatusPicsView.h"
#import "SINStatusViewModel.h"
#import <KILabel.h>
#import "LMJWebViewController.h"

@interface SINStatusRetweetView ()

@property (weak, nonatomic) KILabel *retweetContentLabel;

@end

static const CGFloat margin = 10.0;
@implementation SINStatusRetweetView

- (void)setupUIOnce {
    self.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.1];
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)setRetweetStatusViewModel:(SINStatusViewModel *)retweetStatusViewModel
{
    _retweetStatusViewModel = retweetStatusViewModel;
    self.retweetContentLabel.attributedText = retweetStatusViewModel.sin_textPost ?: [[NSMutableAttributedString alloc] initWithString:@""];
    [self.retweetContentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(retweetStatusViewModel.postTextHeight);
    }];
    
    // 先设置 View 的尺寸, 再刷新数据
    [self.statusPicsView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(retweetStatusViewModel.sin_statusPicsViewModel.picsViewSize);
    }];
    
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.statusPicsView.mas_bottom).offset(retweetStatusViewModel.status.pic_urls.count ? margin : 0);
    }];
    
    [self layoutIfNeeded];
    
    self.statusPicsView.statusViewModel = retweetStatusViewModel;
}


#pragma mark - getter

- (KILabel *)retweetContentLabel
{
    if(_retweetContentLabel == nil)
    {
        KILabel *textPostLabel = [[KILabel alloc] init];
        [self addSubview:textPostLabel];
        _retweetContentLabel = textPostLabel;
        
        textPostLabel.numberOfLines = 0;
        textPostLabel.textAlignment = NSTextAlignmentLeft;
        textPostLabel.preferredMaxLayoutWidth = kScreenWidth - 2 * margin;
        textPostLabel.backgroundColor = [UIColor RandomColor];
        [textPostLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(margin);
            make.right.offset(-margin);
            make.top.offset(margin);
            make.height.mas_equalTo(20);
        }];
        
        [textPostLabel setAttributes:@{NSForegroundColorAttributeName : UIColor.greenColor} forLinkType:KILinkTypeUserHandle];
        [textPostLabel setAttributes:@{NSForegroundColorAttributeName : UIColor.greenColor} forLinkType:KILinkTypeHashtag];
        [textPostLabel setAttributes:@{NSForegroundColorAttributeName : UIColor.greenColor} forLinkType:KILinkTypeURL];

        textPostLabel.userHandleLinkTapHandler = ^(KILabel * _Nonnull label, NSString * _Nonnull string, NSRange range) {
            NSLog(@"%@ %@ %@", label, string, NSStringFromRange(range));
        };
        
        textPostLabel.hashtagLinkTapHandler = ^(KILabel * _Nonnull label, NSString * _Nonnull string, NSRange range) {
            NSLog(@"%@ %@ %@", label, string, NSStringFromRange(range));
        };
        
        
        textPostLabel.urlLinkTapHandler = ^(KILabel * _Nonnull label, NSString * _Nonnull string, NSRange range) {
            NSLog(@"%@ %@ %@", label, string, NSStringFromRange(range));
//            LMJWebViewController *webVc = [[LMJWebViewController alloc] init];
//            webVc.gotoURL = string.copy;
//            [weakself.viewController.navigationController pushViewController:webVc animated:YES];
        };
    }
    return _retweetContentLabel;
}



- (SINStatusPicsView *)statusPicsView
{
    if(_statusPicsView == nil)
    {
        SINStatusPicsView *statusPicsView = [[SINStatusPicsView alloc] init];
        [self addSubview:statusPicsView];
        _statusPicsView = statusPicsView;
        [statusPicsView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.retweetContentLabel.mas_bottom).offset(margin);
            make.left.mas_equalTo(self.retweetContentLabel.mas_left);
            make.size.mas_equalTo(CGSizeMake(66, 66));
        }];
    }
    return _statusPicsView;
}

#pragma mark - base
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
