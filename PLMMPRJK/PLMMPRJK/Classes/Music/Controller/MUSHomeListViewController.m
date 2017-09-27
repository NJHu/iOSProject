//
//  MUSHomeListViewController.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/9/26.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "MUSHomeListViewController.h"
#import "MUSMusic.h"
#import "MUSMusicCell.h"
#import "MUSAnimationTool.h"

@interface MUSHomeListViewController ()
/** <#digest#> */
@property (nonatomic, strong) NSMutableArray<MUSMusic *> *musics;
@end

@implementation MUSHomeListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"音乐";
    
    self.tableView.backgroundView = [UIImageView imageViewWithImageNamed:@"QQListBack"];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.musics.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LMJSettingCell *cell = [MUSMusicCell cellWithTableView:tableView andCellStyle:UITableViewCellStyleSubtitle];
    
    cell.imageView.image = [UIImage imageNamed:self.musics[indexPath.row].icon];
    
    cell.textLabel.text = self.musics[indexPath.row].name;
    
    cell.detailTextLabel.text = self.musics[indexPath.row].singer;
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    [MUSAnimationTool animate:cell type:MUSAnimationTypeTranslation];
    [MUSAnimationTool animate:cell type:MUSAnimationTypeRotation];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - getter

- (NSMutableArray<MUSMusic *> *)musics
{
    if(_musics == nil)
    {
        _musics = [MUSMusic mj_objectArrayWithFilename:@"Musics.plist"];
    }
    return _musics;
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
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
