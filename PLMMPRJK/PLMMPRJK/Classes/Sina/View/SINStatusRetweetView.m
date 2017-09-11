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

@interface SINStatusRetweetView ()

/** <#digest#> */
@property (weak, nonatomic) YYLabel *retweetContentLabel;



@end



static const CGFloat margin = 10.0;
@implementation SINStatusRetweetView


- (void)setupUIOnce
{
    self.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.1];
    
}



- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (void)setRetweetStatusViewModel:(SINStatusViewModel *)retweetStatusViewModel
{
    _retweetStatusViewModel = retweetStatusViewModel;
    
    self.retweetContentLabel.textLayout = retweetStatusViewModel.sin_textPostLayout;
    
    [self.retweetContentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.height.equalTo(retweetStatusViewModel.sin_textPostLayout.textBoundingSize.height);
        
    }];
    
    // 先设置 View 的尺寸, 再刷新数据
    [self.statusPicsView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(retweetStatusViewModel.sin_statusPicsViewModel.picsViewSize);
    }];
    
    [self layoutIfNeeded];
    
    self.statusPicsView.statusViewModel = retweetStatusViewModel;
    
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(self.statusPicsView.mas_bottom).offset(retweetStatusViewModel.status.pic_urls.count ? margin : 0);
        
    }];
    
}



#pragma mark - getter

- (YYLabel *)retweetContentLabel
{
    if(_retweetContentLabel == nil)
    {
        YYLabel *textPostLabel = [[YYLabel alloc] init];
        [self addSubview:textPostLabel];
        _retweetContentLabel = textPostLabel;
        
        textPostLabel.numberOfLines = 0;
        textPostLabel.textAlignment = NSTextAlignmentLeft;
        textPostLabel.preferredMaxLayoutWidth = Main_Screen_Width - 2 * margin;
        
        [textPostLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.offset(margin);
            make.right.offset(-margin);
            make.top.offset(margin);
            make.height.equalTo(20);
        }];
        
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
            
            make.size.equalTo(CGSizeMake(66, 66));
            
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
