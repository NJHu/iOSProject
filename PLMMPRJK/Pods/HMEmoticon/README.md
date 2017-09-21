![](http://www.itheima.com/uploads/2015/08/198x57.png)

# HMEmoticon
[![Build Status](https://travis-ci.org/itheima-developer/HMEmoticon.svg?branch=master)](https://travis-ci.org/itheima-developer/HMEmoticon)
[![Cocoapods Compatible](https://img.shields.io/cocoapods/v/HMEmoticon.svg)](https://img.shields.io/cocoapods/v/HMEmoticon.svg)
[![Platform](https://img.shields.io/cocoapods/p/HMEmoticon.svg?style=flat)](http://cocoadocs.org/docsets/HMEmoticon)

仿新浪微博表情键盘

## 屏幕截图

![](https://github.com/itheima-developer/HMEmoticon/blob/master/screenshots/screenshots01.gif?raw=true">)

## 功能

* 仿新浪微博表情键盘
* 支持多用户最近表情记录

## 系统支持

* iOS 8.0+
* Xcode 7.0

## 安装 

### CocoaPods

* 进入终端，`cd` 到项目目录，输入以下命令，建立 `Podfile`

```bash
$ pod init
```

* 在 Podfile 中输入以下内容：

```
platform :ios, '8.0'
use_frameworks!

target 'ProjectName' do
pod 'HMEmoticon'
end
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
@import HMEmoticon;
```

* 在 Storyboard 中将 `UITextView` 的 `Class` 修改为 `HMEmoticonTextView`

```objc
@property (weak, nonatomic) IBOutlet HMEmoticonTextView *textView;
```

#### 基本使用

* 设置用户标示，默认是 `Default`

```objc
// 1. 设置用户标示 - 用于保存最近使用表情
[HMEmoticonManager sharedManager].userIdentifier = @"刀哥";
```

* 设置表情键盘属性

```objc
// 1> 使用表情视图
_textView.useEmoticonInputView = YES;
// 2> 设置占位文本
_textView.placeholder = @"分享新鲜事...";
// 3> 设置最大文本长度
_textView.maxInputLength = 140;
```

* 与原生键盘之间的切换

```objc
_textView.useEmoticonInputView = !_textView.isUseEmoticonInputView;
```

#### 文本转换

* 将 `符号字符串` 转换成 `带表情图片的属性字符串`

```objc
NSString *text = @"[爱你]啊[笑哈哈]";
NSAttributedString *attributeText = [[HMEmoticonManager sharedManager]
    emoticonStringWithString:text
    font:_textView.font
    textColor:_textView.textColor];
```

* 获得 `符号字符串`

```objc
_textView.emoticonText
```
