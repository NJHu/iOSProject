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

/** <#digest#> */
@property (nonatomic, strong) NSMutableArray<UIView *> *tagLabels;

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
    
    self.tagTitles = [NSMutableArray arrayWithArray:@[@"段子", @"糗事"]];
}




#pragma mark - setter
- (void)setTagTitles:(NSMutableArray<NSString *> *)tagTitles
{
    _tagTitles = tagTitles;
    
    
    [self.tagLabels removeAllObjects];
    [self.tagsView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [tagTitles enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UILabel *tagLabel = [[UILabel alloc] init];
        [self.tagsView addSubview:tagLabel];
        [self.tagLabels addObject:tagLabel];
        tagLabel.text = obj.copy;
        tagLabel.lmj_size = CGSizeMake(tagWidth, tagHeight);
        tagLabel.backgroundColor = [UIColor blueColor];
        tagLabel.textColor = [UIColor whiteColor];
        tagLabel.font = [UIFont systemFontOfSize:14];
        tagLabel.textAlignment = NSTextAlignmentCenter;
        
    }];
    
    
    [self.tagsView addSubview:self.addTagButton];
    [self.tagLabels addObject:self.addTagButton];
    
    [self layoutIfNeeded];
    
    
}


#pragma mark - 计算
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat colMargin = 10;
    CGFloat lineMargin = 10;
    CGFloat tagViewWidth = self.tagsView.lmj_width;
    
    
    __block UIView *lastView = nil;
    [self.tagLabels enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        
        if (idx == 0) {
            
            obj.lmj_origin = CGPointMake(0, 0);
            
        }else
        {
            CGFloat leftWidth = tagViewWidth - CGRectGetMaxX(lastView.frame) - colMargin;
            
            if (leftWidth >= obj.lmj_width) {
                
                obj.lmj_origin = CGPointMake(CGRectGetMaxX(lastView.frame) + colMargin, lastView.lmj_y);
                
            }else
            {
                obj.lmj_origin = CGPointMake(0, CGRectGetMaxY(lastView.frame) + lineMargin);
            }
            
        }
        
        lastView = obj;
        
    }];
    
    self.tagsView.lmj_height = CGRectGetMaxY(self.tagLabels.lastObject.frame) + 35;
    
    self.lmj_height = self.tagsView.lmj_height + self.toolBar.lmj_height;
    
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
        _addTagButton = addTagButton;
        
        addTagButton.lmj_size = CGSizeMake(tagWidth, tagHeight);
        [addTagButton setImage:[UIImage imageNamed:@"tag_add_icon"] forState:UIControlStateNormal];
        [addTagButton addTarget:self action:@selector(addMoreTags:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _addTagButton;
}

- (NSMutableArray<UIView *> *)tagLabels
{
    if (!_tagLabels) {
        
        _tagLabels = [NSMutableArray array];
        
    }
    
    return _tagLabels;
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
