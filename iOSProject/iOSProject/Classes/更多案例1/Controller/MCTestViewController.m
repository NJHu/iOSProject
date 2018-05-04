//
//  MCTestViewController.m
//  iOSProject
//
//  Created by HuXuPeng on 2018/5/3.
//  Copyright © 2018年 github.com/njhu. All rights reserved.
//

#import "MCTestViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import <NSData+YYAdd.h>
#import <NSData+ImageContentType.h>
#import "MCStudent+CoreDataClass.h"
#import "MCStudent+CoreDataProperties.h"
@interface MCTestViewController ()

@end

@implementation MCTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    LMJWeak(self);
    self.addItem([LMJWordItem itemWithTitle:@"保存图片" subTitle:@"image write" itemOperation:^(NSIndexPath *indexPath) {
        
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(100, 100), NO, 0);
        
        CGContextRef contextRef = UIGraphicsGetCurrentContext();
        UIView *redView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        redView.backgroundColor = [UIColor RandomColor];
        redView.layer.cornerRadius = 50;
        redView.layer.masksToBounds = YES;
        [redView.layer renderInContext:contextRef];
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();

        //       jpeg
        UIImageWriteToSavedPhotosAlbum(newImage, weakself, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        
        NSLog(@"%zd", [NSData sd_imageFormatForImageData:UIImageJPEGRepresentation(newImage, 1)]);
    }])
    .addItem([LMJWordItem itemWithTitle:@"保存图片" subTitle:@"data write" itemOperation:^(NSIndexPath *indexPath) {
        
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(100, 100), NO, 0);
        CGContextRef contextRef = UIGraphicsGetCurrentContext();
        UIView *redView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        redView.backgroundColor = [UIColor RandomColor];
        redView.layer.cornerRadius = 50;
        redView.layer.masksToBounds = YES;
        [redView.layer renderInContext:contextRef];
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        //      png
        NSLog(@"%zd", [NSData sd_imageFormatForImageData:UIImagePNGRepresentation(newImage)]);
    }])
    .addItem([LMJWordItem itemWithTitle:@"url" subTitle:nil itemOperation:^(NSIndexPath *indexPath) {
        
//        常见的错误是在get参数添加中文，但是没有重新编码（也叫转义），导致NSURL初始化失败
//        正确的做法是调用NSString的(NSString *)stringByAddingPercentEscapesUsingEncoding:(NSStringEncoding)encoding方法。
//        [gotoURL stringByAddingPercentEncodingWithAllowedCharacters:[[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "] invertedSet]]
        
        NSString *path = @"https://www.baidu.com/";
        NSString *path2 = @"http://fanyi.baidu.com/translate?query=#auto/zh/";
        NSString *path3 = @"http://fanyi.baidu.com/translate?query=#zh/en/测试";
        NSURL *url = [NSURL URLWithString:path];
        NSURL *url2 = [NSURL URLWithString:path2];
        NSURL *url3 = [NSURL URLWithString:[path3 stringByAddingPercentEncodingWithAllowedCharacters:[[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "] invertedSet]]];
        NSLog(@"url = %@", url);
        NSLog(@"url2 = %@", url2);
        NSLog(@"url3 = %@", url3);

    }])
    .addItem([LMJWordItem itemWithTitle:@"log" subTitle:nil itemOperation:^(NSIndexPath *indexPath) {
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSLog(@"before perform");
            // 1.
//            [weakself performSelector:@selector(printLog) withObject:nil];
            //2.
            {
                [weakself performSelector:@selector(printLog) withObject:nil afterDelay:0];
                [[NSRunLoop currentRunLoop] run];
            }
            
            //1、GCD默认的全局并发队列，在并发执行任务的时候，会从线程池获取可执行任务的线程（如果没有就阻塞）。
            
//            2、performSelector的原理是设置一个timer到当前线程Runloop，并且是NSDefaultRunLoopMode；
            
//            3、非主线程的runloop默认是不启用；
            NSLog(@"after perform");
        });
    }])
    .addItem([LMJWordItem itemWithTitle:@"coreData" subTitle:@"增加" itemOperation:^(NSIndexPath *indexPath) {
        
        
    }]).addItem([LMJWordItem itemWithTitle:@"coreData" subTitle:@"删除" itemOperation:^(NSIndexPath *indexPath) {
        
        
    }])
    .addItem([LMJWordItem itemWithTitle:@"coreData" subTitle:@"改" itemOperation:^(NSIndexPath *indexPath) {
        
        
    }])
    .addItem([LMJWordItem itemWithTitle:@"coreData" subTitle:@"查询" itemOperation:^(NSIndexPath *indexPath) {
        
        
    }]);
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    
}

- (void)printLog {
    NSLog(@"printLog");
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
