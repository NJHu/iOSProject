//
//  SINPublishViewController.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/5/11.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "SINPublishViewController.h"
//#import <HMEmoticonManager.h>
//#import <HMEmoticonTextView.h>
#import "SINPublishToolBar.h"
#import "SINPostStatusService.h"
#import "LMJUpLoadImageCell.h"
#import "SINPickPhotoTool.h"
#import "UITextView+WZB.h"

@interface SINPublishViewController ()<YYTextKeyboardObserver, LMJVerticalFlowLayoutDelegate>

/** <#digest#> */
@property (weak, nonatomic) UITextView *postTextView;

/** <#digest#> */
@property (weak, nonatomic) SINPublishToolBar *publishTooBar;

/** <#digest#> */
@property (nonatomic, strong) SINPostStatusService *postStatusService;

/** <#digest#> */
@property (nonatomic, copy) void(^deleteHandler)(NSUInteger index);
@end

@implementation SINPublishViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.groupTableViewBackgroundColor;
    [self.postTextView becomeFirstResponder];
    [(UIButton *)self.lmj_navgationBar.rightView setEnabled:NO];
    [self publishTooBar];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([LMJUpLoadImageCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:NSStringFromClass([LMJUpLoadImageCell class])];
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.bottom.equalTo(self.publishTooBar.mas_top);
        make.top.equalTo(self.postTextView.mas_bottom);
    }];
    self.collectionView.contentInset = UIEdgeInsetsZero;
    self.collectionView.alwaysBounceVertical = YES;
    self.collectionView.showsVerticalScrollIndicator = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    IQKeyboardManager.sharedManager.enable = NO;
}


#pragma mark - LMJVerticalFlowLayoutDelegate

- (NSInteger)waterflowLayout:(LMJVerticalFlowLayout *)waterflowLayout columnsInCollectionView:(UICollectionView *)collectionView
{
    return 3;
}

- (UICollectionViewLayout *)collectionViewController:(LMJCollectionViewController *)collectionViewController layoutForCollectionView:(UICollectionView *)collectionView
{
    return [[LMJVerticalFlowLayout alloc] initWithDelegate:self];
}


- (CGFloat)waterflowLayout:(LMJVerticalFlowLayout *)waterflowLayout collectionView:(UICollectionView *)collectionView heightForItemAtIndexPath:(NSIndexPath *)indexPath itemWidth:(CGFloat)itemWidth
{
    return itemWidth;
}


#pragma mark - collectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.lmj_selectedImages.count + 1;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LMJWeak(self);
    LMJUpLoadImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([LMJUpLoadImageCell class]) forIndexPath:indexPath];
    
    if (indexPath.item == self.lmj_selectedImages.count) {
        cell.photoImage = nil;
        cell.addPhotoClick = ^(LMJUpLoadImageCell *uploadImageCell) {
            [weakself alertAction];
        };
        cell.deletePhotoClick = nil;
    }else {
        cell.photoImage = self.lmj_selectedImages[indexPath.item];
        cell.addPhotoClick = nil;
        cell.deletePhotoClick = ^(UIImage *photoImage) {
            !weakself.deleteHandler ?: weakself.deleteHandler(indexPath.item);
            [collectionView performBatchUpdates:^{
                [collectionView deleteItemsAtIndexPaths:@[indexPath]];
            } completion:^(BOOL finished) {
                [collectionView reloadData];
            }];
        };
    }
    cell.uploadProgress = 0;
    return cell;
}

- (void)alertAction
{
    LMJWeak(self);
    [SINPickPhotoTool showPickPhotoToolWithViewController:self maxPhotoCount:6 choosePhotoHandler:^(NSMutableArray<UIImage *> *selectedImages, NSMutableArray<PHAsset *> *selectedAccest) {
        [weakself.collectionView reloadData];
    } takePhotoHandler:^(NSMutableArray<UIImage *> *selectedImages, NSMutableArray<PHAsset *> *selectedAccest) {
        [weakself.collectionView reloadData];
    } deleteImage:^(void (^deleteHandler)(NSUInteger index)) {
        weakself.deleteHandler =  deleteHandler;
    }];
}

#pragma mark - textviewdelegate
- (void)textViewDidChange:(UITextView *)textView
{
    [(UIButton *)self.lmj_navgationBar.rightView setEnabled:textView.text.length >= 20];
}

- (UITextView *)postTextView
{
    if(_postTextView == nil)
    {
        UITextView *postTextView = [[UITextView alloc] init];
        [self.view addSubview:postTextView];
        _postTextView = postTextView;
        postTextView.delegate = self;
        // 1> 使用表情视图
//        postTextView.useEmoticonInputView = YES;
        // 2> 设置占位文本
        postTextView.wzb_placeholder = @"分享新鲜事...";
        // 3> 设置最大文本长度
//        postTextView.len = 200;
//        与原生键盘之间的切换
//        _textView.useEmoticonInputView = !_textView.isUseEmoticonInputView;
        [postTextView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset([self lmjNavigationHeight:self.lmj_navgationBar]);
            make.left.right.offset(0);
            make.height.equalTo(self.view).multipliedBy(0.4);
        }];
    }
    return _postTextView;
}

- (SINPublishToolBar *)publishTooBar
{
    if(_publishTooBar == nil)
    {
        SINPublishToolBar *publishTooBar = [SINPublishToolBar publishToolBar];
        [self.view addSubview:publishTooBar];
        _publishTooBar = publishTooBar;
        publishTooBar.frame = CGRectMake(0, kScreenHeight - 40, kScreenWidth, 40);
        [[YYTextKeyboardManager defaultManager] addObserver:self];
        LMJWeak(self);
        publishTooBar.selectInput = ^(SINPublishToolBarClickType type) {
            if (type == SINPublishToolBarClickTypeKeyboard) {
//                weakself.postTextView.useEmoticonInputView = NO;
            }else if (type == SINPublishToolBarClickTypeEmos){
//                weakself.postTextView.useEmoticonInputView = YES;
            }
            BOOL isf = weakself.postTextView.isFirstResponder;
            if (!isf) {
                [weakself.postTextView becomeFirstResponder];
            }
        };
    }
    return _publishTooBar;
}



- (void)keyboardChangedWithTransition:(YYTextKeyboardTransition)transition
{
//    typedef struct {
//        BOOL fromVisible; ///< Keyboard visible before transition.
//        BOOL toVisible;   ///< Keyboard visible after transition.
//        CGRect fromFrame; ///< Keyboard frame before transition.
//        CGRect toFrame;   ///< Keyboard frame after transition.
//        NSTimeInterval animationDuration;       ///< Keyboard transition animation duration.
//        UIViewAnimationCurve animationCurve;    ///< Keyboard transition animation curve.
//        UIViewAnimationOptions animationOption; ///< Keybaord transition animation option.
//    } YYTextKeyboardTransition;
    [UIView animateWithDuration:transition.animationDuration animations:^{
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationCurve:transition.animationCurve];
        self.publishTooBar.lmj_y += transition.toFrame.origin.y - transition.fromFrame.origin.y;
    }];
}


#pragma mark - getter
- (SINPostStatusService *)postStatusService
{
    if(_postStatusService == nil)
    {
        _postStatusService = [[SINPostStatusService alloc] init];
    }
    return _postStatusService;
}

#pragma mark - LMJNavUIBaseViewControllerDataSource

- (UIReturnKeyType)textViewControllerLastReturnKeyType:(LMJTextViewController *)textViewController
{
    return UIReturnKeySend;
}

- (BOOL)textViewControllerEnableAutoToolbar:(LMJTextViewController *)textViewController
{
    return NO;
}
- (void)textViewController:(LMJTextViewController *)textViewController inputViewDone:(id)inputView {
    [self rightButtonEvent:nil navigationBar:self.lmj_navgationBar];
}


/** 导航条左边的按钮 */
- (UIImage *)lmjNavigationBarLeftButtonImage:(UIButton *)leftButton navigationBar:(LMJNavigationBar *)navigationBar
{
    [leftButton setTitle:@"取消" forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    
    return nil;
}


- (UIImage *)lmjNavigationBarRightButtonImage:(UIButton *)rightButton navigationBar:(LMJNavigationBar *)navigationBar
{
    [rightButton setTitle:@"发布" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [rightButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    
    return nil;
}

- (NSMutableAttributedString *)lmjNavigationBarTitle:(LMJNavigationBar *)navigationBar
{
    NSMutableAttributedString *faweibo = [[NSMutableAttributedString alloc] initWithString:@"发微博"];
    [faweibo addAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:11], NSForegroundColorAttributeName : [UIColor blackColor]} range:NSMakeRange(0, faweibo.length)];
    [faweibo yy_appendString:@"\n"];
    [faweibo appendAttributedString:[[NSAttributedString alloc] initWithString:[SINUserManager sharedManager].name ?: @"" attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:10], NSForegroundColorAttributeName : [UIColor redColor]}]];
    return faweibo;
}


#pragma mark - LMJNavUIBaseViewControllerDelegate
/** 左边的按钮的点击 */
-(void)leftButtonEvent:(UIButton *)sender navigationBar:(LMJNavigationBar *)navigationBar
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)rightButtonEvent:(UIButton *)sender navigationBar:(LMJNavigationBar *)navigationBar
{
    if (self.postTextView.text.stringByTrim.length < 20) {
        [self.view makeToast:@"少于20个文字" duration:3 position:CSToastPositionCenter];
        return;
    }
    LMJWeak(self);
    [self showLoading];
    [self.postStatusService retweetText:self.postTextView.text images:self.lmj_selectedImages completion:^(BOOL isSucceed) {
        [weakself dismissLoading];
        [MBProgressHUD showInfo:isSucceed ? @"发布成功" : @"发布失败" ToView:weakself.view];
    }];
}

- (void)dealloc {
    [[YYTextKeyboardManager defaultManager] removeObserver:self];
}


@end
