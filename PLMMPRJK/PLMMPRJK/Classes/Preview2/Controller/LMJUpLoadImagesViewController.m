//
//  LMJUpLoadImagesViewController.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/5/4.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJUpLoadImagesViewController.h"
#import "LMJUpLoadImageCell.h"
#import "MPUploadImageHelper.h"
#import <MWPhotoBrowser.h>
#import "LMJUploadImagesService.h"

@interface LMJUpLoadImagesViewController ()<LMJElementsFlowLayoutDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, QBImagePickerControllerDelegate, MWPhotoBrowserDelegate>

/** <#digest#> */
@property (nonatomic, strong) MPUploadImageHelper *uploadImageHelper;

@end

@implementation LMJUpLoadImagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.collectionView registerClass:[LMJUpLoadImageCell class] forCellWithReuseIdentifier:NSStringFromClass([LMJUpLoadImageCell class])];
}


#pragma mark - collectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.uploadImageHelper.imagesArray.count + 1;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LMJWeakSelf(self);
    LMJUpLoadImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([LMJUpLoadImageCell class]) forIndexPath:indexPath];
    
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


#pragma mark - LMJVerticalFlowLayoutDelegate

- (UICollectionViewLayout *)collectionViewController:(LMJCollectionViewController *)collectionViewController layoutForCollectionView:(UICollectionView *)collectionView
{
    return [[LMJElementsFlowLayout alloc] initWithDelegate:self];
}


- (CGSize)waterflowLayout:(LMJElementsFlowLayout *)waterflowLayout collectionView:(UICollectionView *)collectionView sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((Main_Screen_Width - 10 * 4) / 3, (Main_Screen_Width - 10 * 4) / 3);
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

#pragma mark - LMJNavUIBaseViewControllerDataSource

/** 导航条左边的按钮 */
- (UIImage *)lmjNavigationBarLeftButtonImage:(UIButton *)leftButton navigationBar:(LMJNavigationBar *)navigationBar
{
    [leftButton setImage:[UIImage imageNamed:@"NavgationBar_white_back"] forState:UIControlStateHighlighted];
    
    return [UIImage imageNamed:@"NavgationBar_blue_back"];
}

- (UIImage *)lmjNavigationBarRightButtonImage:(UIButton *)rightButton navigationBar:(LMJNavigationBar *)navigationBar
{
    [rightButton setTitle:@"保存" forState: UIControlStateNormal];
    [rightButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    
    [rightButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    
    return nil;
}



#pragma mark - LMJNavUIBaseViewControllerDelegate
/** 左边的按钮的点击 */
-(void)leftButtonEvent:(UIButton *)sender navigationBar:(LMJNavigationBar *)navigationBar
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)rightButtonEvent:(UIButton *)sender navigationBar:(LMJNavigationBar *)navigationBar
{
    if (self.uploadImageHelper.imagesArray.count <= 0) {
        [MBProgressHUD showAutoMessage:@"请选择照片进行上传" ToView:nil];
        return;
    }
    
    LMJUploadImagesService *uploadService = [LMJUploadImagesService new];
    uploadService.imagesArray = [self.uploadImageHelper.imagesArray valueForKey:@"image"];
    
    [uploadService uploadWithProgress:^(NSProgress *progress) {
        
        [MBProgressHUD showProgressToView:self.view Text:[NSString stringWithFormat:@"%.2f", (double)progress.completedUnitCount / progress.totalUnitCount]];
        
        
    } completion:^(LMJBaseResponse *response) {
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
        

        if (response.error) {
            
            [MBProgressHUD showError:@"上传错误" ToView: self.view];
        }
        
        
        
    }];
    
    
}



@end
