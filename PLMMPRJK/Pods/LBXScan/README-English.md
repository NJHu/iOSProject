

# iOS barcode and qr code objective-c version
### iOS scanner wrapper
- scanner wrapper with: AVFoundation、ZXing、ZBar
- scan view wrapper
- recognize image

### 设置参数自定义效果
- 扫码框周围区域背景色可设置
- 扫码框颜色可也设置
- 扫码框4个角的颜色可设置、大小可设置
- 可设置只识别扫码框内的图像区域
- 可设置扫码成功后，获取当前图片
- 动画效果选择:  线条上下移动、网格形式移动、中间线条不移动(一般扫码条形码的效果)



### install with cocoapods
> 可独立安装某一功能,ZXing已经下载到本工程，解决之前版本下载速度慢的问题

#### install with cocoapods by git tag
***
- 安装所有库包括UI  (最低系统iOS7)

```ruby
pod 'LBXScan/All',git:'https://github.com/MxABC/LBXScan.git', tag: '2.0'
```

- 只安装系统原生API封装库  (最低系统iOS7)

```ruby
pod 'LBXScan/LBXNative',git:'https://github.com/MxABC/LBXScan.git', tag: '2.0'
```

- 只安装ZXing封装库  (最低系统iOS6)

```ruby
pod 'LBXScan/LBXZXing',git:'https://github.com/MxABC/LBXScan.git', tag: '2.0'
```

- 只安装ZBar封装库 

```ruby
pod 'LBXScan/LBXZBar',git:'https://github.com/MxABC/LBXScan.git', tag: '2.0'
```

- 只安装UI

```ruby
pod 'LBXScan/UI',git:'https://github.com/MxABC/LBXScan.git', tag: '2.0'
```
- 安装任意组合

> 你可以通过上面的安装方式，安装任意组合


### Demo测试
- xcode版本:xcode8.3
- 将工程下载下来，打开DemoTests中 LBXScanDemo.xcworkspace
- Demo提供了选择对应库进行扫码识别、相册选择图片识别、生成条码等测试

### 使用
#### 自定义参数部分介绍
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
style.notRecoginitonArea = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];

}
```


# 界面效果
![image](https://github.com/MxABC/Resource/blob/master/scan12.gif)

