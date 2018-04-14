//
//  SINHomeViewController.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/5/11.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "SINHomeViewController.h"
#import "SINHomeCategoryViewController.h"
#import "SINStatusListService.h"
#import "SINStatusViewModel.h"
#import "SINStatusCell.h"
#import "PresentAnimator.h"

@interface SINHomeViewController ()
/** 没有登录的状态 */
@property (weak, nonatomic) SINUnLoginRegisterView *unLoginRegisterView;

/** 网络数据 */
@property (nonatomic, strong) SINStatusListService *statusListService;
@end

@implementation SINHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"首页";
    UIEdgeInsets edgeInset = self.tableView.contentInset;
    edgeInset.bottom += self.tabBarController.tabBar.lmj_height;
    self.tableView.contentInset = edgeInset;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([SINUserManager sharedManager].isLogined) {
        self.tableView.hidden = NO;
        self.unLoginRegisterView.hidden = YES;
    }else {
        self.tableView.hidden = YES;
        self.unLoginRegisterView.hidden = NO;
    }
}


- (void)loadMore:(BOOL)isMore
{
    LMJWeak(self);
    if (![SINUserManager sharedManager].isLogined) {
        [weakself endHeaderFooterRefreshing];
        return;
    }
    
    [self.statusListService getStatusList:!isMore complation:^(NSError *error, BOOL isEnd) {
        [weakself endHeaderFooterRefreshing];
        if (error) {
            [weakself.view makeToast:error.localizedDescription];
            return ;
        }
        [weakself.tableView reloadData];
        [weakself.tableView.mj_footer setState:isEnd ? MJRefreshStateNoMoreData : MJRefreshStateIdle];
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.statusListService.statusViewModels.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SINStatusCell *statusCell = [SINStatusCell statusCellWithTableView:tableView];
    statusCell.statusViewModel = self.statusListService.statusViewModels[indexPath.row];
    return statusCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.statusListService.statusViewModels[indexPath.row].cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - LMJNavUIBaseViewControllerDataSource
/**头部标题*/
- (NSMutableAttributedString*)lmjNavigationBarTitle:(LMJNavigationBar *)navigationBar
{
    return [self changeTitle:[SINUserManager sharedManager].name ?: self.navigationItem.title];
}


/** 导航条左边的按钮 */
- (UIImage *)lmjNavigationBarLeftButtonImage:(UIButton *)leftButton navigationBar:(LMJNavigationBar *)navigationBar
{
    [leftButton setTitle:@"注册" forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    if ([SINUserManager sharedManager].isLogined) {
        leftButton.hidden = YES;
    }
    return nil;
}
/** 导航条右边的按钮 */
- (UIImage *)lmjNavigationBarRightButtonImage:(UIButton *)rightButton navigationBar:(LMJNavigationBar *)navigationBar
{
    [rightButton setTitle:@"登录" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    if ([SINUserManager sharedManager].isLogined) {
        rightButton.hidden = YES;
    }
    return nil;
}



#pragma mark - LMJNavUIBaseViewControllerDelegate
/** 左边的按钮的点击 */
-(void)leftButtonEvent:(UIButton *)sender navigationBar:(LMJNavigationBar *)navigationBar
{
    if (![SINUserManager sharedManager].isLogined) {
        [self gotoLogin];
    }
}

/** 右边的按钮的点击 */
-(void)rightButtonEvent:(UIButton *)sender navigationBar:(LMJNavigationBar *)navigationBar
{
    if (![SINUserManager sharedManager].isLogined) {
        [self gotoLogin];
    }
}

/** 中间如果是 label 就会有点击 */
-(void)titleClickEvent:(UILabel *)sender navigationBar:(LMJNavigationBar *)navigationBar
{
    
    NSLog(@"%s", __func__);
    SINHomeCategoryViewController *categoryVc = [[SINHomeCategoryViewController alloc] init];
    
    CGFloat width = kScreenWidth * 0.5;
    
    CGPoint center = [self.lmj_navgationBar convertPoint:self.lmj_navgationBar.titleView.center toView:[UIApplication sharedApplication].keyWindow];
    LMJWeak(categoryVc);
    
    // 写个present 动画吧
    [PresentAnimator viewController:self presentViewController:categoryVc presentViewFrame:CGRectMake((kScreenWidth - width) * 0.5, center.y + 20, width, width * 1.2) animated:YES completion:nil animatedDuration:0.5 presentAnimation:^(UIView *presentedView, UIView *containerView, void (^completionHandler)(BOOL finished)) {
        
        containerView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
        presentedView.layer.anchorPoint = CGPointMake(0.5, 0);
        presentedView.layer.transform = CATransform3DMakeScale(1, 0.1, 1);
        [UIView animateWithDuration:0.5 animations:^{
            presentedView.layer.transform = CATransform3DIdentity;
        } completion:^(BOOL finished) {
            completionHandler(finished);
        }];
        
        [containerView addTapGestureRecognizer:^(UITapGestureRecognizer *recognizer, NSString *gestureId) {
            [weakcategoryVc dismissViewControllerAnimated:YES completion:nil];
        }];
        
    } dismissAnimation:^(UIView *dismissView, void (^completionHandler)(BOOL finished)) {
        
        [UIView animateWithDuration:0.5 animations:^{
            dismissView.layer.transform = CATransform3DMakeScale(1, 0.1, 1);
        } completion:^(BOOL finished) {
            completionHandler(finished);
        }];
    }];
}



#pragma mark 自定义代码

-(NSMutableAttributedString *)changeTitle:(NSString *)curTitle
{
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:curTitle ?: @""];
    
    [title addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:253.0/255 green:108.0/255 blue:7.0/255 alpha:1] range:NSMakeRange(0, title.length)];
    
    [title addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:18] range:NSMakeRange(0, title.length)];
    
    return title;
}


#pragma mark - getter
- (void)gotoLogin
{
    LMJWeak(self);
    [[SINUserManager sharedManager] sinaLogin:^(NSError *error) {
        if (error) {
            [weakself.view makeToast:error.domain];
            return ;
        }
        
        weakself.tableView.hidden = NO;
        weakself.unLoginRegisterView.hidden = YES;
        weakself.lmj_navgationBar.leftView.hidden = YES;
        weakself.lmj_navgationBar.rightView.hidden = YES;
        [weakself changeTitle:[SINUserManager sharedManager].name];
        [weakself.tableView.mj_header beginRefreshing];
    }];
}

- (SINUnLoginRegisterView *)unLoginRegisterView
{
    if(_unLoginRegisterView == nil)
    {
        LMJWeak(self);
        SINUnLoginRegisterView *unLoginRegisterView = [SINUnLoginRegisterView unLoginRegisterViewWithType:SINUnLoginRegisterViewTypeHomePage registClick:^{
            
            [weakself gotoLogin];
            
        } loginClick:^{
            
            [weakself gotoLogin];
        }];
        
        [weakself.view addSubview:unLoginRegisterView];
        _unLoginRegisterView = unLoginRegisterView;
        
        [unLoginRegisterView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.offset(0);
        }];
    }
    return _unLoginRegisterView;
}

- (SINStatusListService *)statusListService
{
    if(_statusListService == nil)
    {
        _statusListService = [[SINStatusListService alloc] init];
    }
    return _statusListService;
}

@end
