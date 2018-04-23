//
//  VIDListViewController.m
//  iOSProject
//
//  Created by HuXuPeng on 2018/4/22.
//  Copyright © 2018年 github.com/njhu. All rights reserved.
//

#import "VIDListViewController.h"
#import "VIDMoviePlayerViewController.h"
#import "VIDCachesTool.h"

@interface VIDListViewController ()
/** <#digest#> */
@property (nonatomic, strong) NSArray<NSString *> *videoUrlStrs;
@end

@implementation VIDListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.videoUrlStrs = @[ @"http://120.25.226.186:32812/resources/videos/minion_01.mp4",
                           @"http://120.25.226.186:32812/resources/videos/minion_02.mp4",
                           @"http://120.25.226.186:32812/resources/videos/minion_03.mp4",
                           @"http://120.25.226.186:32812/resources/videos/minion_04.mp4",
                           @"http://120.25.226.186:32812/resources/videos/minion_05.mp4",
                           @"http://120.25.226.186:32812/resources/videos/minion_06.mp4",
                           @"http://120.25.226.186:32812/resources/videos/minion_07.mp4",
                           @"http://120.25.226.186:32812/resources/videos/minion_08.mp4",
                           @"http://static.smartisanos.cn/common/video/proud-farmer.mp4"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.videoUrlStrs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *videoListCell = [tableView dequeueReusableCellWithIdentifier:@"videoListCell"];
    videoListCell.textLabel.text = self.videoUrlStrs[indexPath.row].lastPathComponent;
    videoListCell.detailTextLabel.text = self.videoUrlStrs[indexPath.row];
    return videoListCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *url = self.videoUrlStrs[indexPath.row];
    VIDMoviePlayerViewController *moviePlayerVc = [[VIDMoviePlayerViewController alloc] init];
    moviePlayerVc.videoURL = url;
    [self.navigationController pushViewController:moviePlayerVc animated:YES];
}

@end
