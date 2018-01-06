//
//  JXTAlertController.m
//  JXTAlertManager
//
//  Created by JXT on 2016/12/22.
//  Copyright © 2016年 JXT. All rights reserved.
//

#import "JXTAlertController.h"

//toast默认展示时间
static NSTimeInterval const JXTAlertShowDurationDefault = 1.0f;


#pragma mark - I.AlertActionModel
@interface JXTAlertActionModel : NSObject
@property (nonatomic, copy) NSString * title;
@property (nonatomic, assign) UIAlertActionStyle style;
@end
@implementation JXTAlertActionModel
- (instancetype)init
{
    if (self = [super init]) {
        self.title = @"";
        self.style = UIAlertActionStyleDefault;
    }
    return self;
}
@end



#pragma mark - II.JXTAlertController
/**
 AlertActions配置

 @param actionBlock JXTAlertActionBlock
 */
typedef void (^JXTAlertActionsConfig)(JXTAlertActionBlock actionBlock);


@interface JXTAlertController ()
//JXTAlertActionModel数组
@property (nonatomic, strong) NSMutableArray <JXTAlertActionModel *>* jxt_alertActionArray;
//是否操作动画
@property (nonatomic, assign) BOOL jxt_setAlertAnimated;
//action配置
- (JXTAlertActionsConfig)alertActionsConfig;
@end

@implementation JXTAlertController

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if (self.alertDidDismiss) {
        self.alertDidDismiss();
    }
}
- (void)dealloc
{
//    NSLog(@"test-dealloc");
}

#pragma mark - Private
//action-title数组
- (NSMutableArray<JXTAlertActionModel *> *)jxt_alertActionArray
{
    if (_jxt_alertActionArray == nil) {
        _jxt_alertActionArray = [NSMutableArray array];
    }
    return _jxt_alertActionArray;
}
//action配置
- (JXTAlertActionsConfig)alertActionsConfig
{
    return ^(JXTAlertActionBlock actionBlock) {
        if (self.jxt_alertActionArray.count > 0)
        {
            //创建action
            __weak typeof(self)weakSelf = self;
            [self.jxt_alertActionArray enumerateObjectsUsingBlock:^(JXTAlertActionModel *actionModel, NSUInteger idx, BOOL * _Nonnull stop) {
                UIAlertAction *alertAction = [UIAlertAction actionWithTitle:actionModel.title style:actionModel.style handler:^(UIAlertAction * _Nonnull action) {
                    __strong typeof(weakSelf)strongSelf = weakSelf;
                    if (actionBlock) {
                        actionBlock(idx, action, strongSelf);
                    }
                }];
                //可利用这个改变字体颜色，但是不推荐！！！
//                [alertAction setValue:[UIColor grayColor] forKey:@"titleTextColor"];
                //action作为self元素，其block实现如果引用本类指针，会造成循环引用
                [self addAction:alertAction];
            }];
        }
        else
        {
            NSTimeInterval duration = self.toastStyleDuration > 0 ? self.toastStyleDuration : JXTAlertShowDurationDefault;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self dismissViewControllerAnimated:!(self.jxt_setAlertAnimated) completion:NULL];
            });
        }
    };
}

#pragma mark - Public

- (instancetype)initAlertControllerWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(UIAlertControllerStyle)preferredStyle
{
    if (!(title.length > 0) && (message.length > 0) && (preferredStyle == UIAlertControllerStyleAlert)) {
        title = @"";
    }
    self = [[self class] alertControllerWithTitle:title message:message preferredStyle:preferredStyle];
    if (!self) return nil;
    
    self.jxt_setAlertAnimated = NO;
    self.toastStyleDuration = JXTAlertShowDurationDefault;
    
    return self;
}

- (void)alertAnimateDisabled
{
    self.jxt_setAlertAnimated = YES;
}

- (JXTAlertActionTitle)addActionDefaultTitle
{
    //该block返回值不是本类属性，只是局部变量，不会造成循环引用
    return ^(NSString *title) {
        JXTAlertActionModel *actionModel = [[JXTAlertActionModel alloc] init];
        actionModel.title = title;
        actionModel.style = UIAlertActionStyleDefault;
        [self.jxt_alertActionArray addObject:actionModel];
        return self;
    };
}

- (JXTAlertActionTitle)addActionCancelTitle
{
    return ^(NSString *title) {
        JXTAlertActionModel *actionModel = [[JXTAlertActionModel alloc] init];
        actionModel.title = title;
        actionModel.style = UIAlertActionStyleCancel;
        [self.jxt_alertActionArray addObject:actionModel];
        return self;
    };
}

- (JXTAlertActionTitle)addActionDestructiveTitle
{
    return ^(NSString *title) {
        JXTAlertActionModel *actionModel = [[JXTAlertActionModel alloc] init];
        actionModel.title = title;
        actionModel.style = UIAlertActionStyleDestructive;
        [self.jxt_alertActionArray addObject:actionModel];
        return self;
    };
}

@end



#pragma mark - III.UIViewController扩展
@implementation UIViewController (JXTAlertController)

- (void)jxt_showAlertWithPreferredStyle:(UIAlertControllerStyle)preferredStyle title:(NSString *)title message:(NSString *)message appearanceProcess:(JXTAlertAppearanceProcess)appearanceProcess actionsBlock:(JXTAlertActionBlock)actionBlock
{
    if (appearanceProcess)
    {
        JXTAlertController *alertMaker = [[JXTAlertController alloc] initAlertControllerWithTitle:title message:message preferredStyle:preferredStyle];
        //防止nil
        if (!alertMaker) {
            return ;
        }
        //加工链
        appearanceProcess(alertMaker);
        //配置响应
        alertMaker.alertActionsConfig(actionBlock);
//        alertMaker.alertActionsConfig(^(NSInteger buttonIndex, UIAlertAction *action){
//            if (actionBlock) {
//                actionBlock(buttonIndex, action);
//            }
//        });
        
        if (alertMaker.alertDidShown)
        {
            [self presentViewController:alertMaker animated:!(alertMaker.jxt_setAlertAnimated) completion:^{
                alertMaker.alertDidShown();
            }];
        }
        else
        {
            [self presentViewController:alertMaker animated:!(alertMaker.jxt_setAlertAnimated) completion:NULL];
        }
    }
}

- (void)jxt_showAlertWithTitle:(NSString *)title message:(NSString *)message appearanceProcess:(JXTAlertAppearanceProcess)appearanceProcess actionsBlock:(JXTAlertActionBlock)actionBlock
{
    [self jxt_showAlertWithPreferredStyle:UIAlertControllerStyleAlert title:title message:message appearanceProcess:appearanceProcess actionsBlock:actionBlock];
}

- (void)jxt_showActionSheetWithTitle:(NSString *)title message:(NSString *)message appearanceProcess:(JXTAlertAppearanceProcess)appearanceProcess actionsBlock:(JXTAlertActionBlock)actionBlock
{
    [self jxt_showAlertWithPreferredStyle:UIAlertControllerStyleActionSheet title:title message:message appearanceProcess:appearanceProcess actionsBlock:actionBlock];
}


@end

@implementation UIAlertController (LMJ)

/**
 JXTAlertController: show-alert(iOS8)
 
 @param title             title
 @param message           message
 @param appearanceProcess alert配置过程
 @param actionBlock       alert点击响应回调
 */
+ (void)mj_showAlertWithTitle:(nullable NSString *)title
                      message:(nullable NSString *)message
            appearanceProcess:(JXTAlertAppearanceProcess)appearanceProcess
                 actionsBlock:(nullable JXTAlertActionBlock)actionBlock NS_AVAILABLE_IOS(8_0)
{
    [[UIApplication sharedApplication].keyWindow.currentViewController jxt_showAlertWithTitle:title message:message appearanceProcess:appearanceProcess actionsBlock:actionBlock];
}

/**
 JXTAlertController: show-actionSheet(iOS8)
 
 @param title             title
 @param message           message
 @param appearanceProcess actionSheet配置过程
 @param actionBlock       actionSheet点击响应回调
 */
+ (void)mj_showActionSheetWithTitle:(nullable NSString *)title
                            message:(nullable NSString *)message
                  appearanceProcess:(JXTAlertAppearanceProcess)appearanceProcess
                       actionsBlock:(nullable JXTAlertActionBlock)actionBlock NS_AVAILABLE_IOS(8_0)
{
    [[UIApplication sharedApplication].keyWindow.currentViewController jxt_showActionSheetWithTitle:title message:message appearanceProcess:appearanceProcess actionsBlock:actionBlock];
}
@end

