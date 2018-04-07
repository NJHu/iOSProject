//
//  LMJListExpendHeaderView.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/4/30.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJListExpendHeaderView.h"
#import "LMJGroup.h"

@interface LMJListExpendHeaderView ()

/** <#digest#> */
@property (weak, nonatomic) UILabel *headerLabel;

/** <#digest#> */
@property (weak, nonatomic) UIButton *indicatorButton;

@end

@implementation LMJListExpendHeaderView

+ (instancetype)headerViewWithTableView:(UITableView *)tableView
{
    LMJListExpendHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass(self)];
    
    if (!headerView) {
        headerView = [[self alloc] initWithReuseIdentifier: NSStringFromClass(self)];
    }
    
    return headerView;
    
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    
    if (!self) {
        return self;
    }
    
    [self setupOnce];
    
    return self;
}


- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setupOnce];
}


- (void)setupOnce
{
    
    self.backgroundColor = [UIColor grayColor];
    
    [self.headerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_offset(10);
        make.top.bottom.mas_offset(0);
    }];
    
    [self.indicatorButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.top.bottom.offset(0);
        make.width.mas_equalTo(100);
    }];
}

- (UILabel *)headerLabel
{
    if(_headerLabel == nil)
    {
        UILabel *label = [[UILabel alloc] init];
        label.textColor = [UIColor blackColor];
        
        [self.contentView addSubview:label];
        
        _headerLabel = label;
    }
    return _headerLabel;
}


- (UIButton *)indicatorButton
{
    if(_indicatorButton == nil)
    {
        UIButton *btn = [[UIButton alloc] init];
        
        [btn setImage:[UIImage imageNamed:@"arrow_down_icon"] forState:UIControlStateNormal];
        
        [self.contentView addSubview:btn];
        
        LMJWeak(self);
        
        [btn addActionHandler:^(NSInteger tag) {
            
            if (weakself.selectGroup) {
                weakself.selectGroup();
            }
            
            if (weakself.group.isOpened) {
                [UIView animateWithDuration:0.3 animations:^{
                    weakself.indicatorButton.imageView.transform = CGAffineTransformIdentity;
                }];
                
            }else
            {
                [UIView animateWithDuration:0.3 animations:^{
                    weakself.indicatorButton.imageView.transform = CGAffineTransformMakeRotation(kDegreesToRadian(180.0));
                }];
            }
        }];
        
        _indicatorButton = btn;
    }
    return _indicatorButton;
}

- (void)setGroup:(LMJGroup *)group
{
    _group = group;
    
    
    self.textLabel.text = group.name;
    
    if (group.isOpened) {
        
        self.indicatorButton.imageView.transform = CGAffineTransformIdentity;
        
    }else
    {
        
        self.indicatorButton.imageView.transform = CGAffineTransformMakeRotation(kDegreesToRadian(180.0));
        
    }
}

@end
