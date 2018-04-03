//
//  LMJAnimationNavBarViewController.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/4/18.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJAnimationNavBarViewController.h"

@interface LMJAnimationNavBarViewController ()

/** <#digest#> */
@property (assign, nonatomic) UIControlState isColorChange;

@end

@implementation LMJAnimationNavBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isColorChange = YES;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self scrollViewDidScroll:self.tableView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    
    if (_isColorChange) {
        CGFloat contentOffsetY = self.tableView.contentOffset.y + self.tableView.contentInset.top;
        
        if (contentOffsetY == 0) {
            
            [UIView animateWithDuration:0.2 animations:^{
            self.lmj_navgationBar.transform = CGAffineTransformMakeTranslation(0, 0);
            }];
            self.lmj_navgationBar.backgroundColor = [UIColor clearColor];
            self.lmj_navgationBar.lmj_height = [self lmjNavigationHeight:nil];
            
        }else if (contentOffsetY < 0)
        {
            [UIView animateWithDuration:0.2 animations:^{
                self.lmj_navgationBar.transform = CGAffineTransformMakeTranslation(0, -[self lmjNavigationHeight:nil]);
            }];
        }else
        {
            [UIView animateWithDuration:0.2 animations:^{
            self.lmj_navgationBar.transform = CGAffineTransformMakeTranslation(0, 0);
            }];
            
            UIColor *redColor = [self lmjNavigationBackgroundColor:nil];
            
            redColor = [redColor colorWithAlphaComponent:(contentOffsetY/ (([self lmjNavigationHeight:nil] + CGRectGetHeight([UIApplication sharedApplication].statusBarFrame)) * 2.0 * 0.63))];
            
            self.lmj_navgationBar.lmj_height = [self lmjNavigationHeight:nil];
            
            self.lmj_navgationBar.backgroundColor = redColor;
        }
    }
    
    
    if (!_isColorChange) {
        
        self.lmj_navgationBar.backgroundColor = [self lmjNavigationBackgroundColor:self.lmj_navgationBar];
        
        CGFloat contentOffsetY = self.tableView.contentOffset.y + self.tableView.contentInset.top;
        
        CGFloat scale = (contentOffsetY / (([self lmjNavigationHeight:nil] + CGRectGetHeight([UIApplication sharedApplication].statusBarFrame)) * 2.0 * 0.63));
        
        if (scale > 2) {
            scale = 2;
        }
        
        if (scale < 1) {
            scale = 1;
        }
        
        self.lmj_navgationBar.lmj_height = [self lmjNavigationHeight:self.lmj_navgationBar] * scale;
        
    }
    
    
}


#pragma mark 重写BaseViewController设置内容

- (UIColor *)lmjNavigationBackgroundColor:(LMJNavigationBar *)navigationBar
{
    return [[UIColor purpleColor] colorWithAlphaComponent:0.63];
}

- (BOOL)lmjNavigationIsHideBottomLine:(LMJNavigationBar *)navigationBar
{
    return YES;
}

- (void)leftButtonEvent:(UIButton *)sender navigationBar:(LMJNavigationBar *)navigationBar
{
    NSLog(@"%s", __func__);
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightButtonEvent:(UIButton *)sender navigationBar:(LMJNavigationBar *)navigationBar
{
    sender.selected = !sender.isSelected;
    NSLog(@"%s", __func__);
    self.isColorChange = !sender.selected;
}

- (void)titleClickEvent:(UILabel *)sender navigationBar:(LMJNavigationBar *)navigationBar
{
    NSLog(@"%@", sender);
}

- (NSMutableAttributedString*)lmjNavigationBarTitle:(LMJNavigationBar *)navigationBar
{
    return [self changeTitle:@"导航条颜色或者高度渐变"];;
}

- (UIImage *)lmjNavigationBarLeftButtonImage:(UIButton *)leftButton navigationBar:(LMJNavigationBar *)navigationBar
{
    [leftButton setImage:[UIImage imageNamed:@"navigationButtonReturn"] forState:UIControlStateHighlighted];
    
    return [UIImage imageNamed:@"navigationButtonReturnClick"];
}


- (UIImage *)lmjNavigationBarRightButtonImage:(UIButton *)rightButton navigationBar:(LMJNavigationBar *)navigationBar
{
    UIButton *btn = rightButton;
    btn.backgroundColor = [UIColor RandomColor];
    
    [btn setTitle:@"颜色渐变" forState:UIControlStateNormal];
    
    [btn setTitle:@"高度渐变" forState:UIControlStateSelected];
    [btn sizeToFit];
    
    btn.lmj_height = 44.0;
    
    return nil;
}



#pragma mark 自定义代码

-(NSMutableAttributedString *)changeTitle:(NSString *)curTitle
{
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:curTitle ?: @""];
    
    [title addAttribute:NSForegroundColorAttributeName value:[UIColor RandomColor] range:NSMakeRange(0, title.length)];
    
    [title addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, title.length)];
    
    return title;
}


#pragma mark - delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 100;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%zd", indexPath.row];
    
    return cell;
    
}


@end
