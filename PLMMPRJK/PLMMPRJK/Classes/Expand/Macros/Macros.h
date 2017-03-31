//
//  Macros.h
//  MobileProject  常见的配置项
//
//  Created by wujunyang on 16/1/5.
//  Copyright © 2016年 wujunyang. All rights reserved.
//


//中文字体
#define CHINESE_FONT_NAME  @"Heiti SC"
#define CHINESE_SYSTEM(x) [UIFont fontWithName:CHINESE_FONT_NAME size:x]

//不同屏幕尺寸字体适配（320，568是因为效果图为IPHONE5 如果不是则根据实际情况修改）
#define kScreenWidthRatio  (Main_Screen_Width / 320.0)
#define kScreenHeightRatio (Main_Screen_Height / 568.0)
#define AdaptedWidth(x)  ceilf((x) * kScreenWidthRatio)
#define AdaptedHeight(x) ceilf((x) * kScreenHeightRatio)
#define AdaptedFontSize(R)     CHINESE_SYSTEM(AdaptedWidth(R))

#define UNICODETOUTF16(x) (((((x - 0x10000) >>10) | 0xD800) << 16)  | (((x-0x10000)&3FF) | 0xDC00))
#define MULITTHREEBYTEUTF16TOUNICODE(x,y) (((((x ^ 0xD800) << 2) | ((y ^ 0xDC00) >> 8)) << 8) | ((y ^ 0xDC00) & 0xFF)) + 0x10000

// App Frame Height&Width
#define App_Frame_Height        [[UIScreen mainScreen] applicationFrame].size.height
#define App_Frame_Width         [[UIScreen mainScreen] applicationFrame].size.width

//获取View的属性
#define GetViewWidth(view)  view.frame.size.width
#define GetViewHeight(view) view.frame.size.height
#define GetViewX(view)      view.frame.origin.x
#define GetViewY(view)      view.frame.origin.y

// MainScreen Height&Width
#define Main_Screen_Height      [[UIScreen mainScreen] bounds].size.height
#define Main_Screen_Width       [[UIScreen mainScreen] bounds].size.width

// MainScreen bounds
#define Main_Screen_Bounds [[UIScreen mainScreen] bounds]

//导航栏高度
#define TopBarHeight 64.5

// 字体大小(常规/粗体)
#define BOLDSYSTEMFONT(FONTSIZE)[UIFont boldSystemFontOfSize:FONTSIZE]
#define SYSTEMFONT(FONTSIZE)    [UIFont systemFontOfSize:FONTSIZE]
#define FONT(NAME, FONTSIZE)    [UIFont fontWithName:(NAME) size:(FONTSIZE)]

//字体色彩
#define COLOR_WORD_BLACK HEXCOLOR(0x333333)
#define COLOR_WORD_GRAY_1 HEXCOLOR(0x666666)
#define COLOR_WORD_GRAY_2 HEXCOLOR(0x999999)

#define COLOR_UNDER_LINE [UIColor colorWithRed:198/255.0 green:198/255.0 blue:198/255.0 alpha:1]

//App版本号
#define appMPVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
// 当前版本
#define FSystemVersion          ([[[UIDevice currentDevice] systemVersion] floatValue])
#define DSystemVersion          ([[[UIDevice currentDevice] systemVersion] doubleValue])
#define SSystemVersion          ([[UIDevice currentDevice] systemVersion])

// 是否大于等于IOS7
#define isIOS7                  ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
// 是否IOS6
#define isIOS6                  ([[[UIDevice currentDevice]systemVersion]floatValue] < 7.0)
// 是否大于等于IOS8
#define isIOS8                  ([[[UIDevice currentDevice]systemVersion]floatValue] >=8.0)
// 是否大于IOS9
#define isIOS9                  ([[[UIDevice currentDevice]systemVersion]floatValue] >=9.0)
// 是否iPad
#define isPad                   (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

// 是否空对象
#define IS_NULL_CLASS(OBJECT) [OBJECT isKindOfClass:[NSNull class]]

//色值
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r,g,b) RGBA(r,g,b,1.0f)

#define HEXCOLOR(hex) [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16)) / 255.0 green:((float)((hex & 0xFF00) >> 8)) / 255.0 blue:((float)(hex & 0xFF)) / 255.0 alpha:1]

#define COLOR_RGB(rgbValue,a) [UIColor colorWithRed:((float)(((rgbValue) & 0xFF0000) >> 16))/255.0 green:((float)(((rgbValue) & 0xFF00)>>8))/255.0 blue: ((float)((rgbValue) & 0xFF))/255.0 alpha:(a)]


//AppDelegate对象
#define AppDelegateInstance [[UIApplication sharedApplication] delegate]
//一些缩写
#define kApplication        [UIApplication sharedApplication]
#define kKeyWindow          [UIApplication sharedApplication].keyWindow
#define kUserDefaults       [NSUserDefaults standardUserDefaults]
#define kNotificationCenter [NSNotificationCenter defaultCenter]

//获取当前语言
#define kCurrentLanguage ([[NSLocale preferredLanguages] objectAtIndex:0])

//获取图片资源
#define GetImage(imageName) [UIImage imageNamed:[NSString stringWithFormat:@"%@",imageName]]

//Library/Caches 文件路径
#define FilePath ([[NSFileManager defaultManager] URLForDirectory:NSCachesDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:nil])
//获取temp
#define kPathTemp NSTemporaryDirectory()
//获取沙盒 Document
#define kPathDocument [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]
//获取沙盒 Cache
#define kPathCache [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]



//字符串是否为空
#define kStringIsEmpty(str) ([str isKindOfClass:[NSNull class]] || str == nil || [str length] < 1 ? YES : NO )
//数组是否为空
#define kArrayIsEmpty(array) (array == nil || [array isKindOfClass:[NSNull class]] || array.count == 0)
//字典是否为空
#define kDictIsEmpty(dic) (dic == nil || [dic isKindOfClass:[NSNull class]] || dic.allKeys == 0)
//是否是空对象
#define kObjectIsEmpty(_object) (_object == nil \
|| [_object isKindOfClass:[NSNull class]] \
|| ([_object respondsToSelector:@selector(length)] && [(NSData *)_object length] == 0) \
|| ([_object respondsToSelector:@selector(count)] && [(NSArray *)_object count] == 0))

//由角度转换弧度
#define kDegreesToRadian(x)      (M_PI * (x) / 180.0)
//由弧度转换角度
#define kRadianToDegrees(radian) (radian * 180.0) / (M_PI)

//获取一段时间间隔
#define kStartTime CFAbsoluteTime start = CFAbsoluteTimeGetCurrent();
#define kEndTime   NSLog(@"Time: %f", CFAbsoluteTimeGetCurrent() - start)


//在Main线程上运行
#define DISPATCH_ON_MAIN_THREAD(mainQueueBlock) dispatch_async(dispatch_get_main_queue(), mainQueueBlock);

//主线程上Demo
//DISPATCH_ON_MAIN_THREAD(^{
    //更新UI
//})



//在Global Queue上运行
#define DISPATCH_ON_GLOBAL_QUEUE_HIGH(globalQueueBlocl) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), globalQueueBlocl);
#define DISPATCH_ON_GLOBAL_QUEUE_DEFAULT(globalQueueBlocl) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), globalQueueBlocl);
#define DISPATCH_ON_GLOBAL_QUEUE_LOW(globalQueueBlocl) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), globalQueueBlocl);
#define DISPATCH_ON_GLOBAL_QUEUE_BACKGROUND(globalQueueBlocl) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), globalQueueBlocl);

//Global Queue
//DISPATCH_ON_GLOBAL_QUEUE_DEFAULT(^{
    //异步耗时任务
//})


//弱引用/强引用  可配对引用在外面用MPWeakSelf(self)，block用MPStrongSelf(self)  也可以单独引用在外面用MPWeakSelf(self) block里面用weakself
#define MPWeakSelf(type)  __weak typeof(type) weak##type = type;
#define MPStrongSelf(type)  __strong typeof(type) type = weak##type;

#define weakify(...) \
ext_keywordify \
metamacro_foreach_cxt(ext_weakify_,, __weak, __VA_ARGS__)
#define strongify(...) \
ext_keywordify \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
metamacro_foreach(ext_strongify_,, __VA_ARGS__) \
_Pragma("clang diagnostic pop")

//上传图片相关
#define kImageCollectionCell_Width floorf((Main_Screen_Width - 10*2- 10*3)/3)
//最大的上传图片张数
#define kupdateMaximumNumberOfImage 12





