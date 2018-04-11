//
//  SINHomeCategoryViewController.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/6/20.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "SINHomeCategoryViewController.h"

@interface SINHomeCategoryViewController ()

/** <#digest#> */
@property (nonatomic, strong) NSMutableArray<NSString *> *categorys;

/** <#digest#> */
@property (weak, nonatomic) UIImageView *backImageView;

@end

@implementation SINHomeCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self backImageView];
    self.tableView.lmj_y = 10;
    self.tableView.lmj_height = self.view.lmj_height - 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.categorys.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([UITableViewCell class])];
    }
    
    cell.textLabel.text = self.categorys[indexPath.row];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - getter

- (NSMutableArray<NSString *> *)categorys
{
    if(_categorys == nil)
    {
        NSMutableArray *array = [NSMutableArray arrayWithArray:@[@"我的", @"事实", @"美女", @"家庭", @"军事", @"其他"]];
        _categorys = array.mutableCopy;
    }
    return _categorys;
}

- (UIImageView *)backImageView
{
    if(_backImageView == nil)
    {
        UIImageView *imageView = [[UIImageView alloc] init];
        [self.view insertSubview:imageView atIndex:0];
        _backImageView = imageView;
        imageView.image = [[UIImage imageNamed:@"popover_background"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20) resizingMode:UIImageResizingModeStretch];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(-10, -10, -10, -10));
        }];
    }
    return _backImageView;
}


@end
