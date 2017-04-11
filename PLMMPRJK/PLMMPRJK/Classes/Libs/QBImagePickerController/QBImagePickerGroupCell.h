//
//  QBImagePickerGroupCell.h
//  QBImagePickerController
//
//  Created by Tanaka Katsuma on 2013/12/30.
//  Copyright (c) 2013年 Katsuma Tanaka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface QBImagePickerGroupCell : UITableViewCell

@property (nonatomic, strong) ALAssetsGroup *assetsGroup;

@end
