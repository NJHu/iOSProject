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
    self.videoUrlStrs = @[ @"http://video1.remindchat.com/20190905/1gEji0Sv/mp4/1gEji0Sv.mp4",
                         @"https://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_20mb.mp4",
                         @"http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4",
                         @"http://mirror.aarnet.edu.au/pub/TED-talks/911Mothers_2010W-480p.mp4"];
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
