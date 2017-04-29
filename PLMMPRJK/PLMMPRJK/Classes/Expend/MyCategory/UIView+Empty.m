//
//  UIView+Empty.m
//  MobileProject
//
//  Created by wujunyang on 2017/1/18.
//  Copyright © 2017年 wujunyang. All rights reserved.
//

#import "UIView+Empty.h"
#import <objc/runtime.h>
#import <ImageIO/ImageIO.h>


static char RefreshKey;
static char BottomKey;

#define TitleFontSize 15
#define TitleColor [UIColor grayColor]

#define DetailTitleFontSize 15
#define DetailTitleColor [UIColor lightGrayColor]

#define ButtonTitleColor [UIColor colorWithRed:59 / 255.0 green:115 / 255.0 blue:211 / 255.0 alpha:1]
#define ButtonFontSize 13
#define ButtoBacColor [UIColor whiteColor]

#define ErrorWidth [UIScreen mainScreen].bounds.size.width
#define Offset ErrorWidth / 3.0
#define Top 100

#define ErrorImageName @""
#define EmptyImageName @""

@implementation UIView (Empty)

@dynamic bottomView;

@dynamic block;

- (UIView *)buttomView {
    UIView *view = objc_getAssociatedObject(self, &BottomKey);
    if (!view) {
        view = [UIView new];
        view.backgroundColor = [UIColor whiteColor];
        view.frame = [UIScreen mainScreen].bounds;
        [self setButtomView:view];
    }
    return view;
}

- (void)setButtomView:(UIView *)buttomView {
    objc_setAssociatedObject(self, &BottomKey, buttomView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (RefreshBlock)block {
    return objc_getAssociatedObject(self, &RefreshKey);
}

- (void)setBlock:(RefreshBlock)block {
    objc_setAssociatedObject(self, &RefreshKey, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)showWithImageName:(NSString *)imageName
                    title:(NSString *)title
              detailTitle:(NSString *)detailTitle
              buttonTitle:(NSString *)buttonTitle {
    //如果页面不为空返回
    if (self.buttomView.subviews.count != 0) {
        return;
    }
    UIImageView *errorImage = [[UIImageView alloc] init];
    
    errorImage.image = [UIImage imageNamed:imageName];
    
    UIImage *image = [self animatedGIFNamed:imageName];
    errorImage.image = image;
    errorImage.contentMode = UIViewContentModeScaleAspectFit;
    [self.buttomView addSubview:errorImage];
    
    UILabel *titleLable = [[UILabel alloc] init];
    titleLable.font = [UIFont systemFontOfSize:TitleFontSize];
    titleLable.textColor = TitleColor;
    titleLable.textAlignment = NSTextAlignmentCenter;
    titleLable.text = title;
    [self.buttomView addSubview:titleLable];
    
    //        self.detailLable = [[UILabel alloc] init];
    //        self.detailLable.font = [UIFont systemFontOfSize:TitleFontSize];
    //        self.detailLable.textColor = TitleColor;
    //        self.detailLable.text = detailTitle;
    //        [self addSubview:_detailLable];
    
    UIButton *reloadButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [reloadButton setTitle:buttonTitle forState:UIControlStateNormal];
    [reloadButton setTitleColor:ButtonTitleColor forState:UIControlStateNormal];
    reloadButton.titleLabel.font = [UIFont systemFontOfSize:ButtonFontSize];
    [reloadButton addTarget:self action:@selector(refresh) forControlEvents:UIControlEventTouchUpInside];
    reloadButton.backgroundColor = ButtoBacColor;
    [self.buttomView addSubview:reloadButton];
    
    [self addSubview:self.buttomView];
    
    errorImage.frame = CGRectMake(Offset, Top, ErrorWidth - 2 * Offset, ErrorWidth - 2 * Offset);
    
    CGFloat titleLableTop = Top + ErrorWidth - 2 * Offset;
    titleLable.frame = CGRectMake(Offset, titleLableTop + 20, ErrorWidth - 2 * Offset, 30);
    
    CGFloat reloadButtonTop = titleLableTop + 20 + 30;
    reloadButton.frame = CGRectMake((ErrorWidth - 70) / 2.0, reloadButtonTop + 20, 70, 30);
}

#pragma mark - 展示空和错误页面
- (void)showNetWorkErrorWithRefresh:(RefreshBlock)block {
    [self showWithImageName:ErrorImageName title:@"网络错误了！" detailTitle:nil buttonTitle:@"重试"];
    self.block = block;
}

- (void)showEmptyViewWithRefresh:(RefreshBlock)block {
    [self showWithImageName:EmptyImageName title:@"没有题目了" detailTitle:nil buttonTitle:@"返回"];
    self.block = block;
}

- (void)showWithImageName:(NSString *)imageName
                    title:(NSString *)title
              detailTitle:(NSString *)detailTitle
              buttonTitle:(NSString *)buttonTitle
                  refresh:(RefreshBlock)block {
    [self showWithImageName:imageName title:title detailTitle:detailTitle buttonTitle:buttonTitle];
    self.block = block;
}

#pragma mark - 移除页面
- (void)removeEmptyView {
    UIView *view = objc_getAssociatedObject(self, &BottomKey);
    if (view) {
        [view removeFromSuperview];
        objc_setAssociatedObject(self, &RefreshKey, nil, OBJC_ASSOCIATION_COPY_NONATOMIC);
        objc_setAssociatedObject(self, &BottomKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (void)refresh {
    self.block();
}

- (NSString *)typeForImageData:(NSData *)data {
    uint8_t c;
    [data getBytes:&c length:1];
    switch (c) {
        case 0xFF:
            return @"image/jpeg";
        case 0x89:
            return @"image/png";
        case 0x47:
            return @"image/gif";
        case 0x49:
        case 0x4D:
            return @"image/tiff";
    }
    return nil;
}

#pragma mark - 加载GIF
- (UIImage *)animatedGIFNamed:(NSString *)name {
    CGFloat scale = [UIScreen mainScreen].scale;
    if (scale > 1.0f) {
        NSString *retinaPath = [[NSBundle mainBundle] pathForResource:[name stringByAppendingString:@"@2x"] ofType:@"gif"];
        NSData *data = [NSData dataWithContentsOfFile:retinaPath];
        if (data) {
            return [self animatedGIFWithData:data];
        }
        NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"gif"];
        data = [NSData dataWithContentsOfFile:path];
        if (data) {
            return [self animatedGIFWithData:data];
        }
        return [UIImage imageNamed:name];
    } else {
        NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"gif"];
        NSData *data = [NSData dataWithContentsOfFile:path];
        if (data) {
            return [self animatedGIFWithData:data];
        }
        return [UIImage imageNamed:name];
    }
}
- (UIImage *)animatedGIFWithData:(NSData *)data {
    if (!data) {
        return nil;
    }
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    size_t count = CGImageSourceGetCount(source);
    UIImage *animatedImage;
    if (count <= 1) {
        animatedImage = [[UIImage alloc] initWithData:data];
    } else {
        NSMutableArray *images = [NSMutableArray array];
        NSTimeInterval duration = 0.0f;
        for (size_t i = 0; i < count; i++) {
            CGImageRef image = CGImageSourceCreateImageAtIndex(source, i, NULL);
            duration += [self frameDurationAtIndex:i source:source];
            [images addObject:[UIImage imageWithCGImage:image scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp]];
            CGImageRelease(image);
        }
        if (!duration) {
            duration = (1.0f / 10.0f) * count;
        }
        animatedImage = [UIImage animatedImageWithImages:images duration:duration];
    }
    CFRelease(source);
    return animatedImage;
}
- (float)frameDurationAtIndex:(NSUInteger)index source:(CGImageSourceRef)source {
    float frameDuration = 0.1f;
    CFDictionaryRef cfFrameProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil);
    NSDictionary *frameProperties = (__bridge NSDictionary *)cfFrameProperties;
    NSDictionary *gifProperties = frameProperties[(NSString *)kCGImagePropertyGIFDictionary];
    NSNumber *delayTimeUnclampedProp = gifProperties[(NSString *)kCGImagePropertyGIFUnclampedDelayTime];
    if (delayTimeUnclampedProp) {
        frameDuration = [delayTimeUnclampedProp floatValue];
    } else {
        NSNumber *delayTimeProp = gifProperties[(NSString *)kCGImagePropertyGIFDelayTime];
        if (delayTimeProp) {
            frameDuration = [delayTimeProp floatValue];
        }
    }
    if (frameDuration < 0.011f) {
        frameDuration = 0.100f;
    }
    CFRelease(cfFrameProperties);
    return frameDuration;
}


@end
