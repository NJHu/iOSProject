//
//  MPUploadImageHelper.m
//  MobileProject
//
//  Created by wujunyang on 16/7/20.
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#import "MPUploadImageHelper.h"

@interface MPUploadImageHelper()
@property(nonatomic)BOOL isUploadProcess;
@end

static MPUploadImageHelper *_mpUploadImageHelper = nil;

@implementation MPUploadImageHelper

+(MPUploadImageHelper *)MPUploadImageForSend:(BOOL)isUploadProcess
{
    _mpUploadImageHelper = [[MPUploadImageHelper alloc] init];
    _mpUploadImageHelper.isUploadProcess=isUploadProcess;
    return _mpUploadImageHelper;
}

- (void)setSelectedAssetURLs:(NSMutableArray *)selectedAssetURLs{
    NSMutableArray *needToAdd = [NSMutableArray new];
    NSMutableArray *needToDelete = [NSMutableArray new];
    [self.selectedAssetURLs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (![selectedAssetURLs containsObject:obj]) {
            [needToDelete addObject:obj];
        }
    }];
    [needToDelete enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [self deleteASelectedAssetURL:obj];
    }];
    [selectedAssetURLs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (![self.selectedAssetURLs containsObject:obj]) {
            [needToAdd addObject:obj];
        }
    }];
    [needToAdd enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [self addASelectedAssetURL:obj];
    }];
}


- (void)addASelectedAssetURL:(NSURL *)assetURL{
    if (!_selectedAssetURLs) {
        _selectedAssetURLs = [NSMutableArray new];
    }
    if (!_imagesArray) {
        _imagesArray = [NSMutableArray new];
    }
    
    [_selectedAssetURLs addObject:assetURL];
    
    NSMutableArray *imagesArray = [self mutableArrayValueForKey:@"imagesArray"];//为了kvo
    MPImageItemModel *imageItem = [MPImageItemModel imageWithAssetURL:assetURL isUploadProcess:self.isUploadProcess];
    [imagesArray addObject:imageItem];
}

- (void)deleteASelectedAssetURL:(NSURL *)assetURL{
    [self.selectedAssetURLs removeObject:assetURL];
    NSMutableArray *imagesArray = [self mutableArrayValueForKey:@"imagesArray"];//为了kvo
    [imagesArray enumerateObjectsUsingBlock:^(MPImageItemModel *obj, NSUInteger idx, BOOL *stop) {
        if (obj.assetURL == assetURL) {
            [imagesArray removeObject:obj];
            *stop = YES;
        }
    }];
}

- (void)deleteAImage:(MPImageItemModel *)imageInfo{
    NSMutableArray *imagesArray = [self mutableArrayValueForKey:@"imagesArray"];//为了kvo
    [imagesArray removeObject:imageInfo];
    if (imageInfo.assetURL) {
        [self.selectedAssetURLs removeObject:imageInfo.assetURL];
    }
}

@end
