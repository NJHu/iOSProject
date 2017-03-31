//
//  introductoryPagesView.m
//  MobileProject
//
//  Created by wujunyang on 16/7/14.
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#import "introductoryPagesView.h"

#define MainScreen_width  [UIScreen mainScreen].bounds.size.width//宽
#define MainScreen_height [UIScreen mainScreen].bounds.size.height//高

@interface introductoryPagesView()<UIScrollViewDelegate>
@property(nonatomic,strong)UIScrollView *bigScrollView;
@property(nonatomic)NSArray *imageArray;
@property(nonatomic,strong)UIPageControl *pageControl;
@end


@implementation introductoryPagesView


-(instancetype)initPagesViewWithFrame:(CGRect)frame Images:(NSArray *)images
{
    if (self = [super initWithFrame:frame]) {
        self.imageArray=images;
        [self loadPageView];
    }
    return self;
}

-(void)loadPageView
{
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, MainScreen_width, MainScreen_height)];
    
    scrollView.contentSize = CGSizeMake((_imageArray.count + 1)*MainScreen_width, MainScreen_height);
    //设置反野效果，不允许反弹，不显示水平滑动条，设置代理为自己
    scrollView.pagingEnabled = YES;//设置分页
    scrollView.bounces = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.delegate = self;
    [self addSubview:scrollView];
    _bigScrollView = scrollView;
    
    for (int i = 0; i < _imageArray.count; i++) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.frame = CGRectMake(i * MainScreen_width, 0, MainScreen_width, MainScreen_height);
        UIImage *image = [UIImage imageNamed:_imageArray[i]];
        imageView.image = image;
        
        [scrollView addSubview:imageView];
    }
    
    UIPageControl *pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(MainScreen_width/2, MainScreen_height - 60, 0, 40)];
    pageControl.numberOfPages = _imageArray.count;
    pageControl.backgroundColor = [UIColor clearColor];
    [self addSubview:pageControl];
    
    _pageControl = pageControl;
    
    //添加手势
    UITapGestureRecognizer *singleRecognizer;
    singleRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleSingleTapFrom)];
    singleRecognizer.numberOfTapsRequired = 1;
    [scrollView addGestureRecognizer:singleRecognizer];
}

-(void)handleSingleTapFrom
{
    if (_pageControl.currentPage == self.imageArray.count-1) {
        [self removeFromSuperview];
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == _bigScrollView) {
        CGPoint offSet = scrollView.contentOffset;
        _pageControl.currentPage = offSet.x/(self.bounds.size.width);//计算当前的页码
        [scrollView setContentOffset:CGPointMake(self.bounds.size.width * (_pageControl.currentPage), scrollView.contentOffset.y) animated:YES];
    }
    if (scrollView.contentOffset.x == (_imageArray.count) *MainScreen_width) {
        [self removeFromSuperview];
    }
}

@end
