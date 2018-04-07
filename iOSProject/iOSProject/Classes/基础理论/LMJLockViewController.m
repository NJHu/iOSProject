//
//  LMJLockViewController.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/4/14.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJLockViewController.h"

@interface LMJLockViewController ()
// 安全
@property (strong, atomic) NSLock *mylock;
/** 售票员01 */
@property (nonatomic, strong) NSThread *thread01;
/** 售票员02 */
@property (nonatomic, strong) NSThread *thread02;
/** 售票员03 */
@property (nonatomic, strong) NSThread *thread03;

/** 票的总数 */
@property (nonatomic, assign) NSInteger ticketCount;

/** 操作类型 */
@property (nonatomic, copy) NSString *actionType;

@end

@implementation LMJLockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    LMJWeak(self);
    //初始化锁对象
    self.mylock = [[NSLock alloc]init];
    
    self.addItem([LMJWordItem itemWithTitle:@"第一种情况" subTitle:@"空" itemOperation:^(NSIndexPath *indexPath) {
        weakself.actionType = nil;
        [weakself startSale];
    }])
    .addItem([LMJWordItem itemWithTitle:@"第二种情况" subTitle:@"NSLock" itemOperation:^(NSIndexPath *indexPath) {
        weakself.actionType = @"NSLock";
        [weakself startSale];
    }])
    
    .addItem([LMJWordItem itemWithTitle:@"第三种情况" subTitle:@"@synchronized" itemOperation:^(NSIndexPath *indexPath) {
        weakself.actionType = @"@synchronized";
        [weakself startSale];
    }]);
}

- (void)startSale
{
    self.ticketCount = 100;
    
    self.thread01 = [[NSThread alloc] initWithTarget:self selector:@selector(saleTicket) object:nil];
    self.thread01.name = @"售票员01";
    
    self.thread02 = [[NSThread alloc] initWithTarget:self selector:@selector(saleTicket) object:nil];
    self.thread02.name = @"售票员02";
    
    self.thread03 = [[NSThread alloc] initWithTarget:self selector:@selector(saleTicket) object:nil];
    self.thread03.name = @"售票员03";
    
    [self.thread01 start];
    [self.thread02 start];
    [self.thread03 start];
}

- (void)saleTicket
{
    if ([self.actionType isEqualToString:@"@synchronized"]) {
        while (1) {
            @synchronized(self) {
                // 先取出总数
                NSInteger count = self.ticketCount;
                if (count > 0) {
                    self.ticketCount = count - 1;
                    NSLog(@"%@卖了一张票，还剩下%zd张", [NSThread currentThread].name, self.ticketCount);
                } else {
                    NSLog(@"票已经卖完了");
                    break;
                }
            }
        }
    }else if ([self.actionType isEqualToString:@"NSLock"]) {
        while (1) {
            [_mylock lock];
            // 先取出总数
            NSInteger count = self.ticketCount;
            if (count > 0) {
                self.ticketCount = count - 1;
                NSLog(@"%@卖了一张票，还剩下%zd张", [NSThread currentThread].name, self.ticketCount);
            } else {
                NSLog(@"票已经卖完了");
                break;
            }
            [_mylock unlock];
        }
    }else {
        while (1) {
            // 先取出总数
            NSInteger count = self.ticketCount;
            if (count > 0) {
                self.ticketCount = count - 1;
                NSLog(@"%@卖了一张票，还剩下%zd张", [NSThread currentThread].name, self.ticketCount);
            } else {
                NSLog(@"票已经卖完了");
                break;
            }
        }
    }
}

- (void)dealloc {
    [_thread01 cancel];
    [_thread02 cancel];
    [_thread03 cancel];
    _thread01 = nil;
    _thread02 = nil;
    _thread03 = nil;
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

//@synchronized跟NSLock区别 （NSLock性能上优于synchronized）
//synchronized会创建一个异常捕获handler和一些内部的锁。所以，使用@synchronized替换普通锁的代价是，你付出更多的时间消耗。
//创建给@synchronized指令的对象是一个用来区别保护块的唯一标示符。如果你在两个不同的线程里面执行上述方法，每次在一个线程传递了一个不同的对象给anObj参数，那么每次都将会拥有它的锁，并持续处理，中间不被其他线程阻塞。然而，如果你传递的是同一个对象，那么多个线程中的一个线程会首先获得该锁，而其他线程将会被阻塞直到第一个线程完成它的临界区。
//作为一种预防措施，@synchronized块隐式的添加一个异常处理例程来保护代码。该处理例程会在异常抛出的时候自动的释放互斥锁。这意味着为了使用@synchronized指令，你必须在你的代码中启用异常处理。了如果你不想让隐式的异常处理例程带来额外的开销，你应该考虑使用锁的类。

//所有同步锁类型
//@synchronized
//NSLock
//NSCondition
//NSConditionLock
//NSRecursiveLock
//pthread_mutex_t
//OSSpinLock
//dispatch_barrier_async
//------------------------------------------------------------------------------------------
