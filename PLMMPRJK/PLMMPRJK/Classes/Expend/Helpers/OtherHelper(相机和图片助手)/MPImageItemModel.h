//
//  MPImageItemModel.h
//  MobileProject 图片上传图片内容
//
//  Created by wujunyang on 16/7/20.
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPFileManager.h"
#import "imageCompressHelper.h"
#import "dateTimeHelper.h"
#import "UIImage+Resize.h"
#import "UIImage+FX.h"

typedef NS_ENUM(NSInteger, MPImageUploadState)
{
    MPImageUploadStateInit = 0,
    MPImageUploadStateIng,
    MPImageUploadStateSuccess,
    MPImageUploadStateFail
};


@interface MPImageItemModel : NSObject

//原图 缩略图
@property (readwrite, nonatomic, strong) UIImage *image, *thumbnailImage;
//当前图片asstURL
@property (strong, nonatomic) NSURL *assetURL;
//上传状态
@property (assign, nonatomic) MPImageUploadState uploadState;
//服务端绑定图片[因为可修改图片上传时，会从服务端绑定一些图片上来，这部分是不用修改,还未启用]
@property(nonatomic,copy)NSString *httpUrl;
@property(nonatomic,copy)NSString *upServicePath;
//照片基本信息 图片名称 经纬度 拍照时间
@property (readwrite, nonatomic, strong) NSString *photoName;
@property (readwrite, nonatomic, strong) NSString *photoLatitude;
@property (readwrite, nonatomic, strong) NSString *photoLongitude;
@property (readwrite, nonatomic, strong) NSString *photoTime;

//转换图片
+ (instancetype)imageWithAssetURL:(NSURL *)assetURL isUploadProcess:(BOOL)isUploadProcess;
+ (instancetype)imageWithAssetURL:(NSURL *)assetURL andImage:(UIImage *)image;

@end
