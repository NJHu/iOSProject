//
//  UMSocialWarterMarkConfig.h
//  testWatermarkImage
//
//  Created by 张军华 on 16/12/23.
//  Copyright © 2016年 张军华. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>

@class UMSocialStringWarterMarkConfig;
@class UMSocialImageWarterMarkConfig;

typedef NS_ENUM(NSInteger, UMSocialWarterMarkPositon) {
    UMSocialWarterMarkPositonNone         = 0,
    
    /************************************************************************
     水印字符串的位置,目前并没有用--start
     *************************************************************************/
    UMSocialStringWarterMarkTopLeft       = (1 << 0),
    UMSocialStringWarterMarkTopRight      = (1 << 1),
    UMSocialStringWarterMarkBottomLeft    = (1 << 2),
    UMSocialStringWarterMarkBottomRight   = (1 << 3),
    /************************************************************************
     水印字符串的位置,目前并没有用--end
     *************************************************************************/
    
    //水印图片的位置
    UMSocialImageWarterMarkTopLeft        = (1 << 4),
    UMSocialImageWarterMarkTopRight       = (1 << 5),
    UMSocialImageWarterMarkBottomLeft     = (1 << 6),
    UMSocialImageWarterMarkBottomRight    = (1 << 7),

    /************************************************************************
     水印字符串和水印图片的相对位置,目前并没有用(如果图片和字符串都在同一个位置,就需要设置相对位置)--start
     *************************************************************************/
    UMSocialImageWarterMarkForwardStringWarterMark = (1 << 8), //图片在字符串前面
    UMSocialStringWarterMarkForwardImageWarterMark = (1 << 9),//字符串在图片前面
    UMSocialImageWarterMarkAboveStringWarterMark = (1 << 10),//图片在字符串上面
    UMSocialStringWarterMarkAboveImageWarterMark = (1 << 11),//字符串在图片上面
    /************************************************************************
     水印字符串和水印图片的相对位置,目前并没有用(如果图片和字符串都在同一个位置,就需要设置相对位置)--end
     *************************************************************************/
};

typedef NS_OPTIONS(NSInteger, UMSocialStringAndImageWarterMarkPositon) {
    UMSocialStringAndImageWarterMarkPositonNone  = 0,
    
    UMSocialOnlyImageWarterMarkTopLeft = UMSocialImageWarterMarkTopLeft,//水印图片左上
    UMSocialOnlyImageWarterMarkTopRight = UMSocialImageWarterMarkTopRight,//水印图片右上
    UMSocialOnlyImageWarterMarkBottomLeft = UMSocialImageWarterMarkBottomLeft,//水印图片左下
    UMSocialOnlyImageWarterMarkBottomRight = UMSocialImageWarterMarkBottomRight,//水印图片右下
    
    /************************************************************************
       以下的枚举变量,目前并没有用--start
     *************************************************************************/
    UMSocialStringWarterMarkTopLeftAndImageWarterMarkTopLeft  = (UMSocialStringWarterMarkTopLeft | UMSocialImageWarterMarkTopLeft),//水印字符串左上,水印图片左上
    UMSocialStringWarterMarkTopLeftAndImageWarterMarkTopRight = (UMSocialStringWarterMarkTopLeft | UMSocialImageWarterMarkTopRight),//水印字符串左上,水印图片右上
    UMSocialStringWarterMarkTopLeftAndImageWarterMarkBottomLeft = (UMSocialStringWarterMarkTopLeft | UMSocialImageWarterMarkBottomLeft),//水印字符串左上,水印图片左下
    UMSocialStringWarterMarkTopLeftAndImageWarterMarkBottomRight = (UMSocialStringWarterMarkTopLeft | UMSocialImageWarterMarkBottomRight),//水印字符串左上,水印图片右下
    
    UMSocialStringWarterMarkTopRightAndImageWarterMarkTopLeft  = (UMSocialStringWarterMarkTopRight | UMSocialImageWarterMarkTopLeft),//水印字符串右上,水印图片左上
    UMSocialStringWarterMarkTopRightAndImageWarterMarkTopRight = (UMSocialStringWarterMarkTopRight | UMSocialImageWarterMarkTopRight),//水印字符串右上,水印图片右上
    UMSocialStringWarterMarkTopRightAndImageWarterMarkBottomLeft = (UMSocialStringWarterMarkTopRight | UMSocialImageWarterMarkBottomLeft),//水印字符串右上,水印图片左下
    UMSocialStringWarterMarkTopRightAndImageWarterMarkBottomRight = (UMSocialStringWarterMarkTopRight | UMSocialImageWarterMarkBottomRight),//水印字符串右上,水印图片右下
    
    UMSocialStringWarterMarkBottomLeftAndImageWarterMarkTopLeft = (UMSocialStringWarterMarkBottomLeft | UMSocialImageWarterMarkTopLeft),//水印字符串左下,水印图片左上
    UMSocialStringWarterMarkBottomLeftAndImageWarterMarkTopRight = (UMSocialStringWarterMarkBottomLeft | UMSocialImageWarterMarkTopRight),//水印字符串左下,水印图片右上
    UMSocialStringWarterMarkBottomLeftAndImageWarterMarkBottomLeft = (UMSocialStringWarterMarkBottomLeft | UMSocialImageWarterMarkBottomLeft),//水印字符串左下,水印图片左下
    UMSocialStringWarterMarkBottomLeftAndImageWarterMarkBottomRight = (UMSocialStringWarterMarkBottomLeft | UMSocialImageWarterMarkBottomRight),//水印字符串左下,水印图片右下
    
    UMSocialStringWarterMarkBottomRightAndImageWarterMarkTopLeft = (UMSocialStringWarterMarkBottomRight | UMSocialImageWarterMarkTopLeft),//水印字符串右下,水印图片左上
    UMSocialStringWarterMarkBottomRightAndImageWarterMarkTopRight = (UMSocialStringWarterMarkBottomRight | UMSocialImageWarterMarkTopRight),//水印字符串右下,水印图片右上
    UMSocialStringWarterMarkBottomRightAndImageWarterMarkBottomLeft = (UMSocialStringWarterMarkBottomRight | UMSocialImageWarterMarkBottomLeft),//水印字符串右下,水印图片左下
    UMSocialStringWarterMarkBottomRightAndImageWarterMarkBottomRight = (UMSocialStringWarterMarkBottomRight | UMSocialImageWarterMarkBottomRight),//水印字符串右下,水印图片右下
    
    /************************************************************************
     以下的枚举变量,目前并没有用---end
     *************************************************************************/
};

extern UMSocialWarterMarkPositon getStringWarterMarkPostion(UMSocialStringAndImageWarterMarkPositon stringAndImageWarterMarkPositon);
extern UMSocialWarterMarkPositon getImageWarterMarkPostion(UMSocialStringAndImageWarterMarkPositon stringAndImageWarterMarkPositon);
extern UMSocialWarterMarkPositon getRelatedWarterMarkPostion(UMSocialStringAndImageWarterMarkPositon stringAndImageWarterMarkPositon);


/**
 *  水印配置类
 *  用户可以设置水印的配置类,目前只是提供图片水印
 *
 *  method1:
 *  用户可以通过默认的配置类来配置水印
 *  代码如下:
    UMSocialWarterMarkConfig* warterMarkConfig = [UMSocialWarterMarkConfig defaultWarterMarkConfig];
 *
 *  method2:
 *  用户可以通过创建自己的配置类来配置水印
 *  代码如下:
    //创建UMSocialImageWarterMarkConfig
    UMSocialImageWarterMarkConfig* imageWarterMarkConfig = [[UMSocialImageWarterMarkConfig alloc] init];
    //配置imageWarterMarkConfig的参数
    //...TODO
    //创建UMSocialWarterMarkConfig
    UMSocialWarterMarkConfig* warterMarkConfig = [[UMSocialWarterMarkConfig alloc] init];
    //配置warterMarkConfig的参数
    //...TODO
    //设置配置类
    [warterMarkConfig setUserDefinedImageWarterMarkConfig:imageWarterMarkConfig];
 *
 *
 */
@interface UMSocialWarterMarkConfig : NSObject<NSCopying>

/**
 *  默认配置类
 *
 *  @return 默认配置类
 */
+(UMSocialWarterMarkConfig*)defaultWarterMarkConfig;


@property(nonatomic,readonly,strong)UMSocialStringWarterMarkConfig*  stringWarterMarkConfig;//字符串配置类对象
@property(nonatomic,readonly,strong)UMSocialImageWarterMarkConfig*  imageWarterMarkConfig;//图片配置类对象

/**
 *  字符串和图片的位置
 *  默认是defaultWarterMarkConfig的配置为文字和图片右下角，图片在前文字在后
 */
@property(nonatomic,readwrite,assign)UMSocialStringAndImageWarterMarkPositon stringAndImageWarterMarkPositon;//字符串和图片的位置
@property(nonatomic,readwrite,assign)CGFloat spaceBetweenStringWarterMarkAndImageWarterMark;//字符水印和图片水印的间距

/**
 *  设置用户自定义的配置类
 *
 *  @param imageWarterMarkConfig  图片配置类对象
 */
-(void)setUserDefinedImageWarterMarkConfig:(UMSocialImageWarterMarkConfig*)imageWarterMarkConfig;

@end


/**
 *  字符水印配置类
 *  目前此配置类没有使用
 */
@interface UMSocialStringWarterMarkConfig : NSObject<NSCopying>

/**
 *  默认配置类
 *
 *  @return 默认配置类
 */
+(UMSocialStringWarterMarkConfig*)defaultStringWarterMarkConfig;

//检查参数是否有效
-(BOOL)checkValid;

@property(nonatomic,readwrite,strong)NSAttributedString* warterMarkAttributedString;//水印字符串
@property(nonatomic,readwrite,assign)NSUInteger warterMarkStringLimit;//水印字符串的字数限制
@property(nonatomic,readwrite,strong)UIColor* warterMarkStringColor;//水印字符串的颜色(要想保证色值半透明，可以创建半透明的颜色对象)
@property(nonatomic,readwrite,strong)UIFont* warterMarkStringFont;//水印字符串的字体

/**
 *  靠近水平边的边距
 *  与UMSocialWarterMarkPositon的停靠位置有关，
    如:为UMSocialStringWarterMarkBottomRight时，paddingToHorizontalParentBorder代表与父窗口的右边间隙.
    如:UMSocialStringWarterMarkTopLeft时，paddingToHorizontalParentBorder代表与父窗口的左边间隙.
 */
@property(nonatomic,readwrite,assign)CGFloat paddingToHorizontalParentBorder;//靠近水平边的边距

/**
 *  靠近垂直边的边距
 *  与UMSocialWarterMarkPositon的停靠位置有关，
    如:为UMSocialStringWarterMarkBottomRight时，paddingToHorizontalParentBorder代表与父窗口的下边的间隙.
    如:UMSocialStringWarterMarkTopLeft时，paddingToHorizontalParentBorder代表与父窗口的上边间隙.
 */
@property(nonatomic,readwrite,assign)CGFloat paddingToVerticalParentBorder;//靠近垂直边的边距

@property(nonatomic,readonly,assign)CGAffineTransform warterMarkStringTransform;//水印字符串的矩阵

@end

/**
 *  图片配置类
 */
@interface UMSocialImageWarterMarkConfig : NSObject<NSCopying>

/**
 *  默认配置类
 *
 *  @return 默认配置类
 */
+(UMSocialImageWarterMarkConfig*)defaultImageWarterMarkConfig;

//检查参数是否有效
-(BOOL)checkValid;

@property(nonatomic,readwrite,strong)UIImage* warterMarkImage;//水印图片
@property(nonatomic,readwrite,assign)CGFloat warterMarkImageScale;//水印图片相对父图片的缩放因素(0-1之间)
@property(nonatomic,readwrite,assign)CGFloat warterMarkImageAlpha;//水印图片的Alpha混合值

/**
 *  靠近水平边的边距
 *  与UMSocialWarterMarkPositon的停靠位置有关，
    如:为UMSocialImageWarterMarkBottomRight时，paddingToHorizontalParentBorder代表与父窗口的右边间隙.
    如:UMSocialImageWarterMarkTopLeft时，paddingToHorizontalParentBorder代表与父窗口的左边间隙.
 */
@property(nonatomic,readwrite,assign)CGFloat paddingToHorizontalParentBorder;//靠近水平边的边距

/**
 *  靠近垂直边的边距
 *  与UMSocialWarterMarkPositon的停靠位置有关，
    如:为UMSocialImageWarterMarkBottomRight时，paddingToHorizontalParentBorder代表与父窗口的下边间隙.
    如:UMSocialImageWarterMarkTopLeft时，paddingToHorizontalParentBorder代表与父窗口的上边间隙.
 */
@property(nonatomic,readwrite,assign)CGFloat paddingToVerticalParentBorder;//靠近垂直边的边距

@property(nonatomic,readonly,assign)CGAffineTransform warterMarkImageTransform;//水印图片的矩阵

@end
