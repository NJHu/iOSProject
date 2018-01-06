YYImage
==============
[![License MIT](https://img.shields.io/badge/license-MIT-green.svg?style=flat)](https://raw.githubusercontent.com/ibireme/YYImage/master/LICENSE)&nbsp;
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)&nbsp;
[![CocoaPods](http://img.shields.io/cocoapods/v/YYImage.svg?style=flat)](http://cocoapods.org/?q= YYImage)&nbsp;
[![CocoaPods](http://img.shields.io/cocoapods/p/YYImage.svg?style=flat)](http://cocoapods.org/?q= YYImage)&nbsp;
[![Support](https://img.shields.io/badge/support-iOS%206%2B%20-blue.svg?style=flat)](https://www.apple.com/nl/ios/)&nbsp;
[![Build Status](https://travis-ci.org/ibireme/YYImage.svg?branch=master)](https://travis-ci.org/ibireme/YYImage)

Image framework for iOS to display/encode/decode animated WebP, APNG, GIF, and more.<br/>
(It's a component of [YYKit](https://github.com/ibireme/YYKit))

![niconiconi~](https://raw.github.com/ibireme/YYImage/master/Demo/YYImageDemo/niconiconi@2x.gif
)

Features
==============
- Display/encode/decode animated image with these types:<br/>&nbsp;&nbsp;&nbsp;&nbsp;WebP, APNG, GIF.
- Display/encode/decode still image with these types:<br/>&nbsp;&nbsp;&nbsp;&nbsp;WebP, PNG, GIF, JPEG, JP2, TIFF, BMP, ICO, ICNS.
- Baseline/progressive/interlaced image decode with these types:<br/>&nbsp;&nbsp;&nbsp;&nbsp;PNG, GIF, JPEG, BMP.
- Display frame based image animation and sprite sheet animation.
- Dynamic memory buffer for lower memory usage.
- Fully compatible with UIImage and UIImageView class.
- Extendable protocol for custom image animation.
- Fully documented.

Usage
==============

###Display animated image
	
	// File: ani@3x.gif
	UIImage *image = [YYImage imageNamed:@"ani.gif"];
	UIImageView *imageView = [[YYAnimatedImageView alloc] initWithImage:image];
	[self.view addSubView:imageView];


###Display frame animation
	
	// Files: frame1.png, frame2.png, frame3.png
	NSArray *paths = @[@"/ani/frame1.png", @"/ani/frame2.png", @"/ani/frame3.png"];
	NSArray *times = @[@0.1, @0.2, @0.1];
	UIImage *image = [YYFrameImage alloc] initWithImagePaths:paths frameDurations:times repeats:YES];
	UIImageView *imageView = [YYAnimatedImageView alloc] initWithImage:image];
	[self.view addSubView:imageView];

###Display sprite sheet animation

	// 8 * 12 sprites in a single sheet image
	UIImage *spriteSheet = [UIImage imageNamed:@"sprite-sheet"];
	NSMutableArray *contentRects = [NSMutableArray new];
	NSMutableArray *durations = [NSMutableArray new];
	for (int j = 0; j < 12; j++) {
	   for (int i = 0; i < 8; i++) {
	       CGRect rect;
	       rect.size = CGSizeMake(img.size.width / 8, img.size.height / 12);
	       rect.origin.x = img.size.width / 8 * i;
	       rect.origin.y = img.size.height / 12 * j;
	       [contentRects addObject:[NSValue valueWithCGRect:rect]];
	       [durations addObject:@(1 / 60.0)];
	   }
	}
	YYSpriteSheetImage *sprite;
	sprite = [[YYSpriteSheetImage alloc] initWithSpriteSheetImage:img
	                                                contentRects:contentRects
	                                              frameDurations:durations
	                                                   loopCount:0];
	YYAnimatedImageView *imageView = [YYAnimatedImageView new];
	imageView.size = CGSizeMake(img.size.width / 8, img.size.height / 12);
	imageView.image = sprite;
	[self.view addSubView:imageView];

###Animation control
	
	YYAnimatedImageView *imageView = ...;
	// pause:
	[imageView stopAnimating];
	// play:
	[imageView startAnimating];
	// set frame index:
	imageView.currentAnimatedImageIndex = 12;
	// get current status
	image.currentIsPlayingAnimation;
	
###Image decoder
		
	// Decode single frame:
	NSData *data = [NSData dataWithContentsOfFile:@"/tmp/image.webp"];
	YYImageDecoder *decoder = [YYImageDecoder decoderWithData:data scale:2.0];
	UIImage image = [decoder frameAtIndex:0 decodeForDisplay:YES].image;
	
	// Progressive:
	NSMutableData *data = [NSMutableData new];
	YYImageDecoder *decoder = [[YYImageDecoder alloc] initWithScale:2.0];
	while(newDataArrived) {
	   [data appendData:newData];
	   [decoder updateData:data final:NO];
	   if (decoder.frameCount > 0) {
	       UIImage image = [decoder frameAtIndex:0 decodeForDisplay:YES].image;
	       // progressive display...
	   }
	}
	[decoder updateData:data final:YES];
	UIImage image = [decoder frameAtIndex:0 decodeForDisplay:YES].image;
	// final display...

###Image encoder
	
	// Encode still image:
	YYImageEncoder *jpegEncoder = [[YYImageEncoder alloc] initWithType:YYImageTypeJPEG];
	jpegEncoder.quality = 0.9;
	[jpegEncoder addImage:image duration:0];
	NSData jpegData = [jpegEncoder encode];
	 
	// Encode animated image:
	YYImageEncoder *webpEncoder = [[YYImageEncoder alloc] initWithType:YYImageTypeWebP];
	webpEncoder.loopCount = 5;
	[webpEncoder addImage:image0 duration:0.1];
	[webpEncoder addImage:image1 duration:0.15];
	[webpEncoder addImage:image2 duration:0.2];
	NSData webpData = [webpEncoder encode];

###Image type detection

	// Get image type from image data
	YYImageType type = YYImageDetectType(data); 
	if (type == YYImageTypePNG) ...
	
	
Installation
==============

### CocoaPods

1. Update cocoapods to the latest version.
2. Add `pod 'YYImage'` to your Podfile.
3. Run `pod install` or `pod update`.
4. Import \<YYImage/YYImage.h\>.
5. Notice: it doesn't include WebP subspec by default, if you want to support WebP format, you may add `pod 'YYImage/WebP'` to your Podfile.

### Carthage

1. Add `github "ibireme/YYImage"` to your Cartfile.
2. Run `carthage update --platform ios` and add the framework to your project.
3. Import \<YYImage/YYImage.h\>.
4. Notice: carthage framework doesn't include WebP component, if you want to support WebP format, use CocoaPods or install manually.

### Manually

1. Download all the files in the YYImage subdirectory.
2. Add the source files to your Xcode project.
3. Link with required frameworks:
	* UIKit
	* CoreFoundation
	* QuartzCore
	* AssetsLibrary
	* ImageIO
	* Accelerate
	* MobileCoreServices
	* libz
4. Import `YYImage.h`.
5. Notice: if you want to support WebP format, you may add `Vendor/WebP.framework`(static library) to your Xcode project.

FAQ
==============
_Q: Why I can't display WebP image?_

A: Make sure you added the `WebP.framework` in your project. You may call `YYImageWebPAvailable()` to check whether the WebP subspec is installed correctly.

_Q: Why I can't play APNG animation?_

A: You should disable the `Compress PNG Files` and `Remove Text Metadata From PNG Files` in your project's build settings. Or you can rename your APNG file's extension name with `apng`.

Documentation
==============
Full API documentation is available on [CocoaDocs](http://cocoadocs.org/docsets/YYImage/).<br/>
You can also install documentation locally using [appledoc](https://github.com/tomaz/appledoc).



Requirements
==============
This library requires `iOS 6.0+` and `Xcode 7.0+`.


License
==============
YYImage is provided under the MIT license. See LICENSE file for details.


<br/><br/>
---
中文介绍
==============
YYImage: 功能强大的 iOS 图像框架。<br/>
(该项目是 [YYKit](https://github.com/ibireme/YYKit) 组件之一)

![niconiconi~](https://raw.github.com/ibireme/YYImage/master/Demo/YYImageDemo/niconiconi@2x.gif
)

特性
==============
- 支持以下类型动画图像的播放/编码/解码:<br/>
  &nbsp;&nbsp;&nbsp;&nbsp;WebP, APNG, GIF。
- 支持以下类型静态图像的显示/编码/解码:<br>
  &nbsp;&nbsp;&nbsp;&nbsp;WebP, PNG, GIF, JPEG, JP2, TIFF, BMP, ICO, ICNS。
- 支持以下类型图片的渐进式/逐行扫描/隔行扫描解码:<br/>
  &nbsp;&nbsp;&nbsp;&nbsp;PNG, GIF, JPEG, BMP。
- 支持多张图片构成的帧动画播放，支持单张图片的 sprite sheet 动画。
- 高效的动态内存缓存管理，以保证高性能低内存的动画播放。
- 完全兼容 UIImage 和 UIImageView，使用方便。
- 保留可扩展的接口，以支持自定义动画。
- 每个类和方法都有完善的文档注释。


用法
==============

###显示动画类型的图片
	
	// 文件: ani@3x.gif
	UIImage *image = [YYImage imageNamed:@"ani.gif"];
	UIImageView *imageView = [[YYAnimatedImageView alloc] initWithImage:image];
	[self.view addSubView:imageView];


###播放帧动画
	
	// 文件: frame1.png, frame2.png, frame3.png
	NSArray *paths = @[@"/ani/frame1.png", @"/ani/frame2.png", @"/ani/frame3.png"];
	NSArray *times = @[@0.1, @0.2, @0.1];
	UIImage *image = [YYFrameImage alloc] initWithImagePaths:paths frameDurations:times repeats:YES];
	UIImageView *imageView = [YYAnimatedImageView alloc] initWithImage:image];
	[self.view addSubView:imageView];

###播放 sprite sheet 动画

	// 8 * 12 sprites in a single sheet image
	UIImage *spriteSheet = [UIImage imageNamed:@"sprite-sheet"];
	NSMutableArray *contentRects = [NSMutableArray new];
	NSMutableArray *durations = [NSMutableArray new];
	for (int j = 0; j < 12; j++) {
	   for (int i = 0; i < 8; i++) {
	       CGRect rect;
	       rect.size = CGSizeMake(img.size.width / 8, img.size.height / 12);
	       rect.origin.x = img.size.width / 8 * i;
	       rect.origin.y = img.size.height / 12 * j;
	       [contentRects addObject:[NSValue valueWithCGRect:rect]];
	       [durations addObject:@(1 / 60.0)];
	   }
	}
	YYSpriteSheetImage *sprite;
	sprite = [[YYSpriteSheetImage alloc] initWithSpriteSheetImage:img
	                                                contentRects:contentRects
	                                              frameDurations:durations
	                                                   loopCount:0];
	YYAnimatedImageView *imageView = [YYAnimatedImageView new];
	imageView.size = CGSizeMake(img.size.width / 8, img.size.height / 12);
	imageView.image = sprite;
	[self.view addSubView:imageView];

###动画播放控制
	
	YYAnimatedImageView *imageView = ...;
	// 暂停:
	[imageView stopAnimating];
	// 播放:
	[imageView startAnimating];
	// 设置播放进度:
	imageView.currentAnimatedImageIndex = 12;
	// 获取播放状态:
	image.currentIsPlayingAnimation;
	//上面两个属性都支持 KVO。
	
###图片解码
		
	// 解码单帧图片:
	NSData *data = [NSData dataWithContentsOfFile:@"/tmp/image.webp"];
	YYImageDecoder *decoder = [YYImageDecoder decoderWithData:data scale:2.0];
	UIImage image = [decoder frameAtIndex:0 decodeForDisplay:YES].image;
	
	// 渐进式图片解码 (可用于图片下载显示):
	NSMutableData *data = [NSMutableData new];
	YYImageDecoder *decoder = [[YYImageDecoder alloc] initWithScale:2.0];
	while(newDataArrived) {
	   [data appendData:newData];
	   [decoder updateData:data final:NO];
	   if (decoder.frameCount > 0) {
	       UIImage image = [decoder frameAtIndex:0 decodeForDisplay:YES].image;
	       // progressive display...
	   }
	}
	[decoder updateData:data final:YES];
	UIImage image = [decoder frameAtIndex:0 decodeForDisplay:YES].image;
	// final display...

###图片编码
	
	// 编码静态图 (支持各种常见图片格式):
	YYImageEncoder *jpegEncoder = [[YYImageEncoder alloc] initWithType:YYImageTypeJPEG];
	jpegEncoder.quality = 0.9;
	[jpegEncoder addImage:image duration:0];
	NSData jpegData = [jpegEncoder encode];
	 
	// 编码动态图 (支持 GIF/APNG/WebP):
	YYImageEncoder *webpEncoder = [[YYImageEncoder alloc] initWithType:YYImageTypeWebP];
	webpEncoder.loopCount = 5;
	[webpEncoder addImage:image0 duration:0.1];
	[webpEncoder addImage:image1 duration:0.15];
	[webpEncoder addImage:image2 duration:0.2];
	NSData webpData = [webpEncoder encode];
	
###图片类型探测

	// 获取图片类型
	YYImageType type = YYImageDetectType(data); 
	if (type == YYImageTypePNG) ...
	

安装
==============

### CocoaPods

1. 将 cocoapods 更新至最新版本.
2. 在 Podfile 中添加 `pod 'YYImage'`。
3. 执行 `pod install` 或 `pod update`。
4. 导入 \<YYImage/YYImage.h\>。
5. 注意：pod 配置并没有包含 WebP 组件, 如果你需要支持 WebP，可以在 Podfile 中添加 `pod 'YYImage/WebP'`。

### Carthage

1. 在 Cartfile 中添加 `github "ibireme/YYImage"`。
2. 执行 `carthage update --platform ios` 并将生成的 framework 添加到你的工程。
3. 导入 \<YYImage/YYImage.h\>。
4. 注意：carthage framework 并没有包含 WebP 组件。如果你需要支持 WebP，可以用 CocoaPods 安装，或者手动安装。

### 手动安装

1. 下载 YYImage 文件夹内的所有内容。
2. 将 YYImage 内的源文件添加(拖放)到你的工程。
3. 链接以下 frameworks:
	* UIKit
	* CoreFoundation
	* QuartzCore
	* AssetsLibrary
	* ImageIO
	* Accelerate
	* MobileCoreServices
	* libz
4. 导入 `YYImage.h`。
5. 注意：如果你需要支持 WebP，可以将 `Vendor/WebP.framework`(静态库) 加入你的工程。

常见问题
==============
_Q: 为什么我不能显示 WebP 图片？_

A: 确保 `WebP.framework` 已经被添加到你的工程内了。你可以调用 `YYImageWebPAvailable()` 来检查一下 WebP 组件是否被正确安装。

_Q: 为什么我不能播放 APNG 动画？_

A: 你应该禁用 Build Settings 中的 `Compress PNG Files` 和 `Remove Text Metadata From PNG Files`. 或者你也可以把 APNG 文件的扩展名改为`apng`.

文档
==============
你可以在 [CocoaDocs](http://cocoadocs.org/docsets/YYImage/) 查看在线 API 文档，也可以用 [appledoc](https://github.com/tomaz/appledoc) 本地生成文档。


系统要求
==============
该项目最低支持 `iOS 6.0` 和 `Xcode 7.0`。


许可证
==============
YYImage 使用 MIT 许可证，详情见 LICENSE 文件。


相关链接
==============
[移动端图片格式调研](http://blog.ibireme.com/2015/11/02/mobile_image_benchmark/)<br/>

[iOS 处理图片的一些小 Tip](http://blog.ibireme.com/2015/11/02/ios_image_tips/)

