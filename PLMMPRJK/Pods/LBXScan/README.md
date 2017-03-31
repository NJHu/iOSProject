


# ios 二维码、条形码 objective-c 版本

#### Swift Version <img src="https://github.com/MxABC/LBXScan/blob/master/DemoTests/swiftIcon.png" height="25" width="25">
对应的swift版本请看 : **[swiftScan](https://github.com/MxABC/swiftScan)**


## 介绍
**iOS扫码封装 objective-c版本 封装ios系统API和ZXing**
- 扫码界面效果封装
- 二维码、条形码
- 相册获取图片后识别

**模仿其他app**
- 模仿QQ扫码界面
- 支付宝扫码框效果
- 微信扫码框效果

**其他设置参数自定义效果**

- 扫码框周围区域背景色可设置
- 扫码框颜色可也设置
- 扫码框4个角的颜色可设置、大小可设置
- 可设置只识别扫码框内的图像区域
- 可设置扫码成功后，获取当前图片
- 动画效果选择:  线条上下移动、网格形式移动、中间线条不移动(一般扫码条形码的效果)
- 如果好用请帮忙右上角 star 支持一下

# 安装

### Installation with CocoaPods

```ruby
platform :ios, '6.0'
pod 'LBXScan',:git=>'https://github.com/MxABC/LBXScan.git'
```

### 手动安装 
下载后将LBXScan文件夹copy到工程中
添加预编译 pch文件 （如何添加请百度）
并在其中添加
```objective-c
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
```
否则编译会报许多错误


### Demo测试
- xcode版本:xcode7.1
- 将工程下载下来，打开DemoTests中 LBXScanDemo.xcodeproj

### 使用

- LBXScanViewStyle:设置界面参数,具体各个参数请参看代码头文件
- LBXScanViewController:扫码界面基类控制器，实现基本的扫码功能、相册功能、闪光灯开启关闭、扫码框相关效果，其他提示语及界面请继承LBXScanViewController后添加

####模仿qq界面效果
```obj-c
- (void)qqStyle
{
//设置扫码区域参数设置

//创建参数对象
LBXScanViewStyle *style = [[LBXScanViewStyle alloc]init];

//矩形区域中心上移，默认中心点为屏幕中心点
style.centerUpOffset = 44;

//扫码框周围4个角的类型,设置为外挂式
style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle_Outer;

//扫码框周围4个角绘制的线条宽度
style.photoframeLineW = 6;

//扫码框周围4个角的宽度
style.photoframeAngleW = 24;

//扫码框周围4个角的高度
style.photoframeAngleH = 24;

//扫码框内 动画类型 --线条上下移动
style.anmiationStyle = LBXScanViewAnimationStyle_LineMove;

//线条上下移动图片
style.animationImage = [UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_light_green"];

//SubLBXScanViewController继承自LBXScanViewController
//添加一些扫码或相册结果处理
SubLBXScanViewController *vc = [SubLBXScanViewController new];
vc.style = style;   

vc.isQQSimulator = YES;
[self.navigationController pushViewController:vc animated:YES];
}
```

####自定义参数部分介绍
```obj-c
- (void)custom
{
//设置扫码区域参数
LBXScanViewStyle *style = [[LBXScanViewStyle alloc]init];
style.centerUpOffset = 44;

//扫码框周围4个角的类型设置为在框的上面
style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle_On;
//扫码框周围4个角绘制线宽度
style.photoframeLineW = 6;

//扫码框周围4个角的宽度
style.photoframeAngleW = 24;

//扫码框周围4个角的高度
style.photoframeAngleH = 24;

//显示矩形框
style.isNeedShowRetangle = YES;

//动画类型：网格形式，模仿支付宝
style.anmiationStyle = LBXScanViewAnimationStyle_NetGrid;

//网格图片
style.animationImage = [UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_part_net"];;

//码框周围4个角的颜色
style.colorAngle = [UIColor colorWithRed:65./255. green:174./255. blue:57./255. alpha:1.0];

//矩形框颜色
style.colorRetangleLine = [UIColor colorWithRed:247/255. green:202./255. blue:15./255. alpha:1.0];

//非矩形框区域颜色
style.red_notRecoginitonArea = 247./255.;
style.green_notRecoginitonArea = 202./255;
style.blue_notRecoginitonArea = 15./255;
style.alpa_notRecoginitonArea = 0.2;

SubLBXScanViewController *vc = [SubLBXScanViewController new];
vc.style = style;

//开启只识别矩形框内图像功能
vc.isOpenInterestRect = YES;
[self.navigationController pushViewController:vc animated:YES];

}
```


# 界面效果

(加载速度慢，可刷新网页)

![image](https://github.com/MxABC/LBXScan/blob/master/ScreenShots/page1.png)
![image](https://github.com/MxABC/LBXScan/blob/master/ScreenShots/page2.png)
![image](https://github.com/MxABC/LBXScan/blob/master/ScreenShots/page3.png)
![image](https://github.com/MxABC/LBXScan/blob/master/ScreenShots/page11.png)
![image](https://github.com/MxABC/LBXScan/blob/master/ScreenShots/page4.png)
![image](https://github.com/MxABC/LBXScan/blob/master/ScreenShots/page5.png)
![image](https://github.com/MxABC/LBXScan/blob/master/ScreenShots/page6.png)
![image](https://github.com/MxABC/LBXScan/blob/master/ScreenShots/page7.png)
![image](https://github.com/MxABC/LBXScan/blob/master/ScreenShots/page8.png)
![image](https://github.com/MxABC/LBXScan/blob/master/ScreenShots/page9.png)
![image](https://github.com/MxABC/LBXScan/blob/master/ScreenShots/page12.png)
![image](https://github.com/MxABC/LBXScan/blob/master/ScreenShots/page10.png)

