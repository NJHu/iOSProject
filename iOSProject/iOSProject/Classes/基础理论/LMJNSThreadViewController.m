//
//  LMJNSThreadViewController.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/4/14.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJNSThreadViewController.h"
#import "LMJSettingCell.h"

@interface LMJNSThreadViewController ()
/** <#digest#> */
@property (nonatomic, strong) NSThread *myThread;

/** <#digest#> */
@property (nonatomic, strong) NSMutableArray *myThreadList;
@end

@implementation LMJNSThreadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    LMJWeakSelf(self);
    self.title = @"看打印";
    
    self.addItem([LMJWordItem itemWithTitle:@"简单创建一个多线程" subTitle:@"NSThread alloc init" itemOperation:^(NSIndexPath *indexPath) {
        [weakself addThreadAction];
    }])
    
    .addItem([LMJWordItem itemWithTitle:@"测试增加一定数量对CPU的影响" subTitle:@"在子线程中创建多个线程 不影响主线程" itemOperation:^(NSIndexPath *indexPath) {
        NSLog(@"%lf", CFAbsoluteTimeGetCurrent());
        [weakself addMutableThread];
        NSLog(@"%lf", CFAbsoluteTimeGetCurrent());
    }])
    
    .addItem([LMJWordItem itemWithTitle:@"强制退出线程" subTitle:@"[NSThread exit]" itemOperation:^(NSIndexPath *indexPath) {
        
        [weakself ExitThread];
    }])
    
    .addItem([LMJWordItem itemWithTitle:@"用一个数组存储多条线程" subTitle:nil itemOperation:^(NSIndexPath *indexPath) {
        
        [weakself addArrayThtead];
    }]);
}

//一：简单创建一个多线程
-(void)addThreadAction
{
    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(runAction) object:nil];
    thread.name = @"custom--1";
    [thread start];
    
    //另外的创建方式
    //1：创建线程后自动启动线程 [NSThread detachNewThreadSelector:@selector(run) toTarget:self withObject:nil];
    //2：隐式创建并启动线程 [self performSelectorInBackground:@selector(run) withObject:nil];
}


- (void)runAction
{
    NSLog(@"当前执行的线程为：%@", [NSThread currentThread]);
    //输出：当前执行的线程为：<NSThread: 0x600000071940>{number = 1, name = main}
    
}


//二：测试增加一定数量对CPU的影响
-(void)addMutableThread
{
    //CPU 160%左右  内存150MB左右 平时80MB  这样写在主线程上创建100000多条thread导致卡住
    //    for (int num=0; num<100000; num++) {
    //        NSThread *thread=[[NSThread alloc]initWithTarget:self selector:@selector(runMutableAction) object:nil];
    //        thread.name=[NSString stringWithFormat:@"thread-%d",num];
    //        [thread start];
    //    }
    
    
    //把创建子线程的操作放在一个子线程中进行 不影响主线程
    NSThread *thread=[[NSThread alloc]initWithTarget:self selector:@selector(runMutableThreadAction) object:nil];
    thread.name=[NSString stringWithFormat:@"thread-mutable"];
    [thread start];
}

-(void)runMutableThreadAction
{
    for (int num=0; num<100; num++) {
        NSThread *thread=[[NSThread alloc]initWithTarget:self selector:@selector(runMutableAction) object:nil];
        thread.name=[NSString stringWithFormat:@"thread-thread"];
        [thread start];
    }
    NSLog(@"%@", [NSThread currentThread]);
}

-(void)runMutableAction
{
    NSLog(@"当前线程为：%@",[NSThread currentThread]);
}



//三：强制退出线程
-(void)ExitThread
{
    if (!self.myThread) {
        self.myThread=[[NSThread alloc]initWithTarget:self selector:@selector(runExitAction) object:nil];
        self.myThread.name=@"thread-exit";
    }
    [self.myThread start];
}

-(void)runExitAction
{
    //阻塞（暂停）3秒后执行再下面内容
    [NSThread sleepForTimeInterval:3]; //单位是秒
    
    //结合下面的cancel运用 进行强制退出线程的操作
    if ([[NSThread currentThread] isCancelled]) {
        NSLog(@"当前thread-exit被exit动作了");
        [NSThread exit];
    }
    
    NSLog(@"当前thread-exit线程为：%@",[NSThread currentThread]);
}



//四：用一个数组存储多条线程
-(void)addArrayThtead
{
    if (!self.myThreadList) {
        self.myThreadList=[[NSMutableArray alloc]init];
    }
    
    [self.myThreadList removeAllObjects];
    
    
    for(int i=0; i<10;i++)
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
    NSThread *thread=[NSThread currentThread];
    NSLog(@"loadAction是在线程%@中执行",thread.name);
    
    //回主线程去执行  有些UI相应 必须在主线程中更新
    [self performSelectorOnMainThread:@selector(updateImage) withObject:nil waitUntilDone:YES];
}

-(void)updateImage
{
    NSLog(@"执行完成了");
    NSLog(@"执行方法updateImage是在===%@线程===中",[NSThread isMainThread] ? @"主" : @"子");
    //输出：执行方法updateImage是在主线程中
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //结合VC生命周期 viewWillDisappear退出页面时就把线程标识为cancel
    if (self.myThread && ![self.myThread isCancelled]) {
        NSLog(@"当前thread-exit线程被cancel");
        [self.myThread cancel];
        NSLog(@"当前thread-exit线程被cancel的状态 %@",[self.myThread isCancelled]?@"被标识为Cancel":@"没有被标识");
        //cancel 只是一个标识 最下退出强制终止线程的操作是exit 如果单写cancel 线程还是会继续执行
    }
    
    
    //结合VC生命周期 viewWillDisappear退出页面时就把线程标识为cancel 使用Thread一定要在退出前进行退出，否则会有闪存泄露的问题
    for (int i=0; i<self.myThreadList.count; i++){
        NSThread *thread=self.myThreadList[i];
        if (![thread isCancelled]) {
            NSLog(@"当前thread-exit线程被cancel");
            //cancel 只是一个标识 最下退出强制终止线程的操作是exit 如果单写cancel 线程还是会继续执行
            [thread cancel];
        }}
    //这页会报内存问题，是因为上面还有一些Thread没有进行退出操作 exit
}


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

@end
