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
#import "LMJSettingCell.h"

@interface LMJRunLoopViewController ()

@property (nonatomic, strong) NSMutableDictionary<id, NSTimer *> *timers;

@property (nonatomic, strong) NSMutableDictionary<id, NSThread *> *threads;

@property (nonatomic, assign) CFRunLoopObserverRef observer;
@end

@implementation LMJRunLoopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _timers = [NSMutableDictionary dictionary];
    _threads = [NSMutableDictionary dictionary];
    
    LMJWeak(self);
    self.addItem([LMJWordItem itemWithTitle:@"定时器和\"主\"RunLoop" subTitle:@"定时器为什么走?" itemOperation:^(NSIndexPath *indexPath) {
        // 如果有就取消定时器
        if (weakself.timers[indexPath]) {
            [weakself.timers[indexPath] invalidate];
            weakself.timers[indexPath] = nil;
            return ;
        }
        // 调用了scheduledTimer返回的定时器，已经自动被添加到当前runLoop中，而且是NSDefaultRunLoopMode
        //        定时器只运行在NSDefaultRunLoopMode下，一旦RunLoop进入其他模式，这个定时器就不会工作
        //        定时器只运行在UITrackingRunLoopMode下，一旦RunLoop进入其他模式，这个定时器就不会工作
        weakself.timers[indexPath] = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
            NSLog(@"%@", timer);
        }];
        
        // 修改模式
        // 标记为common modes的模式：UITrackingRunLoopMode和NSDefaultRunLoopMode
        [[NSRunLoop currentRunLoop] addTimer:weakself.timers[indexPath] forMode:NSRunLoopCommonModes];
        
    }])
    .addItem([LMJWordItem itemWithTitle:@"定时器和\"子线程\"RunLoop" subTitle:@"定时器为什么\"不走\"了?" itemOperation:^(NSIndexPath *indexPath) {
        // 如果有就取消定时器
        if (weakself.threads[indexPath]) {
            [weakself.timers[indexPath] invalidate];
            [weakself.threads[indexPath] cancel];
            weakself.threads[indexPath] = nil;
            weakself.timers[indexPath] = nil;
            return ;
        }
        
        // 子线程添加定时器
        weakself.threads[indexPath] = [[NSThread alloc] initWithBlock:^{
            
            weakself.timers[indexPath] = [NSTimer timerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
                NSLog(@"%@", timer);
            }];
            
            [[NSRunLoop currentRunLoop] addTimer:weakself.timers[indexPath] forMode:NSRunLoopCommonModes];
        }];
        
        [weakself.threads[indexPath] start];
        
    }])
    .addItem([LMJWordItem itemWithTitle:@"定时器和\"子线程\"RunLoop" subTitle:@"定时器为什么\"走\"了?" itemOperation:^(NSIndexPath *indexPath) {
        // 如果有就取消定时器
        if (weakself.threads[indexPath]) {
            [weakself.timers[indexPath] invalidate];
            [weakself.threads[indexPath] cancel];
            weakself.threads[indexPath] = nil;
            weakself.timers[indexPath] = nil;
            return ;
        }
        
        // 子线程添加定时器
        weakself.threads[indexPath] = [[NSThread alloc] initWithBlock:^{
            
            weakself.timers[indexPath] = [NSTimer timerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
                NSLog(@"%@", timer);
            }];
            
            // 添加 Timer, 开启 RunLoop
            [[NSRunLoop currentRunLoop] addTimer:weakself.timers[indexPath] forMode:NSDefaultRunLoopMode];
            // 或者添加 NSPort, 开启 RunLoop
            // [[NSRunLoop currentRunLoop] addPort:[NSPort port] forMode:NSRunLoopCommonModes];
            
            
            // 开始运行循环
            [[NSRunLoop currentRunLoop] run];
            
        }];
        
        [weakself.threads[indexPath] start];
        
    }])
    .addItem([LMJWordItem itemWithTitle:@"子线程执行任务" subTitle:@"为什么不能执行?" itemOperation:^(NSIndexPath *indexPath) {
        // 如果有
        if (weakself.threads[indexPath]) {
            // 子线程执行任务
            [weakself performSelector:@selector(log:) onThread:weakself.threads[indexPath] withObject:weakself.threads[indexPath] waitUntilDone:NO];
            return ;
        }
        
        weakself.threads[indexPath] = [[NSThread alloc] initWithBlock:^{
            NSLog(@"start");
        }];
        [weakself.threads[indexPath] start];
        
        [weakself performSelector:@selector(log:) onThread:weakself.threads[indexPath] withObject:weakself.threads[indexPath] waitUntilDone:NO];
        
    }])
    .addItem([LMJWordItem itemWithTitle:@"子线程执行任务" subTitle:@"为什么能执行任务?" itemOperation:^(NSIndexPath *indexPath) {
        // 如果有
        if (weakself.threads[indexPath]) {
            // 子线程执行任务
            [weakself performSelector:@selector(log:) onThread:weakself.threads[indexPath] withObject:weakself.threads[indexPath] waitUntilDone:NO];
            return ;
        }
        
        weakself.threads[indexPath] = [[NSThread alloc] initWithBlock:^{
            NSLog(@"start");
            // 添加 port 或者 timer
            [[NSRunLoop currentRunLoop] addPort:[NSPort port] forMode:NSRunLoopCommonModes];
            [[NSRunLoop currentRunLoop] run];
        }];
        [weakself.threads[indexPath] start];
        
        [weakself performSelector:@selector(log:) onThread:weakself.threads[indexPath] withObject:weakself.threads[indexPath] waitUntilDone:NO];
    }])
    .addItem([LMJWordItem itemWithTitle:@"RunLoop观察者" subTitle:@"" itemOperation:^(NSIndexPath *indexPath) {
        
        // 如果有
        if (weakself.threads[indexPath]) {
            //            [weakself.threads[indexPath] cancel];
            //            weakself.threads[indexPath] = nil;
            //            CFRunLoopObserverInvalidate(observer);
            //            observer = nil;
            // 子线程执行任务
            [weakself performSelector:@selector(log:) onThread:weakself.threads[indexPath] withObject:weakself.threads[indexPath] waitUntilDone:NO];
            return ;
        }
        
        weakself.threads[indexPath] = [[NSThread alloc] initWithBlock:^{
            
            NSLog(@"start");
            
          CFRunLoopObserverRef  observer = CFRunLoopObserverCreateWithHandler(CFAllocatorGetDefault(), kCFRunLoopAllActivities, YES, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
                //                kCFRunLoopEntry = (1UL << 0),
                //                kCFRunLoopBeforeTimers = (1UL << 1),
                //                kCFRunLoopBeforeSources = (1UL << 2),
                //                kCFRunLoopBeforeWaiting = (1UL << 5),
                //                kCFRunLoopAfterWaiting = (1UL << 6),
                //                kCFRunLoopExit = (1UL << 7),
                //                kCFRunLoopAllActivities = 0x0FFFFFFFU
                NSLog(@"----%lu", activity);
            });
            
            CFRunLoopAddObserver(CFRunLoopGetCurrent(), observer, kCFRunLoopCommonModes);
            CFRelease(observer);
            // 添加 port 或者 timer
            [[NSRunLoop currentRunLoop] addPort:[NSPort port] forMode:NSRunLoopCommonModes];
            [[NSRunLoop currentRunLoop] run];
        }];
        [weakself.threads[indexPath] start];
    }]);
    
    LMJWordItem *item = [LMJWordItem itemWithTitle:@"恢复所有的初始化" subTitle:@"取消定时器和线程" itemOperation:^(NSIndexPath *indexPath) {
        
        [weakself.timers enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, NSTimer * _Nonnull obj, BOOL * _Nonnull stop) {
            [obj invalidate];
        }];
        
        [weakself.threads enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, NSThread * _Nonnull obj, BOOL * _Nonnull stop) {
            [obj cancel];
        }];
        
        weakself.observer = nil;
        [weakself.timers removeAllObjects];
        [weakself.threads removeAllObjects];
    }];
    
    item.titleColor = [UIColor redColor];
    item.subTitleColor = [UIColor greenColor];
    
    [self.sections.firstObject.items addObject:item];
}

- (void)log:(id)obj
{
    NSLog(@"%@", obj);
}


#pragma mark - null
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
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

@end
