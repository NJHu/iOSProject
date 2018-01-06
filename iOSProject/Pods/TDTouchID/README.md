# TDTouchID

TDTouchID是一个封装好的指纹验证库,可以用来做iOSAPP的登录/支付等验证。
![(logo)](IMG_3457.PNG)
#安装方式
使用Cocoa Pods安装
```
pod `TDTouchID`
```
手动导入      

下载本项目,导入子层`TDTouchID`文件夹.(里面包含`TDTouchID.h`和`TDTouchID.m`)文件

* 导入`TDTouchID.h`即可使用


#如何使用
```
/**
 启动TouchID进行验证

 @param desc Touch显示的描述
 @param block 回调状态的block
 */

-(void)td_showTouchIDWithDescribe:(NSString *)desc BlockState:(StateBlock)block;
```
详细使用方法参见Demo即可
