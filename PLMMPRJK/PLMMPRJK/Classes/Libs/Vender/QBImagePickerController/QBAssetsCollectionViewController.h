//
//  QBAssetsCollectionViewController.h
//  QBImagePickerController
//
//  Created by Tanaka Katsuma on 2013/12/31.
//  Copyright (c) 2013年 Katsuma Tanaka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

// ViewControllers
#import "QBImagePickerController.h"

@class QBAssetsCollectionViewController;

@protocol QBAssetsCollectionViewControllerDelegate <NSObject>

@optional
- (void)assetsCollectionViewController:(QBAssetsCollectionViewController *)assetsCollectionViewController didSelectAsset:(ALAsset *)asset;
- (void)assetsCollectionViewController:(QBAssetsCollectionViewController *)assetsCollectionViewController didDeselectAsset:(ALAsset *)asset;
- (void)assetsCollectionViewControllerDidFinishSelection:(QBAssetsCollectionViewController *)assetsCollectionViewController;

@end

@interface QBAssetsCollectionViewController : UICollectionViewController <UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak) QBImagePickerController *imagePickerController;

@property (nonatomic, weak) id<QBAssetsCollectionViewControllerDelegate> delegate;
@property (nonatomic, strong) ALAssetsGroup *assetsGroup;
@property (nonatomic, assign) QBImagePickerControllerFilterType filterType;
@property (nonatomic, assign) BOOL allowsMultipleSelection;
@property (nonatomic, assign) NSUInteger minimumNumberOfSelection;
@property (nonatomic, assign) NSUInteger maximumNumberOfSelection;

- (void)selectAssetHavingURL:(NSURL *)URL;

@end
