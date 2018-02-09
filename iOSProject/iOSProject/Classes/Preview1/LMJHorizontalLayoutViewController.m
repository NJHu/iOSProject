//
//  LMJHorizontalLayoutViewController.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/4/20.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJHorizontalLayoutViewController.h"

@interface LMJHorizontalLayoutViewController ()<LMJHorizontalFlowLayoutDelegate>

@end

@implementation LMJHorizontalLayoutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.collectionView.backgroundColor = [UIColor RandomColor];
 
    self.collectionView.contentInset = UIEdgeInsetsZero;
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(UIEdgeInsetsMake(100, 20, 100, 20));
    }];
    
    
}

#pragma mark - LMJCollectionViewControllerDataSource

- (UICollectionViewLayout *)collectionViewController:(LMJCollectionViewController *)collectionViewController layoutForCollectionView:(UICollectionView *)collectionView
{
    LMJHorizontalFlowLayout *layout = [[LMJHorizontalFlowLayout alloc] initWithDelegate:self];
    
    return layout;
}


#pragma mark - LMJHorizontalFlowLayoutDelegate

- (CGFloat)waterflowLayout:(LMJHorizontalFlowLayout *)waterflowLayout collectionView:(UICollectionView *)collectionView widthForItemAtIndexPath:(NSIndexPath *)indexPath itemHeight:(CGFloat)itemHeight
{
    
    return (arc4random() % 4 + 1) * itemHeight;
}


- (NSInteger)waterflowLayout:(LMJHorizontalFlowLayout *)waterflowLayout linesInCollectionView:(UICollectionView *)collectionView
{
    return 5;
}



#pragma mark - LMJNavUIBaseViewControllerDataSource

/** 导航条左边的按钮 */
- (UIImage *)lmjNavigationBarLeftButtonImage:(UIButton *)leftButton navigationBar:(LMJNavigationBar *)navigationBar
{
    
    [leftButton setTitle:@"< 返回" forState:UIControlStateNormal];
    
    leftButton.lmj_width = 60;
    
    [leftButton setTitleColor:[UIColor RandomColor] forState:UIControlStateNormal];
    
    return nil;
}


#pragma mark - LMJNavUIBaseViewControllerDelegate
/** 左边的按钮的点击 */
-(void)leftButtonEvent:(UIButton *)sender navigationBar:(LMJNavigationBar *)navigationBar
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
