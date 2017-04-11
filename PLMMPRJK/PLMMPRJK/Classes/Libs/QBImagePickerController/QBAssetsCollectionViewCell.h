//
//  QBAssetsCollectionViewCell.h
//  QBImagePickerController
//
//  Created by Tanaka Katsuma on 2013/12/31.
//  Copyright (c) 2013年 Katsuma Tanaka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface QBAssetsCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) ALAsset *asset;
@property (nonatomic, assign) BOOL showsOverlayViewWhenSelected;

@end
