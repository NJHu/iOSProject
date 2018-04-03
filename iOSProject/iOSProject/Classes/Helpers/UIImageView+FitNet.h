//
//  UIImageView+FitNet.h
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/5/23.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDWebImageManager.h>

@interface UIImageView (FitNet)

//typedef void(^SDWebImageDownloaderProgressBlock)(NSInteger receivedSize, NSInteger expectedSize);
//typedef void(^SDWebImageCompletionBlock)(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL);
- (void)lmj_setImageWithURL:(NSURL *)originImageURL thumbnailImageURL:(NSURL *)thumbImageURL placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDExternalCompletionBlock)completedBlock;

@end
