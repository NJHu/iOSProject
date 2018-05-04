//
//  LMJWebImagesCacheViewController.m
//  iOSProject
//
//  Created by HuXuPeng on 2018/4/7.
//  Copyright © 2018年 github.com/njhu. All rights reserved.
//

#import "LMJWebImagesCacheViewController.h"
#import "LMJXGMVideo.h"
#import "LMJWebImageCacheCell.h"
#import "VIDMoviePlayerViewController.h"
@interface LMJWebImagesCacheViewController ()
/**网络数据*/
@property (nonatomic, strong) NSMutableArray<LMJXGMVideo *> *videos;
/**  内存缓存图片 */
@property (nonatomic, strong) NSMutableDictionary<NSString *, UIImage *> *images;
/** <#digest#> */
@property (nonatomic, strong) NSOperationQueue *queue;
/** 队列 */
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSBlockOperation *> *operations;
@end

@implementation LMJWebImagesCacheViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _images = [NSMutableDictionary dictionary];
    _queue = [[NSOperationQueue alloc] init];
    _queue.maxConcurrentOperationCount = 3;
    _operations = [NSMutableDictionary dictionary];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"LMJWebImageCacheCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"LMJWebImageCacheCell"];
    
    LMJWeak(self);
    NSDictionary *parameters = @{@"type" : @"JSON"};
    [[LMJRequestManager sharedManager] GET:[LMJXMGBaseUrl stringByAppendingPathComponent:@"video"] parameters:parameters completion:^(LMJBaseResponse *response) {
        if (!response.error && response.responseObject) {
            weakself.videos = [LMJXGMVideo mj_objectArrayWithKeyValuesArray:response.responseObject[@"videos"]];
        } else {
            [weakself.view makeToast:response.errorMsg];
            return ;
        }
        [weakself.tableView reloadData];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.videos.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LMJWebImageCacheCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LMJWebImageCacheCell"];
    LMJXGMVideo *video = self.videos[indexPath.row];
    
    __block UIImage *image = nil;
    // 1,从内存中取
    image = self.images[video.image.absoluteString];
    cell.videoImageView.image = image;
    
    if (!image) {
        cell.videoImageView.image = [UIImage imageNamed:@"empty_picture"];
        NSBlockOperation *operation = nil;
        // 对应的图片下载操作
        operation = self.operations[video.image.absoluteString];
        
        if (!operation) {
            
            operation = [NSBlockOperation blockOperationWithBlock:^{
                NSFileManager *manager = [NSFileManager defaultManager];
                // 2, 从沙盒中取
                NSString *cache = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject;
                // 创建文件夹
                if (![manager fileExistsAtPath:[cache stringByAppendingPathComponent:[NSString stringWithFormat:@"LMJWebImageCaches"]] isDirectory:nil]) {
                    [manager createDirectoryAtPath:[cache stringByAppendingPathComponent:[NSString stringWithFormat:@"LMJWebImageCaches"]] withIntermediateDirectories:YES attributes:nil error:nil];
                }
                NSString *file = [cache stringByAppendingPathComponent:[NSString stringWithFormat:@"LMJWebImageCaches/%@.png", video.image.absoluteString.md5String]];
                
                NSData *imageData = [NSData dataWithContentsOfFile:file];
                
                if (imageData) {
                    UIImage *imageDataImage = [UIImage imageWithData:imageData];
                    // 4缓存到内存
                    self.images[video.image.absoluteString] = imageDataImage;
                    
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        // 5 cell 循环利用后的图片 ID 对应
                        if ([cell.videoNameLabel.text isEqualToString:video.ID]) {
                            cell.videoImageView.image = imageDataImage;
                        }
                    }];
                    // 移除
                    self.operations[video.image.absoluteString] = nil;
                }
                
                if (!imageData) {
                    // 2下载
                    imageData = [NSData dataWithContentsOfURL:video.image];
                    
                    if (imageData) {
                        // 3缓存到沙盒
                        [imageData writeToFile:file atomically:YES];
                        
                        UIImage *imageDataImage = [UIImage imageWithData:imageData];
                        
                        // 4缓存到内存
                        self.images[video.image.absoluteString] = imageDataImage;
                        
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            // 5 cell 循环利用后的图片 ID 对应
                            if ([cell.videoNameLabel.text isEqualToString:video.ID]) {
                                cell.videoImageView.image = imageDataImage;
                            }
                        }];
                    }
                    
                    // 移除
                    self.operations[video.image.absoluteString] = nil;
                }
                
            }];
            
            // 开始
            [self.queue addOperation:operation];
            // 保存
            self.operations[video.image.absoluteString] = operation;
        }
    }
    
    cell.videoNameLabel.text = video.ID;
    cell.videoDesLabel.text = video.name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    VIDMoviePlayerViewController *playerVc = [[VIDMoviePlayerViewController alloc] init];
    playerVc.videoURL = self.videos[indexPath.row].url.absoluteString;
    
    [self.navigationController pushViewController:playerVc animated:YES];
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

@end
