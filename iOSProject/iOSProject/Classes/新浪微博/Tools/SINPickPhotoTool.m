//
//  SINPickPhotoTool.m
//  iOSProject
//
//  Created by HuXuPeng on 2018/4/11.
//  Copyright © 2018年 github.com/njhu. All rights reserved.
//

#import "SINPickPhotoTool.h"
#import <TZImagePickerController.h>
#import <TZImageManager.h>
#import <TZLocationManager.h>

@interface SINPickPhotoTool () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, TZImagePickerControllerDelegate>

/** 选中的图片 */
@property (nonatomic, strong) NSMutableArray<UIImage *> *selectedImages;
/** 选中的相册 */
@property (nonatomic, strong) NSMutableArray<PHAsset *> *selectedAccest;
/** 定位 */
@property (nonatomic, strong) CLLocation *location;

@property (nonatomic, strong) UIImagePickerController *imagePickerVc;
/** 当前的页面 */
@property (weak, nonatomic) UIViewController *currentViewController;

@property (nonatomic, assign) NSUInteger maxPhotoCount;

/** 选中图片的回调 */
@property (nonatomic, copy) void(^choosePhotoHandler)(NSMutableArray<UIImage *> *selectedImages, NSMutableArray<PHAsset *> *selectedAccest);

/** 拍照图片的回调 */
@property (nonatomic, copy) void(^takePhotoHandler)(NSMutableArray<UIImage *> *selectedImages, NSMutableArray<PHAsset *> *selectedAccest);
@end

@implementation SINPickPhotoTool

- (UIImagePickerController *)imagePickerVc {
    if (_imagePickerVc == nil) {
        _imagePickerVc = [[UIImagePickerController alloc] init];
        _imagePickerVc.delegate = self;
        // set appearance / 改变相册选择页的导航栏外观
        _imagePickerVc.navigationBar.barTintColor = [UIColor greenColor];
        // 红色
        _imagePickerVc.navigationBar.tintColor = [UIColor redColor];
        UIBarButtonItem *tzBarItem, *BarItem;
        tzBarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[TZImagePickerController class]]];
        BarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
        NSDictionary *titleTextAttributes = [tzBarItem titleTextAttributesForState:UIControlStateNormal];
        [BarItem setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
    }
    return _imagePickerVc;
}

- (void)alertAction
{
    [UIAlertController mj_showActionSheetWithTitle:nil message:nil appearanceProcess:^(JXTAlertController * _Nonnull alertMaker) {
        alertMaker.addActionDefaultTitle(@"选择相册").addActionDefaultTitle(@"照相").addActionCancelTitle(@"取消");
    } actionsBlock:^(NSInteger buttonIndex, UIAlertAction * _Nonnull action, JXTAlertController * _Nonnull alertSelf) {
        if (buttonIndex == 0) {
            [self pushTZImagePickerController];
        }else if (buttonIndex == 1) {
            [self takePhoto];
        }
    }];
}

- (void)pushTZImagePickerController
{
    if (self.maxPhotoCount <= 0) {
        return;
    }
    
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:self.maxPhotoCount columnNumber:4 delegate:self pushPhotoPickerVc:YES];
    // imagePickerVc.navigationBar.translucent = NO;
    
#pragma mark - 五类个性化设置，这些参数都可以不传，此时会走默认设置
    imagePickerVc.isSelectOriginalPhoto = NO;
    if (self.maxPhotoCount > 1) {
        // 1.设置目前已经选中的图片数组
        imagePickerVc.selectedAssets = self.selectedAccest; // 目前已经选中的图片数组
    }
    imagePickerVc.allowTakePicture = NO; // 在内部显示拍照按钮
    
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
    NSInteger widthHeight = kScreenWidth - 2 * left;
    NSInteger top = (kScreenHeight - widthHeight) / 2;
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
    
    // Deprecated, Use statusBarStyle
    // imagePickerVc.isStatusBarDefault = NO;
//    imagePickerVc.isStatusBarDefault = YES;
    
    // 设置首选语言 / Set preferred language
    // imagePickerVc.preferredLanguage = @"zh-Hans";
    
    // 设置languageBundle以使用其它语言 / Set languageBundle to use other language
    // imagePickerVc.languageBundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"tz-ru" ofType:@"lproj"]];
#pragma mark - 到这里为止
    LMJWeak(self);
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        weakself.selectedImages = [NSMutableArray arrayWithArray:photos];
        weakself.selectedAccest = [NSMutableArray arrayWithArray:assets];
        !weakself.choosePhotoHandler ?: weakself.choosePhotoHandler(weakself.selectedImages, weakself.selectedAccest);
    }];
    [self.currentViewController presentViewController:imagePickerVc animated:YES completion:nil];
}

- (void)takePhoto
{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if ((authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied)) {
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
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [self takePhoto];
                    });
                }
            }];
        // 拍照之前还需要检查相册权限
    } else if (authStatus == AVAuthorizationStatusDenied) { // 已被拒绝，没有相册权限，将无法保存拍的照片

            [UIAlertController mj_showAlertWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" appearanceProcess:^(JXTAlertController * _Nonnull alertMaker) {
                alertMaker.addActionDestructiveTitle(@"取消").addActionDefaultTitle(@"确认");
            } actionsBlock:^(NSInteger buttonIndex, UIAlertAction * _Nonnull action, JXTAlertController * _Nonnull alertSelf) {
                if (buttonIndex == 1) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
                }
            }];
    } else if (authStatus == AVAuthorizationStatusNotDetermined) { // 未请求过相册权限
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
    [[TZLocationManager manager] startLocationWithSuccessBlock:^(NSArray<CLLocation *> *locations) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.location = locations.lastObject;
    } failureBlock:^(NSError *error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.location = nil;
    }];
    
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        self.imagePickerVc.sourceType = sourceType;
            self.imagePickerVc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [self.currentViewController presentViewController:self.imagePickerVc animated:YES completion:nil];
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
        [[TZImageManager manager] savePhotoWithImage:image location:self.location completion:^(PHAsset *asset, NSError *error){
            if (error) {
                [tzImagePickerVc hideProgressHUD];
                NSLog(@"图片保存失败 %@",error);
            } else {
                [[TZImageManager manager] getCameraRollAlbum:NO allowPickingImage:YES needFetchAssets:YES completion:^(TZAlbumModel *model) {
                    [[TZImageManager manager] getAssetsFromFetchResult:model.result allowPickingVideo:NO allowPickingImage:YES completion:^(NSArray<TZAssetModel *> *models) {
                        [tzImagePickerVc hideProgressHUD];
                        TZAssetModel *assetModel = [models firstObject];
                        if (tzImagePickerVc.sortAscendingByModificationDate) {
                            assetModel = [models lastObject];
                        }
                        if (/* DISABLES CODE */ (NO)) { // 允许裁剪,去裁剪
                            TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initCropTypeWithAsset:assetModel.asset photo:image completion:^(UIImage *cropImage, id asset) {
                                [self refreshAsset:asset image:cropImage];
                            }];
                            imagePicker.needCircleCrop = NO;
                            imagePicker.circleCropRadius = 100;
                            [self.currentViewController presentViewController:imagePicker animated:YES completion:nil];
                        } else {
                            [self refreshAsset:assetModel.asset image:image];
                        }
                    }];
                }];
            }
        }];
    }
}

- (void)refreshAsset:(id)asset image:(UIImage *)image {
    if ([asset isKindOfClass:[PHAsset class]]) {
        PHAsset *phAsset = asset;
        NSLog(@"location:%@",phAsset.location);
    }
    [self.selectedAccest addObject:asset];
    [self.selectedImages addObject:image];
    !self.takePhotoHandler ?: self.takePhotoHandler(self.selectedImages, self.selectedAccest);
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    if ([picker isKindOfClass:[UIImagePickerController class]]) {
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}

static void *pickToolKey = &pickToolKey;
+ (void)showPickPhotoToolWithViewController:(UIViewController *)viewController maxPhotoCount:(NSUInteger)maxPhotoCount choosePhotoHandler:(void(^)(NSMutableArray<UIImage *> *selectedImages, NSMutableArray<PHAsset *> *selectedAccest))choosePhotoHandler takePhotoHandler:(void(^)(NSMutableArray<UIImage *> *selectedImages, NSMutableArray<PHAsset *> *selectedAccest))takePhotoHandler deleteImage:(void(^)(void(^deleteHandler)(NSUInteger index)))deleteImage
{
    SINPickPhotoTool *pickTool;
    pickTool = objc_getAssociatedObject(viewController, pickToolKey);
    if (pickTool) {
        [pickTool alertAction];
        return;
    }
    pickTool = [[self alloc] init];
    pickTool.currentViewController = viewController;
    pickTool.maxPhotoCount = maxPhotoCount ?: pickTool.maxPhotoCount;
    pickTool.choosePhotoHandler = [choosePhotoHandler copy];
    pickTool.takePhotoHandler = [takePhotoHandler copy];
    
    LMJWeak(pickTool);
    void(^deleteImageHandler)(NSUInteger index) = ^void(NSUInteger index) {
        [weakpickTool.selectedImages removeObjectAtIndex:index];
        [weakpickTool.selectedAccest removeObjectAtIndex:index];
    };
    !deleteImage ?: deleteImage(deleteImageHandler);
    objc_setAssociatedObject(viewController, pickToolKey, pickTool, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [pickTool alertAction];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _selectedAccest = [NSMutableArray array];
        _selectedImages = [NSMutableArray array];
        _maxPhotoCount = 6;
    }
    return self;
}

@end

@implementation UIViewController (LMJImagePickTool)

- (NSMutableArray<UIImage *> *)lmj_selectedImages {
    SINPickPhotoTool *pickTool;
    pickTool = objc_getAssociatedObject(self, pickToolKey);
    return pickTool.selectedImages;
}

- (NSMutableArray<PHAsset *> *)lmj_selectedAccests {
    SINPickPhotoTool *pickTool;
    pickTool = objc_getAssociatedObject(self, pickToolKey);
    return pickTool.selectedAccest;
}

@end
