//
//  SINPickPhotoTool.h
//  iOSProject
//
//  Created by HuXuPeng on 2018/4/11.
//  Copyright © 2018年 github.com/njhu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>


/**
 老板再也不担心这个功能做不出来啦
 */
@interface SINPickPhotoTool : NSObject

+ (void)showPickPhotoToolWithViewController:(UIViewController *)viewController maxPhotoCount:(NSUInteger)maxPhotoCount choosePhotoHandler:(void(^)(NSMutableArray<UIImage *> *selectedImages, NSMutableArray<PHAsset *> *selectedAccest))choosePhotoHandler takePhotoHandler:(void(^)(NSMutableArray<UIImage *> *selectedImages, NSMutableArray<PHAsset *> *selectedAccest))takePhotoHandler deleteImage:(void(^)(void(^deleteHandler)(NSUInteger index)))deleteImage;


@end


@interface UIViewController (LMJImagePickTool)
@property (nonatomic, strong, readonly) NSMutableArray<UIImage *> *lmj_selectedImages;
@property (nonatomic, strong, readonly) NSMutableArray<PHAsset *> *lmj_selectedAccests;
@end
