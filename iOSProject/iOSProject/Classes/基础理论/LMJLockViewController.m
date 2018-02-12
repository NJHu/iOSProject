//
//  LMJLockViewController.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/4/14.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJLockViewController.h"

@interface LMJLockViewController ()
@property (nonatomic, strong) NSMutableArray *myMutableList;

//要运用atomic 线程安全 只能是相对安全 只有这个属性也会出现线程问题
@property (strong, nonatomic) NSMutableArray *myThreadList;

// 安全
@property (strong, atomic) NSLock *mylock;

/** <#digest#> */
@property (nonatomic, assign) NSInteger action;

/** <#digest#> */
@property (nonatomic, strong) NSMutableString *printStr;
@end

@implementation LMJLockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    LMJWeakSelf(self);
    //初始化锁对象
    self.mylock = [[NSLock alloc]init];
    

    
    self.addItem([LMJWordItem itemWithTitle:@"第一种情况" subTitle:@"空" itemOperation:^(NSIndexPath *indexPath) {
        [weakself start:indexPath];
    }])
    .addItem([LMJWordItem itemWithTitle:@"第二种情况" subTitle:@"NSLock" itemOperation:^(NSIndexPath *indexPath) {
        [weakself start:indexPath];
    }])
    
    .addItem([LMJWordItem itemWithTitle:@"第三种情况" subTitle:@"@synchronized" itemOperation:^(NSIndexPath *indexPath) {
        [weakself start:indexPath];
    }]);
    
    
}

- (void)start:(NSIndexPath *)indexPath
{
    LMJWeakSelf(self);
    weakself.myMutableList = [NSMutableArray array];
    for (NSInteger i = 0; i < 20; i++) {
        [weakself.myMutableList addObject:[NSString stringWithFormat:@"图片%zd", i+1]];
    }
    weakself.printStr = [NSMutableString string];
    weakself.action = indexPath.row;
    [weakself addArrayThtead];
    
    [MBProgressHUD showLoadToView:self.view];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view];
        [UIAlertController mj_showActionSheetWithTitle:@"打印" message:weakself.printStr appearanceProcess:^(JXTAlertController * _Nonnull alertMaker) {
            alertMaker.addActionDefaultTitle(@"知道了");
        } actionsBlock:nil];
    });
    
}

- (void)addArrayThtead
{
    if (!self.myThreadList) {
        self.myThreadList=[[NSMutableArray alloc]init];
    }
    
    [self.myThreadList removeAllObjects];
    
    for(int i = 0; i < 20; i++)
    {
        NSThread *thread=[[NSThread alloc]initWithTarget:self selector:@selector(loadAction:) object:[NSNumber numberWithInt:i]];
        thread.name=[NSString stringWithFormat:@"myThread%i",i];
        
        [self.myThreadList addObject:thread];
    }
    
    for (int i=0; i<self.myThreadList.count; i++) {
        NSThread *thread=self.myThreadList[i];
        [thread start];
    }
}

-(void)loadAction:(NSNumber *)index
{
    
    NSThread *thread = [NSThread currentThread];
    NSLog(@"loadAction是在线程%@中执行",thread.name);
    
    NSMutableString *name;
    if (self.action == 0) {
        //第一种情况
        if (self.myMutableList.count>0) {
            name=[[self.myMutableList lastObject] mutableCopy];
            [self.myMutableList removeObject:[self.myMutableList lastObject]];
            NSLog(@"当前要加载的图片名称%@",name);
            [self.printStr appendFormat:@"当前要加载的图片名称%@\n",name];
        }
    }else if (self.action == 1) {
        //    第二种情况
        //加锁
        [_mylock lock];
        if (self.myMutableList.count>0) {
            name=[[self.myMutableList lastObject] mutableCopy];
            [self.myMutableList removeObject:[self.myMutableList lastObject]];
        }
        NSLog(@"当前要加载的图片名称%@",name);
        [self.printStr appendFormat:@"当前要加载的图片名称%@\n",name];
        [_mylock unlock];
        
    }else if (self.action == 2) {
        //  第三种情况
        //线程同步
        @synchronized(self){
            if (self.myMutableList.count>0) {
                name = [[self.myMutableList lastObject] mutableCopy];
                [self.myMutableList removeObject:[self.myMutableList lastObject]];
                NSLog(@"当前要加载的图片名称%@",name);
                [self.printStr appendFormat:@"当前要加载的图片名称%@\n",name];
            }
        }
        
    }
    
    //回主线程去执行  有些UI相应 必须在主线程中更新
    [self performSelectorOnMainThread:@selector(updateImage) withObject:nil waitUntilDone:YES];
    
    //结合下面的cancel运用 进行强制退出线程的操作
    if (![thread isCancelled]) {
        [thread cancel];
        NSLog(@"当前thread-exit被exit动作了");
        [NSThread exit];
    }else {
        [NSThread exit];
    }
}

-(void)updateImage
{
    @autoreleasepool {
        NSLog(@"执行完成了");
    }
    
    //输出：执行方法updateImage是在主线程中
}


//******解决Thread中的内存问题
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //结合VC生命周期 viewWillDisappear退出页面时就把线程标识为cancel 使用Thread一定要在退出前进行退出，否则会有闪存泄露的问题
    for (int i=0; i<self.myThreadList.count; i++){
        NSThread *thread=self.myThreadList[i];
        if (![thread isCancelled]) {
            NSLog(@"当前thread-exit线程被cancel");
            //cancel 只是一个标识 最下退出强制终止线程的操作是exit 如果单写cancel 线程还是会继续执行
            [thread cancel];
        }}
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



//------------------------------------------------------------------------------------------
//第一种情况
//输出  @property(nonatomic,strong)NSMutableArray *myMutableList;
//当前要加载的图片名称图片9
//当前要加载的图片名称图片8
//当前要加载的图片名称图片8
//当前要加载的图片名称图片7
//当前要加载的图片名称图片6
//当前要加载的图片名称图片5
//当前要加载的图片名称图片4
//当前要加载的图片名称图片3
//当前要加载的图片名称图片2


//说明：错乱，当前要加载的图片名称图片8被加载的两次


//------------------------------------------------------------------------------------------
//第二种情况
//输出 @property(atomic,strong)NSMutableArray *myMutableList;  atomic原子性
//当前要加载的图片名称图片9
//当前要加载的图片名称图片8
//当前要加载的图片名称图片7
//当前要加载的图片名称图片6
//当前要加载的图片名称图片6
//当前要加载的图片名称图片5
//当前要加载的图片名称图片4
//当前要加载的图片名称图片3
//当前要加载的图片名称图片2

//说明：错乱，当前要加载的图片名称图片6被加载的两次


//------------------------------------------------------------------------------------------
//第三种情况
//输出  [_mylock lock]; [_mylock unlock];
//当前要加载的图片名称图片9
//当前要加载的图片名称图片8
//当前要加载的图片名称图片7
//当前要加载的图片名称图片6
//当前要加载的图片名称图片5
//当前要加载的图片名称图片4
//当前要加载的图片名称图片3
//当前要加载的图片名称图片1
//当前要加载的图片名称图片2

//说明：成功防止错乱


//------------------------------------------------------------------------------------------
//第四种情况
//输出  @synchronized
//当前要加载的图片名称图片9
//当前要加载的图片名称图片8
//当前要加载的图片名称图片7
//当前要加载的图片名称图片6
//当前要加载的图片名称图片5
//当前要加载的图片名称图片4
//当前要加载的图片名称图片3
//当前要加载的图片名称图片2
//当前要加载的图片名称图片1

//说明：成功防止错乱 而且还是有顺序执行下来




//------------------------------------------------------------------------------------------
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
