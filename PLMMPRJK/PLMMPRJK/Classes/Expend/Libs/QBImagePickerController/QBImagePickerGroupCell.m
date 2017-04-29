//
//  QBImagePickerGroupCell.m
//  QBImagePickerController
//
//  Created by Tanaka Katsuma on 2013/12/30.
//  Copyright (c) 2013年 Katsuma Tanaka. All rights reserved.
//

#import "QBImagePickerGroupCell.h"

// Views
#import "QBImagePickerThumbnailView.h"

@interface QBImagePickerGroupCell ()

@property (nonatomic, strong) QBImagePickerThumbnailView *thumbnailView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *countLabel;

@end

@implementation QBImagePickerGroupCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        // Cell settings
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        // Create thumbnail view
        QBImagePickerThumbnailView *thumbnailView = [[QBImagePickerThumbnailView alloc] initWithFrame:CGRectMake(8, 4, 70, 74)];
        thumbnailView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
        
        [self.contentView addSubview:thumbnailView];
        self.thumbnailView = thumbnailView;
        
        // Create name label
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(8 + 70 + 18, 22, 180, 21)];
        nameLabel.font = [UIFont systemFontOfSize:17];
        nameLabel.textColor = [UIColor blackColor];
        nameLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        
        [self.contentView addSubview:nameLabel];
        self.nameLabel = nameLabel;
        
        // Create count label
        UILabel *countLabel = [[UILabel alloc] initWithFrame:CGRectMake(8 + 70 + 18, 46, 180, 15)];
        countLabel.font = [UIFont systemFontOfSize:12];
        countLabel.textColor = [UIColor blackColor];
        countLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        
        [self.contentView addSubview:countLabel];
        self.countLabel = countLabel;
    }
    
    return self;
}


#pragma mark - Accessors

- (void)setAssetsGroup:(ALAssetsGroup *)assetsGroup
{
    _assetsGroup = assetsGroup;
    
    // Update thumbnail view
    self.thumbnailView.assetsGroup = self.assetsGroup;
    
    // Update label
    self.nameLabel.text = [self.assetsGroup valueForProperty:ALAssetsGroupPropertyName];
    self.countLabel.text = [NSString stringWithFormat:@"%ld", (long)self.assetsGroup.numberOfAssets];
}

@end
