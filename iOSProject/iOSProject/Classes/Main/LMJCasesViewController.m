//
//  LMJCasesViewController.m
//  iOSProject
//
//  Created by HuXuPeng on 2018/1/22.
//  Copyright © 2018年 HuXuPeng. All rights reserved.
//

#import "LMJCasesViewController.h"
#import <DWBubbleMenuButton.h>
#import "MCCornersRoundViewController.h"
#import "LMJSettingCell.h"
#import "MCSphereTagCloudViewController.h"
#import "MCLocalHTMLViewController.h"
@interface LMJCasesViewController ()

@end

@implementation LMJCasesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"更多案例";
    
    LMJWordArrowItem *item0 = [LMJWordArrowItem itemWithTitle:@"各种圆角btn" subTitle:@"MCCornersRoundViewController"];
    item0.destVc = [MCCornersRoundViewController class];
    
    LMJWordArrowItem *item1 = [LMJWordArrowItem itemWithTitle:@"球形滚动标签" subTitle:@"MCSphereTagCloudViewController"];
    item1.destVc = [MCSphereTagCloudViewController class];
    
    LMJWordArrowItem *item2 = [LMJWordArrowItem itemWithTitle:@"加载本地html和css 需要建立实体文件夹" subTitle:@"MCLocalHTMLViewController"];
    item2.destVc = [MCLocalHTMLViewController class];
    
//    MCTestViewController
    LMJWordArrowItem *item3 = [LMJWordArrowItem itemWithTitle:@"多项测试" subTitle:@"MCTestViewController"];
    item3.destVc =  NSClassFromString(@"MCTestViewController");
    
    LMJItemSection *section0 = [LMJItemSection sectionWithItems:@[item0, item1, item2, item3] andHeaderTitle:@"UI 更多案例" footerTitle:@"UI --end"];
    
    [self.sections addObject:section0];
}



- (UIView *)lmjNavigationBarLeftView:(LMJNavigationBar *)navigationBar {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.f, 0.f, 44, 44)];
    
    label.text = @"Tap";
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.layer.cornerRadius = label.frame.size.height / 2.f;
    label.backgroundColor =[UIColor colorWithRed:0.f green:0.f blue:0.f alpha:0.5f];
    label.clipsToBounds = YES;
    
    DWBubbleMenuButton *bubbleMenuButton = [[DWBubbleMenuButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44) expansionDirection:DirectionRight];
    bubbleMenuButton.homeButtonView = label;
    
    [bubbleMenuButton addButtons:[self createDemoButtonArray]];
    
    return bubbleMenuButton;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    [super tableView:tableView  cellForRowAtIndexPath:indexPath];
    LMJWordItem *item = self.sections[indexPath.section].items[indexPath.row];
    
    LMJSettingCell *cell = [LMJSettingCell cellWithTableView:tableView andCellStyle:UITableViewCellStyleSubtitle];
    
    cell.item = item;
    
    return cell;
}


- (NSArray *)createDemoButtonArray {
    NSMutableArray *buttonsMutable = [[NSMutableArray alloc] init];
    
    int i = 0;
    for (NSString *title in @[@"A", @"B", @"C", @"D", @"E", @"F"]) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitle:title forState:UIControlStateNormal];
        
        button.frame = CGRectMake(0.f, 0.f, 30.f, 30.f);
        button.layer.cornerRadius = button.frame.size.height / 2.f;
        button.backgroundColor = [UIColor colorWithRed:0.f green:0.f blue:0.f alpha:0.5f];
        button.clipsToBounds = YES;
        button.tag = i++;
        
        [button addTarget:self action:@selector(test:) forControlEvents:UIControlEventTouchUpInside];
        
        [buttonsMutable addObject:button];
    }
    
    return buttonsMutable;
}

- (void)test:(UIButton *)sender {
    NSLog(@"Button tapped, tag: %ld", (long)sender.tag);
}

- (UIView *)lmjNavigationBarTitleView:(LMJNavigationBar *)navigationBar {
    UILabel *label = [[UILabel alloc] init];
    
    label.text = @"更多案例titleView";
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentCenter;
    [label sizeToFit];
    label.height = 44;
    
    return label;
}


- (void)rightButtonEvent:(UIButton *)sender navigationBar:(LMJNavigationBar *)navigationBar {
    
    NSInteger count = [[sender titleForState:UIControlStateNormal] substringFromIndex:4].integerValue;
    count += 1;
    // 查看 UIButton+LMJBlock, 延时间隔点击
    [sender setTitle:[NSString stringWithFormat:@"点击次数%zd", count] forState:UIControlStateNormal];
 
    [sender sizeToFit];
    sender.height = 44;
}

- (UIImage *)lmjNavigationBarRightButtonImage:(UIButton *)rightButton navigationBar:(LMJNavigationBar *)navigationBar {
    
    [rightButton setTitle:@"点击次数0" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightButton sizeToFit];
    rightButton.height = 44;
    return nil;
}

@end
