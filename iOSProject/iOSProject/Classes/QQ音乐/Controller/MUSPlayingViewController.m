//
//  MUSPlayingViewController.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/9/28.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "MUSPlayingViewController.h"

#import "QQMusicOperationTool.h"
#import "CALayer+MUSAmi.h"
#import "MUSLrcTableViewController.h"
#import "QQLrcDataTool.h"
#import "QQLrcLabel.h"
#import "QQTimeTool.h"

@interface MUSPlayingViewController ()<UIScrollViewDelegate>

// *************************** 改变一次 ********************************

/** 背景图片*/
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;

/** 歌曲名称*/
//@property (weak, nonatomic) IBOutlet UILabel *songNameLabel;

/** 歌手名称*/
//@property (weak, nonatomic) IBOutlet UILabel *singerNameLabel;

/** 前景图片*/
@property (weak, nonatomic) IBOutlet UIImageView *foreImageView;

/** 总时长*/
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel;

/** 播放 或 暂停 按钮*/
@property (weak, nonatomic) IBOutlet UIButton *playOrPauseBtn;


// *************************** 改变多次 ********************************

/**  已经播放时长*/
@property (weak, nonatomic) IBOutlet UILabel *costTimeLabel;

/** 进度条*/
@property (weak, nonatomic) IBOutlet UISlider *progressSlider;

/** 单行歌词*/
@property (weak, nonatomic) IBOutlet QQLrcLabel *lrcLabel;



// *************************** 其他控件或数据 ********************************

/** 歌词的背景视图*/
@property (weak, nonatomic) IBOutlet UIScrollView *lrcBackView;


/** 歌词控制器*/
@property (nonatomic, strong) MUSLrcTableViewController *lrcTVC;

/** 定时器*/
@property (nonatomic, weak) NSTimer *timer;

/** 歌词定时器*/
@property (nonatomic, weak) CADisplayLink *displayLink;

/** 进度条手势*/
@property (nonatomic, strong) UITapGestureRecognizer *tap;


@end

@implementation MUSPlayingViewController

#pragma mark --------------------------
#pragma mark 懒加载

/** 歌词控制器*/
- (MUSLrcTableViewController *)lrcTVC{
    if (_lrcTVC == nil) {
        _lrcTVC = [[MUSLrcTableViewController alloc] init];
        [self addChildViewController:_lrcTVC];
    }
    return _lrcTVC;
}


#pragma mark --------------------------
#pragma mark 初始

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpViewOnce];
    // 监听播放完毕后的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nextMusic:) name:kPlayFinishNotificationName object:nil];
    
    [self setUpDataOnce];
    
    [self addTimer];
    
    [self addDisplayLink];
}

- (void)dealloc{
    // 移除监听
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self setUpFrame];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self removeTimer];
    
    [self removeDisplayLind];
}

/** 加载界面上需要手动添加的控件*/
- (void)setUpViewOnce{
    
    [self addLrcView];
    
    [self setUpSlider];
}

/** 设置子控件的 frame*/
- (void)setUpFrame{
    
    [self setUpForeImageView];
    
    [self setUpLrcViewFrame];
}

/** 设置图片圆角*/
- (void) setUpForeImageView {
    
    self.foreImageView.layer.cornerRadius = self.foreImageView.lmj_width * 0.5;
    self.foreImageView.layer.masksToBounds = YES;
}

/** 添加歌词视图*/
- (void)addLrcView{
    
    // 歌词视图
    [self.lrcBackView addSubview:self.lrcTVC.view];
    
    // 歌词的背景视图
    self.lrcBackView.showsHorizontalScrollIndicator = NO;
    self.lrcBackView.pagingEnabled = YES;
    self.lrcBackView.delegate = self;
}

/** 设置歌词视图的 frame*/
- (void)setUpLrcViewFrame{
    
    // 歌词视图
    self.lrcTVC.view.frame = CGRectMake(kScreenWidth, 0, kScreenWidth, self.lrcBackView.lmj_height);
    
    // 歌词背景视图
    self.lrcBackView.contentSize = CGSizeMake(self.lrcBackView.lmj_width * 2, 0);
}

/** 更改进度条显示样式*/
- (void)setUpSlider{
    
    [self.progressSlider setThumbImage:[UIImage imageNamed:@"player_slider_playback_thumb"] forState:UIControlStateNormal];
}

#pragma mark --------------------------
#pragma mark 动画处理

/** 处理透明度*/
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat alpha = 1 - 1.0 * scrollView.contentOffset.x / self.lrcBackView.lmj_width;
    
    self.foreImageView.alpha = alpha;
    self.lrcLabel.alpha = alpha;
}

/** 添加旋转动画*/
- (void)addRotationAnimation{
    
    // 1.移除之前的动画
    NSString *key = @"rotation";
    [self.foreImageView.layer removeAnimationForKey:key];
    
    // 2.重新添加动画
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.fromValue = 0;
    animation.toValue = @(M_PI * 2);
    animation.duration = 30;
    animation.repeatCount = MAXFLOAT;
    
    // 设置播放完成之后不移除
    animation.removedOnCompletion = NO;
    
    // 添加动画
    [self.foreImageView.layer addAnimation:animation forKey:key];
}

/** 暂停旋转动画*/
- (void)pauseRotationAnimation{
    
    [self.foreImageView.layer pauseAnimate];
}

/** 恢复旋转动画*/
- (void)resumeRotationAnimatioin{
    
    [self.foreImageView.layer resumeAnimate];
}


#pragma mark --------------------------
#pragma mark 按钮点击事件
/** 暂停 或 播放*/
- (IBAction)playOrPauseMusic:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    
    if (sender.selected) {
        [[QQMusicOperationTool shareInstance] playCurrentMusic];
        [self resumeRotationAnimatioin];
        
    }else{
        [[QQMusicOperationTool shareInstance] pauseCurrentMusic];
        [self pauseRotationAnimation];
    }
}

/** 上一首*/
- (IBAction)preMusic:(UIButton *)sender {
    
    if ([[QQMusicOperationTool shareInstance] preMusic]) {
        [self setUpDataOnce];
    }
}

/** 下一首*/
- (IBAction)nextMusic:(UIButton *)sender {
    
    if ([[QQMusicOperationTool shareInstance] nextMusic]) {
        [self setUpDataOnce];
    }
}



#pragma mark --------------------------
#pragma mark 进度条监听
- (IBAction)sliderDidTouchDown:(UISlider *)sender {
    // 移除定时器
    [self removeTimer];
}

- (IBAction)sliderDidTouchUp:(UISlider *)sender {
    
    // 控制当前的播放进度
    // 1.添加定时器
    [self addTimer];
    
    // 2.计算当前时间
    // 2.1 总时长
    NSTimeInterval totalTime = [[QQMusicOperationTool shareInstance] getNewMusicMessageModel].totalTime;
    
    // 2.2. 当前时间
    NSTimeInterval currentTime = sender.value * totalTime;
    
    // 3.设置当前播放进度
    [[QQMusicOperationTool shareInstance] seekTo:currentTime];
    
    if (sender.value >= 1.0) {
        
        [self nextMusic:nil];
    }
}

- (IBAction)sliderDidValueChange:(UISlider *)sender {
    
    // 设置 已经播放时长
    
    // 1.计算总时长
    NSTimeInterval totalTime = [[QQMusicOperationTool shareInstance] getNewMusicMessageModel].totalTime;
    
    // 2.当前时间
    NSTimeInterval currentTime = sender.value * totalTime;
    
    // 3.设置 已经播放时长
    self.costTimeLabel.text = [QQTimeTool getFormatTime:currentTime];
    
    //NSLog(@"%lf", sender.value);
}


#pragma mark --------------------------
#pragma mark 界面数据变化

/** 当切换歌曲的时候, 更新 一次 界面数据*/
- (void)setUpDataOnce{
    
    // 获取最新数据
    QQMusicMessageModel *musicMessageModel = [[QQMusicOperationTool shareInstance] getNewMusicMessageModel];
    
    // 背景图片
    NSString *imageName = musicMessageModel.musicM.icon;
    self.backImageView.image = [UIImage imageNamed:imageName];
    
    // 前景图片
    self.foreImageView.image = [UIImage imageNamed:imageName];
    
    // 歌曲名称
//    self.songNameLabel.text = musicMessageModel.musicM.name;
//    
//    // 歌手名称
//    self.singerNameLabel.text = musicMessageModel.musicM.singer;
    
    self.lmj_navgationBar.title = [self changeTitle:[musicMessageModel.musicM.name stringByAppendingFormat:@"\n%@", musicMessageModel.musicM.singer]];
    
    // 进度恢复成0
    self.progressSlider.value = 0.0;
    // 播放时长是0
    self.costTimeLabel.text = @"00:00";
    // 总时长
    self.totalTimeLabel.text = musicMessageModel.totalTimeFormat;
    
    // 开启旋转动画
    [self addRotationAnimation];
    
    if (musicMessageModel.isPlaying) {
        [self resumeRotationAnimatioin];
    }else{
        [self pauseRotationAnimation];
    }
    
    // 获取歌词数据
    // 1.获取歌词数据源
    NSArray<QQLrcModel *> *lrcMs = [QQLrcDataTool getLrcData:musicMessageModel.musicM.lrcname];
    //    NSLog(@"%@", lrcMs);
    
    // 2.将数据源交给控制器来展示
    self.lrcTVC.datasource = lrcMs;
}

/** 当切换歌曲的时候, 更新 多次 界面数据*/
- (void)setUpDataTimes{
    
    // 获取最新数据
    QQMusicMessageModel *musicMessageModel = [[QQMusicOperationTool shareInstance] getNewMusicMessageModel];
    
    self.costTimeLabel.text = musicMessageModel.costTimeFormat;
    self.progressSlider.value = 1.0 * musicMessageModel.costTime / musicMessageModel.totalTime;
    
    // 播放或者暂停按钮 待定
    self.playOrPauseBtn.selected = musicMessageModel.isPlaying;
}


/** 更新歌词*/
- (void)updateLrc{
    
    // 1.获取当前音乐的数据
    QQMusicMessageModel *musicMessageModel = [[QQMusicOperationTool shareInstance] getNewMusicMessageModel];
    
    // 2.获取当前歌词所在的行
    [QQLrcDataTool getRow:musicMessageModel.costTime andLrcs:self.lrcTVC.datasource completion:^(NSInteger row, QQLrcModel *lrc) {
        
        // 3.把数据传递给歌词控制器管理
        self.lrcTVC.scrollRow = row;
        
        // 4.设置单行歌词
        self.lrcLabel.text = lrc.lrcStr;
        
        // 5.跟新歌词进度
        CGFloat progress = (musicMessageModel.costTime - lrc.beginTime) / (lrc.endTime - lrc.beginTime);
        self.lrcLabel.progress = progress;
        
        // 6.把歌词的播放进度传递给 歌词控制器
        self.lrcTVC.progress = progress;
        
    }];
    
    // 7.设置锁屏信息
    // 前台不更新, 进入后台之后才更新
    UIApplicationState state =  [UIApplication sharedApplication].applicationState;
    if (state == UIApplicationStateBackground) {
        [[QQMusicOperationTool shareInstance] setUpLockMessage];
    }
}

#pragma mark --------------------------
#pragma mark 定时器

/** 添加定时器*/
- (void)addTimer{
    
    if (_timer == nil) {
        
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(setUpDataTimes) userInfo:nil repeats:YES];
        self.timer = timer;
        // 添加到 runloop
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    }
}

/** 移除定时器*/
- (void)removeTimer{
    
    [self.timer invalidate];
    self.timer = nil;
}

/** 定时更新 歌词面板信息*/
- (void)addDisplayLink{
    
    if (!_displayLink) {
        CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateLrc)];
        self.displayLink = displayLink;
        // 添加到 runloop
        [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    }
}

/** 移除 歌词面板信息 定时器*/
- (void)removeDisplayLind{
    
    [self.displayLink invalidate];
    self.displayLink = nil;
}


#pragma mark --------------------------
#pragma mark 远程处理事件

/** 摇一摇*/
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    
    // 下一首歌曲
    [self nextMusic:nil];
}


/** 锁屏状态下接收的远程事件处理*/
- (void)remoteControlReceivedWithEvent:(UIEvent *)event{
    
    UIEventSubtype type = event.subtype;
    switch (type) {
        case UIEventSubtypeRemoteControlPlay:{
            //NSLog(@"播放");
//            [[QQMusicOperationTool shareInstance] playCurrentMusic];
            [self playOrPauseMusic:self.playOrPauseBtn];
            break;
        }
            
        case UIEventSubtypeRemoteControlPause:{
            //NSLog(@"暂停");
//            [[QQMusicOperationTool shareInstance] pauseCurrentMusic];
            [self playOrPauseMusic:self.playOrPauseBtn];
            break;
        }
            
        case UIEventSubtypeRemoteControlNextTrack:{
            //NSLog(@"下一首");
//            [[QQMusicOperationTool shareInstance] nextMusic];
            [self nextMusic:nil];
            break;
        }
            
        case UIEventSubtypeRemoteControlPreviousTrack:{
            //NSLog(@"上一首");
//            [[QQMusicOperationTool shareInstance] preMusic];
            [self preMusic:nil];
            break;
        }
        default:{
            //NSLog(@"暂不处理");
            break;
        }
    }
}



#pragma mark - LMJNavUIBaseViewControllerDataSource

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


/** 背景色 */
- (UIColor *)lmjNavigationBackgroundColor:(LMJNavigationBar *)navigationBar
{
    return [UIColor clearColor];
}

/** 是否隐藏底部黑线 */
- (BOOL)lmjNavigationIsHideBottomLine:(LMJNavigationBar *)navigationBar
{
    return YES;
}


- (NSMutableAttributedString *)changeTitle:(NSString *)curTitle
{
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:curTitle ?: @""];
    
    [title addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, title.length)];
    
    [title addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, title.length)];
    
    return title;
}


#pragma mark - LMJNavUIBaseViewControllerDataSource

/** 导航条左边的按钮 */
- (UIImage *)lmjNavigationBarLeftButtonImage:(UIButton *)leftButton navigationBar:(LMJNavigationBar *)navigationBar
{
    [leftButton setImage:[UIImage imageNamed:@"NavgationBar_white_back"] forState:UIControlStateHighlighted];
    
    return [UIImage imageNamed:@"NavgationBar_white_back"];
}
/** 左边的按钮的点击 */
-(void)leftButtonEvent:(UIButton *)sender navigationBar:(LMJNavigationBar *)navigationBar
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
