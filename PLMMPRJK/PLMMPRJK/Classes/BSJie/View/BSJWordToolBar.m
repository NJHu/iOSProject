//
//  BSJWordToolBar.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/6/16.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "BSJWordToolBar.h"

@interface BSJWordToolBar ()

/** <#digest#> */
@property (weak, nonatomic) UIToolbar *toolBar;


/** <#digest#> */
@property (weak, nonatomic) UIView *tagsView;

/** <#digest#> */
@property (strong, nonatomic) UIButton *addTagButton;


@end

static CGFloat tagWidth = 40;
static CGFloat tagHeight = 25;

@implementation BSJWordToolBar

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
    
    [self toolBar];
    

    [self tagsView];
    
    self.backgroundColor = [UIColor greenColor];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
}






#pragma mark - getter

- (UIToolbar *)toolBar
{
    if(_toolBar == nil)
    {
        UIToolbar *toolBar = [[UIToolbar alloc] init];
        [self addSubview:toolBar];
        _toolBar = toolBar;
        toolBar.translucent = NO;
        UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"comment_bar_at_icon"] style:UIBarButtonItemStyleDone target:self action:@selector(at:)];
        
        UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"post-#"] style:UIBarButtonItemStyleDone target:self action:@selector(talk:)];
        
        toolBar.items = @[item1, item2];
        
        [toolBar mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.right.bottom.offset(0);
            make.height.equalTo(@40);
            
        }];
        
    }
    return _toolBar;
}




- (UIView *)tagsView
{
    if(_tagsView == nil)
    {
        UIView *tagsView = [[UIView alloc] initWithFrame:CGRectMake(5, 0, YYScreenSize().width - 10, 60)];
        [self addSubview:tagsView];
        _tagsView = tagsView;
        tagsView.backgroundColor = [UIColor orangeColor];
        
    }
    return _tagsView;
}

//40 25
- (UIButton *)addTagButton
{
    if(_addTagButton == nil)
    {
        
        UIButton *addTagButton = [[UIButton alloc] init];
        addTagButton.lmj_size = CGSizeMake(40, 25);
        [addTagButton setImage:[UIImage imageNamed:@"tag_add_icon"] forState:UIControlStateNormal];
        [addTagButton addTarget:self action:@selector(addMoreTags:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _addTagButton;
}

#pragma mark - action

- (void)at:(UIBarButtonItem *)item
{
    NSLog(@"%s", __func__);
    
}
- (void)talk:(UIBarButtonItem *)item
{
    NSLog(@"%s", __func__);
}

- (void)addMoreTags:(UIButton *)button
{
    
    
}


@end
