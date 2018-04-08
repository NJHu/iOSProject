//
//  LMJCAClockViewController.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/10/23.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJCAClockViewController.h"

@interface LMJCAClockViewController ()

/** timer */
@property (weak, nonatomic) NSTimer *timer;

@property (strong, nonatomic) UIImageView *clockImageView;

@property (nonatomic, weak) CALayer *secondLayer;

@property (nonatomic, weak) CALayer *minuteLayer;

@property (nonatomic, weak) CALayer *hourLayer;

@end


#define angle2radion(a) ((a) / 180.0 * M_PI)
// 一秒钟秒针转6°
#define perSecondA 6

// 一分钟分针转6°
#define perMinuteA 6

// 一小时时针转30°
#define perHourA 30

// 每分钟时针转多少度
#define perMinuteHourA 0.5

#define kClockW _clockImageView.bounds.size.width

@implementation LMJCAClockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.clockImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"钟表.png"]];
    [self.view addSubview:self.clockImageView];
    [self.clockImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.centerOffset(CGPointZero);
    }];
    
    
    // 添加时针
    [self setUpHourLayer];
    
    // 添加分针
    [self setUpMinuteLayer];
    
    // 添加秒针
    [self setUpSecondLayer];
    
    // 添加定时器
   NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeChange) userInfo:nil repeats:YES];
    _timer = timer;
    [self timeChange];
}

- (void)dealloc {
    [_timer invalidate];
    _timer = nil;
}

#pragma mark - 添加秒针
- (void)setUpSecondLayer
{
    CALayer *secondL = [CALayer layer];
    
    secondL.backgroundColor = [UIColor redColor].CGColor;
    
    // 设置锚点
    secondL.anchorPoint = CGPointMake(0.5, 1);
    
    secondL.position = CGPointMake(kClockW * 0.5, kClockW * 0.5);
    
    secondL.bounds = CGRectMake(0, 0, 1, kClockW * 0.5 - 20);
    
    secondL.cornerRadius = 0;
    
    [_clockImageView.layer addSublayer:secondL];
    
    _secondLayer = secondL;
}


#pragma mark - 添加分针
- (void)setUpMinuteLayer
{
    CALayer *layer = [CALayer layer];
    
    layer.backgroundColor = [UIColor blackColor].CGColor;
    
    // 设置锚点
    layer.anchorPoint = CGPointMake(0.5, 1);
    
    layer.position = CGPointMake(kClockW * 0.5, kClockW * 0.5);
    
    layer.bounds = CGRectMake(0, 0, 4, kClockW * 0.5 - 20);
    
    layer.cornerRadius = 2;
    
    
    [_clockImageView.layer addSublayer:layer];
    
    _minuteLayer = layer;
}

#pragma mark - 添加时针
- (void)setUpHourLayer
{
    CALayer *layer = [CALayer layer];
    
    layer.backgroundColor = [UIColor blackColor].CGColor;
    
    // 设置锚点
    layer.anchorPoint = CGPointMake(0.5, 1);
    
    layer.position = CGPointMake(kClockW * 0.5, kClockW * 0.5);
    
    layer.bounds = CGRectMake(0, 0, 4, kClockW * 0.5 - 40);
    
    layer.cornerRadius = 4;
    
    
    [_clockImageView.layer addSublayer:layer];
    
    _hourLayer = layer;
}
- (void)timeChange
{
    // 获取当前的系统的时间
    
    // 获取当前日历对象
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    // 获取日期的组件：年月日小时分秒
    // components:需要获取的日期组件
    // fromDate：获取哪个日期的组件
    // 经验：以后枚举中有移位运算符，通常一般可以使用并运算（|）
    NSDateComponents  *cmp = [calendar components:NSCalendarUnitSecond | NSCalendarUnitMinute | NSCalendarUnitHour fromDate:[NSDate date]];
    
    // 获取秒
    NSInteger second = cmp.second;
    
    // 获取分
    NSInteger minute = cmp.minute;
    
    // 获取小时
    NSInteger hour = cmp.hour;
    
    // 计算秒针转多少度
    CGFloat secondA = second * perSecondA;
    
    // 计算分针转多少度
    CGFloat minuteA = minute * perMinuteA;
    
    // 计算时针转多少度
    CGFloat hourA = hour * perHourA + minute * perMinuteHourA;
    
    // 旋转秒针
    _secondLayer.transform = CATransform3DMakeRotation(angle2radion(secondA), 0, 0, 1);
    
    // 旋转分针
    _minuteLayer.transform = CATransform3DMakeRotation(angle2radion(minuteA), 0, 0, 1);
    
    // 旋转小时
    _hourLayer.transform = CATransform3DMakeRotation(angle2radion(hourA), 0, 0, 1);
}

@end
