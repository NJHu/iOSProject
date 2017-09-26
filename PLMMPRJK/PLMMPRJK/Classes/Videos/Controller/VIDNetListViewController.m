//
//  VIDNetListViewController.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/9/22.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "VIDNetListViewController.h"
#import "VIDMoviePlayerViewController.h"


@interface VIDNetListViewController ()

@end

@implementation VIDNetListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"网络列表视频";
    
    NSArray<NSString *> *urls = @[
                        @"http://7xqhmn.media1.z0.glb.clouddn.com/femorning-20161106.mp4",
                        @"http://wvideo.spriteapp.cn/video/2016/0328/56f8ec01d9bfe_wpd.mp4",
                        @"http://baobab.wdjcdn.com/1456117847747a_x264.mp4",
                        @"http://baobab.wdjcdn.com/14525705791193.mp4",
                        @"http://baobab.wdjcdn.com/1456459181808howtoloseweight_x264.mp4",
                        @"http://baobab.wdjcdn.com/1455968234865481297704.mp4",
                        @"http://baobab.wdjcdn.com/1455782903700jy.mp4",
                        @"http://baobab.wdjcdn.com/14564977406580.mp4",
                        @"http://baobab.wdjcdn.com/1456316686552The.mp4",
                        @"http://baobab.wdjcdn.com/1456480115661mtl.mp4",
                        @"http://baobab.wdjcdn.com/1456665467509qingshu.mp4",
                        @"http://baobab.wdjcdn.com/1455614108256t(2).mp4",
                        @"http://baobab.wdjcdn.com/1456317490140jiyiyuetai_x264.mp4",
                        @"http://baobab.wdjcdn.com/1455888619273255747085_x264.mp4",
                        @"http://baobab.wdjcdn.com/1456734464766B(13).mp4",
                        @"http://baobab.wdjcdn.com/1456653443902B.mp4",
                        @"http://baobab.wdjcdn.com/1456231710844S(24).mp4"];
    
    NSMutableArray<LMJWordArrowItem *> *items = [NSMutableArray array];
    
    [urls enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        LMJWordArrowItem *item = [LMJWordArrowItem itemWithTitle:[NSString stringWithFormat:@"%zd, %@", idx, [obj.lastPathComponent substringToIndex:14]] subTitle:obj];
        [items addObject:item];
    }];
    
    LMJItemSection *secion0 = [LMJItemSection sectionWithItems:items andHeaderTitle:nil footerTitle:nil];
    
    [self.sections addObject:secion0];
    
    
    UIEdgeInsets insets = self.tableView.contentInset;
    insets.bottom += 49;
    self.tableView.contentInset = insets;
    
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    LMJWordItem *item = self.sections[indexPath.section].items[indexPath.row];
    
    VIDMoviePlayerViewController *playerVc = [[VIDMoviePlayerViewController alloc] init];
    playerVc.videoURL = item.subTitle.copy;
    [self.navigationController pushViewController:playerVc animated:YES];
    
    
}

@end
