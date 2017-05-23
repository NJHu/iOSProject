//
//  UIImageView+FitNet.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/5/23.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "UIImageView+FitNet.h"

@implementation UIImageView (FitNet)


//typedef void(^SDWebImageDownloaderProgressBlock)(NSInteger receivedSize, NSInteger expectedSize);
//typedef void(^SDWebImageCompletionBlock)(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL);
- (void)lmj_setImageWithURL:(NSURL *)originImageURL thumbnailImageURL:(NSURL *)thumbImageURL placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDWebImageCompletionBlock)completedBlock
{
    
    
    
    //    AFNetworkReachabilityStatusUnknown          = -1,
    //    AFNetworkReachabilityStatusNotReachable     = 0,
    //    AFNetworkReachabilityStatusReachableViaWWAN = 1,
    //    AFNetworkReachabilityStatusReachableViaWiFi = 2,
    self.image = placeholder;
    
    UIImage *originImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:originImageURL.absoluteString];
    
    if (originImage) {
        
        self.image = originImage;
        !progressBlock ?: progressBlock(1, 1);
        !completedBlock ?: completedBlock(originImage, nil, 0, originImageURL);
        
    }else
    {
        
        AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
        
        if (mgr.isReachableViaWiFi) {
            
            [self sd_setImageWithURL:originImageURL placeholderImage:placeholder options:options progress:progressBlock completed:completedBlock];
            
        }else if (mgr.isReachableViaWWAN)
        {
            
            // 沙盒中去取, 让用户选择
            BOOL is3GOr4GNeedOriginal = YES;
            
            if (is3GOr4GNeedOriginal) {
                
                [self sd_setImageWithURL:originImageURL placeholderImage:placeholder options:options progress:progressBlock completed:completedBlock];
            }else
            {
                
                [self sd_setImageWithURL:thumbImageURL placeholderImage:placeholder options:options  progress:progressBlock completed:completedBlock];
                
            }
            
        }else
        {
            UIImage *thumbnailImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:thumbImageURL.absoluteString];
            
            if (thumbnailImage) {
                
                self.image = thumbnailImage;
                
                !progressBlock ?: progressBlock(1, 1);
                !completedBlock ?: completedBlock(thumbnailImage, nil, 0, thumbImageURL);
            }else
            {
                
                self.image = placeholder;
                
                
            }
            
            
        }
        
        
        
        
    }
    
    
    
}

@end
