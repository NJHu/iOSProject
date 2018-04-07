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
#import "LMJAnnotationCustomPopView.h"
#include <stdio.h>
#include <malloc/malloc.h>


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

/** <#digest#> */
@property (assign, nonatomic) CLLocationCoordinate2D targetLocationCoordinate;

@end

@implementation LMJBaiduMapViewController

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
        
        baiduMapView.compassPosition = CGPointMake(kScreenWidth - 10 - baiduMapView.compassSize.width, 20);
        
        
        [self.view addSubview:baiduMapView];
        
        _baiduMapView = baiduMapView;
        
        [baiduMapView mas_makeConstraints:^(MASConstraintMaker *make) {
            
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

#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.fd_interactivePopDisabled = YES;
    LMJWeak(self);
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [self.mapManager start:LMJThirdSDKBaiduMapKey  generalDelegate:weakself];
    if (!ret) {
        [MBProgressHUD showError:@"manager start failed!" ToView:self.view];
    }
    self.baiduMapView.showsUserLocation = YES;
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
    [self addptAnnotations];
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
        
        annotation.type = 100;
        annotation.title = obj.coordinate_title;
        annotation.subtitle = obj.coordinate_comments;
        annotation.coordinate = CLLocationCoordinate2DMake(obj.coordinate_latitude, obj.coordinate_longitude);
        annotation.selectedIndex = idx;
        [self.baiduMapView addAnnotation:annotation];
        
        if (idx == 0) {
            BMKCoordinateRegion region;
            region.center = annotation.coordinate;
            region.span.latitudeDelta = 0.2;
            region.span.longitudeDelta = 0.2;
            // 选中一个范围
            [self.baiduMapView setRegion:region];
            // 标注大头针
            [self.baiduMapView selectAnnotation:annotation animated:YES];
        }
        
    }];
    
}


#pragma mark - BMKLocationServiceDelegate 定位

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    BMKPlanNode *start = [[BMKPlanNode alloc] init];
    start.pt = userLocation.location.coordinate;
    BMKPlanNode *end = [[BMKPlanNode alloc] init];
    end.pt =  self.targetLocationCoordinate;
    
    BMKWalkingRoutePlanOption *walkingRoutePlanOption = [[BMKWalkingRoutePlanOption alloc] init];
    
    walkingRoutePlanOption.from = start;
    walkingRoutePlanOption.to = end;
    
    if ([self.routesearch walkingSearch:walkingRoutePlanOption]) {
        [self.locationService stopUserLocationService];
    }else
    {
        NSLog(@"检索失败");
        [self addptAnnotations];
    }
}


#pragma mark - BMKRouteSearchDelegate
- (void)onGetWalkingRouteResult:(BMKRouteSearch *)searcher result:(BMKWalkingRouteResult *)result errorCode:(BMKSearchErrorCode)error
{
    [self.baiduMapView removeAnnotations:self.baiduMapView.annotations];
    [self.baiduMapView removeOverlays:self.baiduMapView.overlays];
    
    if (error != BMK_SEARCH_NO_ERROR) {
        return;
    }
    
    BMKWalkingRouteLine *plan = (BMKWalkingRouteLine *)result.routes.firstObject;
    __block NSInteger planPointCounts = 0;
    
    [plan.steps enumerateObjectsUsingBlock:^(BMKWalkingStep  *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (idx == 0) {
            LMJBaiduPointAnnotation *annotation = [[LMJBaiduPointAnnotation alloc] init];
            annotation.selectedIndex = idx;
            annotation.type = 0;
            annotation.title = @"起点";
            annotation.subtitle = @"起点副标题";
            annotation.coordinate = plan.starting.location;
            [self.baiduMapView addAnnotation:annotation];
            
        } else if (idx == plan.steps.count - 1) {
            
            LMJBaiduPointAnnotation *annotation = [[LMJBaiduPointAnnotation alloc] init];
            annotation.selectedIndex = idx;
            annotation.type = 1;
            annotation.title = @"终点";
            annotation.subtitle = @"终点副标题";
            annotation.coordinate = plan.terminal.location;
            [self.baiduMapView addAnnotation:annotation];
        }
        
        planPointCounts += obj.pointsCount;
    }];
    
    // 设置起点, 为中心点
    BMKUserLocation *userLocation = self.locationService.userLocation;
    BMKCoordinateRegion region;
    region.center = userLocation.location.coordinate;
    region.span.latitudeDelta = 0.2;
    region.span.longitudeDelta = 0.2;
    [self.baiduMapView setRegion:region];
    
    BMKMapPoint *temppoints = (BMKMapPoint *)malloc(sizeof(BMKMapPoint) * planPointCounts);
    
    __block NSInteger j = 0;
    [plan.steps enumerateObjectsUsingBlock:^(BMKWalkingStep  *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        for (NSInteger i = 0; i < obj.pointsCount; i++) {
            temppoints[j].x = obj.points[i].x;
            temppoints[j].y = obj.points[i].y;
            j++;
        }
    }];
    
    // 通过points构建BMKPolyline
    BMKPolyline *polyline = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
    
    [self.baiduMapView addOverlay:polyline];
    free(temppoints);
}



#pragma mark - BMKMapViewDelegate
/**
 *根据overlay生成对应的View
 *@param mapView 地图View
 *@param overlay 指定的overlay
 *@return 生成的覆盖物View
 */
- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id <BMKOverlay>)overlay
{
    if ([overlay isKindOfClass:[BMKPolyline class]]) {
        BMKPolylineView *polylineView = [[BMKPolylineView alloc] initWithPolyline:(BMKPolyline *)overlay];
        polylineView.fillColor = [[UIColor greenColor] colorWithAlphaComponent:0.4];
        polylineView.strokeColor = [[UIColor redColor] colorWithAlphaComponent:0.4];
        polylineView.lineWidth = 2.0;
        return polylineView;
    }
    return nil;
}





#pragma mark - BMKMapViewDelegate mapView

/**
 *根据anntation生成对应的View
 *@param mapView 地图View
 *@param annotation 指定的标注
 *@return 生成的标注View
 */
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    BMKAnnotationView *pinAnnotationView = nil;
    if ([annotation isKindOfClass:[LMJBaiduPointAnnotation class]]) {
        
        LMJBaiduPointAnnotation *myAnnotation = (LMJBaiduPointAnnotation *)annotation;
        
        pinAnnotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:[NSStringFromClass([BMKAnnotationView class]) stringByAppendingFormat:@"Type_%zd", myAnnotation.type]];
        
        NSInteger type = myAnnotation.type;
        
        switch (type) {
                // 起点
//                标注 view
            case 0:
            {
                if (!pinAnnotationView) {
                    pinAnnotationView = [[BMKAnnotationView alloc] initWithAnnotation:myAnnotation reuseIdentifier:[NSStringFromClass([BMKAnnotationView class]) stringByAppendingFormat:@"Type_%zd", myAnnotation.type]];
                    pinAnnotationView.image = [UIImage imageNamed:@"test_BaiDu_StartPoint"];
                    pinAnnotationView.centerOffset = CGPointMake(0, -pinAnnotationView.lmj_height * 0.5);
                    pinAnnotationView.canShowCallout = YES;
                }
                
                pinAnnotationView.annotation = annotation;
            }
                break;
                // 终点
                // 标注 view
            case 1:
            {
                if (!pinAnnotationView) {
                    pinAnnotationView = [[BMKAnnotationView alloc] initWithAnnotation:myAnnotation reuseIdentifier:[NSStringFromClass([BMKAnnotationView class]) stringByAppendingFormat:@"Type_%zd", myAnnotation.type]];
                    pinAnnotationView.image = [UIImage imageNamed:@"test_BaiDu_endPoint"];
                    pinAnnotationView.centerOffset = CGPointMake(0, -pinAnnotationView.lmj_height * 0.5);
                    pinAnnotationView.canShowCallout = YES;
                }
                pinAnnotationView.annotation = annotation;
            }
                break;
            default:
            {
                if (!pinAnnotationView) {
                    // 绿色的小针
                    pinAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:myAnnotation reuseIdentifier:[NSStringFromClass([BMKAnnotationView class]) stringByAppendingFormat:@"Type_%zd", myAnnotation.type]];
                    pinAnnotationView.image = [UIImage imageNamed:@"test_BaiDu_green"];
                }
                
                // 取出位置对应的点
                NSInteger selectedIndex = myAnnotation.selectedIndex;
                
                LMJCoordinateModel *coordinateModel = self.coordinates[selectedIndex];
                
                // 创建自定义的点击弹出的popview
                LMJAnnotationCustomPopView *popView = [LMJAnnotationCustomPopView popView];
                popView.frame = CGRectMake(0, 0, 150, 100);
                
                // 设置数据
                popView.titleLabel.text = coordinateModel.coordinate_title;
                popView.subTitleLabel.text = coordinateModel.coordinate_comments;
                // 设置点击事件
                popView.gotoButton.tag = selectedIndex;
                [popView.gotoButton addTarget:self action:@selector(gotoThisPlaceAndLocation:) forControlEvents:UIControlEventTouchUpInside];
                
                // 添加自定义的 View
                BMKActionPaopaoView *paopaoView = [[BMKActionPaopaoView alloc] initWithCustomView:popView];
                
                paopaoView.frame = CGRectMake(0, 0, 150, 100);
                
                
                // 添加泡泡 View
                // 包装 popView
                BMKPinAnnotationView *newPinAnnotationView = (BMKPinAnnotationView *)pinAnnotationView;
                
                [newPinAnnotationView.paopaoView  removeFromSuperview];
                newPinAnnotationView.paopaoView = nil;
                newPinAnnotationView.paopaoView = paopaoView;
            }
                break;
        }
    }
    
    return pinAnnotationView;
}


#pragma mark - 用户去到的位置
- (void)gotoThisPlaceAndLocation:(UIButton *)btn
{
    self.baiduMapView.showsUserLocation = NO;
    self.baiduMapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
    
    LMJCoordinateModel *endModel = self.coordinates[btn.tag];
    
    // 添加一个终点
    self.targetLocationCoordinate = CLLocationCoordinate2DMake(endModel.coordinate_latitude, endModel.coordinate_longitude);
    
    [self.locationService startUserLocationService];
}


#pragma mark - BMKGeneralDelegate判断是授权否成功
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

#pragma mark - datagetter
/**
模拟2个点
 */
- (NSMutableArray<LMJCoordinateModel *> *)coordinates
{
    if(_coordinates == nil)
    {
        _coordinates = [NSMutableArray array];
        
        LMJCoordinateModel *coordinate = [[LMJCoordinateModel alloc] init];
        
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


- (void)dealloc
{
    _baiduMapView = nil;
    _locationService = nil;
    _routesearch = nil;
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
