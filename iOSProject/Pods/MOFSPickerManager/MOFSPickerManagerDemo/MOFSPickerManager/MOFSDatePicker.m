//
//  MOFSDatePicker.m
//  MOFSPickerManager
//
//  Created by luoyuan on 16/8/26.
//  Copyright © 2016年 luoyuan. All rights reserved.
//

#import "MOFSDatePicker.h"

#define UISCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define UISCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface MOFSDatePicker()

@property (nonatomic, strong) NSMutableDictionary *recordDic;
@property (nonatomic, strong) UIView *bgView;

@end


@implementation MOFSDatePicker

- (NSMutableDictionary *)recordDic {
    if (!_recordDic) {
        _recordDic = [NSMutableDictionary dictionary];
    }
    return _recordDic;
}

#pragma mark - create UI

- (instancetype)initWithFrame:(CGRect)frame {
    
    [self initToolBar];
    [self initContainerView];
    
    CGRect initialFrame;
    if (CGRectIsEmpty(frame)) {
        initialFrame = CGRectMake(0, self.toolBar.frame.size.height, UISCREEN_WIDTH, 216);
    } else {
        initialFrame = frame;
    }
    self = [super initWithFrame:initialFrame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.datePickerMode = UIDatePickerModeDate;
        
        [self initBgView];
    }
    return self;
}

- (void)initToolBar {
    self.toolBar = [[MOFSToolView alloc] initWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH, 44)];
    self.toolBar.backgroundColor = [UIColor whiteColor];
}

- (void)initContainerView {
    self.containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH, UISCREEN_HEIGHT)];
    self.containerView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    self.containerView.userInteractionEnabled = YES;
    [self.containerView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenWithAnimation)]];
}

- (void)initBgView {
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, UISCREEN_HEIGHT - self.frame.size.height - 44, UISCREEN_WIDTH, self.frame.size.height + self.toolBar.frame.size.height)];
}

#pragma mark - Action

- (void)showMOFSDatePickerViewWithTag:(NSInteger)tag firstDate:(NSDate *)date commit:(CommitBlock)commitBlock cancel:(CancelBlock)cancelBlock {
    
     NSString *showtagStr = [NSString stringWithFormat:@"%ld",(long)tag];
    
    if ([self.recordDic.allKeys containsObject:showtagStr]) {
        NSDate *date1 = self.recordDic[showtagStr][showtagStr];
        self.date = date1;
    } else {
        if (date) {
            self.date = date;
        } else {
            self.date = [NSDate date];
        }
    }
    
    [self showWithAnimation];
    __weak __typeof(self) weakSelf = self;
    
    self.toolBar.cancelBlock = ^{
        [weakSelf hiddenWithAnimation];
        if (cancelBlock) {
            cancelBlock();
        }
    };
    
    self.toolBar.commitBlock = ^{
       
        NSDictionary *dic = [NSDictionary dictionaryWithObject:weakSelf.date forKey:showtagStr];
        [weakSelf.recordDic setValue:dic forKey:showtagStr];
        
        [weakSelf hiddenWithAnimation];
        if (commitBlock) {
            commitBlock(weakSelf.date);
        }
    };

}

- (void)showWithAnimation {
    [self addViews];
    self.containerView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
    CGFloat height = self.bgView.frame.size.height;
    self.bgView.center = CGPointMake(UISCREEN_WIDTH / 2, UISCREEN_HEIGHT + height / 2);
    [UIView animateWithDuration:0.25 animations:^{
        self.bgView.center = CGPointMake(UISCREEN_WIDTH / 2, UISCREEN_HEIGHT - height / 2);
        self.containerView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    }];
    
}

- (void)hiddenWithAnimation {
    CGFloat height = self.bgView.frame.size.height;
    [UIView animateWithDuration:0.25 animations:^{
        self.bgView.center = CGPointMake(UISCREEN_WIDTH / 2, UISCREEN_HEIGHT + height / 2);
        self.containerView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
    } completion:^(BOOL finished) {
        [self hiddenViews];
    }];
}

- (void)addViews {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.containerView];
    [window addSubview:self.bgView];
    [self.bgView addSubview:self.toolBar];
    [self.bgView addSubview:self];
}

- (void)hiddenViews {
    [self removeFromSuperview];
    [self.toolBar removeFromSuperview];
    [self.bgView removeFromSuperview];
    [self.containerView removeFromSuperview];
}


@end
