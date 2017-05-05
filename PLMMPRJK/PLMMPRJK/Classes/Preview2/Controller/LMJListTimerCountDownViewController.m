//
//  LMJListTimerCountDownViewController.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/5/5.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJListTimerCountDownViewController.h"
#import "LMJCountDownModel.h"
#import "LMJCountDownCell.h"

@interface LMJListTimerCountDownViewController ()

/** <#digest#> */
@property (nonatomic, strong) NSMutableArray<LMJCountDownModel *> *products;

/** <#digest#> */
@property (weak, nonatomic) NSTimer *countTimer;

@end

@implementation LMJListTimerCountDownViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    [self.tableView registerClass:[LMJCountDownCell class] forCellReuseIdentifier:NSStringFromClass([LMJCountDownCell class])];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.products.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LMJCountDownCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LMJCountDownCell class]) forIndexPath:indexPath];
    
    cell.countDownModel = self.products[indexPath.row];
    
    
    return cell;
}




- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return AdaptedHeight(50);
}





- (NSMutableArray<LMJCountDownModel *> *)products
{
    if(_products == nil)
    {
        NSMutableArray *products = [NSMutableArray array];
     
        for (NSInteger i = 0; i < 30; i++) {
            
            LMJCountDownModel *model = [LMJCountDownModel new];

            [products addObject:model];
            
            model.productName = [NSString stringWithFormat:@"产品标号%zd", i];
            
            model.date = CFAbsoluteTimeGetCurrent() + i * (10);
            
            model.pruductImage = [UIImage imageNamed:@"test_BaiDu_red"];
        }
        
        _products = products;
        
        [self startTimer];
    }
    return _products;
}

- (void)startTimer
{
    LMJWeakSelf(self);
   _countTimer = [NSTimer scheduledTimerWithTimeInterval:1 block:^{
        
        [weakself.products enumerateObjectsUsingBlock:^(LMJCountDownModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if (obj.date == CFAbsoluteTimeGetCurrent()) {
                return;
            }
            
            obj.date -= 1;
            
        }];
        
    } repeats:YES];
    

    
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

- (void)dealloc
{
    [_countTimer invalidate];
    _countTimer = nil;
}

@end
