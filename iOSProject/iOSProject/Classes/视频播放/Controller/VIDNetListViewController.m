//
//  VIDNetListViewController.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/9/22.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "VIDNetListViewController.h"
#import "VIDMoviePlayerViewController.h"
#import <ZFPlayer.h>
#import <ZFDownloadManager.h>


@interface VIDNetListViewController ()

@end

@implementation VIDNetListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"网络列表视频";
    
    NSArray<NSString *> *urls = @[
                        @"http://120.25.226.186:32812/resources/videos/minion_01.mp4",
                        @"http://120.25.226.186:32812/resources/videos/minion_02.mp4",
                        @"http://120.25.226.186:32812/resources/videos/minion_03.mp4",
                        @"http://120.25.226.186:32812/resources/videos/minion_04.mp4",
                        @"http://120.25.226.186:32812/resources/videos/minion_05.mp4",
                        @"http://120.25.226.186:32812/resources/videos/minion_06.mp4",
                        @"http://120.25.226.186:32812/resources/videos/minion_07.mp4",
                        @"http://120.25.226.186:32812/resources/videos/minion_08.mp4",
                        @"http://120.25.226.186:32812/resources/videos/minion_09.mp4",
                        @"http://120.25.226.186:32812/resources/videos/minion_10.mp4"
                        ];
    NSMutableArray<LMJWordArrowItem *> *items = [NSMutableArray array];
    
    [urls enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        LMJWordArrowItem *item = [LMJWordArrowItem itemWithTitle:obj subTitle:nil];
        [items addObject:item];
    }];
    
    LMJItemSection *secion0 = [LMJItemSection sectionWithItems:items andHeaderTitle:nil footerTitle:nil];
    
    [self.sections addObject:secion0];
    
    
    UIEdgeInsets insets = self.tableView.contentInset;
    insets.bottom += self.tabBarController.tabBar.lmj_height;
    self.tableView.contentInset = insets;
    
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    LMJWordItem *item = self.sections[indexPath.section].items[indexPath.row];
    
    VIDMoviePlayerViewController *playerVc = [[VIDMoviePlayerViewController alloc] init];
    playerVc.videoURL = item.title.copy;
    [self.navigationController pushViewController:playerVc animated:YES];
    
    
}

@end
