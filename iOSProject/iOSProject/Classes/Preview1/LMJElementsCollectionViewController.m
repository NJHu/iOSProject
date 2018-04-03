//
//  LMJElementsCollectionViewController.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/4/19.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJElementsCollectionViewController.h"

@interface LMJElementsCollectionViewController ()<LMJElementsFlowLayoutDelegate>

/** <#digest#> */
@property (nonatomic, strong) NSMutableArray<NSValue *> *elementsHight;


@end

@implementation LMJElementsCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.title = @"app首页布局";
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class])];
    
}



- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.elementsHight.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class]) forIndexPath:indexPath];
    
    cell.contentView.backgroundColor = [UIColor yellowColor];
    
    
    if (![cell.contentView viewWithTag:100]) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        label.tag = 100;
        label.textColor = [UIColor redColor];
        label.font = [UIFont boldSystemFontOfSize:17];
        [cell.contentView addSubview:label];
    }
    
    UILabel *label = [cell.contentView viewWithTag:100];
    
    label.text = [NSString stringWithFormat:@"%zd", indexPath.item];
    
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    NSLog(@"%zd", indexPath.item);
}

#pragma mark - LMJElementsFlowLayoutDelegate

- (CGSize)waterflowLayout:(LMJElementsFlowLayout *)waterflowLayout collectionView:(UICollectionView *)collectionView sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.elementsHight[indexPath.item].CGSizeValue;
}

- (UIEdgeInsets)waterflowLayout:(LMJElementsFlowLayout *)waterflowLayout edgeInsetsInCollectionView:(UICollectionView *)collectionView
{
    return UIEdgeInsetsMake(1, 10, 10, 10);
}



#pragma mark - LMJCollectionViewControllerDataSource

- (UICollectionViewLayout *)collectionViewController:(LMJCollectionViewController *)collectionViewController layoutForCollectionView:(UICollectionView *)collectionView
{
    LMJElementsFlowLayout *elementsFlowLayout = [[LMJElementsFlowLayout alloc] initWithDelegate:self];
    
    return elementsFlowLayout;
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
/** 导航条右边的按钮 */
- (UIImage *)lmjNavigationBarRightButtonImage:(UIButton *)rightButton navigationBar:(LMJNavigationBar *)navigationBar
{
    [rightButton setTitle:@"改变头图高度" forState:UIControlStateNormal];
    
    rightButton.lmj_width = 120;
    
    [rightButton setTitleColor:[UIColor RandomColor] forState:UIControlStateNormal];
    
    return nil;
}



#pragma mark - Delegate
/** 左边的按钮的点击 */
-(void)leftButtonEvent:(UIButton *)sender navigationBar:(LMJNavigationBar *)navigationBar
{
    [self.navigationController popViewControllerAnimated:YES];
}
/** 右边的按钮的点击 */
-(void)rightButtonEvent:(UIButton *)sender navigationBar:(LMJNavigationBar *)navigationBar
{
    [self.elementsHight replaceObjectAtIndex:0 withObject:[NSValue valueWithCGSize:CGSizeMake(([UIScreen mainScreen].bounds.size.width - 30) * 0.5, 44)]];
    
    [self.collectionView reloadData];
}


- (NSMutableArray<NSValue *> *)elementsHight
{
    if(_elementsHight == nil)
    {
        _elementsHight = [NSMutableArray array];
        
        for (NSInteger i = 0; i < 200; i++) {
            
            if (i == 0) {
                
                [_elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, 150)]];
                
            }else if (i == 1)
            {
                
                [_elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 20, 100)]];
                
            }else if (i == 2)
            {
                
                [_elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 50, 60)]];
                
            }else if (i == 3)
            {
                
                [_elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 10, 300)]];
            }else
            {
                
                [_elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(([UIScreen mainScreen].bounds.size.width - 30) * 0.5, ([UIScreen mainScreen].bounds.size.width - 30) * 0.5 * 0.8)]];
            }
            
            
            
        }
    }
    return _elementsHight;
}


@end
