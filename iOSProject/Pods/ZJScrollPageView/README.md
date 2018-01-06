# ZJScrollPageView
####OC版的简单方便的集成网易新闻, 腾讯视频, 头条 等首页的滑块视图联动的效果, segmentVIew, scrollViewController

###swift版本的请点[这里](https://github.com/jasnig/ScrollPageView)

####注意,如果您需要查看详细的注释, 可以下载swift版本里面, 这里很多地方就没有把注释移过来了
----
##使用示例效果
![滚动示例1.gif](http://upload-images.jianshu.io/upload_images/1271831-ecb291a43d1e5209.gif?imageMogr2/auto-orient/strip)![滚动示例2.gif](http://upload-images.jianshu.io/upload_images/1271831-bd679dbe86ab7404.gif?imageMogr2/auto-orient/strip)![滚动示例3.gif](http://upload-images.jianshu.io/upload_images/1271831-e094a23212160015.gif?imageMogr2/auto-orient/strip)

![滚动示例4.gif](http://upload-images.jianshu.io/upload_images/1271831-829166f3911adff6.gif?imageMogr2/auto-orient/strip)![滚动示例5.gif](http://upload-images.jianshu.io/upload_images/1271831-3f2b8dc30bf013b1.gif?imageMogr2/auto-orient/strip)![滚动示例6.gif](http://upload-images.jianshu.io/upload_images/1271831-6d37b6b5699e63a6.gif?imageMogr2/auto-orient/strip)

![滚动示例7.gif](http://upload-images.jianshu.io/upload_images/1271831-d4c09a66bd840fe4.gif?imageMogr2/auto-orient/strip)
![滚动示例8.gif](http://upload-images.jianshu.io/upload_images/1271831-c6b1d54295f4bcb1.gif?imageMogr2/auto-orient/strip)

![tupian1](http://upload-images.jianshu.io/upload_images/1271831-7cd2608c83794f15.gif?imageMogr2/auto-orient/strip)
![tupian2.gif](http://upload-images.jianshu.io/upload_images/1271831-6910abfdf29dc67f.gif?imageMogr2/auto-orient/strip)
![tupian3.gif](http://upload-images.jianshu.io/upload_images/1271831-b62f7976f4051931.gif?imageMogr2/auto-orient/strip)
![tupian4.gif](http://upload-images.jianshu.io/upload_images/1271831-bb2c00f01725c010.gif?imageMogr2/auto-orient/strip)

----
### 可以简单快速灵活的实现上图中的效果

-----


### 书写思路移步
###[简书1](http://www.jianshu.com/p/b84f4dd96d0c)

## Requirements

* iOS 7.0+ 


## Installation

* ###直接将下载文件的ZJScrollPageView文件夹下的文件拖进您的项目中然后#import "ZJScrollPageView.h"就可以使用了
 
* 使用cocoaPods, 在你项目的Podfile文件里面添加 `pod ZJScrollPageView`

##usage

####特别说明
因为大家可能会复用同一个controller来显示内容
* 在对应的controller的viewWillAppear()等生命周期里面可以根据不同的title来显示不同的内容或者刷新视图
* 但是注意ZJScrollPageView不会保证viewWillAppear等生命周期方法一定会调用
* 所以建议在子控制器中使用ZJScrollPageViewChildVcDelegate中的方法来加载不同的数据


----
###更新说明
* 2016/05/26 新增了一个通知ScrollPageViewDidShowThePageNotification, 你可以监听这个通知来获取到正在显示的页数, 使用的示例可以参照 ZJSegmentStyle.h里面的说明
* 2016/05/27 增加了一个style属性 segmentViewBounces, 来设置segmentView是否有弹性
* 2016/05/27 增加了一个style属性 scrollContentView, 来设置contentView是否能滑动
* 2016/06/12 增加了一个分类, 提供了 scrollPageParentViewController属性, 方便在每个界面获取到父控制器
* 2016/06/29 更改了初始化方法, 改为了使用代理来传递相关的自控制器 方便动态更新
* 2016/06/30 新增加了子控制器遵守的协议ZJScrollPageViewChildVcDelegate, 用于页面出现的时候加载数据
* 2016/08/21 增加了可以显示图片, 和设置图片的不同位置的功能
----




####可以设置的style效果
```
/** 是否显示遮盖 默认为NO */
@property (assign, nonatomic, getter=isShowCover) BOOL showCover;
/** 是否显示滚动条 默认为NO*/
@property (assign, nonatomic, getter=isShowLine) BOOL showLine;
/** 是否缩放标题 默认为NO*/
@property (assign, nonatomic, getter=isScaleTitle) BOOL scaleTitle;
/** 是否滚动标题 默认为YES 设置为NO的时候所有的标题将不会滚动, 并且宽度会平分 和系统的segment效果相似 */
@property (assign, nonatomic, getter=isScrollTitle) BOOL scrollTitle;
/** segmentView是否有弹性 默认为NO*/
@property (assign, nonatomic, getter=isSegmentViewBounces) BOOL segmentViewBounces;
/** 是否颜色渐变 默认为NO*/
@property (assign, nonatomic, getter=isGradualChangeTitleColor) BOOL gradualChangeTitleColor;
/** 是否显示附加的按钮 默认为NO*/
@property (assign, nonatomic, getter=isShowExtraButton) BOOL showExtraButton;
/** 内容view是否能滑动 默认为YES*/
@property (assign, nonatomic, getter=isScrollContentView) BOOL scrollContentView;
/** 设置附加按钮的背景图片 默认为nil*/
@property (strong, nonatomic) NSString *extraBtnBackgroundImageName;
/** 滚动条的高度 默认为2 */
@property (assign, nonatomic) CGFloat scrollLineHeight;
/** 滚动条的颜色 */
@property (strong, nonatomic) UIColor *scrollLineColor;
/** 遮盖的颜色 */
@property (strong, nonatomic) UIColor *coverBackgroundColor;
/** 遮盖的圆角 默认为14*/
@property (assign, nonatomic) CGFloat coverCornerRadius;
/** 遮盖的高度 默认为28*/
@property (assign, nonatomic) CGFloat coverHeight;
/** 标题之间的间隙 默认为15.0 */
@property (assign, nonatomic) CGFloat titleMargin;
/** 标题的字体 默认为14 */
@property (strong, nonatomic) UIFont *titleFont;
/** 标题缩放倍数, 默认1.3 */
@property (assign, nonatomic) CGFloat titleBigScale;
/** 标题一般状态的颜色 */
@property (strong, nonatomic) UIColor *normalTitleColor;
/** 标题选中状态的颜色 */
@property (strong, nonatomic) UIColor *selectedTitleColor;
/** segmentVIew的高度, 这个属性只在使用ZJScrollPageVIew的时候设置生效 */
@property (assign, nonatomic) CGFloat segmentHeight;
```

####一. 使用ScrollPageView , 提供了各种效果的组合,但是不能修改segmentView和ContentView的相对位置,两者是结合在一起的

	- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"效果示例";

    //必要的设置, 如果没有设置可能导致内容显示不正常
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    ZJSegmentStyle *style = [[ZJSegmentStyle alloc] init];
    //显示遮盖
    style.showCover = YES;
    style.segmentViewBounces = NO;
    // 颜色渐变
    style.gradualChangeTitleColor = YES;
    // 显示附加的按钮
    style.showExtraButton = YES;
    // 设置附加按钮的背景图片
    style.extraBtnBackgroundImageName = @"extraBtnBackgroundImage";
    
    self.titles = @[@"新闻头条",
                    @"国际要闻",
                    @"体育",
                    @"中国足球",
                    @"汽车",
                    @"囧途旅游",
                    @"幽默搞笑",
                    @"视频",
                    @"无厘头",
                    @"美女图片",
                    @"今日房价",
                    @"头像",
                    ];
    // 初始化
    CGRect scrollPageViewFrame = CGRectMake(0, 64.0, self.view.bounds.size.width, self.view.bounds.size.height - 64.0);
    ZJScrollPageView *scrollPageView = [[ZJScrollPageView alloc] initWithFrame:scrollPageViewFrame segmentStyle:style titles:_titles parentViewController:self delegate:self];
    self.scrollPageView = scrollPageView;
    // 额外的按钮响应的block
    __weak typeof(self) weakSelf = self;
    
    
    self.scrollPageView.extraBtnOnClick = ^(UIButton *extraBtn){
        weakSelf.title = @"点击了extraBtn";
        NSLog(@"点击了extraBtn");
        
    };
    [self.view addSubview:self.scrollPageView];
}


代理方法

	- (NSInteger)numberOfChildViewControllers {
    return self.titles.count;// 传入页面的总数, 推荐使用titles.count
    }
    
	- (UIViewController *)childViewController:(UIViewController *)reuseViewController forIndex:(NSInteger)index {

    UIViewController *childVc = reuseViewController;
    // 这里一定要判断传过来的是否是nil, 如果为nil直接使用并返回
    // 如果不为nil 就创建
    if (childVc == nil) {
        childVc = [UIViewController new];
        
        if (index%2 == 0) {
            childVc.view.backgroundColor = [UIColor redColor];
        } else {
            childVc.view.backgroundColor = [UIColor cyanColor];

        }
        
    }
    return childVc;
	}
####二 使用 ZJScrollSegmentView 和 ZJContentView, 提供相同的效果组合, 但是同时可以分离开segmentView和contentView,可以单独设置他们的frame, 使用更灵活


	- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"效果示例";

    //必要的设置, 如果没有设置可能导致内容显示不正常
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.childVcs = [self setupChildVc];
    // 初始化
    [self setupSegmentView];
    [self setupContentView];
    
	}


###setupSegmentView
	    // 注意: 一定要避免循环引用!!
    __weak typeof(self) weakSelf = self;
    ZJScrollSegmentView *segment = [[ZJScrollSegmentView alloc] initWithFrame:CGRectMake(0, 64.0, 160.0, 28.0) segmentStyle:style titles:titles titleDidClick:^(UILabel *label, NSInteger index) {
        
        [weakSelf.contentView setContentOffSet:CGPointMake(weakSelf.contentView.bounds.size.width * index, 0.0) animated:YES];
        
    }];
    // 自定义标题的样式
    segment.layer.cornerRadius = 14.0;
    segment.backgroundColor = [UIColor redColor];
    // 当然推荐直接设置背景图片的方式
	//    segment.backgroundImage = [UIImage imageNamed:@"extraBtnBackgroundImage"];
    
    self.segmentView = segment;
    self.navigationItem.titleView = self.segmentView;
    
    
###setupContentView

	    ZJContentView *content = [[ZJContentView alloc] initWithFrame:CGRectMake(0.0, 64.0, self.view.bounds.size.width, self.view.bounds.size.height - 64.0) segmentView:self.segmentView parentViewController:self delegate:self];
    self.contentView = content;
    [self.view addSubview:self.contentView];
 代理方法
 
	- (NSInteger)numberOfChildViewControllers {
    return self.titles.count;
	}

	- (UIViewController *)childViewController:(UIViewController *)reuseViewController forIndex:(NSInteger)index {
    UIViewController *childVc = reuseViewController;
    if (childVc == nil) {
        childVc = self.childVcs[index];
        
        if (index%2 == 0) {
            childVc.view.backgroundColor = [UIColor redColor];
        } else {
            childVc.view.backgroundColor = [UIColor cyanColor];
            
        }
        
    }
    return childVc;
	}
    
    
    
###如果有建议, 请随意issue或者P-R


####如果对你有帮助,请随手给个star 
####如果你在使用中遇到问题: 可以联系我QQ: 854136959

## License

ScrollPageView is released under the MIT license. See LICENSE for details.