/*
 *  BMKMapView.h
 *	BMapKit
 *
 *  Copyright 2011 Baidu Inc. All rights reserved.
 *
 */
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import "BMKAnnotation.h"
#import "BMKAnnotationView.h"
#import "BMKOverlayView.h"
#import "UIKit/UIKit.h"
#import "BMKMapStatus.h"
#import "BMKLocationViewDisplayParam.h"
#import "BMKHeatMap.h"
#import "BMKBaseIndoorMapInfo.h"

@protocol BMKMapViewDelegate;

///点击地图标注返回数据结构
@interface BMKMapPoi : NSObject
///点标注的名称
@property (nonatomic,strong) NSString* text;
///点标注的经纬度坐标
@property (nonatomic,assign) CLLocationCoordinate2D pt;
///点标注的uid，可能为空
@property (nonatomic,strong) NSString* uid;
@end

typedef enum {
    BMKUserTrackingModeNone = 0,             /// 普通定位模式
    BMKUserTrackingModeHeading,              /// 定位方向模式
	BMKUserTrackingModeFollow,               /// 定位跟随模式
	BMKUserTrackingModeFollowWithHeading,    /// 定位罗盘模式
} BMKUserTrackingMode;

///枚举：logo位置
typedef enum {
    BMKLogoPositionLeftBottom = 0,          /// 地图左下方
    BMKLogoPositionLeftTop,                 /// 地图左上方
    BMKLogoPositionCenterBottom,            /// 地图中下方
    BMKLogoPositionCenterTop,               /// 地图中上方
    BMKLogoPositionRightBottom,             /// 地图右下方
    BMKLogoPositionRightTop,                /// 地图右上方
} BMKLogoPosition;

///枚举：室内图切换楼层结果
typedef enum {
    BMKSwitchIndoorFloorSuccess = 0,     /// 切换楼层成功
    BMKSwitchIndoorFloorFailed,          /// 切换楼层失败
    BMKSwitchIndoorFloorNotFocused,      /// 地图还未聚焦到传入的室内图
    BMKSwitchIndoorFloorNotExist,        /// 当前室内图不存在该楼层
} BMKSwitchIndoorFloorError;

///地图View类，使用此View可以显示地图窗口，并且对地图进行相关的操作
@interface BMKMapView : UIView

/// 地图View的Delegate，此处记得不用的时候需要置nil，否则影响内存的释放
@property (nonatomic, weak) id<BMKMapViewDelegate> delegate;

/// 当前地图类型，可设定为标准地图、卫星地图
@property (nonatomic) BMKMapType mapType;

/// 当前地图的经纬度范围，设定的该范围可能会被调整为适合地图窗口显示的范围
@property (nonatomic) BMKCoordinateRegion region;

/// 限制地图的显示范围（地图状态改变时，该范围不会在地图显示范围外。设置成功后，会调整地图显示该范围）
@property (nonatomic) BMKCoordinateRegion limitMapRegion;

/// 指南针的位置，设定坐标以BMKMapView左上角为原点，向右向下增长
@property (nonatomic) CGPoint compassPosition;
/// 指南针的宽高
@property (nonatomic, readonly) CGSize compassSize;

/// 当前地图的中心点，改变该值时，地图的比例尺级别不会发生变化
@property (nonatomic) CLLocationCoordinate2D centerCoordinate;

/// 地图比例尺级别，在手机上当前可使用的级别为3-21级
@property (nonatomic) float zoomLevel;
/// 地图的自定义最小比例尺级别
@property (nonatomic) float minZoomLevel;
/// 地图的自定义最大比例尺级别
@property (nonatomic) float maxZoomLevel;

/// 地图旋转角度，在手机上当前可使用的范围为－180～180度
@property (nonatomic) int rotation;

/// 地图俯视角度，在手机上当前可使用的范围为－45～0度
@property (nonatomic) int overlooking;
///设定地图是否现显示3D楼块效果
@property(nonatomic, getter=isBuildingsEnabled) BOOL buildingsEnabled;
///设定地图是否显示底图poi标注(不包含室内图标注)，默认YES
@property(nonatomic, assign) BOOL showMapPoi;
///设定地图是否打开路况图层
@property(nonatomic, getter=isTrafficEnabled) BOOL trafficEnabled;
///设定地图是否打开百度城市热力图图层（百度自有数据）,注：地图层级大于11时，可显示热力图
@property(nonatomic, getter=isBaiduHeatMapEnabled) BOOL baiduHeatMapEnabled;

///设定地图View能否支持所有手势操作
@property(nonatomic) BOOL gesturesEnabled;
///设定地图View能否支持用户多点缩放(双指)
@property(nonatomic, getter=isZoomEnabled) BOOL zoomEnabled;
///设定地图View能否支持用户缩放(双击或双指单击)
@property(nonatomic, getter=isZoomEnabledWithTap) BOOL zoomEnabledWithTap;
///设定地图View能否支持用户移动地图
@property(nonatomic, getter=isScrollEnabled) BOOL scrollEnabled;
///设定地图View能否支持俯仰角
@property(nonatomic, getter=isOverlookEnabled) BOOL overlookEnabled;
///设定地图View能否支持旋转
@property(nonatomic, getter=isRotateEnabled) BOOL rotateEnabled;

/// 设定地图是否回调force touch事件，默认为NO，仅适用于支持3D Touch的情况，开启后会回调 - mapview:onForceTouch:force:maximumPossibleForce:
@property(nonatomic) BOOL forceTouchEnabled;

/// 设定是否显式比例尺
@property (nonatomic) BOOL showMapScaleBar;

/// 比例尺的位置，设定坐标以BMKMapView左上角为原点，向右向下增长
@property (nonatomic) CGPoint mapScaleBarPosition;

/// 比例尺的宽高
@property (nonatomic, readonly) CGSize mapScaleBarSize;

/// logo位置，默认BMKLogoPositionLeftBottom
@property (nonatomic) BMKLogoPosition logoPosition;

///当前地图范围，采用直角坐标系表示，向右向下增长
@property (nonatomic) BMKMapRect visibleMapRect;

/**
 *地图预留边界，默认：UIEdgeInsetsZero。
 *注：设置后，会根据mapPadding调整logo、比例尺、指南针的位置。
 *   当updateTargetScreenPtWhenMapPaddingChanged==YES时，地图中心(屏幕坐标：BMKMapStatus.targetScreenPt)跟着改变
 */
@property (nonatomic) UIEdgeInsets mapPadding;
///设置mapPadding时，地图中心(屏幕坐标：BMKMapStatus.targetScreenPt)是否跟着改变，默认YES
@property (nonatomic) BOOL updateTargetScreenPtWhenMapPaddingChanged;

///设定地图View能否支持以手势中心点为轴进行旋转和缩放
@property(nonatomic, getter=isChangeWithTouchPointCenterEnabled) BOOL ChangeWithTouchPointCenterEnabled;

///双击手势放大地图时, 设置为YES, 地图中心点移动至点击处; 设置为NO，地图中心点不变；默认为YES;
@property(nonatomic, getter=isChangeCenterWithDoubleTouchPointEnabled) BOOL ChangeCenterWithDoubleTouchPointEnabled;

/**
 *设置自定义地图样式
 *注：必须在BMKMapView对象初始化之前调用
 *@param customMapStyleJsonFilePath 自定义样式文件所在路径，包含文件名
 */
+ (void)customMapStyle:(NSString*) customMapStyleJsonFilePath;
/**
 * 自定义地图样式开关，影响所有BMKMapView对象
 *@param enable 自定义地图样式是否生效
 */
+ (void)enableCustomMapStyle:(BOOL) enable;

/**
 * 2.10.0起废弃，空实现，逻辑由地图SDK控制
 *
 *当应用即将后台时调用，停止一切调用opengl相关的操作。
 */
+(void)willBackGround __deprecated_msg("废弃方法（空实现）,逻辑由地图SDK控制");
/**
 * 2.10.0起废弃，空实现，逻辑由地图SDK控制
 *
 *当应用恢复前台状态时调用。
 */
+(void)didForeGround __deprecated_msg("废弃方法（空实现）,逻辑由地图SDK控制");
/**
 *当mapview即将被显式的时候调用，恢复之前存储的mapview状态。
 */
-(void)viewWillAppear;

/**
 *当mapview即将被隐藏的时候调用，存储当前mapview的状态。
 */
-(void)viewWillDisappear;

/**
 *强制刷新mapview
 */
- (void)mapForceRefresh;

/**
 *放大一级比例尺
 *@return 是否成功
 */
- (BOOL)zoomIn;

/**
 *缩小一级比例尺
 *@return 是否成功
 */
- (BOOL)zoomOut;

/**
 *根据当前地图View的窗口大小调整传入的region，返回适合当前地图窗口显示的region，调整过程会保证中心点不改变
 *@param region 待调整的经纬度范围
 *@return 调整后适合当前地图窗口显示的经纬度范围
 */
- (BMKCoordinateRegion)regionThatFits:(BMKCoordinateRegion)region;

/**
 *设定当前地图的显示范围
 *@param region 要设定的地图范围，用经纬度的方式表示
 *@param animated 是否采用动画效果
 */
- (void)setRegion:(BMKCoordinateRegion)region animated:(BOOL)animated;

/**
 *设定地图中心点坐标
 *@param coordinate 要设定的地图中心点坐标，用经纬度表示
 *@param animated 是否采用动画效果
 */
- (void)setCenterCoordinate:(CLLocationCoordinate2D)coordinate animated:(BOOL)animated;

/**
 *获得地图当前可视区域截图
 *@return 返回view范围内的截取的UIImage
 */
-(UIImage*) takeSnapshot;

/**
 *获得地图区域区域截图
 *@return 返回指定区域的截取的UIImage
 */
-(UIImage*) takeSnapshot:(CGRect)rect;

/**
 *设置罗盘的图片
 *@param image 设置的图片
*/
- (void)setCompassImage:(UIImage *)image;

/**
 *设定当前地图的显示范围,采用直角坐标系表示
 *@param mapRect 要设定的地图范围，用直角坐标系表示
 *@param animate 是否采用动画效果
 */
- (void)setVisibleMapRect:(BMKMapRect)mapRect animated:(BOOL)animate;

/**
 *根据当前地图View的窗口大小调整传入的mapRect，返回适合当前地图窗口显示的mapRect，调整过程会保证中心点不改变
 *@param mapRect 待调整的地理范围，采用直角坐标系表示
 *@return 调整后适合当前地图窗口显示的地理范围，采用直角坐标系
 */
- (BMKMapRect)mapRectThatFits:(BMKMapRect)mapRect;

/**
 *设定地图的显示范围,并使mapRect四周保留insets指定的边界区域
 *@param mapRect 要设定的地图范围，用直角坐标系表示
 *@param insets 指定的四周边界大小
 *@param animate 是否采用动画效果
 */
- (void)setVisibleMapRect:(BMKMapRect)mapRect edgePadding:(UIEdgeInsets)insets animated:(BOOL)animate;

/**
 *根据当前mapView的窗口大小，预留insets指定的边界区域后，将mapRect指定的地理范围显示在剩余的区域内，并尽量充满
 *@param mapRect 要显示的地图范围，用直角坐标系表示
 *@param insets 屏幕四周预留的边界大小（mapRect的内容不会显示在该边界范围内）
 *@param animate 是否采用动画效果
 */
- (void)fitVisibleMapRect:(BMKMapRect)mapRect edgePadding:(UIEdgeInsets)insets withAnimated:(BOOL)animate;

/**
 *根据当前地图View的窗口大小调整传入的mapRect，返回适合当前地图窗口显示的mapRect，并且在该mapRect四周保留insets指定的边界区域
 *@param mapRect 待调整的地理范围，采用直角坐标系表示
 ×@param insets mapRect四周要预留的边界大小
 *@return 调整后适合当前地图窗口显示的地理范围，采用直角坐标系
 */
- (BMKMapRect)mapRectThatFits:(BMKMapRect)mapRect edgePadding:(UIEdgeInsets)insets;

/**
 *将经纬度坐标转换为View坐标
 *@param coordinate 待转换的经纬度坐标
 *@param view 指定相对的View
 *@return 转换后的View坐标
 */
- (CGPoint)convertCoordinate:(CLLocationCoordinate2D)coordinate toPointToView:(UIView *)view;

/**
 *将View坐标转换成经纬度坐标
 *@param point 待转换的View坐标
 *@param view point坐标所在的view
 *@return 转换后的经纬度坐标
 */
- (CLLocationCoordinate2D)convertPoint:(CGPoint)point toCoordinateFromView:(UIView *)view;

/**
 *将经纬度矩形区域转换为View矩形区域
 *@param region 待转换的经纬度矩形
 *@param view 指定相对的View
 *@return 转换后的View矩形区域
 */
- (CGRect)convertRegion:(BMKCoordinateRegion)region toRectToView:(UIView *)view;

/**
 *将View矩形区域转换成经纬度矩形区域
 *@param rect 待转换的View矩形区域
 *@param view rect坐标所在的view
 *@return 转换后的经纬度矩形区域
 */
- (BMKCoordinateRegion)convertRect:(CGRect)rect toRegionFromView:(UIView *)view;

/**
 *将直角地理坐标矩形区域转换为View矩形区域
 *@param mapRect 待转换的直角地理坐标矩形
 *@param view 指定相对的View
 *@return 转换后的View矩形区域
 */
- (CGRect)convertMapRect:(BMKMapRect)mapRect toRectToView:(UIView *)view;

/**
 *将View矩形区域转换成直角地理坐标矩形区域
 *@param rect 待转换的View矩形区域
 *@param view rect坐标所在的view
 *@return 转换后的直角地理坐标矩形区域
 */
- (BMKMapRect)convertRect:(CGRect)rect toMapRectFromView:(UIView *)view;

/**
 *将BMKMapPoint转换为opengles可以直接使用的坐标
 @param mapPoint BMKMapPoint坐标
 @return opengles 直接支持的坐标
 */
- (CGPoint)glPointForMapPoint:(BMKMapPoint)mapPoint;

/**
 *批量将BMKMapPoint转换为opengles可以直接使用的坐标
 @param mapPoints BMKMapPoint坐标数据指针
 @param count 个数,count不能大于数组长度
 @return opengles 直接支持的坐标数据指针(需要调用者手动释放)
 */
- (CGPoint *)glPointsForMapPoints:(BMKMapPoint *)mapPoints count:(NSUInteger)count;

/**
 * 设置地图中心点在地图中的屏幕坐标位置
 * @param ptInScreen 要设定的地图中心点位置，为屏幕坐标，设置的中心点不能超过屏幕范围，否则无效
 */
- (void)setMapCenterToScreenPt:(CGPoint)ptInScreen;

/**
 * 获取地图状态
  *@return 返回地图状态信息
 */
- (BMKMapStatus*)getMapStatus;

/**
 *	设置地图状态
 *	@param	[in]	mapStatus	地图状态信息
 */
- (void)setMapStatus:(BMKMapStatus*)mapStatus;

/**
 *	设置地图状态
 *	@param	[in]	mapStatus	地图状态信息
 *	@param	[in]	bAnimation	是否需要动画效果，true:需要做动画
 */
- (void)setMapStatus:(BMKMapStatus*)mapStatus withAnimation:(BOOL)bAnimation;

/**
 *	设置地图状态
 *	@param	[in]	mapStatus	地图状态信息
 *	@param	[in]	bAnimation	是否需要动画效果，true:需要做动画
 *	@param	[in]	ulDuration	指定动画时间，单位：ms
 */
- (void)setMapStatus:(BMKMapStatus*)mapStatus withAnimation:(BOOL)bAnimation withAnimationTime:(int)ulDuration;

/**
 *	判断当前图区是否支持百度热力图（百度自有数据）
 *  @return 支持返回YES，否则返回NO
 */
- (BOOL)isSurpportBaiduHeatMap;

@end

@interface BMKMapView (IndoorMapAPI)

/// 设定地图是否显示室内图（包含室内图标注），默认不显示
@property (nonatomic, assign) BOOL baseIndoorMapEnabled;

/// 设定室内图标注是否显示，默认YES，仅当显示室内图（baseIndoorMapEnabled为YES）时生效
@property (nonatomic, assign) BOOL showIndoorMapPoi;

/**
 * 设置室内图楼层
 * @param strFloor      楼层
 * @param strID         室内图ID
 * @return 切换结果
 */
- (BMKSwitchIndoorFloorError)switchBaseIndoorMapFloor:(NSString*)strFloor withID:(NSString*)strID;

/**
 * 获取当前聚焦的室内图信息
 * @return 当前聚焦的室内图信息。没有聚焦的室内图，返回nil
 */
- (BMKBaseIndoorMapInfo*)getFocusedBaseIndoorMapInfo;

@end

@interface BMKMapView (LocationViewAPI)

/// 设定是否显示定位图层
@property (nonatomic) BOOL showsUserLocation;

/// 设定定位模式，取值为：BMKUserTrackingMode
@property (nonatomic) BMKUserTrackingMode userTrackingMode;

/// 返回定位坐标点是否在当前地图可视区域内
@property (nonatomic, readonly, getter=isUserLocationVisible) BOOL userLocationVisible;

/**
 *动态定制我的位置样式
 *	@param	[in]	locationViewDisplayParam	样式参数
 */
- (void)updateLocationViewWithParam:(BMKLocationViewDisplayParam*)locationViewDisplayParam;

/**
 *动态更新我的位置数据
 *	@param	[in]	userLocation	定位数据
 */
-(void)updateLocationData:(BMKUserLocation*)userLocation;
@end

@interface BMKMapView (AnnotationAPI)

/// 当前地图View的已经添加的标注数组
@property (nonatomic, readonly) NSArray *annotations;

//设定是否总让选中的annotaion置于最前面
@property (nonatomic, assign) BOOL isSelectedAnnotationViewFront;

/**
 *向地图窗口添加标注，需要实现BMKMapViewDelegate的-mapView:viewForAnnotation:函数来生成标注对应的View
 *@param annotation 要添加的标注
 */
- (void)addAnnotation:(id <BMKAnnotation>)annotation;

/**
 *向地图窗口添加一组标注，需要实现BMKMapViewDelegate的-mapView:viewForAnnotation:函数来生成标注对应的View
 *@param annotations 要添加的标注数组
 */
- (void)addAnnotations:(NSArray *)annotations;

/**
 *移除标注
 *@param annotation 要移除的标注
 */
- (void)removeAnnotation:(id <BMKAnnotation>)annotation;

/**
 *移除一组标注
 *@param annotations 要移除的标注数组
 */
- (void)removeAnnotations:(NSArray *)annotations;

/**
 *查找指定标注对应的View，如果该标注尚未显示，返回nil
 *@param annotation 指定的标注
 *@return 指定标注对应的View
 */
- (BMKAnnotationView *)viewForAnnotation:(id <BMKAnnotation>)annotation;

/**
 *根据指定标识查找一个可被复用的标注View，一般在delegate中使用，用此函数来代替新申请一个View
 *@param identifier 指定标识
 *@return 返回可被复用的标注View
 */
- (BMKAnnotationView *)dequeueReusableAnnotationViewWithIdentifier:(NSString *)identifier;

/**
 *选中指定的标注，本版暂不支持animate效果
 *@param annotation 指定的标注
 *@param animated 本版暂不支持
 */
- (void)selectAnnotation:(id <BMKAnnotation>)annotation animated:(BOOL)animated;

/**
 *取消指定的标注的选中状态，本版暂不支持animate效果
 *@param annotation 指定的标注
 *@param animated 本版暂不支持
 */
- (void)deselectAnnotation:(id <BMKAnnotation>)annotation animated:(BOOL)animated;

/**
 *设置地图使显示区域显示所有annotations,如果数组中只有一个则直接设置地图中心为annotation的位置
 *@param annotations 指定的标注
 *@param animated 是否启动动画
 */
- (void)showAnnotations:(NSArray *)annotations animated:(BOOL)animated;

/**
 *获取矩形区域内的所有annotations
 *@param bounds 矩形区域（经纬度）
 *@return 该矩形区域内的所有annotations
 */
- (NSArray *)annotationsInCoordinateBounds:(BMKCoordinateBounds) bounds;

@end
///地图View类(和Overlay操作相关的接口)
@interface BMKMapView (OverlaysAPI)

/**
 *向地图窗口添加Overlay，需要实现BMKMapViewDelegate的-mapView:viewForOverlay:函数来生成标注对应的View
 *@param overlay 要添加的overlay
 */
- (void)addOverlay:(id <BMKOverlay>)overlay;

/**
 *向地图窗口添加一组Overlay，需要实现BMKMapViewDelegate的-mapView:viewForOverlay:函数来生成标注对应的View
 *@param overlays 要添加的overlay数组
 */
- (void)addOverlays:(NSArray *)overlays;

/**
 *移除Overlay
 *@param overlay 要移除的overlay
 */
- (void)removeOverlay:(id <BMKOverlay>)overlay;

/**
 *移除一组Overlay
 *@param overlays 要移除的overlay数组
 */
- (void)removeOverlays:(NSArray *)overlays;

/**
 *在指定的索引处添加一个Overlay
 *@param overlay 要添加的overlay
 *@param index 指定的索引
 */
- (void)insertOverlay:(id <BMKOverlay>)overlay atIndex:(NSUInteger)index;

/**
 *在交换指定索引处的Overlay
 *@param index1 索引1
 *@param index2 索引2
 */
- (void)exchangeOverlayAtIndex:(NSUInteger)index1 withOverlayAtIndex:(NSUInteger)index2;

/**
 *在指定的Overlay之上插入一个overlay
 *@param overlay 带添加的Overlay
 *@param sibling 用于指定相对位置的Overlay
 */
- (void)insertOverlay:(id <BMKOverlay>)overlay aboveOverlay:(id <BMKOverlay>)sibling;

/**
 *在指定的Overlay之下插入一个overlay
 *@param overlay 带添加的Overlay
 *@param sibling 用于指定相对位置的Overlay
 */
- (void)insertOverlay:(id <BMKOverlay>)overlay belowOverlay:(id <BMKOverlay>)sibling;

/// 当前mapView中已经添加的Overlay数组
@property (nonatomic, readonly) NSArray *overlays;

/**
 *查找指定overlay对应的View，如果该View尚未创建，返回nil
 *@param overlay 指定的overlay
 *@return 指定overlay对应的View
 */
- (BMKOverlayView *)viewForOverlay:(id <BMKOverlay>)overlay;

@end
@interface BMKMapView (HeatMapAPI)

/**
 *添加热力图
 *	@param	heatMap	热力图绘制和显示数据
 */
- (void)addHeatMap:(BMKHeatMap*)heatMap;

/**
 *移除热力图
 */
- (void)removeHeatMap;

@end

/// MapView的Delegate，mapView通过此类来通知用户对应的事件
@protocol BMKMapViewDelegate <NSObject>
@optional

/**
 *地图初始化完毕时会调用此接口
 *@param mapView 地图View
 */
- (void)mapViewDidFinishLoading:(BMKMapView *)mapView;

/**
 *地图渲染完毕后会调用此接口
 *@param mapView 地图View
 */
- (void)mapViewDidFinishRendering:(BMKMapView *)mapView;

/**
 *地图渲染每一帧画面过程中，以及每次需要重绘地图时（例如添加覆盖物）都会调用此接口
 *@param mapView 地图View
 *@param status 此时地图的状态
 */
- (void)mapView:(BMKMapView *)mapView onDrawMapFrame:(BMKMapStatus*)status;

/**
 *地图区域即将改变时会调用此接口
 *@param mapView 地图View
 *@param animated 是否动画
 */
- (void)mapView:(BMKMapView *)mapView regionWillChangeAnimated:(BOOL)animated;

/**
 *地图区域改变完成后会调用此接口
 *@param mapView 地图View
 *@param animated 是否动画
 */
- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated;

/**
 *根据anntation生成对应的View
 *@param mapView 地图View
 *@param annotation 指定的标注
 *@return 生成的标注View
 */
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation;

/**
 *当mapView新添加annotation views时，调用此接口
 *@param mapView 地图View
 *@param views 新添加的annotation views
 */
- (void)mapView:(BMKMapView *)mapView didAddAnnotationViews:(NSArray *)views;

/**
 *当选中一个annotation views时，调用此接口
 *@param mapView 地图View
 *@param view 选中的annotation views
 */
- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view;

/**
 *当取消选中一个annotation views时，调用此接口
 *@param mapView 地图View
 *@param view 取消选中的annotation views
 */
- (void)mapView:(BMKMapView *)mapView didDeselectAnnotationView:(BMKAnnotationView *)view;

/**
 *拖动annotation view时，若view的状态发生变化，会调用此函数。ios3.2以后支持
 *@param mapView 地图View
 *@param view annotation view
 *@param newState 新状态
 *@param oldState 旧状态
 */
- (void)mapView:(BMKMapView *)mapView annotationView:(BMKAnnotationView *)view didChangeDragState:(BMKAnnotationViewDragState)newState
   fromOldState:(BMKAnnotationViewDragState)oldState;

/**
 *当点击annotation view弹出的泡泡时，调用此接口
 *@param mapView 地图View
 *@param view 泡泡所属的annotation view
 */
- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view;

/**
 *根据overlay生成对应的View
 *@param mapView 地图View
 *@param overlay 指定的overlay
 *@return 生成的覆盖物View
 */
- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id <BMKOverlay>)overlay;

/**
 *当mapView新添加overlay views时，调用此接口
 *@param mapView 地图View
 *@param overlayViews 新添加的overlay views
 */
- (void)mapView:(BMKMapView *)mapView didAddOverlayViews:(NSArray *)overlayViews;

/**
 *点中覆盖物后会回调此接口，目前只支持点中BMKPolylineView时回调
 *@param mapView 地图View
 *@param overlayView 覆盖物view信息
 */
- (void)mapView:(BMKMapView *)mapView onClickedBMKOverlayView:(BMKOverlayView *)overlayView;

/**
 *点中底图标注后会回调此接口
 *@param mapView 地图View
 *@param mapPoi 标注点信息
 */
- (void)mapView:(BMKMapView *)mapView onClickedMapPoi:(BMKMapPoi*)mapPoi;

/**
 *点中底图空白处会回调此接口
 *@param mapView 地图View
 *@param coordinate 空白处坐标点的经纬度
 */
- (void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate;

/**
 *双击地图时会回调此接口
 *@param mapView 地图View
 *@param coordinate 返回双击处坐标点的经纬度
 */
- (void)mapview:(BMKMapView *)mapView onDoubleClick:(CLLocationCoordinate2D)coordinate;

/**
 *长按地图时会回调此接口
 *@param mapView 地图View
 *@param coordinate 返回长按事件坐标点的经纬度
 */
- (void)mapview:(BMKMapView *)mapView onLongClick:(CLLocationCoordinate2D)coordinate;

/**
 *3DTouch 按地图时会回调此接口（仅在支持3D Touch，且fouchTouchEnabled属性为YES时，会回调此接口）
 *@param mapView 地图View
 *@param coordinate 触摸点的经纬度
 *@param force 触摸该点的力度(参考UITouch的force属性)
 *@param maximumPossibleForce 当前输入机制下的最大可能力度(参考UITouch的maximumPossibleForce属性)
 */
- (void)mapview:(BMKMapView *)mapView onForceTouch:(CLLocationCoordinate2D)coordinate force:(CGFloat)force maximumPossibleForce:(CGFloat)maximumPossibleForce;

/**
 *地图状态改变完成后会调用此接口
 *@param mapView 地图View
 */
- (void)mapStatusDidChanged:(BMKMapView *)mapView;

/**
 *地图进入/移出室内图会调用此接口
 *@param mapView 地图View
 *@param flag  YES:进入室内图; NO:移出室内图
 *@param info 室内图信息
 */
- (void)mapview:(BMKMapView *)mapView baseIndoorMapWithIn:(BOOL)flag baseIndoorMapInfo:(BMKBaseIndoorMapInfo *)info;

@end
