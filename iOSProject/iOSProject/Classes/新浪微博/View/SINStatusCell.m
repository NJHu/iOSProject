//
//  SINStatusCell.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/6/21.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "SINStatusCell.h"
#import "SINStatusViewModel.h"
#import "SINStatus.h"
#import "SINDictURL.h"
#import "SINUser.h"
#import "SINStatusToolBarView.h"
#import "SINStatusPicsView.h"
#import "SINStatusRetweetView.h"
//#import <HMEmoticonManager.h>
#import <KILabel.h>
#import "LMJWebViewController.h"

@interface SINStatusCell ()

/** 头像 */
@property (weak, nonatomic)  UIImageView *profile_image_urlImageView;

/** 加 V 认证 */
@property (weak, nonatomic) UIImageView *avatarVipImageView;

/** 昵称 */
@property (weak, nonatomic) YYLabel *screen_nameLabel;

/** 等级 Vip */
@property (weak, nonatomic) UIImageView *mbrankImageView;

/** 发表时间 */
@property (weak, nonatomic) UILabel *created_atTimeLabel;

/** 来源 */
@property (weak, nonatomic)  UILabel *sourceCreatLabel;

/** 说的内容 */
@property (weak, nonatomic) KILabel *textPostLabel;

/** 底部的工具条 */
@property (weak, nonatomic) SINStatusToolBarView *bottomToolBarView;
/** 底部的分割线 */
@property (weak, nonatomic)  UIView *sepLineView;

/** 展示图片的 View */
@property (weak, nonatomic) SINStatusPicsView *statusPicsView;


/** <#digest#> */
@property (weak, nonatomic) SINStatusRetweetView *reweetView;

@end

@implementation SINStatusCell

static const CGFloat margin = 10.0;


- (void)setStatusViewModel:(SINStatusViewModel *)statusViewModel
{
    _statusViewModel = statusViewModel;
    
    [self.profile_image_urlImageView sd_setImageWithURL:statusViewModel.status.user.profile_image_url placeholderImage:[UIImage imageNamed:@"avatar_default"]];
    
    self.avatarVipImageView.image = statusViewModel.sin_verified_typeImage;
    self.avatarVipImageView.hidden = !statusViewModel.sin_verified_typeImage;
    
    self.screen_nameLabel.text = statusViewModel.status.user.screen_name;
    self.mbrankImageView.image = statusViewModel.sin_mbrankImage;
    self.textPostLabel.attributedText = statusViewModel.sin_textPost ?: [[NSMutableAttributedString alloc] initWithString:@""];
    [self.textPostLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(statusViewModel.postTextHeight);
    }];
    
    self.bottomToolBarView.statusViewModel = statusViewModel;
    
    self.created_atTimeLabel.text = statusViewModel.sin_creatTime;
    self.sourceCreatLabel.text = statusViewModel.sin_source;
    
    // 先设置 View 的尺寸, 再刷新数据
    [self.statusPicsView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(statusViewModel.sin_statusPicsViewModel.picsViewSize);
    }];
    
    [self layoutIfNeeded];
    self.statusPicsView.statusViewModel = statusViewModel;
    self.reweetView.hidden = !statusViewModel.sin_retweetStatusViewModel;
    self.reweetView.retweetStatusViewModel = statusViewModel.sin_retweetStatusViewModel;
}


- (void)setupUIOnce
{
    self.contentView.backgroundColor = [UIColor whiteColor];
}



#pragma mark - getter

- (UIImageView *)profile_image_urlImageView
{
    if(_profile_image_urlImageView == nil)
    {
        UIImageView *profile_image_urlImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"avatar_default"]];
        [self.contentView addSubview:profile_image_urlImageView];
        _profile_image_urlImageView = profile_image_urlImageView;
        profile_image_urlImageView.layer.cornerRadius = 25;
        profile_image_urlImageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        profile_image_urlImageView.layer.borderWidth = 0.3;
        profile_image_urlImageView.layer.masksToBounds = YES;
        profile_image_urlImageView.contentMode = UIViewContentModeScaleAspectFill;
        [profile_image_urlImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.offset(margin);
            make.size.mas_equalTo(CGSizeMake(50, 50));
        }];
    }
    return _profile_image_urlImageView;
}


- (YYLabel *)screen_nameLabel
{
    if(_screen_nameLabel == nil) {
        YYLabel *screen_nameLabel = [[YYLabel alloc] init];
        [self.contentView addSubview:screen_nameLabel];
        _screen_nameLabel = screen_nameLabel;
        screen_nameLabel.textAlignment = NSTextAlignmentLeft;
        screen_nameLabel.textColor = [UIColor blackColor];
        screen_nameLabel.font = [UIFont systemFontOfSize:AdaptedWidth(14)];
        [screen_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.profile_image_urlImageView.mas_right).offset(10);
            make.right.lessThanOrEqualTo(self.contentView.mas_right).offset(-50);
            make.bottom.mas_equalTo(self.profile_image_urlImageView.mas_centerY);
        }];
    }
    return _screen_nameLabel;
}

- (UIImageView *)avatarVipImageView
{
    if(_avatarVipImageView == nil) {
        UIImageView *avatarVipImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"avatar_enterprise_vip"]];
        [self.contentView addSubview:avatarVipImageView];
        _avatarVipImageView = avatarVipImageView;
        avatarVipImageView.layer.cornerRadius = 8;
        //        avatarVipImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        //        avatarVipImageView.layer.borderWidth = 1;
        avatarVipImageView.contentMode = UIViewContentModeScaleToFill;;
        avatarVipImageView.backgroundColor = [UIColor whiteColor];
        [avatarVipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.right.mas_equalTo(self.profile_image_urlImageView).offset(0);
            make.size.mas_equalTo(CGSizeMake(16, 16));
        }];
    }
    return _avatarVipImageView;
}

- (UIImageView *)mbrankImageView
{
    if(_mbrankImageView == nil)
    {
        UIImageView *mbrankImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common_icon_membership_level1"]];
        [self.contentView addSubview:mbrankImageView];
        _mbrankImageView = mbrankImageView;
        [mbrankImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.screen_nameLabel.mas_centerY);
            make.left.mas_equalTo(self.screen_nameLabel.mas_right).offset(margin);
        }];
    }
    return _mbrankImageView;
}


- (SINStatusToolBarView *)bottomToolBarView
{
    if(_bottomToolBarView == nil)
    {
        SINStatusToolBarView *bottomToolBarView = [SINStatusToolBarView tooBarView];
        [self.contentView addSubview:bottomToolBarView];
        _bottomToolBarView = bottomToolBarView;
        bottomToolBarView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [bottomToolBarView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.offset(0);
            make.bottom.mas_equalTo(self.sepLineView.mas_top);
            make.height.mas_equalTo(32.5);
        }];
    }
    return _bottomToolBarView;
}


- (UIView *)sepLineView
{
    if(_sepLineView == nil)
    {
        UIView *lineView = [[UIView alloc] init];
        [self.contentView addSubview:lineView];
        _sepLineView = lineView;
        lineView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.right.left.offset(0);
            make.height.mas_equalTo(margin);
        }];
    }
    return _sepLineView;
}

- (KILabel *)textPostLabel
{
    if(_textPostLabel == nil)
    {
        KILabel *textPostLabel = [[KILabel alloc] init];
        [self.contentView addSubview:textPostLabel];
        _textPostLabel = textPostLabel;
        textPostLabel.numberOfLines = 0;
        textPostLabel.textAlignment = NSTextAlignmentLeft;
        textPostLabel.preferredMaxLayoutWidth = kScreenWidth - 2 * margin;
        textPostLabel.backgroundColor = [UIColor RandomColor];
        [textPostLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(margin);
            make.right.offset(-margin);
            make.top.mas_equalTo(self.profile_image_urlImageView.mas_bottom).offset(margin);
            make.height.mas_equalTo(20);
        }];
        
        //        /**
        //         *  Usernames starting with "@" token
        //         */
        //        KILinkTypeUserHandle,
        //
        //        /**
        //         *  Hashtags starting with "#" token
        //         */
        //        KILinkTypeHashtag,
        //
        //        /**
        //         *  URLs, http etc
        //         */
        //        KILinkTypeURL,
        
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
    return _textPostLabel;
}

- (UILabel *)created_atTimeLabel
{
    if(_created_atTimeLabel == nil)
    {
        UILabel *created_atTimeLabel = [[UILabel alloc] init];
        [self.contentView addSubview:created_atTimeLabel];
        _created_atTimeLabel = created_atTimeLabel;
        created_atTimeLabel.textAlignment = NSTextAlignmentLeft;
        created_atTimeLabel.textColor = [UIColor lightGrayColor];
        created_atTimeLabel.font = [UIFont systemFontOfSize:AdaptedWidth(11)];
        [created_atTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.screen_nameLabel.mas_left);
            make.top.mas_equalTo(self.profile_image_urlImageView.mas_centerY).offset(3);
        }];
    }
    return _created_atTimeLabel;
}


- (UILabel *)sourceCreatLabel
{
    if(_sourceCreatLabel == nil)
    {
        UILabel *sourceCreatLabel = [[UILabel alloc] init];
        [self.contentView addSubview:sourceCreatLabel];
        _sourceCreatLabel = sourceCreatLabel;
        sourceCreatLabel.textAlignment = NSTextAlignmentLeft;
        sourceCreatLabel.textColor = [UIColor lightGrayColor];
        sourceCreatLabel.font = [UIFont systemFontOfSize:AdaptedWidth(11)];
        [sourceCreatLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.created_atTimeLabel.mas_right).offset(5);
            make.centerY.mas_equalTo(self.created_atTimeLabel);
        }];
    }
    return _sourceCreatLabel;
}


- (SINStatusPicsView *)statusPicsView
{
    if(_statusPicsView == nil)
    {
        SINStatusPicsView *statusPicsView = [[SINStatusPicsView alloc] init];
        [self.contentView addSubview:statusPicsView];
        _statusPicsView = statusPicsView;
        [statusPicsView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.textPostLabel.mas_bottom).offset(margin);
            make.left.mas_equalTo(self.textPostLabel.mas_left);
            make.size.mas_equalTo(CGSizeMake(66, 66));
        }];
    }
    return _statusPicsView;
}

- (SINStatusRetweetView *)reweetView
{
    if(_reweetView == nil)
    {
        SINStatusRetweetView *reweetView = [[SINStatusRetweetView alloc] init];
        [self.contentView addSubview:reweetView];
        _reweetView = reweetView;
        [reweetView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.offset(0);
            make.top.mas_equalTo(self.textPostLabel.mas_bottom).offset(margin);
            make.bottom.mas_equalTo(reweetView.statusPicsView.mas_bottom).offset(margin);
        }];
    }
    return _reweetView;
}

#pragma mark - base
+ (instancetype)statusCellWithTableView:(UITableView *)tableView {
    SINStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
    if (cell == nil) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass(self)];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUIOnce];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setupUIOnce];
}



- (void)layoutSubviews{
    [super layoutSubviews];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
