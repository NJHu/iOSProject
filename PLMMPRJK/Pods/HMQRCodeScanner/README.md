# HMQRCodeScanner

包含 UI 界面的轻量级二维码扫描及生成框架

## 功能

* 提供一个导航控制器，扫描 `二维码 / 条形码`
* 能够生成指定 `字符串` + `avatar(可选)` 的二维码名片
* 能够识别相册图片中的二维码(iOS 64 位设备)

## 系统支持

* iOS 8.0+
* Xcode 7.0

## 安装

### CocoaPods

* 进入终端，`cd` 到项目目录，输入以下命令，建立 `Podfile`

```bash
$ pod init
```

* 在 `Podfile` 中输入以下内容：

```
platform :ios, '8.0'
use_frameworks!

pod 'HMQRCodeScanner'
```

* 在终端中输入以下命令，安装或升级 Pod

```bash
# 安装 Pod，第一次使用
$ pod install


# 升级 Pod，后续使用
$ pod update
```

## 使用

### Objective-C

* 导入框架

```objc
@import HMQRCodeScanner;
```

* 打开扫描控制器，扫描及完成回调

```objc
NSString *cardName = @"天涯刀哥 - 傅红雪";
UIImage *avatar = [UIImage imageNamed:@"avatar"];

// 实例化扫描控制器
HMScannerController *scanner = [HMScannerController scannerWithCardName:cardName avatar:avatar completion:^(NSString *stringValue) {

    self.scanResultLabel.text = stringValue;
}];

// 设置导航栏样式
[scanner setTitleColor:[UIColor whiteColor] tintColor:[UIColor greenColor]];

// 展现扫描控制器
[self showDetailViewController:scanner sender:nil];
```

* 生成二维码名片

```objc
NSString *cardName = @"天涯刀哥 - 傅红雪";
UIImage *avatar = [UIImage imageNamed:@"avatar"];

[HMScannerController cardImageWithCardName:cardName avatar:avatar scale:0.2 completion:^(UIImage *image) {
    self.imageView.image = image;
}];
```

### Swift

* 导入框架

```swift
import HMQRCodeScanner
```

* 打开扫描控制器，扫描及完成回调

```swift
let cardName = "天涯刀哥 - 傅红雪"
let avatar = UIImage(named: "avatar")

let scanner = HMScannerController.scannerWithCardName(cardName, avatar: avatar) { (stringValue) -> Void in
    self.scanResultLabel.text = stringValue
}

self.showDetailViewController(scanner, sender: nil)
```

* 生成二维码名片

```swift
let cardName = "天涯刀哥 - 傅红雪"
let avatar = UIImage(named: "avatar")

HMScannerController.cardImageWithCardName(cardName, avatar: avatar, scale: 0.2) { (image) -> Void in
    self.imageView.image = image
}
```

