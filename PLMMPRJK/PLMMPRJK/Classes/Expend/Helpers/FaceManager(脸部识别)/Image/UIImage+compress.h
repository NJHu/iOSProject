
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIImage (Compress)
- (UIImage *)compressedImage;
- (CGFloat)compressionQuality;
- (NSData *)compressedData;
- (NSData *)compressedData:(CGFloat)compressionQuality;

@end
