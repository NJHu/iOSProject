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
#import "SINPostStatusService.h"
#import <AVFoundation/AVFoundation.h>
#import <TZImageManager.h>
#import <TZLocationManager.h>
#import <TZImagePickerController.h>
#import "LMJUpLoadImageCell.h"
static const NSInteger maxPhotoCount = 9;

@interface SINPublishViewController ()<YYTextKeyboardObserver, LMJVerticalFlowLayoutDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, TZImagePickerControllerDelegate>

/** <#digest#> */
@property (weak, nonatomic) HMEmoticonTextView *postTextView;

/** <#digest#> */
@property (weak, nonatomic) SINPublishToolBar *publishTooBar;


/** <#digest#> */
@property (nonatomic, strong) SINPostStatusService *postStatusService;

/** <#digest#> */
@property (nonatomic, strong) NSMutableArray<UIImage *> *selectedImages;
/** <#digest#> */
@property (nonatomic, strong) NSMutableArray<PHAsset *> *selectedAccest;

/** <#digest#> */
@property (nonatomic, strong) CLLocation *location;

@property (nonatomic, strong) UIImagePickerController *imagePickerVc;

@end



@implementation SINPublishViewController

- (UIImagePickerController *)imagePickerVc {
    if (_imagePickerVc == nil) {
        _imagePickerVc = [[UIImagePickerController alloc] init];
        _imagePickerVc.delegate = self;
        // set appearance / 改变相册选择页的导航栏外观
        if (iOS7Later) {
            _imagePickerVc.navigationBar.barTintColor = self.navigationController.navigationBar.barTintColor;
        }
        _imagePickerVc.navigationBar.tintColor = self.navigationController.navigationBar.tintColor;
        UIBarButtonItem *tzBarItem, *BarItem;
        if (iOS9Later) {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[TZImagePickerController class]]];
            BarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
        } else {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[TZImagePickerController class]]];
            BarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
        }
        NSDictionary *titleTextAttributes = [tzBarItem titleTextAttributesForState:UIControlStateNormal];
        [BarItem setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
        
    }
    return _imagePickerVc;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.selectedAccest = [NSMutableArray array];
    self.selectedImages = [NSMutableArray array];
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
    return self.selectedImages.count + 1;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LMJWeak(self);
    LMJUpLoadImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([LMJUpLoadImageCell class]) forIndexPath:indexPath];
    
    if (indexPath.item == self.selectedImages.count) {
        cell.photoImage = nil;
        cell.addPhotoClick = ^(LMJUpLoadImageCell *uploadImageCell) {
            [weakself alertAction];
        };
        cell.deletePhotoClick = nil;
    }else {
        cell.photoImage = self.selectedImages[indexPath.item];
        cell.addPhotoClick = nil;
        cell.deletePhotoClick = ^(UIImage *photoImage) {
            [weakself.selectedAccest removeObjectAtIndex:indexPath.item];
            [weakself.selectedImages removeObject:photoImage];
            //            [weakself.collectionView deleteItemsAtIndexPaths:@[indexPath]];
            [weakself.collectionView reloadData];
        };
    }
    cell.uploadProgress = 0;
    
    
    return cell;
}




#pragma mark - textviewdelegate

- (void)textViewDidChange:(HMEmoticonTextView *)textView
{
    [(UIButton *)self.lmj_navgationBar.rightView setEnabled:textView.emoticonText.length >= 20];
    
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
        
        publishTooBar.frame = CGRectMake(0, kScreenHeight - 40, kScreenWidth, 40);
        
        [[YYTextKeyboardManager defaultManager] addObserver:self];
        
        LMJWeak(self);
//        LMJWeak(publishTooBar);
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

- (void)alertAction
{
    [UIAlertController mj_showActionSheetWithTitle:nil message:nil appearanceProcess:^(JXTAlertController * _Nonnull alertMaker) {
        alertMaker.addActionDefaultTitle(@"选择相册").addActionDefaultTitle(@"照相").addActionCancelTitle(@"取消");
    } actionsBlock:^(NSInteger buttonIndex, UIAlertAction * _Nonnull action, JXTAlertController * _Nonnull alertSelf) {
        if (buttonIndex == 0) {
            [self choosePhoto];
        }else if (buttonIndex == 1) {
            [self takePhoto];
        }
    }];
}

- (void)choosePhoto
{
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:maxPhotoCount columnNumber:4 delegate:self pushPhotoPickerVc:YES];
    // imagePickerVc.navigationBar.translucent = NO;
    
#pragma mark - 五类个性化设置，这些参数都可以不传，此时会走默认设置
    imagePickerVc.isSelectOriginalPhoto = NO;
    
    if (maxPhotoCount > 1) {
        // 1.设置目前已经选中的图片数组
        imagePickerVc.selectedAssets = self.selectedAccest; // 目前已经选中的图片数组
    }
    imagePickerVc.allowTakePicture = YES; // 在内部显示拍照按钮
    
    // imagePickerVc.photoWidth = 1000;
    
    // 2. Set the appearance
    // 2. 在这里设置imagePickerVc的外观
    // if (iOS7Later) {
    // imagePickerVc.navigationBar.barTintColor = [UIColor greenColor];
    // }
    // imagePickerVc.oKButtonTitleColorDisabled = [UIColor lightGrayColor];
    // imagePickerVc.oKButtonTitleColorNormal = [UIColor greenColor];
    // imagePickerVc.navigationBar.translucent = NO;
    
    // 3. Set allow picking video & photo & originalPhoto or not
    // 3. 设置是否可以选择视频/图片/原图
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingImage = YES;
    imagePickerVc.allowPickingOriginalPhoto = NO;
    imagePickerVc.allowPickingGif = NO;
    imagePickerVc.allowPickingMultipleVideo = NO; // 是否可以多选视频
    
    // 4. 照片排列按修改时间升序
    imagePickerVc.sortAscendingByModificationDate = YES;
    
    // imagePickerVc.minImagesCount = 3;
    // imagePickerVc.alwaysEnableDoneBtn = YES;
    
    // imagePickerVc.minPhotoWidthSelectable = 3000;
    // imagePickerVc.minPhotoHeightSelectable = 2000;
    
    /// 5. Single selection mode, valid when maxImagesCount = 1
    /// 5. 单选模式,maxImagesCount为1时才生效
    imagePickerVc.showSelectBtn = NO;
    imagePickerVc.allowCrop = YES;
    imagePickerVc.needCircleCrop = NO;
    // 设置竖屏下的裁剪尺寸
    NSInteger left = 30;
    NSInteger widthHeight = self.view.lmj_width - 2 * left;
    NSInteger top = (self.view.lmj_height - widthHeight) / 2;
    imagePickerVc.cropRect = CGRectMake(left, top, widthHeight, widthHeight);
    // 设置横屏下的裁剪尺寸
    // imagePickerVc.cropRectLandscape = CGRectMake((self.view.tz_height - widthHeight) / 2, left, widthHeight, widthHeight);
    /*
     [imagePickerVc setCropViewSettingBlock:^(UIView *cropView) {
     cropView.layer.borderColor = [UIColor redColor].CGColor;
     cropView.layer.borderWidth = 2.0;
     }];*/
    
    //imagePickerVc.allowPreview = NO;
    // 自定义导航栏上的返回按钮
    /*
     [imagePickerVc setNavLeftBarButtonSettingBlock:^(UIButton *leftButton){
     [leftButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
     [leftButton setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 20)];
     }];
     imagePickerVc.delegate = self;
     */
    
    imagePickerVc.isStatusBarDefault = NO;
#pragma mark - 到这里为止
    LMJWeak(self);
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        
        weakself.selectedImages = [NSMutableArray arrayWithArray:photos];
        weakself.selectedAccest = [NSMutableArray arrayWithArray:assets];
        
        [weakself.collectionView reloadData];
        
    }];
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
    
}

- (void)takePhoto
{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if ((authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) && iOS7Later) {
        // 无相机权限 做一个友好的提示
        
        [UIAlertController mj_showAlertWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" appearanceProcess:^(JXTAlertController * _Nonnull alertMaker) {
            
            alertMaker.addActionDestructiveTitle(@"取消").addActionDefaultTitle(@"确认");
            
        } actionsBlock:^(NSInteger buttonIndex, UIAlertAction * _Nonnull action, JXTAlertController * _Nonnull alertSelf) {
            
            if (buttonIndex == 1) {
                
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
            }
            
        }];
        
    } else if (authStatus == AVAuthorizationStatusNotDetermined) {
        // fix issue 466, 防止用户首次拍照拒绝授权时相机页黑屏
        if (iOS7Later) {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [self takePhoto];
                    });
                }
            }];
        } else {
            [self takePhoto];
        }
        // 拍照之前还需要检查相册权限
    } else if ([TZImageManager authorizationStatus] == 2) { // 已被拒绝，没有相册权限，将无法保存拍的照片
        if (iOS8Later) {
            [UIAlertController mj_showAlertWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" appearanceProcess:^(JXTAlertController * _Nonnull alertMaker) {
                
                alertMaker.addActionDestructiveTitle(@"取消").addActionDefaultTitle(@"确认");
                
            } actionsBlock:^(NSInteger buttonIndex, UIAlertAction * _Nonnull action, JXTAlertController * _Nonnull alertSelf) {
                
                if (buttonIndex == 1) {
                    
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
                }
                
            }];
        }
    } else if ([TZImageManager authorizationStatus] == 0) { // 未请求过相册权限
        [[TZImageManager manager] requestAuthorizationWithCompletion:^{
            [self takePhoto];
        }];
    } else {
        [self pushImagePickerController];
    }
}

// 调用相机
- (void)pushImagePickerController {
    // 提前定位
    __weak typeof(self) weakSelf = self;
    [[TZLocationManager manager] startLocationWithSuccessBlock:^(CLLocation *location, CLLocation *oldLocation) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.location = location;
    } failureBlock:^(NSError *error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.location = nil;
    }];
    
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        self.imagePickerVc.sourceType = sourceType;
        if(iOS8Later) {
            self.imagePickerVc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        }
        [self presentViewController:self.imagePickerVc animated:YES completion:nil];
    } else {
        NSLog(@"模拟器中无法打开照相机,请在真机中使用");
    }
}

- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        TZImagePickerController *tzImagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
        tzImagePickerVc.sortAscendingByModificationDate = YES;
        [tzImagePickerVc showProgressHUD];
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        // save photo and get asset / 保存图片，获取到asset
        [[TZImageManager manager] savePhotoWithImage:image location:self.location completion:^(NSError *error){
            if (error) {
                [tzImagePickerVc hideProgressHUD];
                NSLog(@"图片保存失败 %@",error);
            } else {
                [[TZImageManager manager] getCameraRollAlbum:NO allowPickingImage:YES completion:^(TZAlbumModel *model) {
                    [[TZImageManager manager] getAssetsFromFetchResult:model.result allowPickingVideo:NO allowPickingImage:YES completion:^(NSArray<TZAssetModel *> *models) {
                        [tzImagePickerVc hideProgressHUD];
                        TZAssetModel *assetModel = [models firstObject];
                        if (tzImagePickerVc.sortAscendingByModificationDate) {
                            assetModel = [models lastObject];
                        }
                        if (YES) { // 允许裁剪,去裁剪
                            TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initCropTypeWithAsset:assetModel.asset photo:image completion:^(UIImage *cropImage, id asset) {
                                [self refreshCollectionViewWithAddedAsset:asset image:cropImage];
                            }];
                            imagePicker.needCircleCrop = NO;
                            imagePicker.circleCropRadius = 100;
                            [self presentViewController:imagePicker animated:YES completion:nil];
                        } else {
                            //                            [self refreshCollectionViewWithAddedAsset:assetModel.asset image:image];
                        }
                    }];
                }];
            }
        }];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    if ([picker isKindOfClass:[UIImagePickerController class]]) {
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)refreshCollectionViewWithAddedAsset:(id)asset image:(UIImage *)image {
    [self.selectedAccest addObject:asset];
    [self.selectedImages addObject:image];
    [self.collectionView reloadData];
    
    if ([asset isKindOfClass:[PHAsset class]]) {
        PHAsset *phAsset = asset;
        NSLog(@"location:%@",phAsset.location);
    }
}
#pragma mark - LMJNavUIBaseViewControllerDelegate
/** 左边的按钮的点击 */
-(void)leftButtonEvent:(UIButton *)sender navigationBar:(LMJNavigationBar *)navigationBar
{
//    PopUp
//    [self dismissPopUpViewController:DDPopUpAnimationTypeFade];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)rightButtonEvent:(UIButton *)sender navigationBar:(LMJNavigationBar *)navigationBar
{
    if (self.postTextView.emoticonText.stringByTrim.length < 20) {
        [self.view makeToast:@"少于20个文字" duration:3 position:CSToastPositionCenter];
        return;
    }
    
    LMJWeak(self);
    [self showLoading];
    [self.postStatusService retweetText:self.postTextView.emoticonText images:self.selectedImages completion:^(BOOL isSucceed) {
        [weakself dismissLoading];
        
        [MBProgressHUD showInfo:isSucceed ? @"发布成功" : @"发布失败" ToView:weakself.view];
        
    }];
    
}



- (void)dealloc
{
    [[YYTextKeyboardManager defaultManager] removeObserver:self];
}


@end
