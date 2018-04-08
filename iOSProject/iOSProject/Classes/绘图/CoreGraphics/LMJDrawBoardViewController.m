//
//  LMJDrawBoardViewController.m
//  DrawingBoard-2
//
//  Created by apple on 16/6/10.
//  Copyright © 2016年 itcast. All rights reserved.
//

#import "LMJDrawBoardViewController.h"
#import "LMJDrawingView.h"
#import "LMJHandleView.h"

@interface LMJDrawBoardViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet LMJDrawingView *drawingView;

@end

@implementation LMJDrawBoardViewController
- (IBAction)clearAll:(UIBarButtonItem *)sender {
    [self.drawingView clearAll];
}
- (IBAction)undo:(UIBarButtonItem *)sender {
    [self.drawingView undo];
}
- (IBAction)eraser:(UIBarButtonItem *)sender {
    self.drawingView.lineColor = self.drawingView.backgroundColor;
}
- (IBAction)showPicture:(UIBarButtonItem *)sender {
    UIImagePickerController *pickerVC = [[UIImagePickerController alloc] init];
    pickerVC.delegate = self;
    pickerVC.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [self presentViewController:pickerVC animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    LMJHandleView *handleView = [[LMJHandleView alloc] initWithFrame:self.drawingView.bounds];
    handleView.image = info[UIImagePickerControllerOriginalImage];
    LMJWeak(self);
    handleView.imageBlock = ^(UIImage *image)
    {
        weakself.drawingView.image = image;
    };
    [self.drawingView addSubview:handleView];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)save:(UIBarButtonItem *)sender {
    
    // 1开启一个上下文
    UIGraphicsBeginImageContextWithOptions(self.drawingView.frame.size, NO, 0);
    
    // 2 把绘图板上的图层渲染到上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [self.drawingView.layer renderInContext:ctx];
    
    // 3获得生成的新图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 4关闭上下文
    UIGraphicsEndImageContext();
    
    // 保存到相册
    UIImageWriteToSavedPhotosAlbum(newImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}


- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"成功保存到相册" preferredStyle:UIAlertControllerStyleAlert];
    
    [self presentViewController:alert animated:YES completion:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self dismissViewControllerAnimated:YES completion:nil];
        });
    }];
}

- (IBAction)changeColor:(UIButton *)sender {
    self.drawingView.lineColor = sender.backgroundColor;
}
- (IBAction)changeLineWidth:(UISlider *)sender {
    self.drawingView.lineWidth = sender.value;
}

@end
