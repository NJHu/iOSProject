//
//  MUSHomeListViewController.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/9/26.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "MUSHomeListViewController.h"
#import "MUSPlayingViewController.h"
#import "MUSMusicCell.h"
#import "QQMusicOperationTool.h"
#import "NeteaseMusicAPI.h"

@interface MUSHomeListViewController ()<UISearchBarDelegate>

@end

@implementation MUSHomeListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"音乐";
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"QQListBack"]];
}

- (void)dealloc {
    NSLog(@"%s", __func__);
    [[QQMusicOperationTool shareInstance] stopCurrentMusic];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return QQMusicOperationTool.shareInstance.musicMList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LMJSettingCell *cell = [MUSMusicCell cellWithTableView:tableView andCellStyle:UITableViewCellStyleSubtitle];
    
    cell.imageView.image = [UIImage imageNamed:QQMusicOperationTool.shareInstance.musicMList[indexPath.row].icon];
    
    cell.textLabel.text = QQMusicOperationTool.shareInstance.musicMList[indexPath.row].name;
    
    cell.detailTextLabel.text = QQMusicOperationTool.shareInstance.musicMList[indexPath.row].singer;
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
//    [MUSAnimationTool animate:cell type:MUSAnimationTypeTranslation];
//    [MUSAnimationTool animate:cell type:MUSAnimationTypeRotation];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MUSPlayingViewController *playVc = [[MUSPlayingViewController alloc] init];
    [QQMusicOperationTool.shareInstance playMusic:QQMusicOperationTool.shareInstance.musicMList[indexPath.row]];
    [self.navigationController pushViewController:playVc animated:YES];
}



- (void)searchMusic
{
    [self.view endEditing:YES];
    UITextField *textField = (UITextField *)self.lmj_navgationBar.titleView;
    NSString *searchMusicText = textField.text;
    
    NSLog(@"%@", searchMusicText);
    [NeteaseMusicAPI searchWithQuery:@"经典老歌" type:NMSearch_PlayList offset:0 limit:3 completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (!error) {
            NSLog(@"%@", [NSJSONSerialization JSONObjectWithData:data options:0 error:nil]);
        }
        NSLog(@"%@", response);
        NSLog(@"%@", error);
    }];
}


#pragma mark - getter


#pragma mark - 最后一个输入框点击键盘上的完成按钮时调用
- (void)textViewController:(LMJTextViewController *)textViewController inputViewDone:(id)inputView
{
    [self searchMusic];
}

#pragma mark - LMJNavUIBaseViewControllerDataSource

/** 导航条左边的按钮 */
- (UIImage *)lmjNavigationBarLeftButtonImage:(UIButton *)leftButton navigationBar:(LMJNavigationBar *)navigationBar
{
    [leftButton setImage:[UIImage imageNamed:@"NavgationBar_white_back"] forState:UIControlStateHighlighted];
    
    return [UIImage imageNamed:@"NavgationBar_blue_back"];
}

- (UIImage *)lmjNavigationBarRightButtonImage:(UIButton *)rightButton navigationBar:(LMJNavigationBar *)navigationBar
{
    [rightButton setTitle:@"搜索" forState: UIControlStateNormal];
    [rightButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    
    return nil;
}

- (UIView *)lmjNavigationBarTitleView:(LMJNavigationBar *)navigationBar
{
    UITextField *textField = [[UITextField alloc] init];
    textField.lmj_height = 34;
    textField.placeholder = @"搜索";
    textField.lmj_width = kScreenWidth * 0.6;
    textField.backgroundColor = [UIColor whiteColor];
    textField.delegate = self;
    return textField;
}

- (void)rightButtonEvent:(UIButton *)sender navigationBar:(LMJNavigationBar *)navigationBar
{
    [self searchMusic];
}

#pragma mark - LMJNavUIBaseViewControllerDelegate
/** 左边的按钮的点击 */
-(void)leftButtonEvent:(UIButton *)sender navigationBar:(LMJNavigationBar *)navigationBar
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
