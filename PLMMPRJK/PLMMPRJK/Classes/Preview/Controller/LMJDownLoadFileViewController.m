//
//  LMJDownLoadFileViewController.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/4/25.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJDownLoadFileViewController.h"

@interface LMJDownLoadFileViewController ()

/** <#digest#> */
@property (weak, nonatomic) UIButton *downBtn;

/** <#digest#> */
@property (weak, nonatomic) UIButton *memoryFileBtn;

/** <#digest#> */
@property (nonatomic, strong) NSArray *addressArray;

@end

@implementation LMJDownLoadFileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.downBtn makeConstraints:^(MASConstraintMaker *make) {
       
        make.center.equalTo(self.view);
        make.size.equalTo(CGSizeMake(200, 44));
    }];
    
    
    [self.memoryFileBtn makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.offset(0);
        make.centerY.equalTo(self.view.mas_centerY).offset(100);
        make.size.equalTo(CGSizeMake(200, 44));
    }];
}


- (UIButton *)downBtn
{
    if(_downBtn == nil)
    {
        LMJWeakSelf(self);
        UIButton *btn = [[MPSolidColorButton alloc] initWithFrame:CGRectMake(0, 0, 100, 44) buttonTitle:@"下载文件点击" normalBGColor:[UIColor greenColor] selectBGColor:[UIColor lightGrayColor] normalColor:[UIColor redColor] selectColor:[UIColor whiteColor] buttonFont:SYSTEMFONT(17) cornerRadius:5 doneBlock:^(UIButton *button) {
            
            [weakself downloadFile];
            
        }];
        
        
        [self.view addSubview:btn];
        
        _downBtn = btn;
        
    }
    return _downBtn;
}


- (UIButton *)memoryFileBtn
{
    if(_memoryFileBtn == nil)
    {
        LMJWeakSelf(self);
        UIButton *btn = [[MPSolidColorButton alloc] initWithFrame:CGRectMake(0, 0, 100, 44) buttonTitle:@"加载内存文件" normalBGColor:[UIColor greenColor] selectBGColor:[UIColor lightGrayColor] normalColor:[UIColor redColor] selectColor:[UIColor whiteColor] buttonFont:SYSTEMFONT(17) cornerRadius:5 doneBlock:^(UIButton *button) {

            
            CFTimeInterval start = CFAbsoluteTimeGetCurrent();
            
            NSString *path = @"/Users/huxupeng/Demo/area.json";
            NSData *data = [NSData dataWithContentsOfFile:path];
            
            //        for (NSInteger i = 0; i < 1000; i++) {
            
            
            weakself.addressArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            
            
            //        }
            
            NSLog(@"%f", (CFAbsoluteTimeGetCurrent() - start));
            
        }];
        
        
        [self.view addSubview:btn];
        
        _memoryFileBtn = btn;
        
    }
    return _memoryFileBtn;
}

- (void)downloadFile
{
    
    LMJLogFunc;
    
    /*
     1.NSURLRequestUseProtocolCachePolicy NSURLRequest                  默认的cache policy，使用Protocol协议定义。
     2.NSURLRequestReloadIgnoringCacheData                                        忽略缓存直接从原始地址下载。
     3.NSURLRequestReturnCacheDataDontLoad                                     只使用cache数据，如果不存在cache，请求失败；用于没有建立网络连接离线模式
     4.NSURLRequestReturnCacheDataElseLoad                                     只有在cache中不存在data时才从原始地址下载。
     5.NSURLRequestReloadIgnoringLocalAndRemoteCacheData           忽略本地和远程的缓存数据，直接从原始地址下载，与NSURLRequestReloadIgnoringCacheData类似。
     6.NSURLRequestReloadRevalidatingCacheData                              :验证本地数据与远程数据是否相同，如果不同则下载远程数据，否则使用本地数据
     
     */
    
    NSString *fileDownLoadPath = @"https://s3.cn-north-1.amazonaws.com.cn/zplantest.s3.seed.meme2c.com/area/area.json";
    
    NSString *lastModified = [NSUserDefaults stringForKey:@"Last-Modified"] ?: @"";
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:fileDownLoadPath]];
//    request.cachePolicy = NSURLRequestUseProtocolCachePolicy;
//    服务器做对比, 不用重复下载
    [request setValue:lastModified forHTTPHeaderField:@"If-Modified-Since"];
    
    [request setValue:@"no-cache" forHTTPHeaderField:@"Cache-Control"];
    
    
    LMJLog(@"%@", request);
    
    [[[LMJRequestManager sharedManager] downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
        [SVProgressHUD showProgress:(downloadProgress.completedUnitCount) / (downloadProgress.totalUnitCount)];
        LMJLog(@"%lf", ((float)downloadProgress.completedUnitCount) / (downloadProgress.totalUnitCount));
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        return [NSURL fileURLWithPath:[[NSFileManager cachesPath] stringByAppendingPathComponent:[fileDownLoadPath lastPathComponent]]];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        [SVProgressHUD dismiss];
        LMJLog(@"%@", filePath);
        LMJLog(@"%@", response);
        LMJLog(@"%@", error);
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        
        NSString *lastModified = [httpResponse allHeaderFields][@"Last-Modified"];
        
        if (lastModified) {
            [NSUserDefaults setObject:lastModified forKey:@"Last-Modified"];
            
        }
        
        LMJLog(@"%@", lastModified);
        
        
    }] resume];
    
    
}



#pragma mark - LMJNavUIBaseViewControllerDataSource
//- (BOOL)navUIBaseViewControllerIsNeedNavBar:(LMJNavUIBaseViewController *)navUIBaseViewController
//{
//    return YES;
//}

/**头部标题*/
- (NSMutableAttributedString*)lmjNavigationBarTitle:(LMJNavigationBar *)navigationBar
{
    return [self changeTitle:self.title];
}

/** 背景图片 */
//- (UIImage *)lmjNavigationBarBackgroundImage:(LMJNavigationBar *)navigationBar
//{
//
//}

/** 背景色 */
//- (UIColor *)lmjNavigationBackgroundColor:(LMJNavigationBar *)navigationBar
//{
//
//}

/** 是否隐藏底部黑线 */
//- (BOOL)lmjNavigationIsHideBottomLine:(LMJNavigationBar *)navigationBar
//{
//    return NO;
//}

/** 导航条的高度 */
//- (CGFloat)lmjNavigationHeight:(LMJNavigationBar *)navigationBar
//{
//
//}


/** 导航条的左边的 view */
//- (UIView *)lmjNavigationBarLeftView:(LMJNavigationBar *)navigationBar
//{
//
//}
/** 导航条右边的 view */
//- (UIView *)lmjNavigationBarRightView:(LMJNavigationBar *)navigationBar
//{
//
//}
/** 导航条中间的 View */
//- (UIView *)lmjNavigationBarTitleView:(LMJNavigationBar *)navigationBar
//{
//
//}
/** 导航条左边的按钮 */
- (UIImage *)lmjNavigationBarLeftButtonImage:(UIButton *)leftButton navigationBar:(LMJNavigationBar *)navigationBar
{
    
    [leftButton setTitle:@"< 返回" forState:UIControlStateNormal];
    
    leftButton.width = 60;
    
    [leftButton setTitleColor:[UIColor RandomColor] forState:UIControlStateNormal];
    
    return nil;
}
/** 导航条右边的按钮 */
//- (UIImage *)lmjNavigationBarRightButtonImage:(UIButton *)rightButton navigationBar:(LMJNavigationBar *)navigationBar
//{
//
//}



#pragma mark - LMJNavUIBaseViewControllerDelegate
/** 左边的按钮的点击 */
-(void)leftButtonEvent:(UIButton *)sender navigationBar:(LMJNavigationBar *)navigationBar
{
    [self.navigationController popViewControllerAnimated:YES];
}
/** 右边的按钮的点击 */
-(void)rightButtonEvent:(UIButton *)sender navigationBar:(LMJNavigationBar *)navigationBar
{
    
}
/** 中间如果是 label 就会有点击 */
-(void)titleClickEvent:(UILabel *)sender navigationBar:(LMJNavigationBar *)navigationBar
{
    
}


#pragma mark 自定义代码

-(NSMutableAttributedString *)changeTitle:(NSString *)curTitle
{
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:curTitle];
    
    [title addAttribute:NSForegroundColorAttributeName value:HEXCOLOR(0x333333) range:NSMakeRange(0, title.length)];
    
    [title addAttribute:NSFontAttributeName value:CHINESE_SYSTEM(16) range:NSMakeRange(0, title.length)];
    
    return title;
}

@end
