//
//  UIWebView+Canvas.m
//  iOS-Categories (https://github.com/shaojiankui/iOS-Categories)
//
//  Created by Jakey on 14/12/22.
//  Copyright (c) 2014年 duzixi. All rights reserved.
//

#import "UIWebView+Canvas.h"
#import "UIColor+Web.h"
@implementation UIWebView (Canvas)
/// 创建一个指定大小的透明画布
- (void)createCanvas:(NSString *)canvasId width:(NSInteger)width height:(NSInteger)height
{
    NSString *jsString = [NSString stringWithFormat:
                          @"var canvas = document.createElement('canvas');"
                          "canvas.id = %@; canvas.width = %ld; canvas.height = %ld;"
                          "document.body.appendChild(canvas);"
                          "var g = canvas.getContext('2d');"
                          "g.strokeRect(%ld,%ld,%ld,%ld);",
                          canvasId, (long)width, (long)height, 0L ,0L ,(long)width,(long)height];
    [self stringByEvaluatingJavaScriptFromString:jsString];
}
/// 在指定位置创建一个指定大小的透明画布
- (void)createCanvas:(NSString *)canvasId width:(NSInteger)width height:(NSInteger)height x:(NSInteger)x y:(NSInteger)y
{
    //[self createCanvas:canvasId width:width height:height];
    NSString *jsString = [NSString stringWithFormat:
                          @"var canvas = document.createElement('canvas');"
                          "canvas.id = %@; canvas.width = %ld; canvas.height = %ld;"
                          "canvas.style.position = 'absolute';"
                          "canvas.style.top = '%ld';"
                          "canvas.style.left = '%ld';"
                          "document.body.appendChild(canvas);"
                          "var g = canvas.getContext('2d');"
                          "g.strokeRect(%ld,%ld,%ld,%ld);",
                          canvasId, (long)width, (long)height, (long)y, (long)x, 0L ,0L ,(long)width,(long)height];
    [self stringByEvaluatingJavaScriptFromString:jsString];
}
/// 绘制矩形填充 context.fillRect(x,y,width,height)
- (void)fillRectOnCanvas:(NSString *)canvasId x:(NSInteger)x y:(NSInteger)y width:(NSInteger)width height:(NSInteger) height uicolor:(UIColor *)color
{
    NSString *jsString = [NSString stringWithFormat:
                          @"var canvas = document.getElementById('%@');"
                          "var context = canvas.getContext('2d');"
                          "context.fillStyle = '%@';"
                          "context.fillRect(%ld,%ld,%ld,%ld);"
                          ,canvasId, [color canvasColorString], (long)x, (long)y, (long)width, (long)height];
    [self stringByEvaluatingJavaScriptFromString:jsString];
}
/// 绘制矩形边框 strokeRect(x,y,width,height)
- (void)strokeRectOnCanvas:(NSString *)canvasId x:(NSInteger)x y:(NSInteger)y width:(NSInteger)width height:(NSInteger) height uicolor:(UIColor *)color lineWidth:(NSInteger)lineWidth
{
    NSString *jsString = [NSString stringWithFormat:
                          @"var canvas = document.getElementById('%@');"
                          "var context = canvas.getContext('2d');"
                          "context.strokeStyle = '%@';"
                          "context.lineWidth = '%ld';"
                          "context.strokeRect(%ld,%ld,%ld,%ld);"
                          ,canvasId, [color canvasColorString], (long)lineWidth, (long)x, (long)y, (long)width, (long)height];
    [self stringByEvaluatingJavaScriptFromString:jsString];
}
/// 清除矩形区域 context.clearRect(x,y,width,height)
- (void)clearRectOnCanvas:(NSString *)canvasId x:(NSInteger)x y:(NSInteger)y width:(NSInteger)width height:(NSInteger) height
{
    NSString *jsString = [NSString stringWithFormat:
                          @"var canvas = document.getElementById('%@');"
                          "var context = canvas.getContext('2d');"
                          "context.clearRect(%ld,%ld,%ld,%ld);"
                          ,canvasId, (long)x, (long)y, (long)width, (long)height];
    [self stringByEvaluatingJavaScriptFromString:jsString];
}
/// 绘制圆弧填充 context.arc(x, y, radius, starAngle,endAngle, anticlockwise)
- (void)arcOnCanvas:(NSString *)canvasId centerX:(NSInteger)x centerY:(NSInteger)y radius:(NSInteger)r startAngle:(float)startAngle endAngle:(float)endAngle anticlockwise:(BOOL)anticlockwise uicolor:(UIColor *)color
{
    NSString *jsString = [NSString stringWithFormat:
                          @"var canvas = document.getElementById('%@');"
                          "var context = canvas.getContext('2d');"
                          "context.beginPath();"
                          "context.arc(%ld,%ld,%ld,%f,%f,%@);"
                          "context.closePath();"
                          "context.fillStyle = '%@';"
                          "context.fill();",
                          canvasId, (long)x, (long)y, (long)r, startAngle, endAngle, anticlockwise ? @"true" : @"false", [color canvasColorString]];
    [self stringByEvaluatingJavaScriptFromString:jsString];
}
/// 绘制一条线段 context.moveTo(x,y) context.lineTo(x,y)
- (void)lineOnCanvas:(NSString *)canvasId x1:(NSInteger)x1 y1:(NSInteger)y1 x2:(NSInteger)x2 y2:(NSInteger)y2 uicolor:(UIColor *)color lineWidth:(NSInteger)lineWidth
{
    NSString *jsString = [NSString stringWithFormat:
                          @"var canvas = document.getElementById('%@');"
                          "var context = canvas.getContext('2d');"
                          "context.beginPath();"
                          "context.moveTo(%ld,%ld);"
                          "context.lineTo(%ld,%ld);"
                          "context.closePath();"
                          "context.strokeStyle = '%@';"
                          "context.lineWidth = %ld;"
                          "context.stroke();",
                          canvasId, (long)x1, (long)y1, (long)x2, (long)y2, [color canvasColorString], (long)lineWidth];
    [self stringByEvaluatingJavaScriptFromString:jsString];
}
/// 绘制一条折线
- (void)linesOnCanvas:(NSString *)canvasId points:(NSArray *)points unicolor:(UIColor *)color lineWidth:(NSInteger)lineWidth
{
    NSString *jsString = [NSString stringWithFormat:
                          @"var canvas = document.getElementById('%@');"
                          "var context = canvas.getContext('2d');"
                          "context.beginPath();",
                          canvasId];
    for (int i = 0; i < [points count] / 2; i++) {
        jsString = [jsString stringByAppendingFormat:@"context.lineTo(%@,%@);",
                    points[i * 2], points[i * 2 + 1]];
    }
    jsString = [jsString stringByAppendingFormat:@""
                "context.strokeStyle = '%@';"
                "context.lineWidth = %ld;"
                "context.stroke();",
                [color canvasColorString], (long)lineWidth];
    [self stringByEvaluatingJavaScriptFromString:jsString];
}
/// 绘制贝塞尔曲线 context.bezierCurveTo(cp1x,cp1y,cp2x,cp2y,x,y)
- (void)bezierCurveOnCanvas:(NSString *)canvasId
                         x1:(NSInteger)x1
                         y1:(NSInteger)y1
                       cp1x:(NSInteger)cp1x
                       cp1y:(NSInteger)cp1y
                       cp2x:(NSInteger)cp2x
                       cp2y:(NSInteger)cp2y
                         x2:(NSInteger)x2
                         y2:(NSInteger)y2
                   unicolor:(UIColor *)color
                  lineWidth:(NSInteger)lineWidth
{
    NSString *jsString = [NSString stringWithFormat:
                          @"var canvas = document.getElementById('%@');"
                          "var context = canvas.getContext('2d');"
                          "context.beginPath();"
                          "context.moveTo(%ld,%ld);"
                          "context.bezierCurveTo(%ld,%ld,%ld,%ld,%ld,%ld);"
                          "context.strokeStyle = '%@';"
                          "context.lineWidth = %ld;"
                          "context.stroke();",
                          canvasId, (long)x1, (long)y1, (long)cp1x, (long)cp1y, (long)cp2x, (long)cp2y, (long)x2, (long)y2, [color canvasColorString], (long)lineWidth];
    [self stringByEvaluatingJavaScriptFromString:jsString];
}
/// 显示图像的一部分 context.drawImage(image,sx,sy,sw,sh,dx,dy,dw,dh)
- (void)drawImage:(NSString *)src
         onCanvas:(NSString *)canvasId
               sx:(NSInteger)sx
               sy:(NSInteger)sy
               sw:(NSInteger)sw
               sh:(NSInteger)sh
               dx:(NSInteger)dx
               dy:(NSInteger)dy
               dw:(NSInteger)dw
               dh:(NSInteger)dh
{
    NSString *jsString = [NSString stringWithFormat:
                          @"var image = new Image();"
                          "image.src = '%@';"
                          "var canvas = document.getElementById('%@');"
                          "var context = canvas.getContext('2d');"
                          "context.drawImage(image,%ld,%ld,%ld,%ld,%ld,%ld,%ld,%ld)",
                          src, canvasId, (long)sx, (long)sy, (long)sw, (long)sh, (long)dx, (long)dy, (long)dw, (long)dh];
    [self stringByEvaluatingJavaScriptFromString:jsString];
}
@end
