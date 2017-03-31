//
//  cameraHelper.m
//  MobileProject
//
//  Created by wujunyang on 16/7/20.
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#import "cameraHelper.h"
#import <AssetsLibrary/ALAsset.h>
#import <AssetsLibrary/ALAssetsLibrary.h>
#import <AssetsLibrary/ALAssetsGroup.h>
#import <AssetsLibrary/ALAssetRepresentation.h>

@import AVFoundation;

@implementation cameraHelper

+ (BOOL)checkPhotoLibraryAuthorizationStatus
{
    //if ([ALAssetsLibrary respondsToSelector:@selector(authorizationStatus)]) {
        ALAuthorizationStatus authStatus = [ALAssetsLibrary authorizationStatus];
            if (ALAuthorizationStatusDenied == authStatus ||
                ALAuthorizationStatusRestricted == authStatus) {
                [MBProgressHUD showAutoMessage:@"请在iPhone的“设置->隐私->照片”中打开本应用的访问权限" ToView:nil];
                return NO;
        //    }
        }
    return YES;
}

+ (BOOL)checkCameraAuthorizationStatus
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [MBProgressHUD showAutoMessage:@"该设备不支持拍照" ToView:nil];
        return NO;
    }

    if ([AVCaptureDevice respondsToSelector:@selector(authorizationStatusForMediaType:)]) {
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (AVAuthorizationStatusDenied == authStatus ||
            AVAuthorizationStatusRestricted == authStatus) {
            [MBProgressHUD showAutoMessage:@"请在iPhone的“设置->隐私->相机”中打开本应用的访问权限" ToView:nil];
            return NO;
        }
    }
    return YES;
}

@end
