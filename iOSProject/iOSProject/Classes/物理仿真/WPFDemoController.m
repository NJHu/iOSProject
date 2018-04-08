//
//  WPFDemoController.m
//  02-多物理仿真
//
//  Created by 王鹏飞 on 16/1/10.
//  Copyright © 2016年 王鹏飞. All rights reserved.
//

#import "WPFDemoController.h"
#import "WPFSnapView.h"
#import "WPFPushView.h"
#import "WPFAttachmentView.h"
#import "WPFSpringView.h"
#import "WPFCollisionView.h"

@interface WPFDemoController ()

@end

@implementation WPFDemoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.fd_interactivePopDisabled = YES;
    
    WPFBaseView *baseView = nil;
    
    // 根据不同的功能类型选择不同的视图
    // 运用了多态
    switch (self.function) {
        case kDemoFunctionSnap:
            baseView = [[WPFSnapView alloc] init];
            break;
            
        case kDemoFunctionPush:
            baseView = [[WPFPushView alloc] init];
            break;
            
        case kDemoFunctionAttachment:
            baseView = [[WPFAttachmentView alloc] init];
            break;
            
        case kDemoFunctionSpring:
            baseView = [[WPFSpringView alloc] init];
            break;
            
        case kDemoFunctionCollision:
            baseView = [[WPFCollisionView alloc] init];
            break;
            
        default:
            break;
    }
    
    
    [self.view addSubview:baseView];
    
    [baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(self.lmj_navgationBar.lmj_height + 10, 10, 10, 10));
    }];
    
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
