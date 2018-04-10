//
//  BSJMeViewController.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/5/11.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "BSJMeViewController.h"
#import "BSJMeSquare.h"
#import "BSJMeSquareCell.h"
#import "LMJWebViewController.h"

@interface BSJMeViewController ()<LMJVerticalFlowLayoutDelegate>

/** <#digest#> */
@property (nonatomic, strong) NSMutableArray<BSJMeSquare *> *meSquares;

/** <#digest#> */
@property (weak, nonatomic) LMJRequestManager *requestManager;

@end

@implementation BSJMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     UIEdgeInsets contentInset = self.collectionView.contentInset;
    contentInset.bottom += self.tabBarController.tabBar.lmj_height;
    self.collectionView.contentInset = contentInset;
    self.navigationItem.title = @"我的";
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass(BSJMeSquareCell.class) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:NSStringFromClass(BSJMeSquareCell.class)];
    [self getDatas];
}


- (void)getDatas
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"square";
    params[@"c"] = @"topic";
    
    LMJWeak(self);
    [self.requestManager GET:BSJBaiSiJieHTTPAPI parameters:params completion:^(LMJBaseResponse *response) {

        NSError *error = response.error;
        
        if (error) {
            [weakself.view makeToast:response.errorMsg];
        }
        
        [weakself.meSquares removeAllObjects];
        [weakself.meSquares addObjectsFromArray:[BSJMeSquare mj_objectArrayWithKeyValuesArray:response.responseObject[@"square_list"]]];
        [self.collectionView reloadData];
    }];
}



#pragma mark - uicollectionDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.meSquares.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BSJMeSquareCell *squareCell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(BSJMeSquareCell.class) forIndexPath:indexPath];
    squareCell.meSquare = self.meSquares[indexPath.item];
    return squareCell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%@", indexPath);
    LMJWebViewController *webVc = [[LMJWebViewController alloc] init];
    webVc.gotoURL = self.meSquares[indexPath.row].url.absoluteString;
    [self.navigationController pushViewController:webVc animated:YES];
}


#pragma mark - LMJCollectionViewControllerDataSource
// 需要返回对应的布局
- (UICollectionViewLayout *)collectionViewController:(LMJCollectionViewController *)collectionViewController layoutForCollectionView:(UICollectionView *)collectionView
{
    return [LMJVerticalFlowLayout flowLayoutWithDelegate:self];   
}


#pragma mark - LMJVerticalFlowLayoutDelegate
/**
 *  要求实现
 *
 *  @param waterflowLayout 哪个布局需要代理返回高度
 *  @param  indexPath          对应的cell, 的indexPath, 但是indexPath.section == 0
 *  @param width           layout内部计算的宽度
 *
 *  @return 需要代理高度对应的cell的高度
 */
- (CGFloat)waterflowLayout:(LMJVerticalFlowLayout *)waterflowLayout collectionView:(UICollectionView *)collectionView heightForItemAtIndexPath:(NSIndexPath *)indexPath itemWidth:(CGFloat)itemWidth
{
    
    return itemWidth * 1.3;
}

/**
 *  需要显示的列数, 默认3
 */
- (NSInteger)waterflowLayout:(LMJVerticalFlowLayout *)waterflowLayout columnsInCollectionView:(UICollectionView *)collectionView
{
    
    return 4;
}
/**
 *  列间距, 默认10
 */
- (CGFloat)waterflowLayout:(LMJVerticalFlowLayout *)waterflowLayout columnsMarginInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
/**
 *  行间距, 默认10
 */
- (CGFloat)waterflowLayout:(LMJVerticalFlowLayout *)waterflowLayout collectionView:(UICollectionView *)collectionView linesMarginForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return 1;
}

/**
 *  距离collectionView四周的间距, 默认{20, 10, 10, 10}
 */
- (UIEdgeInsets)waterflowLayout:(LMJVerticalFlowLayout *)waterflowLayout edgeInsetsInCollectionView:(UICollectionView *)collectionView
{
    return UIEdgeInsetsMake(20, 1, 20, 1);
}


#pragma mark - getter

- (NSMutableArray<BSJMeSquare *> *)meSquares
{
    if(_meSquares == nil)
    {
        _meSquares = [NSMutableArray array];
    }
    return _meSquares;
}

- (LMJRequestManager *)requestManager
{
    if(_requestManager == nil)
    {
        _requestManager = [LMJRequestManager sharedManager];
    }
    return _requestManager;
}

@end
