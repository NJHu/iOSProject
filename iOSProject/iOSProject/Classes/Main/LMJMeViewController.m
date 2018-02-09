//
//  LMJMeViewController.m
//  PLMMPRJK
//
//  Created by NJHu on 2017/3/30.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJMeViewController.h"
#import "LMJUMengHelper.h"

@interface LMJMeViewController ()

/** <#digest#> */
@property (weak, nonatomic) UIButton *QQLoginBtn;
/** <#digest#> */
@property (weak, nonatomic) UIButton *WXLoginBtn;
/** <#digest#> */
@property (weak, nonatomic) UIButton *SinaLoginBtn;

/** <#digest#> */
@property (weak, nonatomic) UIButton *shareBtn;

@end

@implementation LMJMeViewController

#pragma mark viewController生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    LMJWordItem *item0 = [LMJWordItem itemWithTitle:@"分享面板" subTitle:nil];
    item0.itemOperation = ^(NSIndexPath *indexPath) {
        
        [LMJUMengHelper shareTitle:@"GitHub-iOSProject" subTitle:@"谢谢使用!欢迎交流!" thumbImage:@"https://avatars2.githubusercontent.com/u/18454795?s=400&u=c8a7cc691e5c3611e9fb49dcf9c83843dd9141a2&v=4" shareURL:@"https://www.github.com/njhu"];
    };
    
    LMJWordItem *item1 = [LMJWordItem itemWithTitle:@"QQ登录" subTitle:nil];
    item1.itemOperation = ^(NSIndexPath *indexPath) {
        [LMJUMengHelper getUserInfoForPlatform:UMSocialPlatformType_QQ completion:^(UMSocialUserInfoResponse *result, NSError *error) {
            
            NSLog(@"%@", result);
        }];
    };
    
    LMJWordItem *item2 = [LMJWordItem itemWithTitle:@"微信登录" subTitle:nil];
    item2.itemOperation = ^(NSIndexPath *indexPath) {
        [LMJUMengHelper getUserInfoForPlatform:UMSocialPlatformType_WechatSession completion:^(UMSocialUserInfoResponse *result, NSError *error) {
            
            NSLog(@"%@", result);
        }];
    };
    
    LMJWordItem *item3 = [LMJWordItem itemWithTitle:@"微博登录" subTitle:nil];
    item3.itemOperation = ^(NSIndexPath *indexPath) {
        [LMJUMengHelper getUserInfoForPlatform:UMSocialPlatformType_Sina completion:^(UMSocialUserInfoResponse *result, NSError *error) {
            
            NSLog(@"%@", result);
        }];
    };

    
    [self.sections addObject:[LMJItemSection sectionWithItems:@[item0, item1, item2, item3] andHeaderTitle:nil footerTitle:nil]];
}


- (UIImage *)lmjNavigationBarRightButtonImage:(UIButton *)rightButton navigationBar:(LMJNavigationBar *)navigationBar {
    
    [rightButton setTitle:@"分享" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightButton setBackgroundColor:[UIColor yellowColor] forState:UIControlStateNormal];
    rightButton.lmj_width = 50;
    
    return nil;
}

- (void)rightButtonEvent:(UIButton *)sender navigationBar:(LMJNavigationBar *)navigationBar
{
    self.sections[0].items[0].itemOperation(nil);
}



@end
