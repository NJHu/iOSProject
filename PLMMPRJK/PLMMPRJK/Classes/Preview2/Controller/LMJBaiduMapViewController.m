//
//  LMJBaiduMapViewController.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/5/2.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJBaiduMapViewController.h"
// 百度地图
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件

#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件

#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件

#import <BaiduMapAPI_Cloud/BMKCloudSearchComponent.h>//引入云检索功能所有的头文件

#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件

#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>//引入计算工具所有的头文件

#import <BaiduMapAPI_Radar/BMKRadarComponent.h>//引入周边雷达功能所有的头文件

#import <BaiduMapAPI_Map/BMKMapView.h>//只引入所需的单个头文件

#import "LMJBaiduPointAnnotation.h"
#import "LMJCoordinateModel.h"


@interface LMJBaiduMapViewController ()<BMKGeneralDelegate, BMKMapViewDelegate, BMKLocationServiceDelegate, BMKRouteSearchDelegate>

/** <#digest#> */
@property (nonatomic, strong) BMKMapManager *mapManager;

/** <#digest#> */
@property (weak, nonatomic) BMKMapView *baiduMapView;

/** <#digest#> */
@property (nonatomic, strong) BMKLocationService *locationService;

/** <#digest#> */
@property (nonatomic, strong) BMKRouteSearch *routesearch;

/** <#digest#> */
@property (nonatomic, strong) NSMutableArray<LMJCoordinateModel *> *coordinates;

@end

@implementation LMJBaiduMapViewController



#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.fd_interactivePopDisabled = YES;
    
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [self.mapManager start:LMJThirdSDKBaiduMapKey  generalDelegate:self];
    if (!ret) {
        
        [MBProgressHUD showError:@"manager start failed!" ToView:self.view];
        
    }
    
    self.baiduMapView.showsUserLocation = YES;

    [self addptAnnotations];
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.baiduMapView viewWillAppear];
    
    self.baiduMapView.delegate = self;
    self.locationService.delegate = self;
    self.routesearch.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.baiduMapView viewWillDisappear];
    
    self.baiduMapView.delegate = nil;
    self.locationService.delegate = nil;
    self.routesearch.delegate = nil;
    
}

- (void)addptAnnotations
{
    [self.coordinates enumerateObjectsUsingBlock:^(LMJCoordinateModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        LMJBaiduPointAnnotation *annotation = [[LMJBaiduPointAnnotation alloc] init];
        
        /** <#digest#> */
//        @property (assign, nonatomic) NSInteger type; // <0:起点 1：终点 2：公交 3：地铁 4:驾乘 5:途经点 100:自定义视图点
        
        
        /** <#digest#> */
        //@property (assign, nonatomic) NSInteger degree;
        
        
        
        ///// 要显示的标题
        //@property (copy) NSString *title;
        ///// 要显示的副标题
        //@property (copy) NSString *subtitle;
        
        
        
        ///该点的坐标
        //@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
        
        annotation.type = 100;
        annotation.title = obj.coordinate_title;
        annotation.subtitle = obj.coordinate_comments;
        annotation.coordinate = CLLocationCoordinate2DMake(obj.coordinate_latitude, obj.coordinate_longitude);
        
        [self.baiduMapView addAnnotation:annotation];
        
        [self.baiduMapView selectAnnotation:annotation animated:YES];
        
        
        if (idx == 0) {
            
            BMKCoordinateRegion region;
            
            region.center = annotation.coordinate;
            
            region.span.latitudeDelta = 0.2;
            region.span.longitudeDelta = 0.2;
            
            [self.baiduMapView setRegion:region];
        }
        
    }];
    
}


#pragma mark - BMKMapViewDelegate



/**
 *根据anntation生成对应的View
 *@param mapView 地图View
 *@param annotation 指定的标注
 *@return 生成的标注View
 */
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    
    if ([annotation isKindOfClass:[LMJBaiduPointAnnotation class]]) {
        
        
        BMKPinAnnotationView *pinAnnotationView = (BMKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:NSStringFromClass([BMKPinAnnotationView class])];
        
        
        if (!pinAnnotationView) {
            
            pinAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:NSStringFromClass([BMKPinAnnotationView class])];
        }
        
        pinAnnotationView.annotation = annotation;
        
        return pinAnnotationView;
    }
    
    return nil;
}




#pragma mark - BMKGeneralDelegate判断是否成功
/**
 *返回网络错误
 *@param iError 错误号
 */
- (void)onGetNetworkState:(int)iError
{
    if (iError) {
        [MBProgressHUD showError:@"返回网络错误" ToView:self.view];
    }
    
}

/**
 *返回授权验证错误
 *@param iError 错误号 : 为0时验证通过，具体参加BMKPermissionCheckResultCode
 */
- (void)onGetPermissionState:(int)iError
{
    
    if (iError) {
        
        [MBProgressHUD showError:@"返回授权验证错误" ToView:self.view];
    }
}
#pragma mark - getter


- (BMKMapManager *)mapManager
{
    if(_mapManager == nil)
    {
        _mapManager = [[BMKMapManager alloc] init];
        
        
    }
    return _mapManager;
}

- (BMKMapView *)baiduMapView
{
    if(_baiduMapView == nil)
    {
        
        BMKMapView *baiduMapView = [[BMKMapView alloc] initWithFrame:self.view.bounds];
        
        baiduMapView.mapType = BMKMapTypeStandard;
        
        baiduMapView.compassPosition = CGPointMake(Main_Screen_Width - 10 - baiduMapView.compassSize.width, 20);

        
        [self.view addSubview:baiduMapView];
        
        _baiduMapView = baiduMapView;
        
        [baiduMapView makeConstraints:^(MASConstraintMaker *make) {
           
            make.edges.equalTo(self.view);
            
        }];
        
    }
    return _baiduMapView;
}



- (BMKRouteSearch *)routesearch
{
    if(_routesearch == nil)
    {
        _routesearch = [[BMKRouteSearch alloc] init];
    }
    return _routesearch;
}

- (BMKLocationService *)locationService
{
    if(_locationService == nil)
    {
        _locationService = [[BMKLocationService alloc] init];
    }
    return _locationService;
}

- (NSMutableArray<LMJCoordinateModel *> *)coordinates
{
    if(_coordinates == nil)
    {
        _coordinates = [NSMutableArray array];
        
        LMJCoordinateModel *coordinate = [[LMJCoordinateModel alloc] init];
        
        
//        //纬度
//        @property(assign,nonatomic)float coordinate_latitude;
//        //经度
//        @property(assign,nonatomic)float coordinate_longitude;
//        //业务标题
//        @property(strong,nonatomic)NSString *coordinate_title;
//        //业务注解
//        @property(strong,nonatomic)NSString *coordinate_comments;
//        //业务ID
//        @property(assign,nonatomic)long coordinate_objID;

        
        coordinate.coordinate_latitude = 40;
        coordinate.coordinate_longitude = 117;
        coordinate.coordinate_title = @"我是第一个点";
        coordinate.coordinate_comments = @"我是第一个点的描述";
        coordinate.coordinate_objID = 1;
        
        
        [_coordinates addObject:coordinate];
        
        
        LMJCoordinateModel *coordinate1 = [[LMJCoordinateModel alloc] init];
        
        
        coordinate1.coordinate_latitude = 40;
        coordinate1.coordinate_longitude = 115;
        coordinate1.coordinate_title = @"我是第二个点";
        coordinate1.coordinate_comments = @"我是第二个点的描述";
        coordinate1.coordinate_objID = 2;
        

        
        [_coordinates addObject:coordinate1];
        
    }
    return _coordinates;
}

#pragma mark - LMJNavUIBaseViewControllerDataSource

- (UIColor *)lmjNavigationBackgroundColor:(LMJNavigationBar *)navigationBar
{
    return [UIColor clearColor];
}

- (BOOL)lmjNavigationIsHideBottomLine:(LMJNavigationBar *)navigationBar
{
    return YES;
}

- (NSMutableAttributedString *)lmjNavigationBarTitle:(LMJNavigationBar *)navigationBar
{
    return nil;
}

/** 导航条左边的按钮 */
- (UIImage *)lmjNavigationBarLeftButtonImage:(UIButton *)leftButton navigationBar:(LMJNavigationBar *)navigationBar
{
    [leftButton setImage:[UIImage imageNamed:@"NavgationBar_white_back"] forState:UIControlStateHighlighted];
    
    return [UIImage imageNamed:@"NavgationBar_blue_back"];
}

#pragma mark - LMJNavUIBaseViewControllerDelegate
/** 左边的按钮的点击 */
-(void)leftButtonEvent:(UIButton *)sender navigationBar:(LMJNavigationBar *)navigationBar
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
