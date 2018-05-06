//
//  LMJDownLoadFileViewController.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/4/25.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJDownLoadFileViewController.h"
#import "MBProgressHUD+LMJ.h"

@interface LMJDownLoadFileViewController ()

@end

@implementation LMJDownLoadFileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    LMJWeak(self);
    self.addItem([LMJWordItem itemWithTitle:@"点击下载" subTitle:@"不会重复下载" itemOperation:^(NSIndexPath *indexPath) {
        [weakself downloadFile];
    }]);
}




- (void)downloadFile
{
    
    NSLog(@"%s", __func__);
    
    /*
     1.NSURLRequestUseProtocolCachePolicy NSURLRequest                  默认的cache policy，使用Protocol协议定义。
     2.NSURLRequestReloadIgnoringCacheData                                        忽略缓存直接从原始地址下载。
     3.NSURLRequestReturnCacheDataDontLoad                                     只使用cache数据，如果不存在cache，请求失败；用于没有建立网络连接离线模式
     4.NSURLRequestReturnCacheDataElseLoad                                     只有在cache中不存在data时才从原始地址下载。
     5.NSURLRequestReloadIgnoringLocalAndRemoteCacheData           忽略本地和远程的缓存数据，直接从原始地址下载，与NSURLRequestReloadIgnoringCacheData类似。
     6.NSURLRequestReloadRevalidatingCacheData                              :验证本地数据与远程数据是否相同，如果不同则下载远程数据，否则使用本地数据
     
     */
    
    NSString *fileDownLoadPath = @"https://s3.cn-north-1.amazonaws.com.cn/zplantest.s3.seed.meme2c.com/area/area.json";
    
    NSString *lastModified = [NSUserDefaults.standardUserDefaults stringForKey:@"areajson_Last_Modified"] ?: @"";
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:fileDownLoadPath]];
//    request.cachePolicy = NSURLRequestUseProtocolCachePolicy;
//    服务器做对比, 不用重复下载
    [request setValue:lastModified forHTTPHeaderField:@"If-Modified-Since"];
    
    [request setValue:@"no-cache" forHTTPHeaderField:@"Cache-Control"];
    
    LMJWeak(self);
    NSLog(@"%@", request);
    MBProgressHUD *hud = [MBProgressHUD showProgressToView:weakself.view Text:@"下载中"];
    [[[LMJRequestManager sharedManager] downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
        hud.progress = (downloadProgress.completedUnitCount) / (CGFloat)(downloadProgress.totalUnitCount);
        NSLog(@"%lf", ((float)downloadProgress.completedUnitCount) / (downloadProgress.totalUnitCount));
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        return [NSURL fileURLWithPath:[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:[fileDownLoadPath lastPathComponent]]];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
    
        [MBProgressHUD hideHUDForView:weakself.view animated:YES];
        NSLog(@"%@", filePath);
        NSLog(@"%@", response);
        NSLog(@"%@", error);
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        
        [self.view makeToast:[NSString stringWithFormat:@"statuscode: %zd, \n200是下载成功, 304是不用下载", httpResponse.statusCode]];
        
        NSString *lastModified = [httpResponse allHeaderFields][@"Last-Modified"];
        
        if (lastModified && !error) {
            [NSUserDefaults.standardUserDefaults setObject:lastModified forKey:@"areajson_Last_Modified"];
        }
        
        NSLog(@"%@", lastModified);
        
    }] resume];
    
    
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
