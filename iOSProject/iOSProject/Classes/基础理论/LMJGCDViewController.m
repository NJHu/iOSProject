//
//  LMJGCDViewController.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/4/14.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJGCDViewController.h"

@interface LMJGCDViewController ()

/** <#digest#> */
@property (weak, nonatomic) UITextView *inputTextView;

@end

@implementation LMJGCDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self des];
    
    
//    六种类型：
//    并发队列 + 同步执行
    [self syncConCurrent];
    
    
//    并发队列 + 异步执行
    
    [self asyncConcurrent];
    
//    串行队列 + 同步执行
    [self syncSerial];
    
//    串行队列 + 异步执行
    [self asyncSerial];
    
    //五：主队列 + 同步执行 直接闪退
//    [self syncMain];
    
    //六：主队列 + 异步执行
    [self asyncMain];
    
    //七：全局队列+ 异步执行
    [self asyncGloba];
    
    
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


- (UITextView *)inputTextView
{
    if(_inputTextView == nil)
    {
        UITextView *textView = [[UITextView alloc] init];
        
        [self.view addSubview:textView];
        
                textView.userInteractionEnabled = YES;
                textView.editable = NO;
                textView.selectable = NO;
                textView.scrollEnabled = YES;
        
        //        [textView addPlaceHolder:@"我是占位的"];
        
        [textView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.edges.mas_equalTo(UIEdgeInsetsMake(60, 0, 0, 0));
            
        }];
        
        textView.textColor = [UIColor RandomColor];
        textView.font = AdaptedFontSize(16);
        
        _inputTextView = textView;
        
    }
    return _inputTextView;
}




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

- (void)rightButtonEvent:(UIButton *)sender navigationBar:(LMJNavigationBar *)navigationBar
{
    NSLog(@"%s", __func__);
}

- (void)titleClickEvent:(UILabel *)sender navigationBar:(LMJNavigationBar *)navigationBar
{
    NSLog(@"%@", sender);
}

- (NSMutableAttributedString*)lmjNavigationBarTitle:(LMJNavigationBar *)navigationBar
{
    return [self changeTitle:@"GCD"];;
}

- (UIImage *)lmjNavigationBarLeftButtonImage:(UIButton *)leftButton navigationBar:(LMJNavigationBar *)navigationBar
{
[leftButton setImage:[UIImage imageNamed:@"navigationButtonReturn"] forState:UIControlStateHighlighted];

return [UIImage imageNamed:@"navigationButtonReturnClick"];
}


- (UIImage *)lmjNavigationBarRightButtonImage:(UIButton *)rightButton navigationBar:(LMJNavigationBar *)navigationBar
{
    rightButton.backgroundColor = [UIColor RandomColor];
    
    return nil;
}



#pragma mark 自定义代码

-(NSMutableAttributedString *)changeTitle:(NSString *)curTitle
{
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:curTitle ?: @""];
    
    [title addAttribute:NSForegroundColorAttributeName value:[UIColor RandomColor] range:NSMakeRange(0, title.length)];
    
    [title addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, title.length)];
    
    return title;
}

- (void)des
{
    self.inputTextView.text= @"------------------------------------------------------------------------------------------\n\
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
