YYAsyncLayer
==============

[![License MIT](https://img.shields.io/badge/license-MIT-green.svg?style=flat)](https://raw.githubusercontent.com/ibireme/YYAsyncLayer/master/LICENSE)&nbsp;
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)&nbsp;
[![CocoaPods](http://img.shields.io/cocoapods/v/YYAsyncLayer.svg?style=flat)](http://cocoapods.org/?q=YYAsyncLayer)&nbsp;
[![CocoaPods](http://img.shields.io/cocoapods/p/YYAsyncLayer.svg?style=flat)](http://cocoapods.org/?q=YYAsyncLayer)&nbsp;
[![Support](https://img.shields.io/badge/support-iOS%206%2B%20-blue.svg?style=flat)](https://www.apple.com/nl/ios/)&nbsp;
[![Build Status](https://travis-ci.org/ibireme/YYAsyncLayer.svg?branch=master)](https://travis-ci.org/ibireme/YYAsyncLayer)

iOS utility classes for asynchronous rendering and display.<br/>
(It was used by [YYText](https://github.com/ibireme/YYText))


Simple Usage
==============

    @interface YYLabel : UIView
    @property NSString *text;
    @property UIFont *font;
    @end
	
    @implementation YYLabel

    - (void)setText:(NSString *)text {
        _text = text.copy;
        [[YYTransaction transactionWithTarget:self selector:@selector(contentsNeedUpdated)] commit];
    }
	
    - (void)setFont:(UIFont *)font {
        _font = font;
        [[YYTransaction transactionWithTarget:self selector:@selector(contentsNeedUpdated)] commit];
    }
    
    - (void)layoutSubviews {
        [super layoutSubviews];
        [[YYTransaction transactionWithTarget:self selector:@selector(contentsNeedUpdated)] commit];
    }

    - (void)contentsNeedUpdated {
        // do update
        [self.layer setNeedsDisplay];
    }
	
    #pragma mark - YYAsyncLayer

    + (Class)layerClass {
        return YYAsyncLayer.class;
    }

    - (YYAsyncLayerDisplayTask *)newAsyncDisplayTask {
        
        // capture current state to display task
        NSString *text = _text;
        UIFont *font = _font;
        
        YYAsyncLayerDisplayTask *task = [YYAsyncLayerDisplayTask new];
        task.willDisplay = ^(CALayer *layer) {
            //...
        };
        
        task.display = ^(CGContextRef context, CGSize size, BOOL(^isCancelled)(void)) {
            if (isCancelled()) return;
            NSArray *lines = CreateCTLines(text, font, size.width);
            if (isCancelled()) return;
            
            for (int i = 0; i < lines.count; i++) {
                CTLineRef line = line[i];
                CGContextSetTextPosition(context, 0, i * font.pointSize * 1.5);
                CTLineDraw(line, context);
                if (isCancelled()) return;
            }
        };
        
        task.didDisplay = ^(CALayer *layer, BOOL finished) {
            if (finished) {
                // finished
            } else {
                // cancelled
            }
        };
        
        return task;
    }
    @end


Installation
==============

### CocoaPods

1. Add `pod 'YYAsyncLayer'` to your Podfile.
2. Run `pod install` or `pod update`.
3. Import \<YYAsyncLayer/YYAsyncLayer.h\>.


### Carthage

1. Add `github "ibireme/YYAsyncLayer"` to your Cartfile.
2. Run `carthage update --platform ios` and add the framework to your project.
3. Import \<YYAsyncLayer/YYAsyncLayer.h\>.


### Manually

1. Download all the files in the YYAsyncLayer subdirectory.
2. Add the source files to your Xcode project.
3. Import `YYAsyncLayer.h`.


Documentation
==============
Full API documentation is available on [CocoaDocs](http://cocoadocs.org/docsets/YYAsyncLayer/).<br/>
You can also install documentation locally using [appledoc](https://github.com/tomaz/appledoc).


Requirements
==============
This library requires `iOS 6.0+` and `Xcode 7.0+`.


License
==============
YYAsyncLayer is provided under the MIT license. See LICENSE file for details.




<br/><br/>
---
中文介绍
==============
iOS 异步绘制与显示的工具类。<br/>
(该工具是从 [YYText](https://github.com/ibireme/YYText) 提取出来的独立组件)


简单用法
==============

    @interface YYLabel : UIView
    @property NSString *text;
    @property UIFont *font;
    @end
	
    @implementation YYLabel

    - (void)setText:(NSString *)text {
        _text = text.copy;
        [[YYTransaction transactionWithTarget:self selector:@selector(contentsNeedUpdated)] commit];
    }
	
    - (void)setFont:(UIFont *)font {
        _font = font;
        [[YYTransaction transactionWithTarget:self selector:@selector(contentsNeedUpdated)] commit];
    }
    
    - (void)layoutSubviews {
        [super layoutSubviews];
        [[YYTransaction transactionWithTarget:self selector:@selector(contentsNeedUpdated)] commit];
    }

    - (void)contentsNeedUpdated {
        // do update
        [self.layer setNeedsDisplay];
    }
	
    #pragma mark - YYAsyncLayer

    + (Class)layerClass {
        return YYAsyncLayer.class;
    }

    - (YYAsyncLayerDisplayTask *)newAsyncDisplayTask {
        
        // capture current state to display task
        NSString *text = _text;
        UIFont *font = _font;
        
        YYAsyncLayerDisplayTask *task = [YYAsyncLayerDisplayTask new];
        task.willDisplay = ^(CALayer *layer) {
            //...
        };
        
        task.display = ^(CGContextRef context, CGSize size, BOOL(^isCancelled)(void)) {
            if (isCancelled()) return;
            NSArray *lines = CreateCTLines(text, font, size.width);
            if (isCancelled()) return;
            
            for (int i = 0; i < lines.count; i++) {
                CTLineRef line = line[i];
                CGContextSetTextPosition(context, 0, i * font.pointSize * 1.5);
                CTLineDraw(line, context);
                if (isCancelled()) return;
            }
        };
        
        task.didDisplay = ^(CALayer *layer, BOOL finished) {
            if (finished) {
                // finished
            } else {
                // cancelled
            }
        };
        
        return task;
    }
    @end


安装
==============

### CocoaPods

1. 在 Podfile 中添加 `pod 'YYAsyncLayer'`。
2. 执行 `pod install` 或 `pod update`。
3. 导入 \<YYAsyncLayer/YYAsyncLayer.h\>。


### Carthage

1. 在 Cartfile 中添加 `github "ibireme/YYAsyncLayer"`。
2. 执行 `carthage update --platform ios` 并将生成的 framework 添加到你的工程。
3. 导入 \<YYAsyncLayer/YYAsyncLayer.h\>。


### 手动安装

1. 下载 YYAsyncLayer 文件夹内的所有内容。
2. 将 YYAsyncLayer 内的源文件添加(拖放)到你的工程。
3. 导入 `YYAsyncLayer.h`。


文档
==============
你可以在 [CocoaDocs](http://cocoadocs.org/docsets/YYAsyncLayer/) 查看在线 API 文档，也可以用 [appledoc](https://github.com/tomaz/appledoc) 本地生成文档。


系统要求
==============
该项目最低支持 `iOS 6.0` 和 `Xcode 7.0`。


许可证
==============
YYAsyncLayer 使用 MIT 许可证，详情见 LICENSE 文件。

相关文章
==============
[iOS 保持界面流畅的技巧
](http://blog.ibireme.com/2015/11/12/smooth_user_interfaces_for_ios/) 

