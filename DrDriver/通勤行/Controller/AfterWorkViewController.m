//
//  SLTripDetialViewController.m
//  DrDriver
//
//  Created by qqqqqqq on 2019/12/24.
//  Copyright © 2019 tangchaoke. All rights reserved.
//

#import "AfterWorkViewController.h"
#import "AfterWorkTableViewCell.h"

#import "SLTripList.h"
#import "SLStudent.h"
#import "Latlng.h"
#import "SpeechSynthesizer.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapNaviKit/AMapNaviKit.h>
#import <AFNetworking.h>
#import "DriveNaviViewController.h"

#import "LivenessViewController.h"
#import "IDLFaceSDK/IDLFaceSDK.h"
#import "UIImage+FixIMG.h"
#import "FaceViewController.h"
#import "FaceAlertView.h"

#import "SLPwdView.h"

#import "SLMoreViewController.h"

@interface AfterWorkViewController ()<UITableViewDelegate, UITableViewDataSource, AfterWorkTableViewCellDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, MAMapViewDelegate, AMapNaviDriveManagerDelegate, DriveNaviViewControllerDelegate, AMapLocationManagerDelegate>
{
    AMapNaviPoint *_endPoint;
}
@property (strong, nonatomic, readwrite) UITableView *tableView;

@property (strong, nonatomic, readwrite) SLTripList *tripDetail;
@property (strong, nonatomic, readwrite) NSArray <SLStudent *> *studentInfoArray;

@property (strong, nonatomic, readwrite) MAMapView *mapView; //地图

@property (copy, nonatomic, readwrite) NSString *order_id;
@property (copy, nonatomic, readwrite) NSString *latNew;
@property (copy, nonatomic, readwrite) NSString *lgnNew;

@property (nonatomic, strong, readwrite) NSDictionary *locDictionary;

@property (strong, nonatomic, readwrite) UIButton *locationButton; //定位按钮
//@property (strong, nonatomic, readwrite) UIButton * topButton;//顶部按钮
@property (strong, nonatomic, readwrite) MAPointAnnotation *driverAnnotation;//定位的大头针
@property (nonatomic, strong, readwrite) AMapLocationManager *locationManager;
@property (nonatomic, strong, readwrite) NSMutableArray *annotations;
@property (nonatomic, strong) MBProgressHUD *HUD;

@property (nonatomic, strong) SLPwdView *passWordView;//输入密码弹框
@property (nonatomic, strong) MAUserLocation *userLocation;
@end

@implementation AfterWorkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"行程详情";
    [self setUpMapView];
    [self initDriveManager];
    [self setUpTableView];
    [self setUpNav];
    self.studentInfoArray = [NSArray array];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self creatHttp];
}

- (void)dealloc {
    [[AMapNaviDriveManager sharedInstance] stopNavi];
    [[AMapNaviDriveManager sharedInstance] setDelegate:nil];

    BOOL success = [AMapNaviDriveManager destroyInstance];
    NSLog(@"单例是否销毁成功 : %d", success);
}

- (void)setUpMapView {
    if (self.mapView == nil) {
        /*创建地图并添加到父view上*/
        self.mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, DeviceWidth, DeviceHeight / 2)];
        self.mapView.delegate = self;
        self.mapView.mapType = MAMapTypeStandard;
        self.mapView.showsLabels = YES;
        self.mapView.showsBuildings = YES;
        self.mapView.rotateEnabled = NO;      //此属性用于地图旋转手势的开启和关闭
        self.mapView.rotateCameraEnabled = NO;      //此属性用于地图旋转旋转的开启和关闭
        [self.mapView setZoomLevel:13];
        //     自定义定位小蓝点
        [self setUplocationView];
        [self.view addSubview:self.mapView];
        ///如果您需要进入地图就显示定位小蓝点，则需要下面两行代码
        self.mapView.showsUserLocation = YES;
        self.mapView.userTrackingMode = MAUserTrackingModeFollow;
        self.locationButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.locationButton setImage:[UIImage imageNamed:@"location_button"] forState:UIControlStateNormal];
        self.locationButton.backgroundColor = [UIColor lightGrayColor];
        self.locationButton.layer.cornerRadius = 3;
        self.locationButton.layer.masksToBounds = YES;

        [self.locationButton addTarget:self action:@selector(locationClick) forControlEvents:UIControlEventTouchUpInside];
        [self.mapView addSubview:self.locationButton];

        [self.locationButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left).mas_offset(20);
            make.bottom.equalTo(self.mapView.mas_bottom).with.offset(-20);
            make.height.and.width.equalTo(@33);
        }];
        //将locationButton添加到最上面
//               [self.view bringSubviewToFront:self.locationButton];
//                self.topButton = [[UIButton alloc] init];
//                [self.topButton setBackgroundColor:CATECOLOR_SELECTED];
//                self.topButton.alpha = 0.9;
//                self.topButton.layer.cornerRadius=10;
//                self.topButton.layer.masksToBounds=YES;
//                [self.mapView addSubview:self.topButton];
//                [self.topButton mas_makeConstraints:^(MASConstraintMaker *make) {
//                    make.left.mas_equalTo(self.view.mas_left).mas_offset(15);
//                    make.right.mas_equalTo(self.view.mas_right).mas_offset(-15);
//                    make.top.mas_equalTo(self.view.mas_top).mas_offset(80);
//                    make.height.mas_equalTo(44);
//                }];
        //将topButton添加到最上面
//                [self.view bringSubviewToFront:self.topButton];

        self.locationManager = [[AMapLocationManager alloc] init];
        self.locationManager.delegate = self;
        // 带逆地理信息的一次定位（返回坐标和地址信息）
        [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
        //   定位超时时间，最低2s，此处设置为10s
        self.locationManager.locationTimeout = 5;
        UIWindow *window = [UIApplication sharedApplication].delegate.window;
        _HUD = [[MBProgressHUD alloc] initWithView:window];
        [window addSubview:_HUD];
    }
}

- (void)setUplocationView {
    MAUserLocationRepresentation *r = [[MAUserLocationRepresentation alloc] init];
    r.image = [UIImage imageNamed:@"move_car"]; ///定位图标, 与蓝色原点互斥
    [self.mapView updateUserLocationRepresentation:r];
}

- (void)locationClick {
    [self showTost];

    // 带逆地理（返回坐标和地址信息）。将下面代码中的 YES 改成 NO ，则不会返回地址信息。
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        [self hidenTost];
        if (error) {
            NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);

            if (error.code == AMapLocationErrorLocateFailed) {
                [CYTSI otherShowTostWithString:@"定位失败，请重试"];
                return;
            }
        }

        [self.mapView setCenterCoordinate:location.coordinate animated:YES];
    }];
}

- (void)configLocationManager
{
    self.locationManager = [[AMapLocationManager alloc] init];

    [self.locationManager setDelegate:self];

    [self.locationManager setPausesLocationUpdatesAutomatically:NO];

    [self.locationManager setAllowsBackgroundLocationUpdates:YES];
}

- (void)showTost
{
    _HUD.bezelView.backgroundColor = [UIColor blackColor];
    _HUD.bezelView.alpha = 1;
    _HUD.label.textColor = [UIColor whiteColor];
    _HUD.activityIndicatorColor = [UIColor whiteColor];

    //如果设置此属性则当前的view置于后台
    _HUD.dimBackground = YES;
    //设置对话框文字
    _HUD.labelText = @"请稍等";
    [_HUD showAnimated:YES];
}

- (void)hidenTost
{
    [_HUD hideAnimated:YES];
}

- (void)initDriveManager
{
    //请在 dealloc 函数中或者页面pop时，执行 [AMapNaviDriveManager destroyInstance] 来销毁单例
    [[AMapNaviDriveManager sharedInstance] setDelegate:self];

    [[AMapNaviDriveManager sharedInstance] setAllowsBackgroundLocationUpdates:YES];
    [[AMapNaviDriveManager sharedInstance] setPausesLocationUpdatesAutomatically:NO];
}

//请求数据
- (void)creatHttp
{
    __weak typeof(self) weakSelf = self;

    [AFRequestManager postRequestWithUrl:DRIVER_WORKBUS_ROUTE_DETIAL params:@{ @"driver_id": [[NSUserDefaults standardUserDefaults] objectForKey:@"userid"], @"token": [[NSUserDefaults standardUserDefaults] objectForKey:@"token"], @"route_id": self.route_id } tost:YES special:0 success:^(id responseObject) {
//        NSLog(@"DRIVER_SCHOOLBUS_ROUTE_DETAIL --- %@", responseObject[@"data"]);

        weakSelf.tripDetail = [SLTripList mj_objectWithKeyValues:responseObject[@"data"]];

        dispatch_async(dispatch_get_main_queue(), ^{//主线程刷新ui
                           weakSelf.studentInfoArray = weakSelf.tripDetail.list;
                           NSString *isShow = @"n";
                    
                           for (int i = 0; i < weakSelf.studentInfoArray.count; i++) {
                               SLStudent *student = weakSelf.studentInfoArray[i];
                               if ([student.order_state intValue] > 0 && [student.order_state intValue] < 5) {
                                   isShow = @"y";
                               }
                               if ([student.order_state intValue] == 9) {//陪伴中
                                   isShow = @"y";
                               }

                           }

                           if ([isShow isEqualToString:@"y"]) {
//                  weakSelf.topButton.hidden = NO;
                               [[NSNotificationCenter defaultCenter]postNotificationName:@"beginUpdate" object:nil];
                           } else {
//                 weakSelf.topButton.hidden = YES;
                               [[NSNotificationCenter defaultCenter] postNotificationName:@"stopUpdate" object:nil];
                           }
                           /*添加annotation*/
                           weakSelf.annotations = [NSMutableArray array];
                           for (int i = 0; i < weakSelf.tripDetail.latlng.count; ++i) {
                               CLLocationDegrees latitude =  [[weakSelf.tripDetail.latlng[i] start_lat] doubleValue];
                               CLLocationDegrees longitude =  [[weakSelf.tripDetail.latlng[i] start_lng] doubleValue];
                               MAPointAnnotation *a1 = [[MAPointAnnotation alloc] init];
                               a1.coordinate = (CLLocationCoordinate2D) { latitude, longitude };
                               a1.title      = [weakSelf.tripDetail.latlng[i] cm_name];

                               [weakSelf.annotations addObject:a1];
                           }

                           [weakSelf.mapView addAnnotations:weakSelf.annotations];
                           [weakSelf.mapView showAnnotations:weakSelf.annotations edgePadding:UIEdgeInsetsMake(0, 0, 0, 0) animated:YES];
                           [weakSelf.tableView reloadData];
                       });
    } failure:^(NSError *error) {
//        CYLog(@"error ===== %@", error)
    }];
}

- (void)setUpTableView {
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = TABLEVIEW_BACKCOLOR;
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = self.mapView;
}

//设置导航栏
- (void)setUpNav
{
    UIButton *navBackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    navBackButton.frame = CGRectMake(0, 0, 40, 40);
    navBackButton.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    [navBackButton setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [navBackButton addTarget:self action:@selector(navBackButtonClicked) forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:navBackButton];
    self.navigationItem.leftBarButtonItem = leftItem;
}

//导航栏返回按钮
- (void)navBackButtonClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.studentInfoArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AfterWorkTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AfterWorkTableViewCell"];
    if (!cell) {
        cell = [[AfterWorkTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AfterWorkTableViewCell"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }

    cell.student = self.studentInfoArray[indexPath.row];
    cell.delagte = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 290;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 35;
}

- (void)clickTellPhoneButton:(NSString *)phoneStr {
    [CYTSI callPhoneStr:phoneStr withVC:self];
}

- (void)moreBtnClick:(NSString *)studentStr {
    SLMoreViewController *moreVC = [[SLMoreViewController alloc] init];
    moreVC.order_id = studentStr;
    moreVC.whichType = @"0";
    [self.navigationController pushViewController:moreVC animated:YES];
}

#pragma mark - AfterSchoolTableViewCellDelegate

- (void)clickStateButton:(SLStudent *)student {
    __weak typeof(self) weakSelf = self;
 
    if ([student.order_state isEqualToString:@"3"]) {
           [[NSNotificationCenter defaultCenter] postNotificationName:@"beginRecord" object:nil userInfo:@{@"route_id":self.route_id,@"order_type":@"3"}];
      }
    //state 传递下一状态
    int stateInt = [student.order_state intValue] + 1;
    NSLog(@"dict === %@",@{ @"order_id": student.order_id, @"driver_id": [[NSUserDefaults standardUserDefaults] objectForKey:@"userid"], @"token": [[NSUserDefaults standardUserDefaults] objectForKey:@"token"], @"route_id": student.route_id, @"state": @(stateInt), @"driver_lng": [NSString stringWithFormat:@"%f", self.mapView.userLocation.location.coordinate.longitude], @"driver_lat": [NSString stringWithFormat:@"%f", self.mapView.userLocation.location.coordinate.latitude] });
    [AFRequestManager postRequestWithUrl:DRIVER_WORKBUS_UP_ROTE_STATE params:@{ @"order_id": student.order_id, @"driver_id": [[NSUserDefaults standardUserDefaults] objectForKey:@"userid"], @"token": [[NSUserDefaults standardUserDefaults] objectForKey:@"token"], @"route_id": student.route_id, @"state": @(stateInt), @"driver_lng": [NSString stringWithFormat:@"%f", self.mapView.userLocation.location.coordinate.longitude], @"driver_lat": [NSString stringWithFormat:@"%f", self.mapView.userLocation.location.coordinate.latitude] } tost:NO special:0 success:^(id responseObject) {
        NSLog(@"[responseObject ====== DRIVER_WORKBUS_UP_ROTE_STATE = %@",responseObject[@"data"]);
        if ([responseObject[@"flag"] isEqualToString:@"success"]) {//改变状态成功
            if ([student.order_state intValue] == 0 || [student.order_state intValue] == 3) {
                dispatch_async(dispatch_get_main_queue(), ^{
                                   [weakSelf startDrawLine];
                               });
            }
            [weakSelf creatHttp];
            NSString *is_record = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"is_record"]];
            if ([is_record isEqualToString:@"1"]) {//1上传 0不上传
                [[NSNotificationCenter defaultCenter] postNotificationName:@"stopRecord" object:nil];
                  
        }
        }
    } failure:^(NSError *error) {
    }];
}

- (void)clickPhotoButton:(SLStudent *_Nullable)student {
    self.order_id = student.order_id;
    [self clickStateButton:student];
}


- (void)clickMapNavButton:(NSDictionary *)dictionary {
    self.locDictionary = dictionary;
    [self startDrawLine];
}

- (void)otherStateClickMapNavButton:(NSDictionary *)dictionary {
    self.locDictionary = dictionary;
}

//开始绘制轨迹
- (void)startDrawLine
{
    double latitude; double longitude;

    if ([self.locDictionary[@"state"] intValue] < 3) {//去接乘客
        latitude = [self.locDictionary[@"start_lat"] doubleValue];
        longitude = [self.locDictionary[@"start_lng"] doubleValue];
    } else {//去学校
        latitude = [self.locDictionary[@"end_lat"] doubleValue];
        longitude = [self.locDictionary[@"end_lng"] doubleValue];
    }

    AMapNaviPoint *endPoint = [AMapNaviPoint locationWithLatitude:latitude longitude:longitude];

    NSLog(@"endPoint === %@", endPoint);

    [[AMapNaviDriveManager sharedInstance] calculateDriveRouteWithEndPoints:@[endPoint] wayPoints:nil drivingStrategy:AMapNaviDrivingStrategySingleDefault];
}

/* 实现代理方法：*/
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    //用户蓝点设置
    if ([annotation isKindOfClass:[MAUserLocation class]]) {
        return nil;
    }

    if ([annotation isKindOfClass:[MAPointAnnotation class]]) {
        static NSString *pointReuseIndetifier = @"Latlng";
        MAPinAnnotationView *annotationView = (MAPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
        if (annotationView == nil) {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
        }
        annotationView.canShowCallout = YES;
        annotationView.image = [UIImage imageNamed:@"dibiao"];
        return annotationView;
    }

    return nil;
}

//添加完大头针的代理方法
- (void)mapView:(MAMapView *)mapView didAddAnnotationViews:(NSArray *)views {
    for (int i = 0; i < views.count; i++) {
        if (![views[i] isKindOfClass:[MAUserLocation class]]) {
            if ([views[i] isKindOfClass:MAPinAnnotationView.class]) {
                MAPinAnnotationView *mapView = (MAPinAnnotationView *)views[i];
                [self.mapView selectAnnotation:mapView.annotation animated:YES];
            }
        }
    }
}

#pragma mark - MapView Delegate

- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    if (updatingLocation) {
        _userLocation = userLocation;
    }
}

#pragma mark - AMapNaviDriveManager Delegate

- (void)driveManager:(AMapNaviDriveManager *)driveManager error:(NSError *)error
{
    NSLog(@"error:{%ld - %@}", (long)error.code, error.localizedDescription);
}

- (void)driveManagerOnCalculateRouteSuccess:(AMapNaviDriveManager *)driveManager
{
    NSLog(@"onCalculateRouteSuccess");
    DriveNaviViewController *driveVC = [[DriveNaviViewController alloc] init];
    [driveVC setDelegate:self];
    //将driveView添加为导航数据的Representative，使其可以接收到导航诱导数据
    [[AMapNaviDriveManager sharedInstance] addDataRepresentative:driveVC.driveView];

    [self.navigationController pushViewController:driveVC animated:NO];
    [[AMapNaviDriveManager sharedInstance] startGPSNavi];
}

- (void)driveManager:(AMapNaviDriveManager *)driveManager onCalculateRouteFailure:(NSError *)error
{
    NSLog(@"onCalculateRouteFailure:{%ld - %@}", (long)error.code, error);
}

- (void)driveManager:(AMapNaviDriveManager *)driveManager onCalculateRouteFailure:(NSError *)error routePlanType:(AMapNaviRoutePlanType)type {
}

- (void)driveManager:(AMapNaviDriveManager *)driveManager didStartNavi:(AMapNaviMode)naviMode
{
    NSLog(@"didStartNavi");
}

- (void)driveManagerNeedRecalculateRouteForYaw:(AMapNaviDriveManager *)driveManager
{
    NSLog(@"needRecalculateRouteForYaw");
}

- (void)driveManagerNeedRecalculateRouteForTrafficJam:(AMapNaviDriveManager *)driveManager
{
    NSLog(@"needRecalculateRouteForTrafficJam");
}

- (void)driveManager:(AMapNaviDriveManager *)driveManager onArrivedWayPoint:(int)wayPointIndex
{
    NSLog(@"onArrivedWayPoint:%d", wayPointIndex);
}

- (BOOL)driveManagerIsNaviSoundPlaying:(AMapNaviDriveManager *)driveManager
{
    return [[SpeechSynthesizer sharedSpeechSynthesizer] isSpeaking];
}

- (void)driveManager:(AMapNaviDriveManager *)driveManager playNaviSoundString:(NSString *)soundString soundStringType:(AMapNaviSoundType)soundStringType
{
    NSLog(@"playNaviSoundString:{%ld:%@}", (long)soundStringType, soundString);

    [[SpeechSynthesizer sharedSpeechSynthesizer] speakString:soundString];
}

#pragma mark - DriveNaviView Delegate

- (void)driveNaviViewCloseButtonClicked
{
    //停止导航
    [[AMapNaviDriveManager sharedInstance] stopNavi];

    //停止语音
    [[SpeechSynthesizer sharedSpeechSynthesizer] stopSpeak];

    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark - 底部弹框
- (void)passengerTakeDrive:(SLStudent *)student {
    [self clickStateButton:student];
}
 

@end

