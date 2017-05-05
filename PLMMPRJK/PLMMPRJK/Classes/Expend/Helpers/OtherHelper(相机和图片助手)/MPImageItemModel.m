//
//  MPImageItemModel.m
//  MobileProject
//
//  Created by wujunyang on 16/7/20.
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#import "MPImageItemModel.h"
#import <CoreLocation/CoreLocation.h>

@implementation MPImageItemModel

+ (instancetype)imageWithAssetURL:(NSURL *)assetURL isUploadProcess:(BOOL)isUploadProcess{
    MPImageItemModel *imageItem = [[MPImageItemModel alloc] init];
    imageItem.uploadState = MPImageUploadStateInit;
    imageItem.assetURL = assetURL;
    
    LMJWeakSelf(self)
    
    void (^selectAsset)(ALAsset *) = ^(ALAsset *asset){
        if (asset) {
            UIImage *highQualityImage = [imageCompressHelper fullScreenImageALAsset:asset];
            UIImage *thumbnailImage = [UIImage imageWithCGImage:[asset thumbnail]];
            
            //照片信息
            [weakself imageInfoWithALAsset:asset imageItem:imageItem];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                imageItem.image = [imageCompressHelper compressedImageToLimitSizeOfKB:100 image:highQualityImage];;
                imageItem.thumbnailImage = thumbnailImage;
                
                if (isUploadProcess) {
                    //上传到沙盒  成功上传后记得删除对应
                    [MPFileManager writeUploadDataWithName:imageItem.photoName andImage:imageItem.image];
                }
            });
        }
    };
    
    ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
    LMJWeakSelf(assetsLibrary);
    [assetsLibrary assetForURL:assetURL resultBlock:^(ALAsset *asset) {
        if (asset) {
            selectAsset(asset);
        }else{
            
            [weakassetsLibrary enumerateGroupsWithTypes:ALAssetsGroupPhotoStream usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stopG) {
                    if([result.defaultRepresentation.url isEqual:assetURL]) {
                        selectAsset(result);
                        *stop = YES;
                        *stopG = YES;
                    }
                }];
            } failureBlock:^(NSError *error) {
                NSLog(@"读取图片失败");
            }];
        }
    }failureBlock:^(NSError *error) {
        NSLog(@"读取图片失败");
    }];
    return imageItem;
    
}

//获得图片基本信息
+(void)imageInfoWithALAsset:(ALAsset *)asset imageItem:(MPImageItemModel *)imageItem
{
    //拍照时间
    NSDate * nsALAssetPropertyDate = [ asset valueForProperty:ALAssetPropertyDate ];
    if (nsALAssetPropertyDate!=nil) {
        imageItem.photoTime=[dateTimeHelper htcTimeToLocationStr:nsALAssetPropertyDate];
    }
    
    //GPS定位
    CLLocation *location = [asset valueForProperty:ALAssetPropertyLocation];
    if (location) {
        CLLocationCoordinate2D curCoordinate=location.coordinate;
        imageItem.photoLatitude=[NSString stringWithFormat:@"%f",curCoordinate.latitude];
        imageItem.photoLongitude=[NSString stringWithFormat:@"%f",curCoordinate.longitude];
    }
    
    //照片名称
    ALAssetRepresentation *representation = [asset defaultRepresentation];
    imageItem.photoName = [representation filename];
}


+ (instancetype)imageWithAssetURL:(NSURL *)assetURL andImage:(UIImage *)image{
    MPImageItemModel *imageItem = [[MPImageItemModel alloc] init];
    imageItem.uploadState = MPImageUploadStateInit;
    imageItem.assetURL = assetURL;
    imageItem.image = image;
    imageItem.thumbnailImage = [image imageScaledToSize:CGSizeMake(AdaptedWidth(70), AdaptedWidth(70))];
    return imageItem;
}

//- (void)setUploadState:(MPImageUploadState)uploadState
//{
//    _uploadState = uploadState;
//    
////    MPImageUploadStateInit = 0,
////    MPImageUploadStateIng,
////    MPImageUploadStateSuccess,
////    MPImageUploadStateFail
//    switch (uploadState) {
//        case MPImageUploadStateInit:
//            self.uploadProgress = 0;
//            break;
//        case MPImageUploadStateIng:
//            
//            break;
//        case MPImageUploadStateSuccess:
//            self.uploadProgress = 1;
//            break;
//        case MPImageUploadStateFail:
//            
//            break;
//            
//        default:
//            break;
//    }
//}

@end
