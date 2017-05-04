//
//  MPUploadImageHelper.h
//  MobileProject
//
//  Created by wujunyang on 16/7/20.
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPImageItemModel.h"

@interface MPUploadImageHelper : NSObject

//不要直接操作imagesArray 在操作selectedAssetURLs时会利用KVO直接操作
@property (readwrite, nonatomic, strong) NSMutableArray<MPImageItemModel *> *imagesArray;
@property (readwrite, nonatomic, strong) NSMutableArray<NSURL *> *selectedAssetURLs;


- (void)addASelectedAssetURL:(NSURL *)assetURL;
- (void)deleteASelectedAssetURL:(NSURL *)assetURL;
- (void)deleteAImage:(MPImageItemModel *)imageInfo;

/**
 *  @author wujunyang, 16-07-25 13:07:17
 *
 *  @brief  <#Description#>
 *
 *  @param isUploadProcess 是否缓存到沙盒中YES则会转到沙盒中
 *
 *  @return <#return value description#>
 */
+(MPUploadImageHelper *)MPUploadImageForSend:(BOOL)isUploadProcess;

@end
