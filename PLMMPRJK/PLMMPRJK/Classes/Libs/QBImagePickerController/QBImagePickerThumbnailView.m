//
//  QBImagePickerThumbnailView.m
//  QBImagePickerController
//
//  Created by Tanaka Katsuma on 2013/12/31.
//  Copyright (c) 2013年 Katsuma Tanaka. All rights reserved.
//

#import "QBImagePickerThumbnailView.h"

@interface QBImagePickerThumbnailView ()

@property (nonatomic, copy) NSArray *thumbnailImages;
@property (nonatomic, strong) UIImage *blankImage;

@end

@implementation QBImagePickerThumbnailView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

- (CGSize)sizeThatFits:(CGSize)size
{
    return CGSizeMake(70.0, 74.0);
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 1.0);
    
    if (self.thumbnailImages.count == 3) {
        UIImage *thumbnailImage = [self.thumbnailImages firstObject];
        
        CGRect thumbnailImageRect = CGRectMake(4.0, 0, 62.0, 62.0);
        CGContextFillRect(context, thumbnailImageRect);
        [thumbnailImage drawInRect:CGRectInset(thumbnailImageRect, 0.5, 0.5)];
    }
    if (self.thumbnailImages.count >= 2) {
        UIImage *thumbnailImage = self.thumbnailImages[1];
        
        CGRect thumbnailImageRect = CGRectMake(2.0, 2.0, 66.0, 66.0);
        CGContextFillRect(context, thumbnailImageRect);
        [thumbnailImage drawInRect:CGRectInset(thumbnailImageRect, 0.5, 0.5)];
    }
    if (self.thumbnailImages.count >= 1) {
        UIImage *thumbnailImage = [self.thumbnailImages lastObject];
        
        CGRect thumbnailImageRect = CGRectMake(0, 4.0, 70.0, 70.0);
        CGContextFillRect(context, thumbnailImageRect);
        [thumbnailImage drawInRect:CGRectInset(thumbnailImageRect, 0.5, 0.5)];
    }
}


#pragma mark - Accessors

- (void)setAssetsGroup:(ALAssetsGroup *)assetsGroup
{
    _assetsGroup = assetsGroup;
    
    // Extract three thumbnail images
    NSInteger thumbnailImagesCount = MIN(3, assetsGroup.numberOfAssets);
    NSIndexSet *indexes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(assetsGroup.numberOfAssets-thumbnailImagesCount, thumbnailImagesCount)];
    NSMutableArray *thumbnailImages = [NSMutableArray array];
    [assetsGroup enumerateAssetsAtIndexes:indexes
                                  options:0
                               usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                                   if (result) {
                                       CGImageRef thumbnailImageRef = [result thumbnail];
                                       
                                       if (thumbnailImageRef) {
                                           [thumbnailImages addObject:[UIImage imageWithCGImage:thumbnailImageRef]];
                                       } else {
                                           [thumbnailImages addObject:[self blankImage]];
                                       }
                                   }
                               }];
    self.thumbnailImages = [thumbnailImages copy];
    
    [self setNeedsDisplay];
}

- (UIImage *)blankImage
{
    if (_blankImage == nil) {
        CGSize size = CGSizeMake(100.0, 100.0);
        UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
        
        [[UIColor colorWithWhite:(240.0 / 255.0) alpha:1.0] setFill];
        UIRectFill(CGRectMake(0, 0, size.width, size.height));
        
        _blankImage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
    }
    
    return _blankImage;
}

@end
