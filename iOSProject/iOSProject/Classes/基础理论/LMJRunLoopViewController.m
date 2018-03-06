//
//  LMJRunLoopViewController.m
//  iOSProject
//
//  Created by HuXuPeng on 2018/2/8.
//  Copyright © 2018年 github.com/njhu. All rights reserved.
//

#import "LMJRunLoopViewController.h"
#import "LMJWebViewController.h"
#import <CoreFoundation/CoreFoundation.h>
#import "XLMJThread.h"
#import "LMJSettingCell.h"

@interface LMJRunLoopViewController ()
/** <#digest#> */
@property (nonatomic, strong) XLMJThread *xlmjThread;
/** <#digest#> */
@property (nonatomic, strong) NSMutableArray<NSTimer *> *timers;

/** <#digest#> */
@property (nonatomic, strong) NSMutableArray<NSThread *> *threads;

@end

@implementation LMJRunLoopViewController

static BOOL item01Operationed = NO;
static BOOL item02Operationed = NO;
static BOOL item1Operationed = NO;
static BOOL item3Operationed = NO;

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.title = @"看打印";
    [self.view makeToast:@"看打印"];
    LMJWeakSelf(self);
    LMJWordItem *item0 = [LMJWordItem itemWithTitle:@"线程和RunLoop" subTitle:nil];
    item0.itemOperation = ^(NSIndexPath *indexPath) {
        [weakself threadRunLoop];
    };
    
    LMJWordItem *item01 = [LMJWordItem itemWithTitle:@"子线程定时器" subTitle:@"思考定时器为什么不执行?"];
    item01.itemOperation = ^(NSIndexPath *indexPath) {
        if (item01Operationed) {
            return ;
        }
        item01Operationed = YES;
        [weakself timerOnChildThread];
    };
    
    LMJWordItem *item02 = [LMJWordItem itemWithTitle:@"子线程定时器2" subTitle:@"思考定时器为什么\"执行\"?"];
    item02.itemOperation = ^(NSIndexPath *indexPath) {
        if (item02Operationed) {
            return ;
        }
        item02Operationed = YES;
        [weakself timerOnChildThread2];
    };
    
    LMJWordItem *item1 = [LMJWordItem itemWithTitle:@"定时器和RunLoop" subTitle:nil];
    item1.itemOperation = ^(NSIndexPath *indexPath) {
        if (item1Operationed) {
            return ;
        }
        item1Operationed = YES;
        [weakself timerRunLoop];
    };
    
    
    LMJWordItem *item3 = [LMJWordItem itemWithTitle:@"1, 线程常驻:runLoop里边需要添加NSPort" subTitle:@"2, 添加runloop观察者, 请点击多次看打印"];
    item3.itemOperation = ^(NSIndexPath *indexPath) {

        if (!item3Operationed) {
            XLMJThread *thread = [[XLMJThread alloc] initWithTarget:weakself selector:@selector(liveThread) object:nil];
            weakself.xlmjThread = thread;
            [thread start];
        }
        
        item3Operationed = YES;
        // 在常驻线程执行
        [weakself performSelector:@selector(liveThreadRun) onThread:weakself.xlmjThread withObject:nil waitUntilDone:NO];
    };
    
    LMJItemSection *section0 = [LMJItemSection sectionWithItems:@[item0, item01, item02, item1, item3] andHeaderTitle:nil footerTitle:nil];
    [self.sections addObject:section0];
    
    UIButton *btn = [UIButton initWithFrame:CGRectMake(0, 0, 100, 100) buttonTitle:@"取消所有的定时器, 停止所有的线程, 恢复初始化" normalBGColor:[UIColor yellowColor] selectBGColor:[UIColor whiteColor] normalColor:[UIColor redColor] selectColor:[UIColor greenColor] buttonFont:[UIFont systemFontOfSize:16] cornerRadius:10 doneBlock:^(UIButton *btn) {
        
        [weakself cancelAndDissmissAll];
    }];
    
    btn.titleLabel.numberOfLines = 0;

    self.tableView.tableFooterView = btn;
}

- (void)liveThread
{
    // 观察当前 runloop
    [self observerRunLoop];
    
    NSLog(@"----------run--- start -%@", [NSThread currentThread]);
    // 添加 port
    [[NSRunLoop currentRunLoop] addPort:[NSPort port] forMode:NSDefaultRunLoopMode];
    
    // 跑起来
    [[NSRunLoop currentRunLoop] run];
    
    // 不会走的, 不会执行
    NSLog(@"----------run-- end --%@", [NSThread currentThread]);
    
    
}

- (void)liveThreadRun
{
    NSLog(@"----------test----%@", [NSThread currentThread]);
}


- (void)observerRunLoop
{
    /* Run Loop Observer Activities */
//    typedef CF_OPTIONS(CFOptionFlags, CFRunLoopActivity) {
//        kCFRunLoopEntry = (1UL << 0),
//        kCFRunLoopBeforeTimers = (1UL << 1),
//        kCFRunLoopBeforeSources = (1UL << 2),
//        kCFRunLoopBeforeWaiting = (1UL << 5),
//        kCFRunLoopAfterWaiting = (1UL << 6),
//        kCFRunLoopExit = (1UL << 7),
//        kCFRunLoopAllActivities = 0x0FFFFFFFU
//    };
    NSArray *arr = @[@"kCFRunLoopEntry",
                     @"kCFRunLoopBeforeTimers",
                     @"kCFRunLoopBeforeSources",
                     @"kCFRunLoopBeforeWaiting",
                     @"kCFRunLoopAfterWaiting",
                     @"kCFRunLoopExit",
                     @"kCFRunLoopAllActivities"];
    
    // 创建observer
    CFRunLoopObserverRef observerRef =CFRunLoopObserverCreateWithHandler(CFAllocatorGetDefault(), kCFRunLoopAllActivities, YES, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
        
        NSString *activityStr = nil;
        
        if (activity == kCFRunLoopEntry) {
            activityStr = arr[0];
        }
        
        if (activity == kCFRunLoopBeforeTimers) {
            activityStr = arr[1];
        }
        
        
        if (activity == kCFRunLoopBeforeSources) {
            activityStr = arr[2];
        }
        
        
        if (activity == kCFRunLoopBeforeWaiting) {
            activityStr = arr[3];
        }
        
        
        if (activity == kCFRunLoopAfterWaiting) {
            activityStr = arr[4];
        }
        
        
        if (activity == kCFRunLoopExit) {
            activityStr = arr[5];
        }
        
        
        if (activity == kCFRunLoopAllActivities) {
            activityStr = arr[6];
        }
        
        NSLog(@"----监听到RunLoop状态发生改变---%@", activityStr);
    });
    
    // 添加观察者：监听RunLoop的状态
    CFRunLoopAddObserver(CFRunLoopGetCurrent(), observerRef, kCFRunLoopDefaultMode);
    
    // 释放Observer
    CFRelease(observerRef);
    
    /*
     CF的内存管理（Core Foundation）
     1.凡是带有Create、Copy、Retain等字眼的函数，创建出来的对象，都需要在最后做一次release
     * 比如CFRunLoopObserverCreate
     2.release函数：CFRelease(对象);
     */
}

- (void)timerRunLoop
{
    // 主运行循环
    NSLog(@"--runLoop--%p", [NSRunLoop mainRunLoop]);
    
    // 调用了scheduledTimer返回的定时器，已经自动被添加到当前runLoop中，而且是NSDefaultRunLoopMode
   NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(run) userInfo:nil repeats:YES];
    [self.timers addObject:timer];
    // 修改模式
    // 定时器会跑在标记为common modes的模式下
    // 标记为common modes的模式：UITrackingRunLoopMode和kCFRunLoopDefaultMode
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)dealloc {
    [self cancelAndDissmissAll];
}

- (void)cancelAndDissmissAll
{
    [_timers makeObjectsPerformSelector:@selector(invalidate)];
    [_timers removeAllObjects];
    
    [_threads makeObjectsPerformSelector:@selector(cancel)];
    [_threads removeAllObjects];
    [_xlmjThread cancel];
    _xlmjThread = nil;
    
    item01Operationed = NO;
    item02Operationed = NO;
    item1Operationed = NO;
    item3Operationed = NO;
}

- (void)threadRunLoop
{
    // 主运行循环
    NSLog(@"--runLoop--%p", [NSRunLoop mainRunLoop]);
    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(run) object:nil];
    [self.threads addObject:thread];
    [thread start];
}

- (void)run
{
    NSLog(@"----run");
    NSLog(@"-----runLoop--%p", [NSRunLoop currentRunLoop]);
    NSLog(@"--%@---", [NSThread currentThread]);
}

- (void)timerOnChildThread2
{
    NSLog(@"-----runLoop--%p", [NSRunLoop currentRunLoop]);
    NSLog(@"--%@---", [NSThread currentThread]);
    
    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(scheduledTimer2) object:nil];
    [thread start];
    
    [self.threads addObject:thread];
}

- (void)scheduledTimer2
{
    NSLog(@"-----runLoop--%p", [NSRunLoop currentRunLoop]);
    NSLog(@"--%@---", [NSThread currentThread]);
    
    NSLog(@"----------run--- start -%@", [NSThread currentThread]);
    
    LMJWeakSelf(self);
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        [weakself run];
    }];
    [self.timers addObject:timer];
    // 添加 port
    [[NSRunLoop currentRunLoop] addPort:[NSPort port] forMode:NSDefaultRunLoopMode];
    
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
    // 跑起来
    [[NSRunLoop currentRunLoop] run];
    
    // 不会走的, 不会执行
    NSLog(@"----------run-- end --%@", [NSThread currentThread]);
}

- (void)timerOnChildThread
{
    NSLog(@"-----runLoop--%p", [NSRunLoop currentRunLoop]);
    NSLog(@"--%@---", [NSThread currentThread]);
    
    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(scheduledTimer) object:nil];
    [thread start];
    
    [self.threads addObject:thread];
}

- (void)scheduledTimer
{
    NSLog(@"-----runLoop--%p", [NSRunLoop currentRunLoop]);
    NSLog(@"--%@---", [NSThread currentThread]);
    LMJWeakSelf(self);
   NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        [weakself run];
    }];
    [self.timers addObject:timer];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}


#pragma mark - no
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView cellForRowAtIndexPath:indexPath];
    LMJWordItem *item = self.sections[indexPath.section].items[indexPath.row];
    
    LMJSettingCell *cell = [LMJSettingCell cellWithTableView:tableView andCellStyle:UITableViewCellStyleSubtitle];
    
    cell.item = item;
    
    return cell;
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

- (UIImage *)lmjNavigationBarRightButtonImage:(UIButton *)rightButton navigationBar:(LMJNavigationBar *)navigationBar {
    
    [rightButton setTitle:@"参考网页" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    rightButton.lmj_width = 100;
    
    return nil;
}

- (void)rightButtonEvent:(UIButton *)sender navigationBar:(LMJNavigationBar *)navigationBar {
    LMJWebViewController *web = [[LMJWebViewController alloc] init];
    web.gotoURL = @"https://github.com/NJHu/NJNet/blob/master/0912runloop/README.md";
    [self.navigationController pushViewController:web animated:YES];
    
}

- (NSMutableArray<NSTimer *> *)timers
{
    if(!_timers)
    {
        _timers = [NSMutableArray array];
    }
    return _timers;
}

- (NSMutableArray<NSThread *> *)threads
{
    if(!_threads)
    {
        _threads = [NSMutableArray array];
    }
    return _threads;
}

@end
