//
//  SLTripDetialViewController.m
//  DrDriver
//
//  Created by qqqqqqq on 2019/12/24.
//  Copyright © 2019 tangchaoke. All rights reserved.
//

#import "SLTripDetialViewController.h"
#import "SLTripDetailTableViewCell.h"

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
#import "TravelCancelReasonViewController.h"

@interface SLTripDetialViewController ()<UITableViewDelegate, UITableViewDataSource, SLTripDetailTableViewCellDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, MAMapViewDelegate, AMapNaviDriveManagerDelegate, DriveNaviViewControllerDelegate, AMapLocationManagerDelegate, AMapNaviDriveDataRepresentable>
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
@property (nonatomic, strong) DriveNaviViewController *driveVC;
@end

@implementation SLTripDetialViewController

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
//                [self.mapView setZoomLevel:2];
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

    self.driveVC = [[DriveNaviViewController alloc] init];
    [self.driveVC setDelegate:self];
    //将driveView添加为导航数据的Representative，使其可以接收到导航诱导数据
    [[AMapNaviDriveManager sharedInstance] addDataRepresentative:self.driveVC.driveView];
}

//请求数据
- (void)creatHttp
{
    __weak typeof(self) weakSelf = self;

    NSString *urlStr= @"";
    [AFRequestManager postRequestWithUrl:DRIVER_SCHOOLBUS_ROUTE_DETAIL params: @{ @"driver_id": [[NSUserDefaults standardUserDefaults] objectForKey:@"userid"], @"token": [[NSUserDefaults standardUserDefaults] objectForKey:@"token"], @"route_id": self.route_id } tost:YES special:0 success:^(id responseObject) {
        NSLog(@"DRIVER_SCHOOLBUS_ROUTE_DETAIL --- %@", responseObject[@"data"]);

        weakSelf.tripDetail = [SLTripList mj_objectWithKeyValues:responseObject[@"data"]];

        dispatch_async(dispatch_get_main_queue(), ^{//主线程刷新ui
                           weakSelf.studentInfoArray = weakSelf.tripDetail.list;
                           NSString *isShow = @"n";
                           for (int i = 0; i < weakSelf.studentInfoArray.count; i++) {
                               SLStudent *student = weakSelf.studentInfoArray[i];
                               if ([student.order_state intValue] > 0 && [student.order_state intValue] < 5) {
                                   isShow = @"y";
                               }

                           }
                           if ([isShow isEqualToString:@"y"]) {
//                  weakSelf.topButton.hidden = NO;
                               [[NSNotificationCenter defaultCenter] postNotificationName:@"beginUpdate" object:nil];
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
                               a1.title      = [weakSelf.tripDetail.latlng[i] child_name];

                               [weakSelf.annotations addObject:a1];
                           }

                           [weakSelf.mapView addAnnotations:weakSelf.annotations];
                           [weakSelf.mapView showAnnotations:weakSelf.annotations edgePadding:UIEdgeInsetsMake(0, 0, 0, 0) animated:YES];
                           [weakSelf.tableView reloadData];
                       });
    } failure:^(NSError *error) {
        CYLog(@"DRIVER_SCHOOLBUS_ROUTE_DETAIL error ===== %@", error);
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
    SLTripDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SLTripDetailTableViewCell"];
    if (!cell) {
        cell = [[SLTripDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SLTripDetailTableViewCell"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }

    cell.student = self.studentInfoArray[indexPath.row];
    cell.delagte = self;
    cell.btn.hidden = NO;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 290;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 35;
}

- (void)tableViewCell:(UITableViewCell *)tableViewCell clickTellPhoneButton:(NSString *)phoneStr {
    [CYTSI callPhoneStr:phoneStr withVC:self];
}

#pragma mark - SLTripDetailTableViewCellDelegate

- (void)tableViewCell:(UITableViewCell *)tableViewCell clickStateButton:(SLStudent *)student {
    __weak typeof(self) weakSelf = self;
    
    if ([student.order_state isEqualToString:@"1"]) {
         [[NSNotificationCenter defaultCenter] postNotificationName:@"beginRecord" object:nil userInfo:@{@"route_id":self.route_id,@"order_type":@"2"}];
    }
    //state 传递下一状态
    int stateInt = [student.order_state intValue] + 1;
//    NSLog(@"dict ==== %@",@{@"order_id":student.order_id,@"driver_id":[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"],@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"],@"route_id":student.route_id,@"state":@(stateInt),@"driver_lng":[NSString stringWithFormat:@"%f",self.mapView.userLocation.location.coordinate.longitude],@"driver_lat":[NSString stringWithFormat:@"%f",self.mapView.userLocation.location.coordinate.latitude]});
    [AFRequestManager postRequestWithUrl:DRIVER_SCHOOLBUS_UP_ROUTE_STATE params:@{ @"order_id": student.order_id, @"driver_id": [[NSUserDefaults standardUserDefaults] objectForKey:@"userid"], @"token": [[NSUserDefaults standardUserDefaults] objectForKey:@"token"], @"route_id": student.route_id, @"state": @(stateInt), @"driver_lng": [NSString stringWithFormat:@"%f", self.mapView.userLocation.location.coordinate.longitude], @"driver_lat": [NSString stringWithFormat:@"%f", self.mapView.userLocation.location.coordinate.latitude] } tost:NO special:0 success:^(id responseObject) {
        if ([responseObject[@"flag"] isEqualToString:@"success"]) {//改变状态成功
            if ([student.order_state intValue] == 0 || [student.order_state intValue] == 3) {
                [weakSelf startDrawLine];
            }
            [weakSelf creatHttp];
        }
    } failure:^(NSError *error) {
    }];
}

- (void)tableViewCell:(UITableViewCell *_Nullable)tableViewCell clickPhotoButton:(SLStudent *_Nullable)student {
    self.order_id = student.order_id;
    // 创建UIImagePickerController实例
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    // 设置代理
    imagePickerController.delegate = self;
    // 设置照片来源为相机
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    // 展示选取照片控制器
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

- (void)moreBtnClick:(NSString *)studentStr {
    SLMoreViewController *moreVC = [[SLMoreViewController alloc] init];
    moreVC.order_id = studentStr;
    moreVC.whichType = @"0";
    [self.navigationController pushViewController:moreVC animated:YES];
}

- (void)cancelBtnClick:(NSString *)orderStr {//点击确认取消按钮
    TravelCancelReasonViewController *tripVC = [[TravelCancelReasonViewController alloc] init];
    tripVC.isSchoolBus = @"0";
    tripVC.orderID = orderStr;
    __weak typeof(self) weakSelf = self;
    tripVC.cancelBlock = ^{
        [weakSelf creatHttp];
    };
    [self.navigationController pushViewController:tripVC animated:YES];
}

#pragma mark - UIImagePickerControllerDelegate
// 完成图片的选取后调用的方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    // 选取完图片后跳转回原控制器
    [picker dismissViewControllerAnimated:YES completion:nil];
    // 从info中将图片取出，并加载到imageView当中
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    //压缩图片
    UIImage *scalImage = [self compressOriginalImage:image toWidth:100];
    NSData *imageData = UIImageJPEGRepresentation(scalImage, 1);
    __weak typeof(self) weakSelf = self;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/plain", @"text/html", nil];
    NSString *URLString = [NSString stringWithFormat:@"%@%@", HTTP_URL, DRIVER_SCHOOLBUS_UP_CHILD_PIC];
    [manager POST:URLString parameters:@{ @"order_id": self.order_id, @"driver_id": [[NSUserDefaults standardUserDefaults] objectForKey:@"userid"], @"token": [[NSUserDefaults standardUserDefaults] objectForKey:@"token"], @"driver_lng": [NSString stringWithFormat:@"%f", self.mapView.userLocation.location.coordinate.longitude], @"driver_lat": [NSString stringWithFormat:@"%f", self.mapView.userLocation.location.coordinate.latitude] } constructingBodyWithBlock:^(id< AFMultipartFormData >  _Nonnull formData) {
        [formData appendPartWithFileData:imageData name:@"child_img" fileName:@"child.png" mimeType:@"image/png"];
    } progress:nil success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
        if ([responseObject[@"flag"] isEqualToString:@"success"]) {
            [CYTSI otherShowTostWithString:@"图片上传成功！"];
            NSString *str = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"is_record"]];
            if ([str isEqualToString:@"0"]) {//0不结束 1结束
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"beginRecord" object:nil userInfo:@{@"route_id":weakSelf.route_id,@"order_type":@"2"}];
            } else {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"stopRecord" object:nil];
            }
            [weakSelf creatHttp];
        } else {
            [CYTSI otherShowTostWithString:responseObject[@"message"]];
        }
    } failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
//        NSLog(@"error ======%@",error);
    }];
}

// 取消选取调用的方法
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 改变图片的大小
- (UIImage *)compressOriginalImage:(UIImage *)image toWidth:(CGFloat)targetWidth
{
    CGSize imageSize = image.size;
    CGFloat Originalwidth = imageSize.width;
    CGFloat Originalheight = imageSize.height;
    CGFloat targetHeight = Originalheight / Originalwidth * targetWidth;
    UIGraphicsBeginImageContext(CGSizeMake(targetWidth, targetHeight));
    [image drawInRect:CGRectMake(0, 0, targetWidth,  targetHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
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

- (void)driveManager:(AMapNaviDriveManager *)driveManager onCalculateRouteSuccessWithType:(AMapNaviRoutePlanType)type {
    [self.navigationController pushViewController:self.driveVC animated:NO];

    [[AMapNaviDriveManager sharedInstance] startGPSNavi];
}

- (BOOL)driveManagerIsNaviSoundPlaying:(AMapNaviDriveManager *)driveManager
{
    return [[SpeechSynthesizer sharedSpeechSynthesizer] isSpeaking];
}

- (void)driveManager:(AMapNaviDriveManager *)driveManager playNaviSoundString:(NSString *)soundString soundStringType:(AMapNaviSoundType)soundStringType
{
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
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"请选择下列选项" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    __weak typeof(self) weakSelf = self;

    // 创建action，这里action1只是方便编写，以后再编程的过程中还是以命名规范为主
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"人脸识别" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
        [weakSelf scanFaceAction:student];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"输入密码" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {     //给出弹框
        [weakSelf initPasWordView:student];
    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"家长确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
        [CYTSI callPhoneStr:student.passenger_phone withVC:weakSelf];
    }];
    UIAlertAction *action4 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *_Nonnull action) {
    }];
    //把action添加到actionSheet里
    [actionSheet addAction:action1];
    [actionSheet addAction:action2];
    [actionSheet addAction:action3];
    [actionSheet addAction:action4];
    //相当于之前的[actionSheet show];
    [self presentViewController:actionSheet animated:YES completion:nil];
}

#pragma mark -- 扫脸认证
- (void)scanFaceAction:(SLStudent *)student {
    if ([[FaceSDKManager sharedInstance] canWork]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请检查您的网络并重启APP" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *_Nonnull action) {
//            NSLog(@"点击取消");
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
//            NSLog(@"点击确认");
            exit(1);
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
    } else {
        __weak typeof(self) weakSelf = self;
        LivenessViewController *lvc = [[LivenessViewController alloc] init];
        lvc.isFount = NO;
        lvc.liveBlock = ^(UIImage *image) {
            dispatch_async(dispatch_get_main_queue(), ^{
                //初始化进度框，置于当前的View当中
                [_HUD showAnimated:YES];
                NSString *urlString = [NSString stringWithFormat:@"%@%@", HTTP_URL, DRIVER_SCHOOLBUS_CHILD_FACE_MATCH];
                AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                NSDictionary *dict = @{ @"driver_id": [[NSUserDefaults standardUserDefaults] objectForKey:@"userid"], @"token": [[NSUserDefaults standardUserDefaults] objectForKey:@"token"], @"order_id": student.order_id, @"driver_lng": [NSString stringWithFormat:@"%f", _userLocation.coordinate.longitude], @"driver_lat": [NSString stringWithFormat:@"%f", _userLocation.coordinate.latitude] };
                manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", nil];

                [manager POST:urlString parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                    NSString *dateString = [CYTSI getDateStr];
                    NSString *dateStr = [NSString stringWithFormat:@"%@face_img.png", dateString];
//                    NSLog(@"dateStr%@", dateStr);
                    [CYTSI saveImage:[UIImage fixOrientation:[CYTSI compressImageQuality:image toByte:1024 * 1024] ] withName:dateStr];

                    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:dateStr];
                    [formData appendPartWithFileURL:[NSURL fileURLWithPath:fullPath] name:@"face_img" fileName:dateStr mimeType:@"image/png" error:nil];
                } progress:^(NSProgress *_Nonnull uploadProgress) {
                } success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
                    //请求成功
                    [_HUD removeFromSuperview];
                    if ([responseObject[@"flag"] isEqualToString:@"success"]) {
                        [CYTSI otherShowTostWithString:@"认证成功"];
                        [weakSelf creatHttp];
                    } else {
//                        NSLog(@"self.alertself.alertself.alert%@", self.alert);
                        [_HUD removeFromSuperview];
                        [CYTSI otherShowTostWithString:@"认证失败，请重试"];
                    }
                } failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
                    //请求失败
                    [_HUD removeFromSuperview];
                }];
            });
        };

        //        FaceLivenessActionTypeLiveEye    眨眨眼    0
        //        FaceLivenessActionTypeLiveMouth    张张嘴    1
        //        FaceLivenessActionTypeLivePitchUp    抬头    4
        //        FaceLivenessActionTypeLivePitchDown    低头    5
        //        FaceLivenessActionTypeLiveYaw    摇头    6

        //        FaceLivenessActionTypeLiveYawRight    向右摇头    2
        //        FaceLivenessActionTypeLiveYawLeft    向左摇头    3
        //        FaceLivenessActionTypeNoAction    没有动作    7
        NSArray *array = [[NSArray alloc] initWithObjects:@(0), @(1), @(4), @(5), @(6), nil];
        NSMutableArray *randomArray = [[NSMutableArray alloc] init];

        while ([randomArray count] < 1) {
            int r = arc4random() % [array count];
            [randomArray removeAllObjects];
            [randomArray addObject:[array objectAtIndex:r]];
        }
        [lvc livenesswithList:randomArray order:1 numberOfLiveness:0];
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:lvc];
        navi.navigationBarHidden = true;
        [self presentViewController:navi animated:YES completion:nil];
    }
}

#pragma mark - passWordView相关

- (void)initPasWordView:(SLStudent *)student {
    [self.passWordView removeFromSuperview];
    self.passWordView = [[SLPwdView alloc] initWithFrame:self.view.bounds];
    __weak typeof(self) weakSelf = self;
    __weak typeof (self.passWordView) weakAlertView = self.passWordView;
    [self.passWordView showAlertView];

    self.passWordView.sureBlock = ^(NSString *_Nonnull pwd) {
        if ([pwd isEqualToString:@""]) {
            [CYTSI otherShowTostWithString:@"输入的密码不能为空"];
        } else {
            NSDictionary *dict = @{ @"driver_id": [[NSUserDefaults standardUserDefaults] objectForKey:@"userid"], @"token": [[NSUserDefaults standardUserDefaults] objectForKey:@"token"], @"order_id": student.order_id, @"auth_password": pwd, @"driver_lng": [NSString stringWithFormat:@"%f", weakSelf.userLocation.coordinate.longitude], @"driver_lat": [NSString stringWithFormat:@"%f", weakSelf.userLocation.coordinate.latitude] };
                    NSLog(@"dict ==== %@",dict);
            [AFRequestManager postRequestWithUrl:DRIVER_SCHOOLBUS_CHECK_AUTH_PWD params:dict tost:YES special:0 success:^(id responseObject) {
                NSLog(@"DRIVER_SCHOOLBUS_CHECK_AUTH_PWD ==== %@",responseObject);
                if ([responseObject[@"flag"] isEqualToString:@"success"]) {
                    [weakAlertView hideAlertView];
                    [CYTSI otherShowTostWithString:@"认证成功"];
                    [weakSelf creatHttp];
                    NSString *str = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"is_record"]];
                    if ([str isEqualToString:@"0"]) {//0不结束 1结束
//                      [[NSNotificationCenter defaultCenter] postNotificationName:@"beginRecord" object:nil userInfo:@{@"route_id":weakSelf.route_id,@"order_type":@"2"}];
                  } else {
                      [[NSNotificationCenter defaultCenter] postNotificationName:@"stopRecord" object:nil];
                  }
                    
                } else {
                    [CYTSI otherShowTostWithString:@"认证失败，请重试"];
                }
            } failure:^(NSError *error) {
                [weakAlertView hideAlertView];
            }];
        }
    };
    self.passWordView.cancleBlock = ^{
        [weakAlertView hideAlertView];
    };
}

@end
