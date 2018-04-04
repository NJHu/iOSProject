//
//  LMJCuteFlowLayoutViewController.m
//  iOSProject
//
//  Created by HuXuPeng on 2018/3/18.
//  Copyright © 2018年 github.com/njhu. All rights reserved.
//

#import "LMJCuteFlowLayoutViewController.h"
#import "LMJGirdLayout.h"
#import "LMJCircleLayout.h"
#import "LMJLineFlowLayout.h"

@interface LMJCuteFlowLayoutViewController ()<LMJCircleLayoutDelegate>
@property (nonatomic, strong) NSMutableArray<UIImage *> *images;
@end

@implementation LMJCuteFlowLayoutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.fd_interactivePopDisabled = YES;
    UICollectionViewLayout *lineFlowLayout = [[LMJCircleLayout alloc] init];
    self.collectionView.collectionViewLayout = lineFlowLayout;
    self.collectionView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight * 0.8);
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"点我切换布局";
    label.textColor = [UIColor blackColor];
    label.font = [UIFont boldSystemFontOfSize:30];
    [self.view addSubview:label];
    [label sizeToFit];
    label.textAlignment = NSTextAlignmentCenter;
    label.frame = CGRectMake(0, CGRectGetMaxY(self.collectionView.frame) + 10, kScreenWidth, label.height);
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    if([self.collectionView.collectionViewLayout isKindOfClass:[LMJGirdLayout class]])
    {
        LMJLineFlowLayout *lineLayout = [[LMJLineFlowLayout alloc] init];
        lineLayout.itemSize = CGSizeMake(100, 100);
        [self.collectionView setCollectionViewLayout:lineLayout  animated:YES];
        
    }else if ([self.collectionView.collectionViewLayout isKindOfClass:[LMJCircleLayout class]])
    {
        LMJGirdLayout *gird = [[LMJGirdLayout alloc] init];
        [self.collectionView setCollectionViewLayout:gird animated:YES];
        
    } else {
        
        [self.collectionView setCollectionViewLayout:[[LMJCircleLayout alloc] initWithDelegate:self] animated:YES];
        
    }
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.images.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell" forIndexPath:indexPath];
    
    cell.contentView.layer.contents = (id)self.images[indexPath.item].CGImage;
    
    cell.contentView.layer.borderColor = [UIColor whiteColor].CGColor;
    cell.contentView.layer.borderWidth = 5;
    
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.images removeObjectAtIndex:indexPath.item];
    [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
}

- (NSMutableArray *)images
{
    if(_images == nil)
    {
        _images = [NSMutableArray array];
        
        for (NSInteger i = 1; i < 21; i++) {
            
            [_images addObject:[UIImage imageNamed:[NSString stringWithFormat:@"%zd", i]]];
        }
    }
    return _images;
}


#pragma mark - LMJCircleLayoutDelegate
-(CGFloat)circleLayout:(LMJCircleLayout *)circleLayout collectionView:(UICollectionView *)collectionView radiusForItemAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}
- (CGSize)circleLayout:(LMJCircleLayout *)circleLayout collectionView:(UICollectionView *)collectionView sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(62, 62);
}


#pragma mark - LMJNavUIBaseViewControllerDataSource

/** 导航条左边的按钮 */
- (UIImage *)lmjNavigationBarLeftButtonImage:(UIButton *)leftButton navigationBar:(LMJNavigationBar *)navigationBar
{
    [leftButton setImage:[UIImage imageNamed:@"NavgationBar_white_back"] forState:UIControlStateHighlighted];
    
    return [UIImage imageNamed:@"NavgationBar_blue_back"];
}

#pragma mark - LMJNavUIBaseViewControllerDelegate
/** 左边的按钮的点击 */
-(void)leftButtonEvent:(UIButton *)sender navigationBar:(LMJNavigationBar *)navigationBar
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
