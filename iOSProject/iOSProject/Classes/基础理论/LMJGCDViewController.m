//
//  LMJGCDViewController.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/4/14.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJGCDViewController.h"

@interface LMJGCDViewController ()

/** 定时器(这里不用带*，因为dispatch_source_t就是个类，内部已经包含了*) */
@property (nonatomic, strong) dispatch_source_t timer;
@end

@implementation LMJGCDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setDes];
    
    LMJWeak(self);
    
    LMJWordItem *item0 = [LMJWordItem itemWithTitle:@"并发队列 + 同步函数" subTitle:nil];
    [item0 setItemOperation:^(NSIndexPath *indexPath) {
        [weakself syncConCurrent];
    }];
    
    LMJWordItem *item1 = [LMJWordItem itemWithTitle:@"并发队列 + 异步函数" subTitle:nil];
    [item1 setItemOperation:^(NSIndexPath *indexPath) {
        [weakself asyncConcurrent];
    }];
    
    LMJWordItem *item2 = [LMJWordItem itemWithTitle:@"串行队列 + 同步函数" subTitle:nil];
    [item2 setItemOperation:^(NSIndexPath *indexPath) {
        [weakself syncSerial];
    }];
    
    LMJWordItem *item3 = [LMJWordItem itemWithTitle:@"串行队列 + 异步函数" subTitle:nil];
    [item3 setItemOperation:^(NSIndexPath *indexPath) {
        [weakself asyncSerial];
    }];
    
    LMJWordItem *item4 = [LMJWordItem itemWithTitle:@"主队列 + 同步函数--相互等待" subTitle:@"直接闪退"];
    [item4 setItemOperation:^(NSIndexPath *indexPath) {
        [weakself syncMain];
    }];
    
    LMJWordItem *item5 = [LMJWordItem itemWithTitle:@"主队列 + 异步函数" subTitle:nil];
    [item5 setItemOperation:^(NSIndexPath *indexPath) {
        [weakself asyncMain];
    }];
    
    LMJWordItem *item6 = [LMJWordItem itemWithTitle:@"全局队列+ 异步函数" subTitle:nil];
    [item6 setItemOperation:^(NSIndexPath *indexPath) {
        [weakself asyncGloba];
    }];
    
    LMJItemSection *section0 = [LMJItemSection sectionWithItems:@[item0, item1, item2, item3, item4, item5, item6] andHeaderTitle:@"六种类型：" footerTitle:nil];
    LMJItemSection *section1 = [LMJItemSection sectionWithItems:nil andHeaderTitle:@"多种 GCD" footerTitle:nil];
    
    
    LMJWordItem *item10 = [LMJWordItem itemWithTitle:@"dispatch_barrier_async" subTitle:@"栅栏函数"];
    item10.itemOperation = ^(NSIndexPath *indexPath) {
        
        [weakself barrier];
        
    };
    
    LMJWordItem *item11 = [LMJWordItem itemWithTitle:@"dispatch_apply" subTitle:@"快速迭代"];
    item11.itemOperation = ^(NSIndexPath *indexPath) {
        [weakself apply];
    };
    
    LMJWordItem *item12 = [LMJWordItem itemWithTitle:@"dispatch_group_t" subTitle:@"队列组和线程通讯"];
    item12.itemOperation = ^(NSIndexPath *indexPath) {
        [weakself group];
    };
    
    [section1.items addObjectsFromArray:@[item10, item11, item12]];
    
    LMJWordItem *item20 = [LMJWordItem itemWithTitle:@"dispatch_source_t" subTitle:@"GCD 定时器"];
    item20.itemOperation = ^(NSIndexPath *indexPath) {
        [weakself gcdTimer];
    };
    
    [self.sections addObject:section0];
    [self.sections addObject:section1];
    [self.sections addObject:[LMJItemSection sectionWithItems:@[item20] andHeaderTitle:@"other" footerTitle:nil]];

}

int count = 0;
- (void)gcdTimer
{
    // 获得队列
    //    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_queue_t queue = dispatch_get_main_queue();
    
    // 创建一个定时器(dispatch_source_t本质还是个OC对象)
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    // 设置定时器的各种属性（几时开始任务，每隔多长时间执行一次）
    // GCD的时间参数，一般是纳秒（1秒 == 10的9次方纳秒）
    // 何时开始执行第一个任务
    // dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC) 比当前时间晚3秒
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
    uint64_t interval = (uint64_t)(1.0 * NSEC_PER_SEC);
    dispatch_source_set_timer(self.timer, start, interval, 0);
    
    // 设置回调
    dispatch_source_set_event_handler(self.timer, ^{
        NSLog(@"------------%@", [NSThread currentThread]);
        count++;
        
                if (count == 10) {
                    // 取消定时器
                    dispatch_cancel(self.timer);
                    self.timer = nil;
                }
    });
    
    // 启动定时器
    dispatch_resume(self.timer);
}

- (void)group
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    // 创建一个队列组
    dispatch_group_t group = dispatch_group_create();
    
   __block UIImage *image1 = nil;
    
    // 1.下载图片1
    dispatch_group_async(group, queue, ^{
        // 图片的网络路径
        NSURL *url = [NSURL URLWithString:@"http://img.pconline.com.cn/images/photoblog/9/9/8/1/9981681/200910/11/1255259355826.jpg"];
        
        // 加载图片
        NSData *data = [NSData dataWithContentsOfURL:url];
        
        // 生成图片
        image1 = [UIImage imageWithData:data];
    });
    
   __block UIImage *image2 = nil;
    
    // 2.下载图片2
    dispatch_group_async(group, queue, ^{
        // 图片的网络路径
        NSURL *url = [NSURL URLWithString:@"http://pic38.nipic.com/20140228/5571398_215900721128_2.jpg"];
        
        // 加载图片
        NSData *data = [NSData dataWithContentsOfURL:url];
        
        // 生成图片
        image2 = [UIImage imageWithData:data];
    });
    
    // 3.将图片1、图片2合成一张新的图片
    dispatch_group_notify(group, queue, ^{
        // 开启新的图形上下文
        UIGraphicsBeginImageContext(CGSizeMake(100, 100));
        
        // 绘制图片
        [image1 drawInRect:CGRectMake(0, 0, 50, 100)];
        [image2 drawInRect:CGRectMake(50, 0, 50, 100)];
        
        // 取得上下文中的图片
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        
        // 结束上下文
        UIGraphicsEndImageContext();
        
        // 回到主线程显示图片
        dispatch_async(dispatch_get_main_queue(), ^{
            // 4.将新图片显示出来
            UIImageView *imageV = [[UIImageView alloc] initWithImage:image];
            imageV.frame = CGRectMake(100, 100, 200, 200);
            [self.view addSubview:imageV];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [imageV removeFromSuperview];
            });
        });
    });
    
}
/*
 这个函数提交代码块到一个分发队列,以供多次调用,会等迭代其中的任务全部完成以后,才会返回.
 如果被提交的队列是并发队列,那么这个代码块必须保证每次读写的安全.
 这个函数对并行的循环 还有作用,
 
 我理解就是类似遍历一个数组一样,当提交到一个并发的队列上的时候,这个遍历是并发运行的,速度很快.
 
 */
- (void)apply
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_apply(100000, queue, ^(size_t index) {
        
        NSLog(@"%zd---%@", index, [NSThread currentThread]);
    });
}

/*
 <一>什么是dispatch_barrier_async函数
 
 毫无疑问,dispatch_barrier_async函数的作用与barrier的意思相同,在进程管理中起到一个栅栏的作用,它等待所有位于barrier函数之前的操作执行完毕后执行,并且在barrier函数执行之后,barrier函数之后的操作才会得到执行,该函数需要同dispatch_queue_create函数生成的concurrent Dispatch Queue队列一起使用
 
 <二>dispatch_barrier_async函数的作用
 
 1.实现高效率的数据库访问和文件访问
 
 2.避免数据竞争
 
 <三>dispatch_barrier_async实例
 */
- (void)barrier
{
    dispatch_queue_t queue = dispatch_queue_create("my-queue", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(queue, ^{
        
        NSLog(@"1, dispatch_async(dispatch_get_main_queue()");
    });
    
    dispatch_async(queue, ^{
        NSLog(@"2, dispatch_async(dispatch_get_global_queue(0, 0)");
    });
    
    dispatch_sync(queue, ^{
        NSLog(@"3, dispatch_sync(dispatch_get_global_queue(0, 0)");
    });
    
    dispatch_barrier_async(queue, ^(){
        NSLog(@"----barrier-----%@", [NSThread currentThread]);
    });
    
    dispatch_async(queue, ^{
        NSLog(@"4, dispatch_async(dispatch_get_global_queue(0, 0)");
    });
    
    dispatch_sync(queue, ^{
        NSLog(@"5, dispatch_sync(dispatch_get_global_queue(0, 0)");
    });
    
}

- (void)syncConCurrent
{
    NSLog(@"syncConcurrent---begin");
    
    dispatch_queue_t queue= dispatch_queue_create("test.queue", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_sync(queue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"1------%@",[NSThread currentThread]);
        }
    });
    dispatch_sync(queue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"2------%@",[NSThread currentThread]);
        }
    });
    dispatch_sync(queue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"3------%@",[NSThread currentThread]);
        }
    });
    
    
    //输出内容：
    //    syncConcurrent---begin
    //    1------<NSThread: 0x60000007a080>{number = 1, name = main}
    //    1------<NSThread: 0x60000007a080>{number = 1, name = main}
    //    2------<NSThread: 0x60000007a080>{number = 1, name = main}
    //    2------<NSThread: 0x60000007a080>{number = 1, name = main}
    //    3------<NSThread: 0x60000007a080>{number = 1, name = main}
    //    3------<NSThread: 0x60000007a080>{number = 1, name = main}
    //    syncConcurrent---end
    
    //    说明
    //    从并发队列 + 同步执行中可以看到，所有任务都是在主线程中执行的。由于只有一个线程，所以任务只能一个一个执行
    //    所有任务都在打印的syncConcurrent---begin和syncConcurrent---end之间，这说明任务是添加到队列中马上执行的
    
        NSLog(@"syncConcurrent---end");
}

- (void)asyncConcurrent
{
    NSLog(@"asyncConcurrent---begin");
    
    dispatch_queue_t queue= dispatch_queue_create("test.asyncqueue", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"1------%@",[NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"2------%@",[NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"3------%@",[NSThread currentThread]);
        }
    });
    
    NSLog(@"asyncConcurrent---end");
    
    
    //输出内容：
    //    asyncConcurrent---begin
    //    asyncConcurrent---end
    //    3------<NSThread: 0x608000474fc0>{number = 9, name = (null)}
    //    3------<NSThread: 0x608000474fc0>{number = 9, name = (null)}
    //    1------<NSThread: 0x60000007f780>{number = 10, name = (null)}
    //    1------<NSThread: 0x60000007f780>{number = 10, name = (null)}
    //    2------<NSThread: 0x600000460000>{number = 5, name = (null)}
    //    2------<NSThread: 0x600000460000>{number = 5, name = (null)}
    
    //    说明
    //    在并发队列 + 异步执行中可以看出，除了主线程，又开启了3个线程，并且任务是交替着同时执行的。
    //    所有任务是在打印的syncConcurrent---begin和syncConcurrent---end之后才开始执行的。说明任务不是马上执行，而是将所有任务添加到队列之后才开始异步执行
    
}




// 串行队列 同步执行
- (void)syncSerial
{
    NSLog(@"syncSerial---begin");
    
    dispatch_queue_t queue = dispatch_queue_create("test.syncSerial", DISPATCH_QUEUE_SERIAL);
    
    dispatch_sync(queue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"1------%@",[NSThread currentThread]);
        }
    });
    dispatch_sync(queue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"2------%@",[NSThread currentThread]);
        }
    });
    dispatch_sync(queue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"3------%@",[NSThread currentThread]);
        }
    });
    
    NSLog(@"syncSerial---end");
    
    
    //输出内容
    //    syncSerial---begin
    //    1------<NSThread: 0x608000260580>{number = 1, name = main}
    //    1------<NSThread: 0x608000260580>{number = 1, name = main}
    //    2------<NSThread: 0x608000260580>{number = 1, name = main}
    //    2------<NSThread: 0x608000260580>{number = 1, name = main}
    //    3------<NSThread: 0x608000260580>{number = 1, name = main}
    //    3------<NSThread: 0x608000260580>{number = 1, name = main}
    //    syncSerial---end
    
    //    说明
    //    所有任务都是在主线程中执行的，并没有开启新的线程。而且由于串行队列，所以按顺序一个一个执行
    //    所有任务都在打印的syncConcurrent---begin和syncConcurrent---end之间，这说明任务是添加到队列中马上执行的
    
}

// 串行队列 异步执行
- (void)asyncSerial
{
    
    NSLog(@"asyncSerial---begin");
    
    dispatch_queue_t queue = dispatch_queue_create("test.asyncSerial", DISPATCH_QUEUE_SERIAL);
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"1------%@",[NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"2------%@",[NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"3------%@",[NSThread currentThread]);
        }
    });
    
    NSLog(@"asyncSerial---end");
    
    
    //输出的内容
    //    asyncSerial---begin
    //    asyncSerial---end
    //    1------<NSThread: 0x608000663900>{number = 4, name = (null)}
    //    1------<NSThread: 0x608000663900>{number = 4, name = (null)}
    //    2------<NSThread: 0x608000663900>{number = 4, name = (null)}
    //    2------<NSThread: 0x608000663900>{number = 4, name = (null)}
    //    3------<NSThread: 0x608000663900>{number = 4, name = (null)}
    //    3------<NSThread: 0x608000663900>{number = 4, name = (null)}
    
    //    说明
    //    开启了一条新线程，但是任务还是串行，所以任务是一个一个执行
    //    所有任务是在打印的syncConcurrent---begin和syncConcurrent---end之后才开始执行的。说明任务不是马上执行，而是将所有任务添加到队列之后才开始同步执行
    
    
}

// 主队列 + 同步执行 卡死崩溃(方法等待)
- (void)syncMain
{
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    
    
    dispatch_sync(mainQueue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"1------%@",[NSThread currentThread]);
        }
    });
    dispatch_sync(mainQueue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"2------%@",[NSThread currentThread]);
        }
    });
    dispatch_sync(mainQueue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"3------%@",[NSThread currentThread]);
        }
    });
    
    NSLog(@"asyncSerial---end");
}


- (void)asyncMain
{
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    
    
    dispatch_async(mainQueue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"1------%@",[NSThread currentThread]);
        }
    });
    dispatch_async(mainQueue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"2------%@",[NSThread currentThread]);
        }
    });
    dispatch_async(mainQueue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"3------%@",[NSThread currentThread]);
        }
    });
    
    NSLog(@"asyncSerial---end");
    /*
     2018-02-08 16:33:55.378498+0800 iOSProject[63192:4356386] 1------<NSThread: 0x600000070c80>{number = 1, name = main}
     2018-02-08 16:33:55.378659+0800 iOSProject[63192:4356386] 1------<NSThread: 0x600000070c80>{number = 1, name = main}
     2018-02-08 16:33:55.378955+0800 iOSProject[63192:4356386] 2------<NSThread: 0x600000070c80>{number = 1, name = main}
     2018-02-08 16:33:55.379283+0800 iOSProject[63192:4356386] 2------<NSThread: 0x600000070c80>{number = 1, name = main}
     2018-02-08 16:33:55.379804+0800 iOSProject[63192:4356386] 3------<NSThread: 0x600000070c80>{number = 1, name = main}
     2018-02-08 16:33:55.380723+0800 iOSProject[63192:4356386] 3------<NSThread: 0x600000070c80>{number = 1, name = main}
     */
}



//七：全局队列+ 异步执行
-(void)asyncGloba
{
    dispatch_queue_t q = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    // 2. 异步执行
    for (int i = 0; i < 10; ++i) {
        dispatch_async(q, ^{
            NSLog(@"asyncGloba：%@ %d", [NSThread currentThread], i);
        });
    }
    NSLog(@"come here");
    
    //输出内容：
    //    come here
    //    asyncGloba：<NSThread: 0x608000464600>{number = 5, name = (null)} 0
    //    asyncGloba：<NSThread: 0x608000464600>{number = 5, name = (null)} 3
    //    asyncGloba：<NSThread: 0x60000027d480>{number = 18, name = (null)} 1
    //    asyncGloba：<NSThread: 0x60000027d480>{number = 18, name = (null)} 5
    //    asyncGloba：<NSThread: 0x60000027d480>{number = 18, name = (null)} 6
    //    asyncGloba：<NSThread: 0x60000027d480>{number = 18, name = (null)} 7
    //    asyncGloba：<NSThread: 0x60800047e100>{number = 19, name = (null)} 2
    //    asyncGloba：<NSThread: 0x608000464600>{number = 5, name = (null)} 4
    //    asyncGloba：<NSThread: 0x60800047e100>{number = 19, name = (null)} 9
    //    asyncGloba：<NSThread: 0x60000027d480>{number = 18, name = (null)} 8
    //    说明：come here 说明是异步执行，没有马上执行，并且有开子线程执行
}










#pragma mark 重写BaseViewController设置内容


- (void)leftButtonEvent:(UIButton *)sender navigationBar:(LMJNavigationBar *)navigationBar
{
    NSLog(@"%s", __func__);
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (UIImage *)lmjNavigationBarLeftButtonImage:(UIButton *)leftButton navigationBar:(LMJNavigationBar *)navigationBar
{
    [leftButton setImage:[UIImage imageNamed:@"navigationButtonReturn"] forState:UIControlStateHighlighted];

    return [UIImage imageNamed:@"navigationButtonReturnClick"];
}


- (void)setDes
{
    UILabel *label = [[UILabel alloc] init];
    label.width = kScreenWidth;
    self.tableView.tableFooterView = label;
    label.numberOfLines = 0;
    label.textColor = [UIColor blackColor];
    
    label.text= @"------------------------------------------------------------------------------------------\n\
    理论知识\n\
    同步执行（sync）：只能在当前线程中执行任务，不具备开启新线程的能力\n\
    异步执行（async）：可以在新的线程中执行任务，具备开启新线程的能力\n\
    ------------------------------------------------------------------------------------------\n\
    \n\
    ------------------------------------------------------------------------------------------\n\
    并发队列（Concurrent Dispatch Queue）：可以让多个任务并发（同时）执行（自动开启多个线程同时执行任务）,并发功能只有在异步（dispatch_async）函数下才有效\n\
    串行队列（Serial Dispatch Queue）：让任务一个接着一个地执行（一个任务执行完毕后，再执行下一个任务）\n\
    ------------------------------------------------------------------------------------------\n\
    \n\
    ------------------------------------------------------------------------------------------\n\
    串行队列的创建方法\n\
    dispatch_queue_t queue= dispatch_queue_create(\"test.queue\", DISPATCH_QUEUE_SERIAL);\n\
    并发队列的创建方法\n\
    dispatch_queue_t queue= dispatch_queue_create(\"test.queue\", DISPATCH_QUEUE_CONCURRENT);\n\
    创建全局并发队列\n\\n\
    dispatch_get_global_queue来创建全局并发队列\n\
    \n\
    \n\
    dispatch_queue_t queue = dispatch_get_main_queue() 程序一启动，主线程就已经存在，主队列也同时就存在了，所以主队列不需要创建，只需要获取\n\
    \n\
    ------------------------------------------------------------------------------------------\n\
    六种类型：\n\
    并发队列 + 同步执行\n\
    并发队列 + 异步执行\n\
    串行队列 + 同步执行\n\
    串行队列 + 异步执行\n\
    主队列 + 同步执行\n\
    主队列 + 异步执行\n\
    ------------------------------------------------------------------------------------------\n\
    ";
    [label sizeToFit];
}

@end


//------------------------------------------------------------------------------------------
//理论知识
//同步执行（sync）：只能在当前线程中执行任务，不具备开启新线程的能力
//异步执行（async）：可以在新的线程中执行任务，具备开启新线程的能力
//------------------------------------------------------------------------------------------
//
//------------------------------------------------------------------------------------------
//并发队列（Concurrent Dispatch Queue）：可以让多个任务并发（同时）执行（自动开启多个线程同时执行任务）,并发功能只有在异步（dispatch_async）函数下才有效
//串行队列（Serial Dispatch Queue）：让任务一个接着一个地执行（一个任务执行完毕后，再执行下一个任务）
//------------------------------------------------------------------------------------------
//
//------------------------------------------------------------------------------------------
//// 串行队列的创建方法
//dispatch_queue_t queue= dispatch_queue_create("test.queue", DISPATCH_QUEUE_SERIAL);
//// 并发队列的创建方法
//dispatch_queue_t queue= dispatch_queue_create("test.queue", DISPATCH_QUEUE_CONCURRENT);
////创建全局并发队列
//dispatch_get_global_queue来创建全局并发队列
//
//
//dispatch_queue_t queue = dispatch_get_main_queue() 程序一启动，主线程就已经存在，主队列也同时就存在了，所以主队列不需要创建，只需要获取
//
//------------------------------------------------------------------------------------------
//六种类型：
//并发队列 + 同步执行
//并发队列 + 异步执行
//串行队列 + 同步执行
//串行队列 + 异步执行
//主队列 + 同步执行
//主队列 + 异步执行
//------------------------------------------------------------------------------------------
