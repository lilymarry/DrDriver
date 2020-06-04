//
//  InTravelMapViewController.m
//  DrUser
//
//  Created by fy on 2019/1/18.
//  Copyright © 2019 tangchaoke. All rights reserved.
//

#import "InTravelMapViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <AMapNaviKit/AMapNaviKit.h>
//#import "DCYMapView.h"

@interface InTravelMapViewController ()<MAMapViewDelegate,
AMapNaviDriveManagerDelegate>{
    MAPointAnnotation *locationAnnotation;//起点的大头针
    MAPointAnnotation *endAnnotation;//终点的大头针
}

@property (strong, nonatomic) MAMapView * mapView;//地图;
@property (nonatomic,strong) MAPolyline * commonPolyline;//轨迹（折现）
@property (nonatomic,weak) AMapNaviDriveManager * driveManager;//轨迹管理


@end

@implementation InTravelMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpNav];
    self.title = @"行程路线";
    
    [self setUpMapView];//设置显示地图
    [self addAnnation];
}

//设置显示地图
-(void)setUpMapView
{
    [AMapServices sharedServices].enableHTTPS = YES;
    //注册高德地图
    [AMapServices sharedServices].apiKey=@"c6bc4269c364702cbc3632656f126d14";
    self.mapView = [[MAMapView alloc] init];
    self.mapView.frame = CGRectMake(0, 0, DeviceWidth, DeviceHeight);
    [self.view addSubview:self.mapView];
    
    [self.view sendSubviewToBack:self.mapView];
    
    self.mapView.mapType=MAMapTypeNavi;
    self.mapView.showsLabels=YES;
    self.mapView.showsBuildings=YES;
    self.mapView.delegate=self;
    self.mapView.rotateEnabled=NO;//此属性用于地图旋转手势的开启和关闭
    self.mapView.rotateCameraEnabled=NO;//此属性用于地图旋转旋转的开启和关闭
    //绘制折线
    self.driveManager = [AMapNaviDriveManager sharedInstance];
    [self.driveManager setDelegate:self];
}
//添加开始结束位置的大头针
-(void)addAnnation
{
    //初始化大头针
    locationAnnotation = [[MAPointAnnotation alloc] init];
    locationAnnotation.coordinate = CLLocationCoordinate2DMake([self.dic[@"start_lat"] floatValue], [self.dic[@"start_lng"] floatValue]);
    locationAnnotation.title=@"起点";
    [self.mapView addAnnotation:locationAnnotation];
    
    //设置地图
    [self.mapView setZoomLevel:15 animated:YES];
    [self.mapView selectAnnotation:locationAnnotation animated:YES];
    [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake([self.dic[@"end_lat"] floatValue], [self.dic[@"end_lng"] floatValue]) animated:NO];
    
    //添加结束位置大头针
    endAnnotation = [[MAPointAnnotation alloc] init];
    endAnnotation.coordinate = CLLocationCoordinate2DMake([self.dic[@"end_lat"] floatValue], [self.dic[@"end_lng"] floatValue]);
    endAnnotation.title=@"终点";
    [self.mapView addAnnotation:endAnnotation];
    
    AMapNaviPoint * startPoint=[AMapNaviPoint locationWithLatitude:[self.dic[@"start_lat"] floatValue] longitude:[self.dic[@"start_lng"] floatValue]];
    AMapNaviPoint * endPoint   = [AMapNaviPoint locationWithLatitude:[self.dic[@"end_lat"] floatValue] longitude:[self.dic[@"end_lng"] floatValue]];
    
    [self.driveManager calculateDriveRouteWithStartPoints:@[startPoint]
                                                endPoints:@[endPoint]
                                                wayPoints:nil
                                          drivingStrategy:2];
}
#pragma mark - 路径显示样式
- (void)driveManager:(AMapNaviDriveManager *)driveManager onCalculateRouteSuccessWithType:(AMapNaviRoutePlanType)type{
}
- (void)driveManagerOnCalculateRouteSuccess:(AMapNaviDriveManager *)driveManager
{
    NSLog(@"onCalculateRouteSuccess");
    //构造折线对象
    NSArray * array=driveManager.naviRoute.routeCoordinates;
    CLLocationCoordinate2D commonPolylineCoords[array.count];
    for (int i=0; i<array.count; i++) {
        
        AMapNaviPoint * navipoint=array[i];
        commonPolylineCoords[i].latitude=navipoint.latitude;
        commonPolylineCoords[i].longitude=navipoint.longitude;
        
    }
    
    self.commonPolyline = [MAPolyline polylineWithCoordinates:commonPolylineCoords count:array.count];
    //在地图上添加折线对象
    [_mapView addOverlay: self.commonPolyline];
    
    if (endAnnotation!=nil) {
        
        [self.mapView showAnnotations:@[locationAnnotation,endAnnotation] edgePadding:UIEdgeInsetsMake(120, 50, 210, 50) animated:YES];
        
    }
}
#pragma mark - MAMapViewDelegate

//地图上覆盖物的渲染，可以设置路径线路的宽度，颜色等
- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay {
    
    
    MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:overlay];
    
    polylineRenderer.lineWidth    = 8.f;
    polylineRenderer.strokeColor  = [UIColor colorWithRed:0 green:1 blue:0 alpha:0.6];
    polylineRenderer.lineJoinType = kMALineJoinRound;
    polylineRenderer.lineCapType  = kMALineCapRound;
    polylineRenderer.strokeImage = [UIImage imageNamed:@"arrowTexture"];
    
    
    return polylineRenderer;
    
}
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
        MAPinAnnotationView*annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }
        annotationView.canShowCallout= YES;
        annotationView.animatesDrop = YES;
        annotationView.draggable = YES;
        annotationView.enabled=NO;
        
        
        //起点，终点的图标标注
        if (annotation==locationAnnotation) {
            annotationView.image = [UIImage imageNamed:@"map_start"];  //起点
            annotationView.centerOffset=CGPointMake(0, -22);
        }else if(annotation==endAnnotation){
            annotationView.image = [UIImage imageNamed:@"map_end"];  //终点
            annotationView.centerOffset=CGPointMake(0, -22);
        }
        
        return annotationView;
    }
    return nil;
}

//设置导航栏
-(void)setUpNav
{
    UIButton * navBackButton=[UIButton buttonWithType:UIButtonTypeCustom];
    navBackButton.frame=CGRectMake(0, 0, 40, 40);
    navBackButton.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    [navBackButton setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [navBackButton addTarget:self action:@selector(navBackButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * leftItem=[[UIBarButtonItem alloc]initWithCustomView:navBackButton];
    self.navigationItem.leftBarButtonItem=leftItem;
}
-(void)navBackButtonClicked{
    
    BOOL isjjj = [AMapNaviDriveManager destroyInstance];
    NSLog(@"isjjjisjjjisjjjisjjj%d",isjjj);
    [self.mapView removeAnnotations:@[locationAnnotation,endAnnotation]];
    [self.mapView removeOverlay:self.commonPolyline];
    [self.mapView removeFromSuperview];
    self.mapView = nil;
    [self.navigationController popViewControllerAnimated:YES];
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
