//
//  SINPublishViewController.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/5/11.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "SINPublishViewController.h"
#import <HMEmoticonManager.h>
#import <HMEmoticonTextView.h>
#import "SINPublishToolBar.h"
#import "MPUploadImageHelper.h"
#import <MWPhotoBrowser.h>
#import "LMJUploadImagesService.h"
#import "LMJUploadImageProgressCell.h"
#import "SINPostStatusService.h"

@interface SINPublishViewController ()<YYTextKeyboardObserver, LMJVerticalFlowLayoutDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, QBImagePickerControllerDelegate, MWPhotoBrowserDelegate>

/** <#digest#> */
@property (weak, nonatomic) HMEmoticonTextView *postTextView;

/** <#digest#> */
@property (weak, nonatomic) SINPublishToolBar *publishTooBar;


/** <#digest#> */
@property (nonatomic, strong) MPUploadImageHelper *uploadImageHelper;

/** <#digest#> */
@property (nonatomic, strong) SINPostStatusService *postStatusService;

@end



@implementation SINPublishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.groupTableViewBackgroundColor;
    
    [self.postTextView becomeFirstResponder];
    
    
    [(UIButton *)self.lmj_navgationBar.rightView setEnabled:NO];
    
    [self publishTooBar];
    
    
    [self.collectionView registerClass:[LMJUploadImageProgressCell class] forCellWithReuseIdentifier:NSStringFromClass([LMJUploadImageProgressCell class])];
    
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


#pragma mark - broswerDelegate
- (void)gotoImageBroswer:(NSIndexPath *)indexPath
{
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = NO;//分享按钮,默认是
    browser.displayNavArrows = NO;//左右分页切换,默认否
    browser.displaySelectionButtons = NO;//是否显示选择按钮在图片上,默认否
    browser.alwaysShowControls = YES;//控制条件控件 是否显示,默认否
    browser.zoomPhotosToFill = NO;//是否全屏,默认是
    browser.enableGrid = NO;//是否允许用网格查看所有图片,默认是
    browser.startOnGrid = NO;//是否第一张,默认否
    browser.enableSwipeToDismiss = YES;
    [browser showNextPhotoAnimated:YES];
    [browser showPreviousPhotoAnimated:YES];
    [browser setCurrentPhotoIndex:indexPath.item];
    
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:browser] animated:YES completion:nil];
    
}

#pragma mark--MWPhotoBrowserDelegate
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return self.uploadImageHelper.imagesArray.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    
    MWPhoto *photo = [MWPhoto photoWithURL:self.uploadImageHelper.imagesArray[index].assetURL];
    
    return photo;
}


#pragma mark - addPic
//弹出选择框
-(void)showActionForPhoto
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"拍照",@"从相册选择",nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        
        if (![cameraHelper checkCameraAuthorizationStatus]) {
            
            [MBProgressHUD showAutoMessage:@"请对照相机授权"];
            
            return;
        }
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;//设置可编辑
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:nil];//进入照相界面
        
    }else if (buttonIndex == 1)
    {
        if (![cameraHelper  checkPhotoLibraryAuthorizationStatus]) {
            
            [MBProgressHUD showAutoMessage:@"请对相册授权"];
            return;
        }
        
        
        QBImagePickerController *imagePickerController = [[QBImagePickerController alloc] init];
        [imagePickerController.selectedAssetURLs removeAllObjects];
        [imagePickerController.selectedAssetURLs addObjectsFromArray:self.uploadImageHelper.selectedAssetURLs];
        imagePickerController.filterType = QBImagePickerControllerFilterTypePhotos;
        imagePickerController.delegate = self;
        imagePickerController.maximumNumberOfSelection = kupdateMaximumNumberOfImage;
        imagePickerController.allowsMultipleSelection = YES;
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
        [self presentViewController:navigationController animated:YES completion:NULL];
        
    }
}

#pragma mark UINavigationControllerDelegate UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *pickerImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
    
    [assetsLibrary writeImageToSavedPhotosAlbum:[pickerImage CGImage] orientation:(ALAssetOrientation)pickerImage.imageOrientation completionBlock:^(NSURL *assetURL, NSError *error) {
        
        [self.uploadImageHelper addASelectedAssetURL:assetURL];
        //局部刷新 根据布局相应调整
        [self.collectionView reloadData];
    }];
    [picker dismissViewControllerAnimated:YES completion:^{}];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
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
    return self.uploadImageHelper.imagesArray.count + 1;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LMJWeakSelf(self);
    LMJUploadImageProgressCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([LMJUploadImageProgressCell class]) forIndexPath:indexPath];
    
    
    
    if (indexPath.item == self.uploadImageHelper.imagesArray.count) {
        
        cell.imageItem = nil;
        
    }else
    {
        cell.imageItem = self.uploadImageHelper.imagesArray[indexPath.item];
    }
    
    
    [cell setBlankTap:^{
        
        [weakself showActionForPhoto];
    }];
    
    
    [cell setImageTap:^(MPImageItemModel *imageItem){
        
        [weakself gotoImageBroswer:indexPath];
    }];
    
    [cell setDeleteImageTap:^(MPImageItemModel *imageItem){
        
        [weakself.uploadImageHelper deleteAImage:imageItem];
        
        [weakself.collectionView reloadData];
        
    }];
    
    
    return cell;
}


#pragma mark QBImagePickerControllerDelegate

- (void)qb_imagePickerController:(QBImagePickerController *)imagePickerController didSelectAssets:(NSArray *)assets{
    NSMutableArray *selectedAssetURLs = [NSMutableArray new];
    [imagePickerController.selectedAssetURLs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [selectedAssetURLs addObject:obj];
    }];
    
    LMJWeakSelf(self);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.uploadImageHelper.selectedAssetURLs = selectedAssetURLs;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //局部刷新 根据布局相应调整
            [weakself.collectionView reloadData];
        });
    });
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)qb_imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController{
    [self dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark - textviewdelegate

- (void)textViewDidChange:(HMEmoticonTextView *)textView
{
    [(UIButton *)self.lmj_navgationBar.rightView setEnabled:textView.emoticonText.length >= 20];
    
}



#pragma mark - getter

- (MPUploadImageHelper *)uploadImageHelper
{
    if(_uploadImageHelper == nil)
    {
        _uploadImageHelper = [MPUploadImageHelper MPUploadImageForSend:NO];
        
    }
    return _uploadImageHelper;
}


- (HMEmoticonTextView *)postTextView
{
    if(_postTextView == nil)
    {
        HMEmoticonTextView *postTextView = [[HMEmoticonTextView alloc] init];
        [self.view addSubview:postTextView];
        _postTextView = postTextView;
        
        // 1> 使用表情视图
        postTextView.useEmoticonInputView = YES;
        // 2> 设置占位文本
        postTextView.placeholder = @"分享新鲜事...";
        // 3> 设置最大文本长度
        postTextView.maxInputLength = 200;
        
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
        
        publishTooBar.frame = CGRectMake(0, Main_Screen_Height - 40, Main_Screen_Width, 40);
        
        [[YYTextKeyboardManager defaultManager] addObserver:self];
        
        LMJWeakSelf(self);
//        LMJWeakSelf(publishTooBar);
        publishTooBar.selectInput = ^(SINPublishToolBarClickType type) {
            
            if (type == SINPublishToolBarClickTypeKeyboard) {
                
                weakself.postTextView.useEmoticonInputView = NO;
                
            }else if (type == SINPublishToolBarClickTypeEmos)
            {
                weakself.postTextView.useEmoticonInputView = YES;
                
            }
            
            BOOL isf = weakself.postTextView.isFirstResponder;
            
            if (!isf) {
                [weakself.postTextView becomeFirstResponder];
            }
        };
    }
    return _publishTooBar;
}

- (SINPostStatusService *)postStatusService
{
    if(_postStatusService == nil)
    {
        _postStatusService = [[SINPostStatusService alloc] init];
    }
    return _postStatusService;
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



#pragma mark - LMJNavUIBaseViewControllerDataSource

- (UIReturnKeyType)textViewControllerLastReturnKeyType:(LMJTextViewController *)textViewController
{
    return UIReturnKeySend;
}

- (BOOL)textViewControllerEnableAutoToolbar:(LMJTextViewController *)textViewController
{
    return NO;
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
    
    [faweibo appendString:@"\n"];
    
    [faweibo appendAttributedString:[[NSAttributedString alloc] initWithString:[SINUserManager sharedManager].name ?: @"" attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:10], NSForegroundColorAttributeName : [UIColor redColor]}]];
    
    return faweibo;
}

#pragma mark - LMJNavUIBaseViewControllerDelegate
/** 左边的按钮的点击 */
-(void)leftButtonEvent:(UIButton *)sender navigationBar:(LMJNavigationBar *)navigationBar
{
    [self dismissPopUpViewController:DDPopUpAnimationTypeFade];
}

- (void)rightButtonEvent:(UIButton *)sender navigationBar:(LMJNavigationBar *)navigationBar
{
    LMJWeakSelf(self);
    [self showLoading];
    [self.postStatusService retweetText:self.postTextView.emoticonText images:[self.uploadImageHelper.imagesArray valueForKeyPath:@"image"] completion:^(BOOL isSucceed) {
        [weakself dismissLoading];
        
        [MBProgressHUD showInfo:isSucceed ? @"发布成功" : @"发布失败" ToView:weakself.view];
        
    }];
    
}



- (void)dealloc
{
    [[YYTextKeyboardManager defaultManager] removeObserver:self];
}


@end
